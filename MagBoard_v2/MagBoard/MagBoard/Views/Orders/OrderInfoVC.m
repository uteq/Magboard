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

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

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
    self.navigationItem.leftBarButtonItem = [UIBarButtonItem styledBackBarButtonItemWithTarget:self selector:@selector(backButtonTouched)];
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
        NSString *qtyText = [[NSString alloc] initWithFormat:@"%@", [[[[orderInfoHolder valueForKey:@"data-items"] valueForKey:@"items" ] objectAtIndex:i] valueForKey:@"qty_ordered"]];
        NSString *itemId = [[NSString alloc] initWithFormat:@"%@", [[[[orderInfoHolder valueForKey:@"data-items"] valueForKey:@"items" ] objectAtIndex:i] valueForKey:@"item_id"]];
        
        [requestParams appendString:[NSString stringWithFormat:@"|%@ . %@", qtyText, itemId] ];
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
    header.backgroundColor = [UIColor purpleColor];
    [self.view addSubview:header];
    
    createInvoice = [[UIButton alloc] initWithFrame:CGRectMake(10.0f, 5.0f, 90.0f, 30.0f)];
    [createInvoice setBackgroundColor: [UIColor whiteColor]];
    [createInvoice setTitle:@"Factuur" forState:UIControlStateNormal];
    [createInvoice setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [createInvoice addTarget:self action:@selector(createInvoice) forControlEvents:UIControlEventTouchDown];
    [header addSubview:createInvoice];
}

-(void)orderStatisticsHolder{
     NSLog(@"Creating block Statistics");
    //Add to Scroll View Height
    scrollViewHeight += (110 + 10);
    
    UIView *orderStatisticsHolder = [[UIView alloc] initWithFrame:CGRectMake(10.0f, 20.0f, 301.0f, 110.0f)];
    orderStatisticsHolder.backgroundColor = [UIColor whiteColor];
    
    //The statistics main view
    [orderInfoScrollView addSubview:orderStatisticsHolder];
    
    //Create Header and Title
    NSString* orderId = [[NSString alloc] initWithFormat:@"Order: #%@", [[orderInfoHolder valueForKey:@"data-items"] valueForKey:@"increment_id"]];
    UILabel *title = [[UILabel alloc] initWithFrame:CGRectMake(5.0f, 0.0f, 301.0f, 25.0f)];
    title.backgroundColor = [UIColor grayColor];
    title.font = [UIFont systemFontOfSize:12.0f];
    title.text = orderId;
    [orderStatisticsHolder addSubview:title];
    
    //Create body
    UIView *orderStatisticsBody = [[UIView alloc] initWithFrame:CGRectMake(0.0f, 25.0f, 301.0f, 85.0f)];
    orderStatisticsBody.backgroundColor = [UIColor whiteColor];
    [orderStatisticsHolder addSubview:orderStatisticsBody];
    
    //Date
    NSString *dateText = [[NSString alloc] initWithFormat:@"Date: %@", [[orderInfoHolder valueForKey:@"data-items"] valueForKey:@"created_at"]];
    UILabel *date = [[UILabel alloc] initWithFrame:CGRectMake(5.0f, 5.0f, 301.0f, 25.0f)];
    date.backgroundColor = [UIColor clearColor];
    date.font = [UIFont systemFontOfSize:13.0f];
    date.text = dateText;
    [orderStatisticsBody addSubview:date];
    
    //Status
    NSString *statusText = [[NSString alloc] initWithFormat:@"Status: %@", [[orderInfoHolder valueForKey:@"data-items"] valueForKey:@"status"]];
    UILabel *status = [[UILabel alloc] initWithFrame:CGRectMake(5.0f, 25.0f, 301.0f, 25.0f)];
    status.backgroundColor = [UIColor clearColor];
    status.font = [UIFont systemFontOfSize:13.0f];
    status.text = statusText;
    [orderStatisticsBody addSubview:status];
    
    //Store
    NSString *storeText = [[NSString alloc] initWithFormat:@"Orderwaarde: €%@", [[orderInfoHolder valueForKey:@"data-items"] valueForKey:@"grand_total"]];
    UILabel *store = [[UILabel alloc] initWithFrame:CGRectMake(5.0f, 45.0f, 301.0f, 25.0f)];
    store.backgroundColor = [UIColor clearColor];
    store.font = [UIFont systemFontOfSize:13.0f];
    store.text = storeText;
    [orderStatisticsBody addSubview:store];
}

-(void)orderShippingHolder
{
    NSLog(@"Creating block Shipping");
    //Add to Scroll View Height
    scrollViewHeight += (150 + 10);
    
    UIView *orderShippingHolder = [[UIView alloc] initWithFrame:CGRectMake(10.0f, 150.0f, 301.0f, 150.0f)];
    orderShippingHolder.backgroundColor = [UIColor whiteColor];
    
    [orderInfoScrollView addSubview:orderShippingHolder];
    
    UILabel *title = [[UILabel alloc] initWithFrame:CGRectMake(5.0f, 0.0f, 301.0f, 25.0f)];
    title.backgroundColor = [UIColor grayColor];
    title.font = [UIFont systemFontOfSize:12.0f];
    title.text = @"Factuuradres";
    [orderShippingHolder addSubview:title];
    
    //Create body
    UIView *orderShippingBody = [[UIView alloc] initWithFrame:CGRectMake(0.0f, 25.0f, 301.0f, 110.0f)];
    orderShippingBody.backgroundColor = [UIColor whiteColor];
    [orderShippingHolder addSubview:orderShippingBody];
   
    //First and lastname
    NSString *firstLastNameText = [[NSString alloc] initWithFormat:@"%@ %@", [[[orderInfoHolder valueForKey:@"data-items"] valueForKey:@"shipping_address"] valueForKey:@"firstname" ], [[[orderInfoHolder valueForKey:@"data-items"] valueForKey:@"shipping_address"] valueForKey:@"lastname" ]];
    UILabel *firstLastName = [[UILabel alloc] initWithFrame:CGRectMake(5.0f, 5.0f, 301.0f, 25.0f)];
    firstLastName.backgroundColor = [UIColor clearColor];
    firstLastName.font = [UIFont systemFontOfSize:13.0f];
    firstLastName.text = firstLastNameText;
    [orderShippingBody addSubview:firstLastName];
    
    //Street
    NSString *streetText = [[NSString alloc] initWithFormat:@"%@", [[[orderInfoHolder valueForKey:@"data-items"] valueForKey:@"shipping_address"] valueForKey:@"street" ]];
    UILabel *street = [[UILabel alloc] initWithFrame:CGRectMake(5.0f, 25.0f, 301.0f, 25.0f)];
    street.backgroundColor = [UIColor clearColor];
    street.font = [UIFont systemFontOfSize:13.0f];
    street.text = streetText;
    [orderShippingBody addSubview:street];
    
    //Postcode and City
    NSString *postcodeCityText = [[NSString alloc] initWithFormat:@"%@, %@", [[[orderInfoHolder valueForKey:@"data-items"] valueForKey:@"shipping_address"] valueForKey:@"postcode" ], [[[orderInfoHolder valueForKey:@"data-items"] valueForKey:@"shipping_address"] valueForKey:@"city" ]];
    UILabel *postcodeCity = [[UILabel alloc] initWithFrame:CGRectMake(5.0f, 45.0f, 301.0f, 25.0f)];
    postcodeCity.backgroundColor = [UIColor clearColor];
    postcodeCity.font = [UIFont systemFontOfSize:13.0f];
    postcodeCity.text = postcodeCityText;
    [orderShippingBody addSubview:postcodeCity];
    
    //Country
    NSString *countryText = [[NSString alloc] initWithFormat:@"%@", [[[orderInfoHolder valueForKey:@"data-items"] valueForKey:@"shipping_address"] valueForKey:@"country_id" ]];
    UILabel *country = [[UILabel alloc] initWithFrame:CGRectMake(5.0f, 65.0f, 301.0f, 25.0f)];
    country.backgroundColor = [UIColor clearColor];
    country.font = [UIFont systemFontOfSize:13.0f];
    country.text = countryText;
    [orderShippingBody addSubview:country];
    
    //Telephone
    NSString *telephoneText = [[NSString alloc] initWithFormat:@"Tel: %@", [[[orderInfoHolder valueForKey:@"data-items"] valueForKey:@"shipping_address"] valueForKey:@"telephone" ]];
    UILabel *telephone = [[UILabel alloc] initWithFrame:CGRectMake(5.0f, 85.0f, 301.0f, 25.0f)];
    telephone.backgroundColor = [UIColor clearColor];
    telephone.font = [UIFont systemFontOfSize:13.0f];
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
    productsHolderHeight = (45 * itemsCount + 25);
    
    //Add to Scroll View Height
    scrollViewHeight += (productsHolderHeight + 10);
    
    UIView *orderProductsHolder = [[UIView alloc] initWithFrame:CGRectMake(10.0f, 320.0f, 301.0f, productsHolderHeight)];
    orderProductsHolder.backgroundColor = [UIColor whiteColor];
    [orderInfoScrollView addSubview:orderProductsHolder];
    
    // The title head for the block Orderproducts
    UILabel *title = [[UILabel alloc] initWithFrame:CGRectMake(5.0f, 0.0f, 301.0f, 25.0f)];
    title.backgroundColor = [UIColor grayColor];
    title.font = [UIFont systemFontOfSize:12.0f];
    title.text = @"Bestelde Producten";
    [orderProductsHolder addSubview:title];
    
    
    //The body for all the ordered products
    
    UIView *orderProductsBody = [[UIView alloc] initWithFrame:CGRectMake(0.0f, 25.0f, 301.0f, (45 * itemsCount))];
    orderProductsBody.backgroundColor = [UIColor whiteColor];
    [orderProductsHolder addSubview:orderProductsBody];
   
    //Loop through all ordered products
    for (int i = 0; i < itemsCount; i++)
    {
        // For each product his own container
        UIView *orderProductContainer = [[UIView alloc] initWithFrame:CGRectMake(5.0f, (45 * i), 296.0f, 30.0f)];
        orderProductContainer.backgroundColor = [UIColor clearColor];
        [orderProductsBody addSubview:orderProductContainer];
        
        NSString *productNameText = [[NSString alloc] initWithFormat:@"%@", [[[[orderInfoHolder valueForKey:@"data-items"] valueForKey:@"items" ] objectAtIndex:i] valueForKey:@"name"]];
        NSString *qtyText = [[NSString alloc] initWithFormat:@"%@", [[[[orderInfoHolder valueForKey:@"data-items"] valueForKey:@"items" ] objectAtIndex:i] valueForKey:@"qty_ordered"]];
        NSString *priceText = [[NSString alloc] initWithFormat:@"€%@", [[[[orderInfoHolder valueForKey:@"data-items"] valueForKey:@"items" ] objectAtIndex:i] valueForKey:@"price"]];
        
        UILabel *productName = [[UILabel alloc] initWithFrame:CGRectMake(0.0f, 0.0f, 296.0f, 10.0f)];
        productName.font = [UIFont systemFontOfSize:10.0f];
        productName.backgroundColor = [UIColor clearColor];
        productName.text = productNameText;
        [orderProductContainer addSubview:productName];
        
        UILabel *qty = [[UILabel alloc] initWithFrame:CGRectMake(0.0f, 15.0f, 296.0f, 10.0f)];
        qty.font = [UIFont systemFontOfSize:10.0f];
        qty.backgroundColor = [UIColor clearColor];
        qty.text = qtyText;
        [orderProductContainer addSubview:qty];
        
        UILabel *price = [[UILabel alloc] initWithFrame:CGRectMake(0.0f, 30.0f, 296.0f, 10.0f)];
        price.font = [UIFont systemFontOfSize:10.0f];
        price.backgroundColor = [UIColor clearColor];
        price.text = priceText;
        [orderProductContainer addSubview:price];
    }
   
}

-(void)orderTotals{
    NSLog(@"Creating block Totals");
    //Add to Scroll View Height
    scrollViewHeight += (200 + 10);
    UIView *orderTotalsHolder = [[UIView alloc] initWithFrame:CGRectMake(10.0f, productsHolderHeight + 340, 301.0f, 200.0f)];
    orderTotalsHolder.backgroundColor = [UIColor whiteColor];
    
    [orderInfoScrollView addSubview:orderTotalsHolder];
    
    UILabel *title = [[UILabel alloc] initWithFrame:CGRectMake(5.0f, 0.0f, 301.0f, 25.0f)];
    title.backgroundColor = [UIColor grayColor];
    title.font = [UIFont systemFontOfSize:12.0f];
    title.text = @"Totalen";
    [orderTotalsHolder addSubview:title];
    
    UIView *orderTotalsBody = [[UIView alloc] initWithFrame:CGRectMake(0.0f, 25.0f, 301.0f, 175.0f)];
    orderTotalsBody.backgroundColor = [UIColor whiteColor];
    [orderTotalsHolder addSubview:orderTotalsBody];
    
    //Subtotal
    NSString *subtotalText = [[NSString alloc] initWithFormat:@"Subtotaal: €%@", [[orderInfoHolder valueForKey:@"data-items"] valueForKey:@"subtotal"]];
    UILabel *subtotal = [[UILabel alloc] initWithFrame:CGRectMake(5.0f, 5.0f, 301.0f, 25.0f)];
    subtotal.backgroundColor = [UIColor clearColor];
    subtotal.font = [UIFont systemFontOfSize:13.0f];
    subtotal.text = subtotalText;
    [orderTotalsBody addSubview:subtotal];
    
    //Tax
    NSString *taxAmountText = [[NSString alloc] initWithFormat:@"BTW: €%@", [[orderInfoHolder valueForKey:@"data-items"] valueForKey:@"tax_amount"]];
    UILabel *taxAmount = [[UILabel alloc] initWithFrame:CGRectMake(5.0f, 25.0f, 301.0f, 25.0f)];
    taxAmount.backgroundColor = [UIColor clearColor];
    taxAmount.font = [UIFont systemFontOfSize:13.0f];
    taxAmount.text = taxAmountText;
    [orderTotalsBody addSubview:taxAmount];
    
    //Shipping amount
    NSString *shippingAmountText = [[NSString alloc] initWithFormat:@"Verzendkosten: €%@", [[orderInfoHolder valueForKey:@"data-items"] valueForKey:@"shipping_amount"]];
    UILabel *shippingAmount = [[UILabel alloc] initWithFrame:CGRectMake(5.0f, 45.0f, 301.0f, 25.0f)];
    shippingAmount.backgroundColor = [UIColor clearColor];
    shippingAmount.font = [UIFont systemFontOfSize:13.0f];
    shippingAmount.text = shippingAmountText;
    [orderTotalsBody addSubview:shippingAmount];

    //Grand total
    NSString *grandTotalText = [[NSString alloc] initWithFormat:@"Totaal: €%@", [[orderInfoHolder valueForKey:@"data-items"] valueForKey:@"grand_total"]];
    UILabel *grandTotal = [[UILabel alloc] initWithFrame:CGRectMake(5.0f, 65.0f, 301.0f, 25.0f)];
    grandTotal.backgroundColor = [UIColor clearColor];
    grandTotal.font = [UIFont systemFontOfSize:13.0f];
    grandTotal.text = grandTotalText;
    [orderTotalsBody addSubview:grandTotal];
    
    //Total paid
    NSString *totalPaidText = [[NSString alloc] initWithFormat:@"Totaal betaald: €%@", [[orderInfoHolder valueForKey:@"data-items"] valueForKey:@"total_paid"]];
    UILabel *totalPaid = [[UILabel alloc] initWithFrame:CGRectMake(5.0f, 105.0f, 301.0f, 25.0f)];
    totalPaid.backgroundColor = [UIColor clearColor];
    totalPaid.font = [UIFont systemFontOfSize:13.0f];
    totalPaid.text = totalPaidText;
    [orderTotalsBody addSubview:totalPaid];
    
    //Total refunded
    NSString *totalRefundedText = [[NSString alloc] initWithFormat:@"Totaal terugbetaald: €%@", [[orderInfoHolder valueForKey:@"data-items"] valueForKey:@"total_refunded"]];
    UILabel *totalRefunded = [[UILabel alloc] initWithFrame:CGRectMake(5.0f, 125.0f, 301.0f, 25.0f)];
    totalRefunded.backgroundColor = [UIColor clearColor];
    totalRefunded.font = [UIFont systemFontOfSize:13.0f];
    totalRefunded.text = totalRefundedText;
    [orderTotalsBody addSubview:totalRefunded];
    
    //Total due
    NSString *totalDueText = [[NSString alloc] initWithFormat:@"Totaal openstaand: €%@", [[orderInfoHolder valueForKey:@"data-items"] valueForKey:@"total_due"]];
    UILabel *totalDue = [[UILabel alloc] initWithFrame:CGRectMake(5.0f, 145.0f, 301.0f, 25.0f)];
    totalDue.backgroundColor = [UIColor clearColor];
    totalDue.font = [UIFont systemFontOfSize:13.0f];
    totalDue.text = totalDueText;
    [orderTotalsBody addSubview:totalDue];
    
}

-(void)orderInfoScrollView
{
    NSLog(@"Setting height of scrollview");
    [orderInfoScrollView setContentSize:CGSizeMake(320, scrollViewHeight + 120)];
    
}
@end
