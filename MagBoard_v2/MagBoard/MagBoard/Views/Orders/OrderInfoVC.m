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

@synthesize shopInfo, orderInfoHolder, orderInfo, header, createInvoice;

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    shopInfo = [ShopSingleton shopSingleton];
    orderInfo = [OrderSingleton orderSingleton];
    [self constructHeader];
    NSLog(@"%@", [orderInfo orderId]);
    [self loginRequest:[shopInfo shopUrl] username:[shopInfo username] password:[shopInfo password] request:@"salesOrderInfo" requestParams:[orderInfo orderId]];
    //[self loadingRequest];
}

-(void)constructHeader
{
    NSString *barTitle = [NSString stringWithFormat:@"Order: %@", [orderInfo orderId]];
    
    UILabel* navBarTitle = [CustomNavBar setNavBarTitle:barTitle];
    self.navigationItem.titleView = navBarTitle;
    self.navigationItem.leftBarButtonItem = [UIBarButtonItem styledBarButtonItemWithTarget:self selector:@selector(backButtonTouched) title:@"Terug"];
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

//If the 'Invoice' button is pressed
-(void)createInvoice{
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
                //[self backButtonTouched];
           
            NSLog(@"Status: %@", [orderInfoHolder valueForKey:@"session"]);
            NSLog(@"Code: %@", [orderInfoHolder valueForKey:@"message"]);
             NSLog(@"Data items: %@", [orderInfoHolder valueForKey:@"data-items"]);
            //NSLog(@"Data-items: %@", [orderInfoHolder valueForKey:@"data-items"]);
            //Check what type of data is given back (1002 is orderInfo, 1003 is invoiceCreate)
            if([[orderInfoHolder valueForKey:@"message"] isEqualToString: @"1002"]){
                [self makeBlocks];
            }else if([[orderInfoHolder valueForKey:@"message"] isEqualToString: @"1003"]){
                [self invoiceSuccess];
            } else {
                 NSLog(@"Message: %@", [orderInfoHolder valueForKey:@"data-items"]);
            }
        
        } else
        {
            NSLog(@"Something went wrong in the API");
        }
    } else {
        NSLog(@"Er ging iets mis %d", [response status]);
    }
    
   // NSLog(@"OrderInfo: %@", [orderInfoHolder valueForKey:@"data-items"]);
    //[loadingIcon stopAnimating];
    
}

- (void)makeBlocks
{
    NSLog(@"Making blocks");
    orderInfoScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0.0f, 40.0f, 320.0f, 440.0f)];
    [self.view addSubview:orderInfoScrollView];

    [self orderInfoHeader];
    [self orderStatisticsHolder];
    [self orderShippingHolder];
    [self orderProducts];
    [self orderTotals];
    [self orderInfoScrollView];
}

- (void)invoiceSuccess
{
    NSLog(@"Factuur is aangemaakt");
    [createInvoice removeFromSuperview];
}
-(void) orderInfoHeader
{
    NSLog(@"Creating Header");
    header = [[UIView alloc] initWithFrame:CGRectMake(0.0f, 00.0f, 320.0f, 40.0f)];
    header.backgroundColor = [UIColor blackColor];
    [self.view addSubview:header];
    
     NSString *statusText = [[NSString alloc] initWithFormat:@"%@", [[orderInfoHolder valueForKey:@"data-items"] valueForKey:@"status"]];
    if([statusText isEqualToString:@"Pending"]){
        createInvoice = [[UIButton alloc] initWithFrame:CGRectMake(10.0f, 5.0f, 90.0f, 30.0f)];
        [createInvoice setBackgroundColor: [UIColor whiteColor]];
        [createInvoice setTitle:@"Factuur" forState:UIControlStateNormal];
        [createInvoice setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [createInvoice addTarget:self action:@selector(createInvoice) forControlEvents:UIControlEventTouchDown];
        [header addSubview:createInvoice];
    }
}

-(void)orderStatisticsHolder{
     NSLog(@"Creating block Statistics");
    //Add to Scroll View Height
    scrollViewHeight += (110 + 10);
    
    UIView *orderStatisticsHolder = [[UIView alloc] initWithFrame:CGRectMake(10.0f, 20.0f, 301.0f, 110.0f)];
    orderStatisticsHolder.backgroundColor = [UIColor colorWithRed:225.0f/255.0f green:224.0f/255.0f blue:225.0f/255.0f alpha:1.0f];
    orderStatisticsHolder.layer.cornerRadius = 5.0f;
    orderStatisticsHolder.layer.masksToBounds = YES;
    [orderInfoScrollView addSubview:orderStatisticsHolder];
    
    //Create header for the statistics holder
    UIView *statisticsHeader = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 301, 30)];
    UIView *borderBottom = [[UIView alloc] initWithFrame:CGRectMake(0, 30, 301, 1)];
    statisticsHeader.backgroundColor = [UIColor colorWithRed:184.0f/255.0f green:199.0f/255.0f blue:221.0f/255.0f alpha:1.0f];
    borderBottom.backgroundColor = [UIColor colorWithRed:147.0f/255.0f green:149.0f/255.0f blue:149.0f/255.0f alpha:1.0f];
    [orderStatisticsHolder addSubview:statisticsHeader];
    [orderStatisticsHolder addSubview:borderBottom];
    
    //Create Title
    NSString* orderId = [[NSString alloc] initWithFormat:@"Order: #%@", [[orderInfoHolder valueForKey:@"data-items"] valueForKey:@"increment_id"]];
    UILabel *title = [[UILabel alloc] initWithFrame:CGRectMake(10.0f, 3.0f, 301.0f, 25.0f)];
    title.backgroundColor = [UIColor clearColor];
    title.font = [UIFont boldSystemFontOfSize:14.0f];
    title.textColor = [UIColor colorWithRed:87.0f/255.0f green:83.0f/255.0f blue:89.0f/255.0f alpha:1.0f];
    title.shadowColor = [UIColor whiteColor];
    title.shadowOffset = CGSizeMake(0, 1);
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
    
    UIView *orderStatisticsHolder = [[UIView alloc] initWithFrame:CGRectMake(10.0f, 150.0f, 301.0f, 150.0f)];
    orderStatisticsHolder.backgroundColor = [UIColor colorWithRed:225.0f/255.0f green:224.0f/255.0f blue:225.0f/255.0f alpha:1.0f];
    orderStatisticsHolder.layer.cornerRadius = 5.0f;
    orderStatisticsHolder.layer.masksToBounds = YES;
    [orderInfoScrollView addSubview:orderStatisticsHolder];
    
    //Create header for the statistics holder
    UIView *statisticsHeader = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 301, 30)];
    UIView *borderBottom = [[UIView alloc] initWithFrame:CGRectMake(0, 30, 301, 1)];
    statisticsHeader.backgroundColor = [UIColor colorWithRed:184.0f/255.0f green:199.0f/255.0f blue:221.0f/255.0f alpha:1.0f];
    borderBottom.backgroundColor = [UIColor colorWithRed:147.0f/255.0f green:149.0f/255.0f blue:149.0f/255.0f alpha:1.0f];
    [orderStatisticsHolder addSubview:statisticsHeader];
    [orderStatisticsHolder addSubview:borderBottom];
    
    //Create Title
    UILabel *title = [[UILabel alloc] initWithFrame:CGRectMake(10.0f, 3.0f, 301.0f, 25.0f)];
    title.backgroundColor = [UIColor clearColor];
    title.font = [UIFont boldSystemFontOfSize:14.0f];
    title.textColor = [UIColor colorWithRed:87.0f/255.0f green:83.0f/255.0f blue:89.0f/255.0f alpha:1.0f];
    title.shadowColor = [UIColor whiteColor];
    title.shadowOffset = CGSizeMake(0, 1);
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
    
    UIView *orderStatisticsHolder = [[UIView alloc] initWithFrame:CGRectMake(10.0f, 320.0f, 301.0f, productsHolderHeight)];
    orderStatisticsHolder.backgroundColor = [UIColor colorWithRed:225.0f/255.0f green:224.0f/255.0f blue:225.0f/255.0f alpha:1.0f];
    orderStatisticsHolder.layer.cornerRadius = 5.0f;
    orderStatisticsHolder.layer.masksToBounds = YES;
    [orderInfoScrollView addSubview:orderStatisticsHolder];
    
    //Create header for the statistics holder
    UIView *statisticsHeader = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 301, 30)];
    UIView *borderBottom = [[UIView alloc] initWithFrame:CGRectMake(0, 30, 301, 1)];
    statisticsHeader.backgroundColor = [UIColor colorWithRed:184.0f/255.0f green:199.0f/255.0f blue:221.0f/255.0f alpha:1.0f];
    borderBottom.backgroundColor = [UIColor colorWithRed:147.0f/255.0f green:149.0f/255.0f blue:149.0f/255.0f alpha:1.0f];
    [orderStatisticsHolder addSubview:statisticsHeader];
    [orderStatisticsHolder addSubview:borderBottom];
    
    //Create Title
    UILabel *title = [[UILabel alloc] initWithFrame:CGRectMake(10.0f, 3.0f, 301.0f, 25.0f)];
    title.backgroundColor = [UIColor clearColor];
    title.font = [UIFont boldSystemFontOfSize:14.0f];
    title.textColor = [UIColor colorWithRed:87.0f/255.0f green:83.0f/255.0f blue:89.0f/255.0f alpha:1.0f];
    title.shadowColor = [UIColor whiteColor];
    title.shadowOffset = CGSizeMake(0, 1);
    title.text = @"Bestelde producten";
    [statisticsHeader addSubview:title];
    
    
    //The body for all the ordered products
    
    UIView *orderProductsBody = [[UIView alloc] initWithFrame:CGRectMake(0.0f, 30.0f, 301.0f, (61 * itemsCount))];
    orderProductsBody.backgroundColor = [UIColor clearColor];
    [orderStatisticsHolder addSubview:orderProductsBody];
   
    //Loop through all ordered products
    for (int i = 0; i < itemsCount; i++)
    {
        // For each product his own container
        UIView *orderProductContainer = [[UIView alloc] initWithFrame:CGRectMake(0.0f, (60 * i), 296.0f, 30.0f)];
        UIView *orderBorder = [[UIView alloc] initWithFrame:CGRectMake(0, (61 * i), 301.0f, 1)];
        orderBorder.backgroundColor = [UIColor colorWithRed:147.0f/255.0f green:149.0f/255.0f blue:149.0f/255.0f alpha:1.0f];
        orderProductContainer.backgroundColor = [UIColor clearColor];
        [orderProductsBody addSubview:orderBorder];
        [orderProductsBody addSubview:orderProductContainer];
        
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
    
    UIView *orderStatisticsHolder = [[UIView alloc] initWithFrame:CGRectMake(10.0f, productsHolderHeight + 340, 301.0f, 210.0)];
    orderStatisticsHolder.backgroundColor = [UIColor colorWithRed:225.0f/255.0f green:224.0f/255.0f blue:225.0f/255.0f alpha:1.0f];
    orderStatisticsHolder.layer.cornerRadius = 5.0f;
    orderStatisticsHolder.layer.masksToBounds = YES;
    [orderInfoScrollView addSubview:orderStatisticsHolder];
    
    //Create header for the statistics holder
    UIView *statisticsHeader = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 301, 30)];
    UIView *borderBottom = [[UIView alloc] initWithFrame:CGRectMake(0, 30, 301, 1)];
    statisticsHeader.backgroundColor = [UIColor colorWithRed:184.0f/255.0f green:199.0f/255.0f blue:221.0f/255.0f alpha:1.0f];
    borderBottom.backgroundColor = [UIColor colorWithRed:147.0f/255.0f green:149.0f/255.0f blue:149.0f/255.0f alpha:1.0f];
    [orderStatisticsHolder addSubview:statisticsHeader];
    [orderStatisticsHolder addSubview:borderBottom];
    
    //Create Title
    UILabel *title = [[UILabel alloc] initWithFrame:CGRectMake(10.0f, 3.0f, 301.0f, 25.0f)];
    title.backgroundColor = [UIColor clearColor];
    title.font = [UIFont boldSystemFontOfSize:14.0f];
    title.textColor = [UIColor colorWithRed:87.0f/255.0f green:83.0f/255.0f blue:89.0f/255.0f alpha:1.0f];
    title.shadowColor = [UIColor whiteColor];
    title.shadowOffset = CGSizeMake(0, 1);
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
