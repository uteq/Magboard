//
//  DashboardVC.m
//  MagBoard
//
//  Created by Dennis de Jong on 17-12-12.
//  Copyright (c) 2012 Dennis de Jong. All rights reserved.
//

#import "DashboardVC.h"
#import "Alert.h"

@interface DashboardVC ()

@end

@implementation DashboardVC

@synthesize shopInfo, dashboardHolder, dashboardContent, statisticsPointer, statisticsHolder, lastOrdersHolder, percentage,quantity, revenue, revenueSmall, shipping, tax, graphContent, graphHolder, graphText;

- (void)viewDidLoad
{
    [super viewDidLoad];
    shopInfo = [ShopSingleton shopSingleton];
	// Do any additional setup after loading the view.
    [self constructHeader];
    [self constructTabBar];
    [self loginRequest:[shopInfo shopUrl] username:[shopInfo username] password:[shopInfo password]  request:@"webshopDashboardData" requestParams:nil];
    [self contsructDashboardView];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Construct view

-(void)constructHeader
{
    UILabel* navBarTitle = [CustomNavBar setNavBarTitle:@"Dashboard"];
    self.navigationItem.titleView = navBarTitle;
    self.navigationItem.leftBarButtonItem = [UIBarButtonItem styledBarButtonItemWithTarget:self selector:@selector(backButtonTouched) title:@"Shops"];
}

-(void)constructTabBar
{
    
    //Make holder for tabbar
    UIView *tabBar = [[UIView alloc] initWithFrame:CGRectMake(0.0f, [constants getScreenHeight] - 110, 320.0f, 54.0f)];
    UIView *borderTop = [[UIView alloc] initWithFrame:CGRectMake(0, 1.0f, 320.0f, 1.0f)];
    UIView *borderTopBlack = [[UIView alloc] initWithFrame:CGRectMake(0, 0.0f, 320.0f, 1.0f)];
    UIView *deviderBlack = [[UIView alloc] initWithFrame:CGRectMake(159, 0.0f, 1.0f, 54.0f)];
    UIView *deviderLight = [[UIView alloc] initWithFrame:CGRectMake(160, 1.0f, 1.0f, 53.0f)];
    
    borderTop.backgroundColor = [UIColor colorWithRed:75.0f/255.0f green:74.0f/255.0f blue:80.0f/255.0f alpha:1.0];
    borderTopBlack.backgroundColor =[UIColor blackColor];
    deviderBlack.backgroundColor = [UIColor blackColor];
    deviderLight.backgroundColor = [UIColor colorWithRed:75.0f/255.0f green:74.0f/255.0f blue:80.0f/255.0f alpha:1.0];
    UIColor *lightGrey = [UIColor colorWithRed:55.0f/255.0f green:53.0f/255.0f blue:61.0f/255.0f alpha:1.0];
    UIColor *darkGrey = [UIColor colorWithRed:47.0f/255.0f green:46.0f/255.0f blue:53.0f/255.0f alpha:1.0];
    CAGradientLayer *gradient = [CAGradientLayer layer];
    gradient.frame = [[tabBar layer] bounds];
    gradient.colors = [NSArray arrayWithObjects:
                       (id)lightGrey.CGColor,
                       (id)darkGrey.CGColor,
                       nil];
    gradient.locations = [NSArray arrayWithObjects:
                          [NSNumber numberWithFloat:0.0f],
                          [NSNumber numberWithFloat:0.7],
                          nil];
    [[tabBar layer] insertSublayer:gradient atIndex:0];
    
    [self.view addSubview:tabBar];
    [tabBar addSubview:borderTopBlack];
    [tabBar addSubview:borderTop];
    [tabBar addSubview:deviderBlack];
    [tabBar addSubview:deviderLight];
    
    //Make buttons for tabbar
    UIButton *dashboardButton = [UIBarButtonItem styledSubHeaderButtonWithTarget:self selector:nil name:@"dashboardSelected" disabled:NO];
    UIButton *ordersButton = [UIBarButtonItem styledSubHeaderButtonWithTarget:self selector:@selector(goToOrders) name:@"orders" disabled:NO];
    [tabBar addSubview:dashboardButton];
    [tabBar addSubview:ordersButton];
}

-(void)contsructDashboardView
{
    
    //Create UIview and add to screen
    dashboardContent = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, [constants getScreenHeight] - 110)];
    [self constructSwitchBar];
    [self constructStatisticsHolder];
    [self constructStatisticsPointer];
    [self constructLastOrdersHolder];
    [self.view addSubview:dashboardContent];
   
}

-(void)constructSwitchBar
{
    //Create switch row for day, week, month
    UIImage *background = [[UIImage imageNamed:@"switch_holder.png"] stretchableImageWithLeftCapWidth:5.0 topCapHeight:5];
    UIImageView *switchHolder = [[UIImageView alloc] initWithImage:background];
    switchHolder.frame = CGRectMake(10, 20, 300.0, 40);
    switchHolder.userInteractionEnabled = YES;
    [dashboardContent addSubview:switchHolder];
    
    //Add buttons buttons
    UIButton *todayButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [todayButton setTitle:@"Today" forState:UIControlStateNormal];
    [todayButton.titleLabel setFont:[UIFont boldSystemFontOfSize:12]];
    [todayButton setTitleColor:[UIColor colorWithRed:87.0f/255.0f green:83.0f/255.0f blue:89.0f/255.0f alpha:1.0f] forState:UIControlStateNormal];
    todayButton.frame = CGRectMake(0.0, 0.0, 75.0, 40.0);
    [todayButton addTarget:self
                    action:@selector(dashboardToday)
          forControlEvents:UIControlEventTouchUpInside];
    [switchHolder addSubview:todayButton];
    
    UIButton *weekButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [weekButton setTitle:@"Week" forState:UIControlStateNormal];
    [weekButton.titleLabel setFont:[UIFont boldSystemFontOfSize:12]];
    [weekButton setTitleColor:[UIColor colorWithRed:87.0f/255.0f green:83.0f/255.0f blue:89.0f/255.0f alpha:1.0f] forState:UIControlStateNormal];
    weekButton.frame = CGRectMake(75.0, 0.0, 75.0, 40.0);
    [weekButton addTarget:self
                   action:@selector(dashboardWeek)
         forControlEvents:UIControlEventTouchUpInside];
    [switchHolder addSubview:weekButton];
    
    UIButton *monthButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [monthButton setTitle:@"Month" forState:UIControlStateNormal];
    [monthButton.titleLabel setFont:[UIFont boldSystemFontOfSize:12]];
    [monthButton setTitleColor:[UIColor colorWithRed:87.0f/255.0f green:83.0f/255.0f blue:89.0f/255.0f alpha:1.0f] forState:UIControlStateNormal];
    monthButton.frame = CGRectMake(150.0, 0.0, 75.0, 40.0);
    [monthButton addTarget:self
                    action:@selector(dashboardMonth)
          forControlEvents:UIControlEventTouchUpInside];
    [switchHolder addSubview:monthButton];
    
    UIButton *alltimeButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [alltimeButton setTitle:@"All Time" forState:UIControlStateNormal];
    [alltimeButton.titleLabel setFont:[UIFont boldSystemFontOfSize:12]];
    [alltimeButton setTitleColor:[UIColor colorWithRed:87.0f/255.0f green:83.0f/255.0f blue:89.0f/255.0f alpha:1.0f] forState:UIControlStateNormal];
    alltimeButton.frame = CGRectMake(225.0, 0.0, 75.0, 40.0);
    [alltimeButton addTarget:self
                      action:@selector(dashboardAlltime)
            forControlEvents:UIControlEventTouchUpInside];
    [switchHolder addSubview:alltimeButton];
}

-(void)constructStatisticsPointer
{
    UIImage *background = [[UIImage imageNamed:@"statistics_pointer.png"] stretchableImageWithLeftCapWidth:5.0 topCapHeight:5];
    statisticsPointer = [[UIImageView alloc] initWithImage:background];
    statisticsPointer.frame = CGRectMake(30, 62, 29.0, 13);
    statisticsPointer.userInteractionEnabled = YES;
    [dashboardContent addSubview:statisticsPointer];
}

-(void)constructStatisticsHolder
{
    UIImage *background = [[UIImage imageNamed:@"switch_holder.png"] stretchableImageWithLeftCapWidth:5.0 topCapHeight:5.0];
    statisticsHolder = [[UIImageView alloc] initWithImage:background];
    statisticsHolder.frame = CGRectMake(10, 73, 300.0, 112);
    statisticsHolder.userInteractionEnabled = YES;
    [dashboardContent addSubview:statisticsHolder];
    
    //Adding titles & border
    UILabel *revenueTitle = [[UILabel alloc] initWithFrame:CGRectMake(0, 10, 100, 20)];
    revenueTitle.backgroundColor = [UIColor clearColor];
    revenueTitle.text = @"Revenue";
    revenueTitle.textAlignment = UITextAlignmentCenter;
    revenueTitle.font = [UIFont boldSystemFontOfSize:12];
    revenueTitle.textColor = [UIColor colorWithRed:87.0f/255.0f green:83.0f/255.0f blue:89.0f/255.0f alpha:1.0f];
    [statisticsHolder addSubview:revenueTitle];
    
    UILabel *taxTitle = [[UILabel alloc] initWithFrame:CGRectMake(100, 10, 100, 20)];
    taxTitle.backgroundColor = [UIColor clearColor];
    taxTitle.text = @"Tax";
    taxTitle.textAlignment = UITextAlignmentCenter;
    taxTitle.font = [UIFont boldSystemFontOfSize:12];
    taxTitle.textColor = [UIColor colorWithRed:87.0f/255.0f green:83.0f/255.0f blue:89.0f/255.0f alpha:1.0f];
    [statisticsHolder addSubview:taxTitle];
    
    UILabel *shippingTitle = [[UILabel alloc] initWithFrame:CGRectMake(150, 10, 75, 20)];
    shippingTitle.backgroundColor = [UIColor clearColor];
    shippingTitle.text = @"Shipping";
    shippingTitle.textAlignment = UITextAlignmentCenter;
    shippingTitle.font = [UIFont boldSystemFontOfSize:12];
    shippingTitle.textColor = [UIColor colorWithRed:87.0f/255.0f green:83.0f/255.0f blue:89.0f/255.0f alpha:1.0f];
    //[statisticsHolder addSubview:shippingTitle];
    
    UILabel *quantityTitle = [[UILabel alloc] initWithFrame:CGRectMake(200, 10, 100, 20)];
    quantityTitle.backgroundColor = [UIColor clearColor];
    quantityTitle.text = @"Quantity";
    quantityTitle.textAlignment = UITextAlignmentCenter;
    quantityTitle.font = [UIFont boldSystemFontOfSize:12];
    quantityTitle.textColor = [UIColor colorWithRed:87.0f/255.0f green:83.0f/255.0f blue:89.0f/255.0f alpha:1.0f];
    [statisticsHolder addSubview:quantityTitle];
    
    UIView *border = [[UIView alloc] initWithFrame:CGRectMake(10, 56, 280, 1)];
    border.backgroundColor = [UIColor colorWithRed:168.0f/255.0f green:166.0f/255.0f blue:169.0f/255.0f alpha:1.0f];
    [statisticsHolder addSubview:border];
    
    //Insert graph
    graphHolder = [[UIView alloc] initWithFrame:CGRectMake(10, 68, 280, 30)];
    graphHolder.backgroundColor = [UIColor whiteColor];
    graphHolder.layer.cornerRadius = 5;
    graphHolder.layer.masksToBounds = YES;
    [statisticsHolder addSubview:graphHolder];
}

-(void)constructLastOrdersHolder
{
    UIImage *background = [[UIImage imageNamed:@"last_orders_holder.png"] stretchableImageWithLeftCapWidth:5.0 topCapHeight:5.0];
    lastOrdersHolder = [[UIImageView alloc] initWithImage:background];
    lastOrdersHolder.frame = CGRectMake(10, 198, 300.0, 159);
    lastOrdersHolder.userInteractionEnabled = YES;
    lastOrdersHolder.layer.masksToBounds = YES;
    [dashboardContent addSubview:lastOrdersHolder];
    
    UILabel *header = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 300, 30)];
    header.text = @"Last 4 orders";
    header.textAlignment = UITextAlignmentCenter;
    header.backgroundColor = [UIColor clearColor];
    header.font = [UIFont boldSystemFontOfSize:12];
    header.textColor = [UIColor colorWithRed:87.0f/255.0f green:83.0f/255.0f blue:89.0f/255.0f alpha:1.0f];
    [lastOrdersHolder addSubview:header];

}

-(void)addLatestOrders
{

    //Loop trough latest orders
    int numberOfOrders = [[[dashboardHolder valueForKey:@"data-items"] objectForKey:@"last"] count];
    float verticalPosition = 0.0f;
    
    for(int i = 0; i <= numberOfOrders; i++)
    {
        if(i != 0){
            
            verticalPosition = verticalPosition + 31.0f;
        
            UIView *orderHolder = [[UIView alloc] initWithFrame:CGRectMake(10, verticalPosition, 280, 31)];
            orderHolder.backgroundColor = [UIColor clearColor];
            [lastOrdersHolder addSubview:orderHolder];
            
            NSString *latestOrderNumber = [NSString stringWithFormat:@"%i", i];
            UILabel *orderName = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 220, 30)];
            orderName.backgroundColor = [UIColor clearColor];
            orderName.text = [[[[dashboardHolder valueForKey:@"data-items"] objectForKey:@"last"] objectForKey:latestOrderNumber] objectForKey:@"name"];
            orderName.font = [UIFont boldSystemFontOfSize:12.0f];
            orderName.textColor = [UIColor colorWithRed:87.0f/255.0f green:83.0f/255.0f blue:89.0f/255.0f alpha:1.0f];
            [orderHolder addSubview:orderName];
            
            UILabel *orderValue = [[UILabel alloc] initWithFrame:CGRectMake(220, 0, 60, 30)];
            NSString *valueString = [NSString stringWithFormat:@"$ %@", [[[[dashboardHolder valueForKey:@"data-items"] objectForKey:@"last"] objectForKey:latestOrderNumber] objectForKey:@"total"]];
            orderValue.backgroundColor = [UIColor clearColor];
            orderValue.text = valueString;
            orderValue.font = [UIFont boldSystemFontOfSize:12.0f];
            orderValue.textAlignment = UITextAlignmentRight;
            orderValue.textColor = [UIColor colorWithRed:87.0f/255.0f green:83.0f/255.0f blue:89.0f/255.0f alpha:1.0f];
            [orderHolder addSubview:orderValue];
            
            UIView *orderBorder = [[UIView alloc] initWithFrame:CGRectMake(0, 30, 280, 1)];
            orderBorder.backgroundColor = [UIColor colorWithRed:168.0f/255.0f green:166.0f/255.0f blue:169.0f/255.0f alpha:1.0f];
            [orderHolder addSubview:orderBorder];
        }
    }
}

-(void)addStatisticsToHolder
{
    //prepare strings
    NSString *valueString = [NSString stringWithFormat:@"$ %@", [[[dashboardHolder valueForKey:@"data-items"] objectForKey:@"today"] objectForKey:@"revenue"]];
    NSString *taxString = [NSString stringWithFormat:@"$ %@", [[[dashboardHolder valueForKey:@"data-items"] objectForKey:@"today"] objectForKey:@"tax"]];
    NSString *quantityString = [NSString stringWithFormat:@"%@", [[[dashboardHolder valueForKey:@"data-items"] objectForKey:@"today"] objectForKey:@"quantity"]];
    int percentageValue = [[[[dashboardHolder valueForKey:@"data-items"] objectForKey:@"today"] objectForKey:@"percentage"] integerValue];
    NSString *graphString = [NSString stringWithFormat:@"%i percent of daily revenue", percentageValue];
    
    //Insert revenue big
    revenue = [[UILabel alloc] initWithFrame:CGRectMake(10, 70, 100, 30)];
    revenue.text = valueString;
    revenue.backgroundColor = [UIColor clearColor];
    revenue.textAlignment = UITextAlignmentLeft;
    revenue.font = [UIFont boldSystemFontOfSize:13.0f];
    revenue.textColor = [UIColor colorWithRed:87.0f/255.0f green:83.0f/255.0f blue:89.0f/255.0f alpha:1.0f];
    //[statisticsHolder addSubview:revenue];
    
    //Insert revenue small
    revenueSmall = [[UILabel alloc] initWithFrame:CGRectMake(0, 25, 100, 30)];
    revenueSmall.text = valueString;
    revenueSmall.backgroundColor = [UIColor clearColor];
    revenueSmall.font = [UIFont boldSystemFontOfSize:12.0f];
    revenueSmall.textColor = [UIColor colorWithRed:216.0f/255.0f green:144.0f/255.0f blue:49.0f/255.0f alpha:1.0f];
    revenueSmall.textAlignment = UITextAlignmentCenter;
    [statisticsHolder addSubview:revenueSmall];
    
    //Insert tax
    tax = [[UILabel alloc] initWithFrame:CGRectMake(100, 25, 100, 30)];
    tax.text = taxString;
    tax.backgroundColor = [UIColor clearColor];
    tax.font = [UIFont boldSystemFontOfSize:12.0f];
    tax.textColor = [UIColor colorWithRed:216.0f/255.0f green:144.0f/255.0f blue:49.0f/255.0f alpha:1.0f];
    tax.textAlignment = UITextAlignmentCenter;
    [statisticsHolder addSubview:tax];
    
    //Insert quantity
    quantity = [[UILabel alloc] initWithFrame:CGRectMake(200, 25, 100, 30)];
    quantity.text = quantityString;
    quantity.backgroundColor = [UIColor clearColor];
    quantity.font = [UIFont boldSystemFontOfSize:12.0f];
    quantity.textColor = [UIColor colorWithRed:216.0f/255.0f green:144.0f/255.0f blue:49.0f/255.0f alpha:1.0f];
    quantity.textAlignment = UITextAlignmentCenter;
    [statisticsHolder addSubview:quantity];
    
    //Insert graph
    UIImage *graphFilling = [[UIImage imageNamed:@"graph_filling.png"] stretchableImageWithLeftCapWidth:0.0 topCapHeight:0.0];
    graphContent = [[UIImageView alloc] initWithImage:graphFilling];
    graphContent.frame = CGRectMake(0, 0, percentageValue * 2.8, 30);
    [graphHolder addSubview:graphContent];
    
    //Add text for graph
    graphText = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, 260, 30)];
    graphText.text = graphString;
    graphText.backgroundColor = [UIColor clearColor];
    graphText.font = [UIFont boldSystemFontOfSize:12.0f];
    graphText.textColor = [UIColor colorWithRed:87.0f/255.0f green:83.0f/255.0f blue:89.0f/255.0f alpha:1.0f];
    [graphHolder addSubview:graphText];
}

#pragma mark - Request

-(void)loginRequest:(NSString *)shopUrl username:(NSString *)username password:(NSString *)password request:(NSString *)requestFunction requestParams:(NSString *)requestParams
{
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    [params setObject:shopUrl forKey:@"url"];
    [params setObject:username forKey:@"username"];
    [params setObject:password forKey:@"password"];
    [params setObject:requestFunction forKey:@"requestFunction"];
    if(requestParams){
        [params setObject:requestParams forKey:@"requestParams"];
    }
    [[LRResty client] post:[constants apiUrl] payload:params delegate:self];
}

//Catch response for request
- (void)restClient:(LRRestyClient *)client receivedResponse:(LRRestyResponse *)response;
{
    // do something with the response
    if(response.status == 200) {
        
        dashboardHolder = [NSJSONSerialization JSONObjectWithData:[response responseData] options:kNilOptions error:nil];
        
        //If correct login
        if([[dashboardHolder valueForKey:@"message"] isEqualToString:@"1007"])
        {
            NSLog(@"Data items: %@", [dashboardHolder valueForKey:@"data-items"]);
            [self addLatestOrders];
            [self addStatisticsToHolder];
        }
    }
    else
    {
        NSLog(@"Something went wrong: %d", [response status]);
        [self backButtonTouched];
    }
    
    NSLog(@"Status: %@", [dashboardHolder valueForKey:@"session"]);
    NSLog(@"Code: %@", [dashboardHolder valueForKey:@"message"]);
    
}


#pragma mark - Button actions

-(void)backButtonTouched
{
    NSMutableArray *viewControllers = [NSMutableArray arrayWithArray:[[self navigationController] viewControllers]];
    [viewControllers removeLastObject];
    [viewControllers removeLastObject];
    [[self navigationController] setViewControllers:viewControllers animated:YES];
}

-(void)goToOrders
{
    NSMutableArray *viewControllers = [NSMutableArray arrayWithArray:[[self navigationController] viewControllers]];
    [viewControllers removeLastObject];
    [[self navigationController] setViewControllers:viewControllers animated:NO];
}

-(void)dashboardToday
{
    //prepare strings
    NSString *valueString = [NSString stringWithFormat:@"$ %@", [[[dashboardHolder valueForKey:@"data-items"] objectForKey:@"today"] objectForKey:@"revenue"]];
    NSString *taxString = [NSString stringWithFormat:@"$ %@", [[[dashboardHolder valueForKey:@"data-items"] objectForKey:@"today"] objectForKey:@"tax"]];
    NSString *quantityString = [NSString stringWithFormat:@"%@", [[[dashboardHolder valueForKey:@"data-items"] objectForKey:@"today"] objectForKey:@"quantity"]];
    int percentageValue = [[[[dashboardHolder valueForKey:@"data-items"] objectForKey:@"today"] objectForKey:@"percentage"] integerValue];
    NSString *graphString = [NSString stringWithFormat:@"%i percent of daily revenue", percentageValue];
    
    //Making transitions
    [UIImageView beginAnimations:nil context:nil];
    [UIImageView setAnimationDuration:0.3f];
    revenueSmall.text = valueString;
    tax.text = taxString;
    quantity.text = quantityString;
    graphText.text = graphString;
    graphContent.frame = CGRectMake(0, 0, percentageValue * 2.8, 30);
    statisticsPointer.frame = CGRectMake(30, 62, 29.0, 13);
    [UIView commitAnimations];
}

-(void)dashboardWeek
{
    //prepare strings
    NSString *valueString = [NSString stringWithFormat:@"$ %@", [[[dashboardHolder valueForKey:@"data-items"] objectForKey:@"week"] objectForKey:@"revenue"]];
    NSString *taxString = [NSString stringWithFormat:@"$ %@", [[[dashboardHolder valueForKey:@"data-items"] objectForKey:@"week"] objectForKey:@"tax"]];
    NSString *quantityString = [NSString stringWithFormat:@"%@", [[[dashboardHolder valueForKey:@"data-items"] objectForKey:@"week"] objectForKey:@"quantity"]];
    int percentageValue = [[[[dashboardHolder valueForKey:@"data-items"] objectForKey:@"week"] objectForKey:@"percentage"] integerValue];
    NSString *graphString = [NSString stringWithFormat:@"%i percent of weekly revenue", percentageValue];
    
    //Making transitions
    [UIImageView beginAnimations:nil context:nil];
    [UIImageView setAnimationDuration:0.3f];
    revenueSmall.text = valueString;
    tax.text = taxString;
    quantity.text = quantityString;
    graphText.text = graphString;
    graphContent.frame = CGRectMake(0, 0, percentageValue * 2.8, 30);
    statisticsPointer.frame = CGRectMake(110.0f, 62, 29.0, 13);
    [UIView commitAnimations];
}

-(void)dashboardMonth
{
    //prepare strings
    NSString *valueString = [NSString stringWithFormat:@"$ %@", [[[dashboardHolder valueForKey:@"data-items"] objectForKey:@"month"] objectForKey:@"revenue"]];
    NSString *taxString = [NSString stringWithFormat:@"$ %@", [[[dashboardHolder valueForKey:@"data-items"] objectForKey:@"month"] objectForKey:@"tax"]];
    NSString *quantityString = [NSString stringWithFormat:@"%@", [[[dashboardHolder valueForKey:@"data-items"] objectForKey:@"month"] objectForKey:@"quantity"]];
    int percentageValue = [[[[dashboardHolder valueForKey:@"data-items"] objectForKey:@"month"] objectForKey:@"percentage"] integerValue];
    NSString *graphString = [NSString stringWithFormat:@"%i percent of monthly revenue", percentageValue];
    
    //Making transitions
    [UIImageView beginAnimations:nil context:nil];
    [UIImageView setAnimationDuration:0.3f];
    revenueSmall.text = valueString;
    tax.text = taxString;
    quantity.text = quantityString;
    graphText.text = graphString;
    graphContent.frame = CGRectMake(0, 0, percentageValue * 2.8, 30);
    statisticsPointer.frame = CGRectMake(185.0f, 62, 29.0, 13);
    [UIView commitAnimations];
}

-(void)dashboardAlltime
{
    //prepare strings
    NSString *valueString = [NSString stringWithFormat:@"$ %@", [[[dashboardHolder valueForKey:@"data-items"] objectForKey:@"alltime"] objectForKey:@"revenue"]];
    NSString *taxString = [NSString stringWithFormat:@"$ %@", [[[dashboardHolder valueForKey:@"data-items"] objectForKey:@"alltime"] objectForKey:@"tax"]];
    NSString *quantityString = [NSString stringWithFormat:@"%@", [[[dashboardHolder valueForKey:@"data-items"] objectForKey:@"alltime"] objectForKey:@"quantity"]];
    int percentageValue = [[[[dashboardHolder valueForKey:@"data-items"] objectForKey:@"alltime"] objectForKey:@"percentage"] integerValue];
    NSString *graphString = [NSString stringWithFormat:@"Total revenue"];
    
    //Making transitions
    [UIImageView beginAnimations:nil context:nil];
    [UIImageView setAnimationDuration:0.3f];
    revenueSmall.text = valueString;
    tax.text = taxString;
    quantity.text = quantityString;
    graphText.text = graphString;
    graphContent.frame = CGRectMake(0, 0, percentageValue * 2.8, 30);
    statisticsPointer.frame = CGRectMake(260.0f, 62, 29.0, 13);
    [UIView commitAnimations];
}

///////////////////////////////////////////////////////
//////////////// Make alerts     ///////////////////////
///////////////////////////////////////////////////////

//Make alert
-(void)makeAlert:(NSString*)alertTitle message:(NSString*)alertMessage button:(NSString *)buttonTitle
{
    if([buttonTitle isEqualToString:@"607"] || [buttonTitle isEqualToString:@"608"])
    {
        BlockAlertView *alert = [BlockAlertView
                                 alertWithTitle:alertTitle
                                 message:alertMessage];
        
        [alert setCancelButtonWithTitle:@"Ok" block:^{
            [self backButtonTouched];
        }];
        
        [alert show];
    }
    else {
        
        UIAlertView *alert = [[UIAlertView alloc]
                              initWithTitle:alertTitle
                              message:alertMessage
                              delegate:self
                              cancelButtonTitle:@"Cancel"
                              otherButtonTitles:buttonTitle, nil];
        
        [alert show];
    }
}
@end
