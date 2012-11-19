//
//  OrderInfoVCViewController.m
//  MagBoard
//
//  Created by Leo Flapper on 05-11-12.
//  Copyright (c) 2012 Dennis de Jong. All rights reserved.
//

#import "OrderInfoVC.h"

@interface OrderInfoVC ()

@end

@implementation OrderInfoVC

@synthesize shopInfo, orderInfoHolder, orderInfo, subHeader, createInvoice, headerColor, loadingHolder, loadingIcon;

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    shopInfo = [ShopSingleton shopSingleton];
    orderInfo = [OrderSingleton orderSingleton];
    [self constructHeader];
    //NSLog(@"%@", [orderInfo orderId]);
    [self loginRequest:[shopInfo shopUrl]
              username:[shopInfo username]
              password:[shopInfo password]
               request:@"salesOrderInfo"
                requestParams:[orderInfo orderId]];
    [self loadingRequest:@"Order ophalen..."];
}

-(void)reloadScrollview
{
    //Remove scrollview
    [orderInfoScrollView removeFromSuperview];
    
    //Show loading view
    [self loadingRequest:@"Status wijzigen..."];
    
    //Reload scrollview
    [self loginRequest:[shopInfo shopUrl]
              username:[shopInfo username]
              password:[shopInfo password]
               request:@"salesOrderInfo"
         requestParams:[orderInfo orderId]];
}

-(void)constructHeader
{
    NSString *barTitle = [NSString stringWithFormat:@"Order: %@", [orderInfo orderId]];
    
    UILabel* navBarTitle = [CustomNavBar setNavBarTitle:barTitle];
    self.navigationItem.titleView = navBarTitle;
    self.navigationItem.leftBarButtonItem = [UIBarButtonItem styledBarButtonItemWithTarget:self selector:@selector(backButtonTouched) title:@"Terug"];
}

//While doing request show loading icon
-(void)loadingRequest:(NSString*)message
{
    loadingHolder = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 350)];
    loadingHolder.backgroundColor = [UIColor clearColor];
    
    UILabel *loadingText = [[UILabel alloc] initWithFrame:CGRectMake(20, 160, 280, 100)];
    UIFont *font = [UIFont fontWithName:@"Lobster 1.3" size:16.0f];
    loadingText.backgroundColor = [UIColor clearColor];
    loadingText.textColor = [UIColor whiteColor];
    loadingText.font = font;
    loadingText.textAlignment = UITextAlignmentCenter;
    loadingText.shadowColor = [UIColor blackColor];
    loadingText.shadowOffset = CGSizeMake(0, 1);
    loadingText.text = message;
    
    loadingIcon = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
	loadingIcon.center = loadingHolder.center;
    [loadingIcon startAnimating];
    
    [self.view addSubview:loadingHolder];
	[loadingHolder addSubview: loadingIcon];
    [loadingHolder addSubview:loadingText];
}

//Function for generating color for header
-(void)generateHeaderColor
{
    NSLog(@"STATUS:%@",[[orderInfoHolder valueForKey:@"data-items"] valueForKey:@"status"]);
    
    if([[[orderInfoHolder valueForKey:@"data-items"] valueForKey:@"status"] isEqualToString:@"Pending"]){
        
        headerColor = [UIColor colorWithRed:78.0f/255.0f green:123.0f/255.0f blue:185.0f/255.0f alpha:1.0f];
        
    } else if ([[[orderInfoHolder valueForKey:@"data-items"] valueForKey:@"status"] isEqualToString:@"Processing"]){
        
        headerColor = [UIColor colorWithRed:206.0f/255.0f green:141.0f/255.0f blue:56.0f/255.0f alpha:1.0f];
        
    } else if ([[[orderInfoHolder valueForKey:@"data-items"] valueForKey:@"status"] isEqualToString:@"Canceled"]){
        
        headerColor = [UIColor colorWithRed:172.0f/255.0f green:67.0f/255.0f blue:67.0f/255.0f alpha:1.0f];
        
    } else if ([[[orderInfoHolder valueForKey:@"data-items"] valueForKey:@"status"] isEqualToString:@"Complete"]){
        
        headerColor = [UIColor colorWithRed:123.0f/255.0f green:180.0f/255.0f blue:112.0f/255.0f alpha:1.0f];
        
    } else if ([[[orderInfoHolder valueForKey:@"data-items"] valueForKey:@"status"] isEqualToString:@"Holded"]){
        
        headerColor = [UIColor colorWithRed:106.0f/255.0f green:109.0f/255.0f blue:124.0f/255.0f alpha:1.0f];
        
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)backButtonTouched
{
    NSMutableArray *viewControllers = [NSMutableArray arrayWithArray:[[self navigationController] viewControllers]];
    [viewControllers removeLastObject];
    [[self navigationController] setViewControllers:viewControllers animated:YES];
}


-(void)loginRequest:(NSString *)shopUrl username:(NSString *)username password:(NSString *)password request:(NSString *)requestFunction requestParams:(NSString *)requestParams
{
    NSMutableDictionary *params = [[NSMutableDictionary alloc]init];
    [params setObject:shopUrl forKey:@"url"];
    [params setObject:username forKey:@"username"];
    [params setObject:password forKey:@"password"];
    [params setObject:requestFunction forKey:@"requestFunction"];
    [params setObject:requestParams forKey:@"requestParams"];
    NSLog(@"Shop %@ with username %@", shopUrl, username);
    NSLog(@"Executing %@ with params %@", requestFunction, requestParams);
    [[LRResty client] post:@"http://www.magboard.nl/api/index.php" payload:params delegate:self];
}

- (void)restClient:(LRRestyClient *)client receivedResponse:(LRRestyResponse *)response;
{
    // do something with the response
    if(response.status == 200) {
        orderInfoHolder = [NSJSONSerialization JSONObjectWithData:[response responseData] options:kNilOptions error:nil];
        if([orderInfoHolder valueForKey:@"message"] != NULL)
        {
           
            NSLog(@"Status: %@", [orderInfoHolder valueForKey:@"session"]);
            NSLog(@"Code: %@", [orderInfoHolder valueForKey:@"message"]);
            //NSLog(@"Data-items: %@", [orderInfoHolder valueForKey:@"data-items"]);
            //Check what type of data is given back (1002 is orderInfo, 1003 is invoiceCreate)
            if([[orderInfoHolder valueForKey:@"message"] isEqualToString: @"1002"]){
                orderInfo.orderStatus = [[orderInfoHolder objectForKey:@"data-items"] objectForKey:@"status"];
                [self makeBlocks];
                [loadingIcon stopAnimating];
                [loadingHolder removeFromSuperview];
            }else if([[orderInfoHolder valueForKey:@"message"] isEqualToString: @"1003"]){
                NSLog(@"Invoice succesfully created");
            } else {
                 NSLog(@"Message: %@", [orderInfoHolder valueForKey:@"data-items"]);
                [loadingIcon stopAnimating];
                [loadingHolder removeFromSuperview];
            }
        
        } else
        {
            NSLog(@"Something went wrong in the API");
        }
    } else {
        NSLog(@"Er ging iets mis %d", [response status]);
    }
    
}

- (void)makeBlocks
{
    NSLog(@"Making blocks");
    orderInfoScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, 320.0f, [constants getScreenHeight] - 40)];
    [self.view addSubview:orderInfoScrollView];
    
    //Set color for headers
    [self generateHeaderColor];
    
    //Initialize subheader
    [self orderInfoHeader];
    
    [self orderStatisticsHolder];
    [self orderShippingHolder];
    [self orderProducts];
    [self orderTotals];
    [self orderInfoScrollView];
}

//Function for making subheader
-(void) orderInfoHeader
{
    NSLog(@"Creating Header");
    
    //Make subheader holder
    subHeader = [[UIView alloc] initWithFrame:CGRectMake(0.0f, 00.0f, 320.0f, 50.0f)];
    UIColor *lightGrey = [UIColor colorWithRed:55.0f/255.0f green:53.0f/255.0f blue:61.0f/255.0f alpha:1.0];
    UIColor *darkGrey = [UIColor colorWithRed:47.0f/255.0f green:46.0f/255.0f blue:53.0f/255.0f alpha:1.0];
    CAGradientLayer *gradient = [CAGradientLayer layer];
    gradient.frame = [[subHeader layer] bounds];
    gradient.colors = [NSArray arrayWithObjects:
                       (id)lightGrey.CGColor,
                       (id)darkGrey.CGColor,
                       nil];
    gradient.locations = [NSArray arrayWithObjects:
                          [NSNumber numberWithFloat:0.0f],
                          [NSNumber numberWithFloat:0.7],
                          nil];
    [[subHeader layer] insertSublayer:gradient atIndex:0];
    subHeader.layer.shadowColor = [UIColor blackColor].CGColor;
    subHeader.layer.shadowOpacity = 0.3f;
    subHeader.layer.shadowOffset = CGSizeMake(0,01);
    CGRect shadowPath = CGRectMake(subHeader.layer.bounds.origin.x - 10, subHeader.layer.bounds.size.height - 6, subHeader.layer.bounds.size.width + 20, 5);
    subHeader.layer.shadowPath = [UIBezierPath bezierPathWithRect:shadowPath].CGPath;
    [orderInfoScrollView addSubview:subHeader];
    
    //Make status buttons
    UIButton *holdButton = [UIBarButtonItem styledSubHeaderButtonWithTarget:self selector:@selector(setOrderOnHold) name:@"hold"];
    UIButton *cancelButton = [UIBarButtonItem styledSubHeaderButtonWithTarget:self selector:@selector(setOrderCancel) name:@"cancel"];
    UIButton *invoiceButton = [UIBarButtonItem styledSubHeaderButtonWithTarget:self selector:@selector(setOrderInvoice) name:@"invoice"];
    [subHeader addSubview:holdButton];
    [subHeader addSubview:cancelButton];
    [subHeader addSubview:invoiceButton];
}

//Handle action for hold button
-(void)setOrderOnHold
{
    if([[orderInfo orderStatus] isEqualToString:@"Pending"] || [[orderInfo orderStatus] isEqualToString:@"Processing"]){
        
        BlockAlertView *alertInvoice = [BlockAlertView alertWithTitle:@"Order on hold" message:@"Weet u zeker dat u deze order op hold wilt zetten?"];
        [alertInvoice setCancelButtonWithTitle:@"Nee" block:nil];
        [alertInvoice addButtonWithTitle:@"Ja" block:^{
            [self requestHold:@"salesOrderHold"];
        }];
        [alertInvoice show];
        
    } else if([[orderInfo orderStatus] isEqualToString:@"Holded"]) {
    
        BlockAlertView *alertInvoice = [BlockAlertView alertWithTitle:@"Order activeren" message:@"Weet u zeker dat u deze order wilt activeren?"];
        [alertInvoice setCancelButtonWithTitle:@"Nee" block:nil];
        [alertInvoice addButtonWithTitle:@"Ja" block:^{
            [self requestHold:@"salesOrderUnhold"];
        }];
        [alertInvoice show];
        
    }else {
        
        BlockAlertView *alertInvoice = [BlockAlertView alertWithTitle:@"Order on hold" message:@"U kunt deze order niet op hold zetten."];
        [alertInvoice addButtonWithTitle:@"Ok" block:nil];
        [alertInvoice show];
        
    }
}

//Handle action for cancel button
-(void)setOrderCancel
{
    if([[orderInfo orderStatus] isEqualToString:@"Canceled"]){
        
        BlockAlertView *alertInvoice = [BlockAlertView alertWithTitle:@"Order annuleren" message:@"U kunt deze order niet annuleren omdat hij al is geannuleerd."];
        [alertInvoice setCancelButtonWithTitle:@"Ok" block:nil];
        [alertInvoice show];
        
    } else if([[orderInfo orderStatus] isEqualToString:@"Complete"]) {
        
        BlockAlertView *alertInvoice = [BlockAlertView alertWithTitle:@"Order annuleren" message:@"U kunt deze order niet annuleren omdat hij al is afgehandeld."];
        [alertInvoice setCancelButtonWithTitle:@"Ok" block:nil];
        [alertInvoice show];
    
    }  else if([[orderInfo orderStatus] isEqualToString:@"Processing"]) {
        
        BlockAlertView *alertInvoice = [BlockAlertView alertWithTitle:@"Order annuleren" message:@"U kunt deze order niet annuleren omdat hij in behandeling is."];
        [alertInvoice setCancelButtonWithTitle:@"Ok" block:nil];
        [alertInvoice show];
        
    }else {
        
        BlockAlertView *alertInvoice = [BlockAlertView alertWithTitle:@"Order annuleren" message:@"Weet u zeker dat u deze order wilt annuleren?"];
        [alertInvoice setCancelButtonWithTitle:@"Nee" block:nil];
        [alertInvoice addButtonWithTitle:@"Ja" block:^{
            [self requestHold:@"salesOrderCancel"];
        }];
        [alertInvoice show];
    
    }
}

//Handle action for invoice button
-(void)setOrderInvoice
{
    if([[orderInfo orderStatus] isEqualToString:@"Pending"]){
        
        BlockAlertView *alertInvoice = [BlockAlertView alertWithTitle:@"Factuur verzenden" message:@"Weet u zeker dat u een factuur voor deze bestelling wilt verzenden?"];
        [alertInvoice setCancelButtonWithTitle:@"Nee" block:nil];
        [alertInvoice addButtonWithTitle:@"Ja" block:^{
            [self requestInvoice];
        }];
        [alertInvoice show];
        
    } else {
        
        BlockAlertView *alertInvoice = [BlockAlertView alertWithTitle:@"Factuur verzenden" message:@"U kunt geen factuur voor deze order verzenden."];
        [alertInvoice addButtonWithTitle:@"Ok" block:nil];
        [alertInvoice show];
        
    }
}

//If the 'Invoice' button is pressed
-(void)requestInvoice{
    
    NSLog(@"Creating Invoice initiated");
    int itemsCount = [[[orderInfoHolder valueForKey:@"data-items"] valueForKey:@"items" ] count];
    NSMutableString* requestParams = [NSMutableString string];
    [requestParams appendString:[orderInfo orderId] ];
    
    for (int i = 0; i < itemsCount; i++){
        NSString *itemId = [[NSString alloc] initWithFormat:@"%@", [[[[orderInfoHolder valueForKey:@"data-items"] valueForKey:@"items" ] objectAtIndex:i] valueForKey:@"item_id"]];
        NSString *qtyText = [[NSString alloc] initWithFormat:@"%@", [[[[orderInfoHolder valueForKey:@"data-items"] valueForKey:@"items" ] objectAtIndex:i] valueForKey:@"qty_ordered"]];
        
        [requestParams appendString:[NSString stringWithFormat:@"|%@ . %@", itemId, qtyText] ];
    }
    
    NSLog(@"Created product string: %@", requestParams);
    [self loginRequest:[shopInfo shopUrl] username:[shopInfo username] password:[shopInfo password] request:@"salesOrderInvoiceCreate" requestParams:requestParams];
    scrollViewHeight = 0;
    [self reloadScrollview];
}

//If the 'Hold' button is pressed
-(void)requestHold:(NSString*)type{
    
    NSLog(@"Hold order request initiated");
    NSMutableString* requestParams = [NSMutableString string];
    [requestParams appendString:[orderInfo orderId]];
    
    NSLog(@"Created product string: %@", requestParams);
    [self loginRequest:[shopInfo shopUrl] username:[shopInfo username] password:[shopInfo password] request:type requestParams:requestParams];
    
    //Scrollview reloaden
    scrollViewHeight = 0;
    [self reloadScrollview];
}

//If the 'Cancel' button is pressed
-(void)requestCancel:(NSString*)type{
    
    NSLog(@"Cancel order request initiated");
    NSMutableString* requestParams = [NSMutableString string];
    [requestParams appendString:[orderInfo orderId]];
    
    [self loginRequest:[shopInfo shopUrl] username:[shopInfo username] password:[shopInfo password] request:type requestParams:requestParams];
    
    //Scrollview reloaden
    scrollViewHeight = 0;
    [self reloadScrollview];
}

-(void)orderStatisticsHolder{
     NSLog(@"Creating block Statistics");
    //Add to Scroll View Height
    scrollViewHeight += (110 + 10);
    
    UIView *orderStatisticsHolder = [[UIView alloc] initWithFrame:CGRectMake(10.0f, 60.0f, 301.0f, 110.0f)];
    orderStatisticsHolder.backgroundColor = [UIColor colorWithRed:225.0f/255.0f green:224.0f/255.0f blue:225.0f/255.0f alpha:1.0f];
    orderStatisticsHolder.layer.cornerRadius = 5.0f;
    orderStatisticsHolder.layer.masksToBounds = YES;
    [orderInfoScrollView addSubview:orderStatisticsHolder];
    
    //Create header for the statistics holder
    UIView *statisticsHeader = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 301, 30)];
    UIView *borderBottom = [[UIView alloc] initWithFrame:CGRectMake(0, 30, 301, 1)];
    statisticsHeader.backgroundColor = headerColor;
    borderBottom.backgroundColor = [UIColor clearColor];
    [orderStatisticsHolder addSubview:statisticsHeader];
    [orderStatisticsHolder addSubview:borderBottom];
    
    //Create Title
    NSString* orderId = [[NSString alloc] initWithFormat:@"Order: #%@", [[orderInfoHolder valueForKey:@"data-items"] valueForKey:@"increment_id"]];
    UILabel *title = [[UILabel alloc] initWithFrame:CGRectMake(10.0f, 3.0f, 301.0f, 25.0f)];
    title.backgroundColor = [UIColor clearColor];
    title.font = [UIFont boldSystemFontOfSize:14.0f];
    title.textColor = [UIColor whiteColor];
    //title.shadowColor = [UIColor whiteColor];
    //title.shadowOffset = CGSizeMake(0, 1);
    title.text = orderId;
    [statisticsHeader addSubview:title];
    
    //Create body
    UIView *orderStatisticsBody = [[UIView alloc] initWithFrame:CGRectMake(0.0f, 31.0f, 301.0f, 85.0f)];
    orderStatisticsBody.backgroundColor = [UIColor clearColor];
    [orderStatisticsHolder addSubview:orderStatisticsBody];
    
    //Date
    NSString *dateText = [[NSString alloc] initWithFormat:@"Date: %@", [[orderInfoHolder valueForKey:@"data-items"] valueForKey:@"created_at"]];
    UILabel *date = [[UILabel alloc] initWithFrame:CGRectMake(10.0f, 5.0f, 301.0f, 25.0f)];
    date.backgroundColor = [UIColor clearColor];
    date.font = [UIFont systemFontOfSize:14.0f];
    date.textColor = [UIColor colorWithRed:87.0f/255.0f green:83.0f/255.0f blue:89.0f/255.0f alpha:1.0f];
    date.text = dateText;
    [orderStatisticsBody addSubview:date];
    
    //Status
    NSString *statusText = [[NSString alloc] initWithFormat:@"Status: %@", [[orderInfoHolder valueForKey:@"data-items"] valueForKey:@"status"]];
    UILabel *status = [[UILabel alloc] initWithFrame:CGRectMake(10.0f, 25.0f, 301.0f, 25.0f)];
    status.backgroundColor = [UIColor clearColor];
    status.font = [UIFont systemFontOfSize:14.0f];
    status.textColor = [UIColor colorWithRed:87.0f/255.0f green:83.0f/255.0f blue:89.0f/255.0f alpha:1.0f];
    status.text = statusText;
    [orderStatisticsBody addSubview:status];
    
    //Store
    NSString *storeText = [[NSString alloc] initWithFormat:@"Orderwaarde: €%@", [[orderInfoHolder valueForKey:@"data-items"] valueForKey:@"grand_total"]];
    UILabel *store = [[UILabel alloc] initWithFrame:CGRectMake(10.0f, 45.0f, 301.0f, 25.0f)];
    store.backgroundColor = [UIColor clearColor];
    store.font = [UIFont systemFontOfSize:14.0f];
    store.textColor = [UIColor colorWithRed:87.0f/255.0f green:83.0f/255.0f blue:89.0f/255.0f alpha:1.0f];
    store.text = storeText;
    [orderStatisticsBody addSubview:store];
}

-(void)orderShippingHolder
{
    NSLog(@"Creating block Shipping");
    //Add to Scroll View Height
    scrollViewHeight += (150 + 10);
    
    UIView *orderStatisticsHolder = [[UIView alloc] initWithFrame:CGRectMake(10.0f, 190.0f, 301.0f, 150.0f)];
    orderStatisticsHolder.backgroundColor = [UIColor colorWithRed:225.0f/255.0f green:224.0f/255.0f blue:225.0f/255.0f alpha:1.0f];
    orderStatisticsHolder.layer.cornerRadius = 5.0f;
    orderStatisticsHolder.layer.masksToBounds = YES;
    [orderInfoScrollView addSubview:orderStatisticsHolder];
    
    //Create header for the statistics holder
    UIView *statisticsHeader = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 301, 30)];
    UIView *borderBottom = [[UIView alloc] initWithFrame:CGRectMake(0, 30, 301, 1)];
    statisticsHeader.backgroundColor = headerColor;
    borderBottom.backgroundColor = [UIColor clearColor];
    [orderStatisticsHolder addSubview:statisticsHeader];
    [orderStatisticsHolder addSubview:borderBottom];
    
    //Create Title
    UILabel *title = [[UILabel alloc] initWithFrame:CGRectMake(10.0f, 3.0f, 301.0f, 25.0f)];
    title.backgroundColor = [UIColor clearColor];
    title.font = [UIFont boldSystemFontOfSize:14.0f];
    title.textColor = [UIColor whiteColor];
    //title.shadowColor = [UIColor whiteColor];
    //title.shadowOffset = CGSizeMake(0, 1);
    title.text = @"Factuuradres";
    [statisticsHeader addSubview:title];
    
    //Create body
    UIView *orderShippingBody = [[UIView alloc] initWithFrame:CGRectMake(0.0f, 31.0f, 301.0f, 110.0f)];
    orderShippingBody.backgroundColor = [UIColor clearColor];
    [orderStatisticsHolder addSubview:orderShippingBody];
   
    //First and lastname
    NSString *firstLastNameText = [[NSString alloc] initWithFormat:@"%@ %@", [[[orderInfoHolder valueForKey:@"data-items"] valueForKey:@"shipping_address"] valueForKey:@"firstname" ], [[[orderInfoHolder valueForKey:@"data-items"] valueForKey:@"shipping_address"] valueForKey:@"lastname" ]];
    UILabel *firstLastName = [[UILabel alloc] initWithFrame:CGRectMake(10.0f, 5.0f, 301.0f, 25.0f)];
    firstLastName.backgroundColor = [UIColor clearColor];
    firstLastName.font = [UIFont systemFontOfSize:14.0f];
    firstLastName.textColor = [UIColor colorWithRed:87.0f/255.0f green:83.0f/255.0f blue:89.0f/255.0f alpha:1.0f];
    firstLastName.text = firstLastNameText;
    [orderShippingBody addSubview:firstLastName];
    
    //Street
    NSString *streetText = [[NSString alloc] initWithFormat:@"%@", [[[orderInfoHolder valueForKey:@"data-items"] valueForKey:@"shipping_address"] valueForKey:@"street" ]];
    UILabel *street = [[UILabel alloc] initWithFrame:CGRectMake(10.0f, 25.0f, 301.0f, 25.0f)];
    street.backgroundColor = [UIColor clearColor];
    street.font = [UIFont systemFontOfSize:14.0f];
    street.textColor = [UIColor colorWithRed:87.0f/255.0f green:83.0f/255.0f blue:89.0f/255.0f alpha:1.0f];
    street.text = streetText;
    [orderShippingBody addSubview:street];
    
    //Postcode and City
    NSString *postcodeCityText = [[NSString alloc] initWithFormat:@"%@, %@", [[[orderInfoHolder valueForKey:@"data-items"] valueForKey:@"shipping_address"] valueForKey:@"postcode" ], [[[orderInfoHolder valueForKey:@"data-items"] valueForKey:@"shipping_address"] valueForKey:@"city" ]];
    UILabel *postcodeCity = [[UILabel alloc] initWithFrame:CGRectMake(10.0f, 45.0f, 301.0f, 25.0f)];
    postcodeCity.backgroundColor = [UIColor clearColor];
    postcodeCity.font = [UIFont systemFontOfSize:14.0f];
    postcodeCity.textColor = [UIColor colorWithRed:87.0f/255.0f green:83.0f/255.0f blue:89.0f/255.0f alpha:1.0f];
    postcodeCity.text = postcodeCityText;
    [orderShippingBody addSubview:postcodeCity];
    
    //Country
    NSString *countryText = [[NSString alloc] initWithFormat:@"%@", [[[orderInfoHolder valueForKey:@"data-items"] valueForKey:@"shipping_address"] valueForKey:@"country_id" ]];
    UILabel *country = [[UILabel alloc] initWithFrame:CGRectMake(10.0f, 65.0f, 301.0f, 25.0f)];
    country.backgroundColor = [UIColor clearColor];
    country.font = [UIFont systemFontOfSize:14.0f];
    country.textColor = [UIColor colorWithRed:87.0f/255.0f green:83.0f/255.0f blue:89.0f/255.0f alpha:1.0f];
    country.text = countryText;
    [orderShippingBody addSubview:country];
    
    //Telephone
    NSString *telephoneText = [[NSString alloc] initWithFormat:@"Tel: %@", [[[orderInfoHolder valueForKey:@"data-items"] valueForKey:@"shipping_address"] valueForKey:@"telephone" ]];
    UILabel *telephone = [[UILabel alloc] initWithFrame:CGRectMake(10.0f, 85.0f, 301.0f, 25.0f)];
    telephone.backgroundColor = [UIColor clearColor];
    telephone.font = [UIFont systemFontOfSize:14.0f];
    telephone.textColor = [UIColor colorWithRed:87.0f/255.0f green:83.0f/255.0f blue:89.0f/255.0f alpha:1.0f];
    telephone.text = telephoneText;
    [orderShippingBody addSubview:telephone];
}

-(void)orderProducts
{
    
    // Count the items
    int itemsCount = [[[orderInfoHolder valueForKey:@"data-items"] valueForKey:@"items" ] count];
    NSLog(@"Creating block and sublocks for %d products", itemsCount);
    // The holder for all the products
    // Setting productsheight so that the totals are getting good alligned
    productsHolderHeight = (61 * itemsCount + 30);
    
    //Add to Scroll View Height
    scrollViewHeight += (productsHolderHeight + 10);
    
    UIView *orderStatisticsHolder = [[UIView alloc] initWithFrame:CGRectMake(10.0f, 360.0f, 301.0f, productsHolderHeight)];
    orderStatisticsHolder.backgroundColor = [UIColor colorWithRed:225.0f/255.0f green:224.0f/255.0f blue:225.0f/255.0f alpha:1.0f];
    orderStatisticsHolder.layer.cornerRadius = 5.0f;
    orderStatisticsHolder.layer.masksToBounds = YES;
    [orderInfoScrollView addSubview:orderStatisticsHolder];
    
    //Create header for the statistics holder
    UIView *statisticsHeader = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 301, 30)];
    UIView *borderBottom = [[UIView alloc] initWithFrame:CGRectMake(0, 30, 301, 1)];
    statisticsHeader.backgroundColor = headerColor;
    borderBottom.backgroundColor = [UIColor clearColor];
    [orderStatisticsHolder addSubview:statisticsHeader];
    [orderStatisticsHolder addSubview:borderBottom];
    
    //Create Title
    UILabel *title = [[UILabel alloc] initWithFrame:CGRectMake(10.0f, 3.0f, 301.0f, 25.0f)];
    title.backgroundColor = [UIColor clearColor];
    title.font = [UIFont boldSystemFontOfSize:14.0f];
    title.textColor = [UIColor whiteColor];
    //title.shadowColor = [UIColor whiteColor];
    //title.shadowOffset = CGSizeMake(0, 1);
    title.text = @"Bestelde producten";
    [statisticsHeader addSubview:title];
    
    
    //The body for all the ordered products
    
    UIView *orderProductsBody = [[UIView alloc] initWithFrame:CGRectMake(0.0f, 30.0f, 301.0f, (60 * itemsCount))];
    orderProductsBody.backgroundColor = [UIColor clearColor];
    [orderStatisticsHolder addSubview:orderProductsBody];
   
    //Loop through all ordered products
    for (int i = 0; i < itemsCount; i++)
    {
        // For each product his own container
        UIView *orderProductContainer = [[UIView alloc] initWithFrame:CGRectMake(0.0f, (60 * i), 296.0f, 30.0f)];
        UIView *orderBorder = [[UIView alloc] initWithFrame:CGRectMake(0, 59, 301.0f, 1)];
        orderBorder.backgroundColor = [UIColor colorWithRed:147.0f/255.0f green:149.0f/255.0f blue:149.0f/255.0f alpha:1.0f];
        orderProductContainer.backgroundColor = [UIColor clearColor];
        [orderProductsBody addSubview:orderProductContainer];
        
        //No border for last item
        if((i + 1) != itemsCount){
            [orderProductContainer addSubview:orderBorder];
        }
            
        NSString *productNameText = [[NSString alloc] initWithFormat:@"%@", [[[[orderInfoHolder valueForKey:@"data-items"] valueForKey:@"items" ] objectAtIndex:i] valueForKey:@"name"]];
        NSMutableString *qtyText = [[NSMutableString alloc] initWithFormat:@"%@", [[[[orderInfoHolder valueForKey:@"data-items"] valueForKey:@"items" ] objectAtIndex:i] valueForKey:@"qty_ordered"]];
        [qtyText appendString:@" stuk(s)"];
        NSString *priceText = [[NSString alloc] initWithFormat:@"€%@", [[[[orderInfoHolder valueForKey:@"data-items"] valueForKey:@"items" ] objectAtIndex:i] valueForKey:@"price"]];
        
        UILabel *productName = [[UILabel alloc] initWithFrame:CGRectMake(10.0f, 10.0f, 296.0f, 20.0f)];
        productName.font = [UIFont systemFontOfSize:14.0f];
        productName.textColor = [UIColor colorWithRed:87.0f/255.0f green:83.0f/255.0f blue:89.0f/255.0f alpha:1.0f];
        productName.backgroundColor = [UIColor clearColor];
        productName.text = productNameText;
        [orderProductContainer addSubview:productName];
        
        UILabel *qty = [[UILabel alloc] initWithFrame:CGRectMake(10.0f, 35.0f, 296.0f, 20.0f)];
        qty.font = [UIFont systemFontOfSize:14.0f];
        qty.textColor = [UIColor colorWithRed:87.0f/255.0f green:83.0f/255.0f blue:89.0f/255.0f alpha:1.0f];
        qty.backgroundColor = [UIColor clearColor];
        qty.text = qtyText;
        [orderProductContainer addSubview:qty];
        
        UILabel *price = [[UILabel alloc] initWithFrame:CGRectMake(100.0f, 10.0f, 190.0f, 20.0f)];
        price.font = [UIFont boldSystemFontOfSize:14.0f];
        price.textColor = [UIColor colorWithRed:87.0f/255.0f green:83.0f/255.0f blue:89.0f/255.0f alpha:1.0f];
        price.textAlignment = UITextAlignmentRight;
        price.backgroundColor = [UIColor clearColor];
        price.text = priceText;
        [orderProductContainer addSubview:price];
    }
   
}

-(void)orderTotals{
    NSLog(@"Creating block Totals");
    //Add to Scroll View Height
    scrollViewHeight += (210 + 10);
    
    UIView *orderStatisticsHolder = [[UIView alloc] initWithFrame:CGRectMake(10.0f, productsHolderHeight + 380, 301.0f, 210.0)];
    orderStatisticsHolder.backgroundColor = [UIColor colorWithRed:225.0f/255.0f green:224.0f/255.0f blue:225.0f/255.0f alpha:1.0f];
    orderStatisticsHolder.layer.cornerRadius = 5.0f;
    orderStatisticsHolder.layer.masksToBounds = YES;
    [orderInfoScrollView addSubview:orderStatisticsHolder];
    
    //Create header for the statistics holder
    UIView *statisticsHeader = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 301, 30)];
    UIView *borderBottom = [[UIView alloc] initWithFrame:CGRectMake(0, 30, 301, 1)];
    statisticsHeader.backgroundColor = headerColor;
    borderBottom.backgroundColor = [UIColor clearColor];
    [orderStatisticsHolder addSubview:statisticsHeader];
    [orderStatisticsHolder addSubview:borderBottom];
    
    //Create Title
    UILabel *title = [[UILabel alloc] initWithFrame:CGRectMake(10.0f, 3.0f, 301.0f, 25.0f)];
    title.backgroundColor = [UIColor clearColor];
    title.font = [UIFont boldSystemFontOfSize:14.0f];
    title.textColor = [UIColor whiteColor];
    //title.shadowColor = [UIColor whiteColor];
    //title.shadowOffset = CGSizeMake(0, 1);
    title.text = @"Totalen";
    [statisticsHeader addSubview:title];
    
    UIView *orderTotalsBody = [[UIView alloc] initWithFrame:CGRectMake(0.0f, 31.0f, 301.0f, 175.0f)];
    orderTotalsBody.backgroundColor = [UIColor clearColor];
    [orderStatisticsHolder addSubview:orderTotalsBody];
    
    //Subtotal
    NSString *subtotalText = @"Subtotaal:";
    UILabel *subtotal = [[UILabel alloc] initWithFrame:CGRectMake(10.0f, 10.0f, 301.0f, 25.0f)];
    subtotal.backgroundColor = [UIColor clearColor];
    subtotal.font = [UIFont systemFontOfSize:14.0f];
    subtotal.textColor = [UIColor colorWithRed:87.0f/255.0f green:83.0f/255.0f blue:89.0f/255.0f alpha:1.0f];
    subtotal.text = subtotalText;
    [orderTotalsBody addSubview:subtotal];
    
    NSString *subtotalValue = [[NSString alloc] initWithFormat:@"€%@", [[orderInfoHolder valueForKey:@"data-items"] valueForKey:@"subtotal"]];
    UILabel *subtotalContent = [[UILabel alloc] initWithFrame:CGRectMake(100.0f, 10.0f, 190.0f, 25.0f)];
    subtotalContent.backgroundColor = [UIColor clearColor];
    subtotalContent.textAlignment = UITextAlignmentRight;
    subtotalContent.font = [UIFont systemFontOfSize:14.0f];
    subtotalContent.textColor = [UIColor colorWithRed:87.0f/255.0f green:83.0f/255.0f blue:89.0f/255.0f alpha:1.0f];
    subtotalContent.text = subtotalValue;
    [orderTotalsBody addSubview:subtotalContent];
    
    //Tax
    NSString *taxAmountText = @"BTW:";
    UILabel *taxAmount = [[UILabel alloc] initWithFrame:CGRectMake(10.0f, 30.0f, 301.0f, 25.0f)];
    taxAmount.backgroundColor = [UIColor clearColor];
    taxAmount.font = [UIFont systemFontOfSize:14.0f];
    taxAmount.textColor = [UIColor colorWithRed:87.0f/255.0f green:83.0f/255.0f blue:89.0f/255.0f alpha:1.0f];
    taxAmount.text = taxAmountText;
    [orderTotalsBody addSubview:taxAmount];
    
    NSString *taxAmountValue = [[NSString alloc] initWithFormat:@"€%@,-", [[orderInfoHolder valueForKey:@"data-items"] valueForKey:@"tax_amount"]];
    UILabel *taxAmountContent = [[UILabel alloc] initWithFrame:CGRectMake(100.0f, 30.0f, 190.0f, 25.0f)];
    taxAmountContent.backgroundColor = [UIColor clearColor];
    taxAmountContent.textAlignment = UITextAlignmentRight;
    taxAmountContent.font = [UIFont systemFontOfSize:14.0f];
    taxAmountContent.textColor = [UIColor colorWithRed:87.0f/255.0f green:83.0f/255.0f blue:89.0f/255.0f alpha:1.0f];
    taxAmountContent.text = taxAmountValue;
    [orderTotalsBody addSubview:taxAmountContent];
    
    //Shipping amount
    NSString *shippingAmountText = @"Verzendkosten:";
    UILabel *shippingAmount = [[UILabel alloc] initWithFrame:CGRectMake(10.0f, 50.0f, 301.0f, 25.0f)];
    shippingAmount.backgroundColor = [UIColor clearColor];
    shippingAmount.font = [UIFont systemFontOfSize:14.0f];
    shippingAmount.textColor = [UIColor colorWithRed:87.0f/255.0f green:83.0f/255.0f blue:89.0f/255.0f alpha:1.0f];
    shippingAmount.text = shippingAmountText;
    [orderTotalsBody addSubview:shippingAmount];
    
    NSString *shippingAmountValue = [[NSString alloc] initWithFormat:@"€%@", [[orderInfoHolder valueForKey:@"data-items"] valueForKey:@"shipping_amount"]];
    UILabel *shippingAmountContent = [[UILabel alloc] initWithFrame:CGRectMake(100.0f, 50.0f, 190.0f, 25.0f)];
    shippingAmountContent.backgroundColor = [UIColor clearColor];
    shippingAmountContent.textAlignment = UITextAlignmentRight;
    shippingAmountContent.font = [UIFont systemFontOfSize:14.0f];
    shippingAmountContent.textColor = [UIColor colorWithRed:87.0f/255.0f green:83.0f/255.0f blue:89.0f/255.0f alpha:1.0f];
    shippingAmountContent.text = shippingAmountValue;
    [orderTotalsBody addSubview:shippingAmountContent];

    //Grand total
    NSString *grandTotalText = @"Totaal:";
    UILabel *grandTotal = [[UILabel alloc] initWithFrame:CGRectMake(10.0f, 70.0f, 301.0f, 25.0f)];
    grandTotal.backgroundColor = [UIColor clearColor];
    grandTotal.font = [UIFont systemFontOfSize:14.0f];
    grandTotal.textColor = [UIColor colorWithRed:87.0f/255.0f green:83.0f/255.0f blue:89.0f/255.0f alpha:1.0f];
    grandTotal.text = grandTotalText;
    [orderTotalsBody addSubview:grandTotal];
    
    NSString *grandTotalValue = [[NSString alloc] initWithFormat:@"€%@", [[orderInfoHolder valueForKey:@"data-items"] valueForKey:@"grand_total"]];
    UILabel *grandTotalContent = [[UILabel alloc] initWithFrame:CGRectMake(100.0f, 70.0f, 190.0f, 25.0f)];
    grandTotalContent.backgroundColor = [UIColor clearColor];
    grandTotalContent.textAlignment = UITextAlignmentRight;
    grandTotalContent.font = [UIFont systemFontOfSize:14.0f];
    grandTotalContent.textColor = [UIColor colorWithRed:87.0f/255.0f green:83.0f/255.0f blue:89.0f/255.0f alpha:1.0f];
    grandTotalContent.text = grandTotalValue;
    [orderTotalsBody addSubview:grandTotalContent];
    
    //Total paid
    NSString *totalPaidText = @"Totaal betaald:";
    UILabel *totalPaid = [[UILabel alloc] initWithFrame:CGRectMake(10.0f, 105.0f, 301.0f, 25.0f)];
    totalPaid.backgroundColor = [UIColor clearColor];
    totalPaid.font = [UIFont systemFontOfSize:14.0f];
    totalPaid.textColor = [UIColor colorWithRed:87.0f/255.0f green:83.0f/255.0f blue:89.0f/255.0f alpha:1.0f];
    totalPaid.text = totalPaidText;
    [orderTotalsBody addSubview:totalPaid];
    
    NSString *totalPaidValue = [[NSString alloc] initWithFormat:@"€%@", [[orderInfoHolder valueForKey:@"data-items"] valueForKey:@"total_paid"]];
    UILabel *totalPaidContent = [[UILabel alloc] initWithFrame:CGRectMake(100.0f, 105.0f, 190.0f, 25.0f)];
    totalPaidContent.backgroundColor = [UIColor clearColor];
    totalPaidContent.textAlignment = UITextAlignmentRight;
    totalPaidContent.font = [UIFont systemFontOfSize:14.0f];
    totalPaidContent.textColor = [UIColor colorWithRed:87.0f/255.0f green:83.0f/255.0f blue:89.0f/255.0f alpha:1.0f];
    totalPaidContent.text = totalPaidValue;
    [orderTotalsBody addSubview:totalPaidContent];
    
    //Total refunded
    NSString *totalRefundedText = @"Totaal terugbetaald:";
    UILabel *totalRefunded = [[UILabel alloc] initWithFrame:CGRectMake(10.0f, 125.0f, 301.0f, 25.0f)];
    totalRefunded.backgroundColor = [UIColor clearColor];
    totalRefunded.font = [UIFont systemFontOfSize:14.0f];
    totalRefunded.textColor = [UIColor colorWithRed:87.0f/255.0f green:83.0f/255.0f blue:89.0f/255.0f alpha:1.0f];
    totalRefunded.text = totalRefundedText;
    [orderTotalsBody addSubview:totalRefunded];
    
    NSString *totalRefundedValue = [[NSString alloc] initWithFormat:@"€%@", [[orderInfoHolder valueForKey:@"data-items"] valueForKey:@"total_refunded"]];
    UILabel *totalRefundedContent = [[UILabel alloc] initWithFrame:CGRectMake(100.0f, 125.0f, 190.0f, 25.0f)];
    totalRefundedContent.backgroundColor = [UIColor clearColor];
    totalRefundedContent.textAlignment = UITextAlignmentRight;
    totalRefundedContent.font = [UIFont systemFontOfSize:14.0f];
    totalRefundedContent.textColor = [UIColor colorWithRed:87.0f/255.0f green:83.0f/255.0f blue:89.0f/255.0f alpha:1.0f];
    totalRefundedContent.text = totalRefundedValue;
    [orderTotalsBody addSubview:totalRefundedContent];
    
    //Total due
    NSString *totalDueText = @"Totaal openstaand:";
    UILabel *totalDue = [[UILabel alloc] initWithFrame:CGRectMake(10.0f, 145.0f, 301.0f, 25.0f)];
    totalDue.backgroundColor = [UIColor clearColor];
    totalDue.font = [UIFont systemFontOfSize:14.0f];
    totalDue.textColor = [UIColor colorWithRed:87.0f/255.0f green:83.0f/255.0f blue:89.0f/255.0f alpha:1.0f];
    totalDue.text = totalDueText;
    [orderTotalsBody addSubview:totalDue];
    
    NSString *totalDueValue = [[NSString alloc] initWithFormat:@"€%@", [[orderInfoHolder valueForKey:@"data-items"] valueForKey:@"total_due"]];
    UILabel *totalDueContent = [[UILabel alloc] initWithFrame:CGRectMake(100.0f, 145.0f, 190.0f, 25.0f)];
    totalDueContent.backgroundColor = [UIColor clearColor];
    totalDueContent.textAlignment = UITextAlignmentRight;
    totalDueContent.font = [UIFont systemFontOfSize:14.0f];
    totalDueContent.textColor = [UIColor colorWithRed:87.0f/255.0f green:83.0f/255.0f blue:89.0f/255.0f alpha:1.0f];
    totalDueContent.text = totalDueValue;
    [orderTotalsBody addSubview:totalDueContent];
    
}

-(void)orderInfoScrollView
{
    NSLog(@"Setting height of scrollview");
    [orderInfoScrollView setContentSize:CGSizeMake(320, scrollViewHeight + 120)];
    
}
@end
