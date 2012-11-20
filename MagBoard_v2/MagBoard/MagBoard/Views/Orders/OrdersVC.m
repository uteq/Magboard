//
//  OrdersVC.m
//  MagBoard
//
//  Created by Dennis de Jong on 31-10-12.
//  Copyright (c) 2012 Dennis de Jong. All rights reserved.
//

#import "OrdersVC.h"
#import "OrderInfoVC.h"

@interface OrdersVC ()

@end

@implementation OrdersVC

@synthesize shopInfo, orderHolder,loadingHolder, loadingIcon, ordersTable, searchBar, searching, letUserSelectRow, searchOverlay;

- (void)viewDidLoad
{
    [super viewDidLoad];
    shopInfo = [ShopSingleton shopSingleton];
    // Do any additional setup after loading the view.
    [self constructHeader];
    [self constructTabBar];
    
    searching = NO;
    letUserSelectRow = YES;
    
    [self loginRequest:[shopInfo shopUrl] username:[shopInfo username] password:[shopInfo password]  request:@"salesOrderList" requestParams:@"dateSorted"];
    [self loadingRequest];
}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:YES];
    
    [self loginRequest:[shopInfo shopUrl] username:[shopInfo username] password:[shopInfo password]  request:@"salesOrderList" requestParams:@"dateSorted"];

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

///////////////////////////////////////////////////////
//////////////// Construct view ///////////////////////
///////////////////////////////////////////////////////


-(void)constructHeader
{
    UILabel* navBarTitle = [CustomNavBar setNavBarTitle:[shopInfo shopName]];
    self.navigationItem.titleView = navBarTitle;
    self.navigationItem.leftBarButtonItem = [UIBarButtonItem styledBarButtonItemWithTarget:self selector:@selector(backButtonTouched) title:@"Terug"];
}

-(void)constructTabBar
{

    //Make holder for tabbar
    UIView *tabBar = [[UIView alloc] initWithFrame:CGRectMake(0.0f, 365.0f, 320.0f, 54.0f)];
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
    UIButton *dashboardButton = [UIBarButtonItem styledSubHeaderButtonWithTarget:self selector:@selector(goToDashboard) name:@"dashboard"];
    UIButton *ordersButton = [UIBarButtonItem styledSubHeaderButtonWithTarget:self selector:nil name:@"ordersSelected"];
    [tabBar addSubview:dashboardButton];
    [tabBar addSubview:ordersButton];
}

///////////////////////////////////////////////////////
//////////////// Button actions ///////////////////////
///////////////////////////////////////////////////////

-(void)backButtonTouched
{
    NSMutableArray *viewControllers = [NSMutableArray arrayWithArray:[[self navigationController] viewControllers]];
    [viewControllers removeLastObject];
    [[self navigationController] setViewControllers:viewControllers animated:YES];
}

-(void)goToDashboard
{
    NSLog(@"Dashboard button pressed");
}

-(void)doneSearching
{
    searchBar.text = @"";
    [searchBar resignFirstResponder];
    
    letUserSelectRow = YES;
    searching = NO;
    self.navigationItem.rightBarButtonItem = nil;
    ordersTable.scrollEnabled = YES;
    
    [ordersTable reloadData];
    
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0];
    ordersTable.frame = CGRectMake(0, 0, 320, 365);
    [UIView commitAnimations];
    
    [searchOverlay removeFromSuperview];
}


///////////////////////////////////////////////////////
//////////////// Request to API ///////////////////////
///////////////////////////////////////////////////////

//While doing request show loading icon
-(void)loadingRequest
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
    loadingText.text = @"Orders laden...";
    
    loadingIcon = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
	loadingIcon.center = loadingHolder.center;
    [loadingIcon startAnimating];
    
    [self.view addSubview:loadingHolder];
	[loadingHolder addSubview: loadingIcon];
    [loadingHolder addSubview:loadingText];
}

//Make request for logging in en fetching orders
-(void)loginRequest:(NSString *)shopUrl username:(NSString *)username password:(NSString *)password request:(NSString *)requestFunction requestParams:(NSString *)requestParams
{
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    [params setObject:shopUrl forKey:@"url"];
    [params setObject:username forKey:@"username"];
    [params setObject:password forKey:@"password"];
    [params setObject:requestFunction forKey:@"requestFunction"];
    [params setObject:requestParams forKey:@"requestParams"];
    
    [[LRResty client] post:@"http://www.magboard.nl/api/index.php" payload:params delegate:self];
}

//Catch response for request
- (void)restClient:(LRRestyClient *)client receivedResponse:(LRRestyResponse *)response;
{
    // do something with the response
    if(response.status == 200) {
        
        orderHolder = [NSJSONSerialization JSONObjectWithData:[response responseData] options:kNilOptions error:nil];
        
        //If incorrect login
        if([[orderHolder valueForKey:@"message"] isEqualToString:@"607"])
        {
            [self makeAlert:@"Incorrect login" message:@"De combinatie tussen gebruikersnaam en wachtwoord komt niet overeen. Probeer het nogmaals." button:@"607"];
        }
        //if incorrect url
        else if([[orderHolder valueForKey:@"message"] isEqualToString:@"608"] || [[orderHolder valueForKey:@"message"] isEqualToString:@"1000"]) {
            [self makeAlert:@"Onjuiste URL" message:@"Er bestaat geen Magento webshop op dit domein. Controleer de url op eventuele fouten en probeer het nogmaals." button:@"608"];
        }
        //if all is ok
        else {
            if(ordersTable){
                [ordersTable reloadData];
            } else {
                [loadingIcon stopAnimating];
                [loadingHolder removeFromSuperview];
                [self makeTable];
            }
        }
    }
    else
    {
        NSLog(@"Er ging iets mis %d", [response status]);
        [self backButtonTouched];
    }
    
    NSLog(@"Status: %@", [orderHolder valueForKey:@"session"]);
    NSLog(@"Code: %@", [orderHolder valueForKey:@"message"]);
    
}

///////////////////////////////////////////////////////
//////////////// Search orders  ///////////////////////
///////////////////////////////////////////////////////

//For handling action when user types an other letter
- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText
{
    //Remove all objects first.
    [copyListOfOrders removeAllObjects];
    
    if([searchText length] > 0) {
        
        searching = YES;
        letUserSelectRow = YES;
        ordersTable.scrollEnabled = YES;
        [self searchTableView];
    }
    else {
        searching = NO;
        letUserSelectRow = NO;
        ordersTable.scrollEnabled = NO;
    }
    
    //Show or hide search overlay
    if([copyListOfOrders count] != 0){
        [searchOverlay removeFromSuperview];
    } else {
        [searchOverlay removeFromSuperview];
        [self makeSearchOverlay];
    }
    
    [ordersTable reloadData];
}

//For handling action when user begins editing the searchbar
-(void)searchBarTextDidBeginEditing:(UISearchBar *)theSearchBar {
    
    searching = YES;
    letUserSelectRow = NO;
    ordersTable.scrollEnabled = NO;
    
    //Add the done button.
    self.navigationItem.rightBarButtonItem = [UIBarButtonItem styledBarButtonItemWithTarget:self selector:@selector(doneSearching) title:@"Klaar"];
    
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0];
    ordersTable.frame = CGRectMake(0, 0, 320, 365 - 165);
    [UIView commitAnimations];
    
    [self makeSearchOverlay];
}

- (void) searchBarSearchButtonClicked:(UISearchBar *)theSearchBar {
    [self searchTableView];
}

-(void)makeSearchOverlay
{
    UITapGestureRecognizer *singleFingerTap =
    [[UITapGestureRecognizer alloc] initWithTarget:self
                                            action:@selector(doneSearching)];
    
    searchOverlay = [[UIView alloc] initWithFrame:CGRectMake(0, 45, 320, 200)];
    searchOverlay.backgroundColor = [UIColor colorWithRed:0/255 green:0/255 blue:0/255 alpha:0.8f];
    [searchOverlay addGestureRecognizer:singleFingerTap];
    [self.view addSubview:searchOverlay];
}

//Search logic 
- (void) searchTableView {
    
    NSString *searchText = searchBar.text;
    copyListOfOrders = [[NSMutableArray alloc] init];
    
    for (int i = 0; i < [[orderHolder objectForKey:@"data-items"] count]; i++) {
        
        NSString *firstName = [[NSString alloc] initWithFormat:@"%@", [[[[orderHolder objectForKey:@"data-items"] objectAtIndex:i] objectAtIndex:1] objectForKey:@"firstname"]];
        NSString *lastName = [[NSString alloc] initWithFormat:@"%@", [[[[orderHolder objectForKey:@"data-items"] objectAtIndex:i] objectAtIndex:1] objectForKey:@"lastname"]];
        NSString *totalName = [[NSString alloc] initWithFormat:@"%@ %@", firstName, lastName];
        
        NSRange titleResultsRange = [totalName rangeOfString:searchText options:NSCaseInsensitiveSearch];
        if(titleResultsRange.length > 0){
            [copyListOfOrders addObject:[[[orderHolder objectForKey:@"data-items"] objectAtIndex:i] objectAtIndex:1]];
            [searchOverlay removeFromSuperview];
        }
        
    }
    
}


///////////////////////////////////////////////////////
//////////////// Make tableview ///////////////////////
///////////////////////////////////////////////////////

//Initializing table
-(void)makeTable
{
    //Add view to tableview
    ordersTable = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, 320, 365)];
    ordersTable.dataSource = self;
    ordersTable.delegate = self;
    ordersTable.backgroundColor = [UIColor clearColor];
    ordersTable.separatorColor = [UIColor clearColor];
    [self.view addSubview:ordersTable];
    
    //Add searchbar
    searchBar = [[UISearchBar alloc] initWithFrame:CGRectMake(0,70,320,44)];
    searchBar.delegate = self;
    [ordersTable setTableHeaderView:searchBar];
}

// Checking the total of sections
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    if(!searching){
        return [[orderHolder valueForKey:@"data-items"] count];
    } else {
        return 1;
    }
}


//Checking the total of rows in the section
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if(!searching){
        return [[[orderHolder valueForKey:@"data-items"] objectAtIndex:section] count];
    } else {
        return [copyListOfOrders count];
    }
}

// Height of the cells
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    //The date row (indexPath.row = 0) has smaller height then the other order cells
    if(!searching && indexPath.row == 0){
        return 30;
    } else {
        return 65;
    }
}

//The content off the cell
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *orderCell = @"OrderCell";
    NSString *cellIdentifier = [NSString stringWithFormat:@"S%1dR%1d",indexPath.section,indexPath.row];
    //Check for reusable cell first
    UITableViewCell *cell = (UITableViewCell *)[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    //If there is no reusable cell of this type create a new cell
    if(cell == nil)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:orderCell];
        if(!searching){
            [self configureCell:cell atIndexPath:indexPath];
        } else {
            [self configureCellForSearch:cell atIndexPath:indexPath];
        }
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    //For the date no interaction
    if(!searching && indexPath.row == 0){
        cell.userInteractionEnabled = NO;
    }
    
    return cell;
}

- (void)configureCell:(UITableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath
{
    //The first item from the section is always the date, the others are the orders
    if(indexPath.row == 0){
        NSString* date = [[NSString alloc] initWithFormat:@"%@", [[[[orderHolder valueForKey:@"data-items"] objectAtIndex:indexPath.section]objectAtIndex:indexPath.row ] valueForKey:@"date"]];
        
        UILabel * dateTitle = [[UILabel alloc] initWithFrame:CGRectMake(12.0f, 15.0f, 301.0f, 20.0f)];

        UIFont *font = [UIFont fontWithName:@"Lobster 1.3" size:16.0f];
        dateTitle.font = font;
        dateTitle.textColor = [UIColor whiteColor];
        dateTitle.text = date;
        dateTitle.backgroundColor = [UIColor clearColor];
        [cell addSubview:dateTitle];
        
    } else {
        NSString* firstName = [[NSString alloc] initWithFormat:@"%@", [[[[orderHolder valueForKey:@"data-items"] objectAtIndex:indexPath.section]objectAtIndex:indexPath.row ] valueForKey:@"firstname"]];
        NSString* lastName = [[NSString alloc] initWithFormat:@"%@", [[[[orderHolder valueForKey:@"data-items"] objectAtIndex:indexPath.section]objectAtIndex:indexPath.row ] valueForKey:@"lastname"]];
        NSString* grandTotal = [[NSString alloc] initWithFormat:@"%@", [[[[orderHolder valueForKey:@"data-items"] objectAtIndex:indexPath.section]objectAtIndex:indexPath.row ] valueForKey:@"grand_total"]];
        NSString* orderId = [[NSString alloc] initWithFormat:@"%@", [[[[orderHolder valueForKey:@"data-items"] objectAtIndex:indexPath.section]objectAtIndex:indexPath.row ] valueForKey:@"increment_id"]];
        NSString* status = [[NSString alloc] initWithFormat:@"%@", [[[[orderHolder valueForKey:@"data-items"] objectAtIndex:indexPath.section]objectAtIndex:indexPath.row ] valueForKey:@"status"]];

    
        NSString* totalName = [[NSString alloc] initWithFormat:@"%@ %@", firstName, lastName];
        //Add orderlabel image to table cell
        UILabel *orderHolderLabel = [[UILabel alloc] initWithFrame:CGRectMake(10.0f, 10.0f, 301.0f, 53.0f)];
        orderHolderLabel.font = [UIFont boldSystemFontOfSize:14.0f];
        //Determine the label for order status
        
        if([status isEqualToString:@"pending"])
        {
            UIImage *image = [UIImage imageNamed:@"order_holder_pending"];
            orderHolderLabel.backgroundColor = [UIColor colorWithPatternImage:image];
        }
        else if ([status isEqualToString:@"complete"])
        {
            UIImage *image = [UIImage imageNamed:@"order_holder_completed"];
            orderHolderLabel.backgroundColor = [UIColor colorWithPatternImage:image];
        }
        else if ([status isEqualToString:@"processing"])
        {
            UIImage *image = [UIImage imageNamed:@"order_holder_processing"];
            orderHolderLabel.backgroundColor = [UIColor colorWithPatternImage:image];
        }
        else if ([status isEqualToString:@"canceled"])
        {
            UIImage *image = [UIImage imageNamed:@"order_holder_canceled"];
            orderHolderLabel.backgroundColor = [UIColor colorWithPatternImage:image];
        }
        else if ([status isEqualToString:@"holded"])
        {
            UIImage *image = [UIImage imageNamed:@"order_holder_holded"];
            orderHolderLabel.backgroundColor = [UIColor colorWithPatternImage:image];
        }
        [cell addSubview:orderHolderLabel];
        
        //Add consumer name to order label
        UILabel *orderName = [[UILabel alloc] initWithFrame:CGRectMake(20, 7, 200, 20)];
        orderName.font = [UIFont boldSystemFontOfSize:12.0f];
        orderName.backgroundColor = [UIColor clearColor];
        orderName.text = totalName;
        [orderHolderLabel addSubview:orderName];
        
        //Add grandtotal to order label
        UILabel *grandTotalLabel = [[UILabel alloc] initWithFrame:CGRectMake(200, 7, 80, 20)];
        grandTotalLabel.font = [UIFont boldSystemFontOfSize:12.0f];
        grandTotalLabel.backgroundColor = [UIColor clearColor];
        grandTotalLabel.text = grandTotal;
        grandTotalLabel.textAlignment = UITextAlignmentRight;
        [orderHolderLabel addSubview:grandTotalLabel];
        
        //Add ordernumber to order label
        UILabel *orderNumberLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 23, 100, 20)];
        orderNumberLabel.font = [UIFont systemFontOfSize:11.0f];
        orderNumberLabel.backgroundColor = [UIColor clearColor];
        orderNumberLabel.text = orderId;
        [orderHolderLabel addSubview:orderNumberLabel];
        
        //NSLog(@"All fields: %@", [orderHolder valueForKey:@"data-items"]);
        

    }

}

- (void)configureCellForSearch:(UITableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath
{
    //The first item from the section is always the date, the others are the orders

    NSString* firstName = [[NSString alloc] initWithFormat:@"%@", [[copyListOfOrders objectAtIndex:indexPath.row] valueForKey:@"firstname"]];
    NSString* lastName = [[NSString alloc] initWithFormat:@"%@", [[copyListOfOrders objectAtIndex:indexPath.row] valueForKey:@"lastname"]];
    NSString* grandTotal = [[NSString alloc] initWithFormat:@"%@", [[copyListOfOrders objectAtIndex:indexPath.row] valueForKey:@"grand_total"]];
    NSString* orderId = [[NSString alloc] initWithFormat:@"%@", [[copyListOfOrders objectAtIndex:indexPath.row] valueForKey:@"increment_id"]];
    NSString* status = [[NSString alloc] initWithFormat:@"%@", [[copyListOfOrders objectAtIndex:indexPath.row] valueForKey:@"status"]];
    
    
    NSString* totalName = [[NSString alloc] initWithFormat:@"%@ %@", firstName, lastName];
    //Add orderlabel image to table cell
    UILabel *orderHolderLabel = [[UILabel alloc] initWithFrame:CGRectMake(10.0f, 10.0f, 301.0f, 53.0f)];
    orderHolderLabel.font = [UIFont boldSystemFontOfSize:14.0f];
    //Determine the label for order status
    
    if([status isEqualToString:@"pending"])
    {
        UIImage *image = [UIImage imageNamed:@"order_holder_pending"];
        orderHolderLabel.backgroundColor = [UIColor colorWithPatternImage:image];
    }
    else if ([status isEqualToString:@"complete"])
    {
        UIImage *image = [UIImage imageNamed:@"order_holder_completed"];
        orderHolderLabel.backgroundColor = [UIColor colorWithPatternImage:image];
    }
    else if ([status isEqualToString:@"processing"])
    {
        UIImage *image = [UIImage imageNamed:@"order_holder_processing"];
        orderHolderLabel.backgroundColor = [UIColor colorWithPatternImage:image];
    }
    else if ([status isEqualToString:@"canceled"])
    {
        UIImage *image = [UIImage imageNamed:@"order_holder_canceled"];
        orderHolderLabel.backgroundColor = [UIColor colorWithPatternImage:image];
    }
    else if ([status isEqualToString:@"holded"])
    {
        UIImage *image = [UIImage imageNamed:@"order_holder_holded"];
        orderHolderLabel.backgroundColor = [UIColor colorWithPatternImage:image];
    }
    [cell addSubview:orderHolderLabel];
    
    //Add consumer name to order label
    UILabel *orderName = [[UILabel alloc] initWithFrame:CGRectMake(20, 7, 200, 20)];
    orderName.font = [UIFont boldSystemFontOfSize:12.0f];
    orderName.backgroundColor = [UIColor clearColor];
    orderName.text = totalName;
    [orderHolderLabel addSubview:orderName];
    
    //Add grandtotal to order label
    UILabel *grandTotalLabel = [[UILabel alloc] initWithFrame:CGRectMake(200, 7, 80, 20)];
    grandTotalLabel.font = [UIFont boldSystemFontOfSize:12.0f];
    grandTotalLabel.backgroundColor = [UIColor clearColor];
    grandTotalLabel.text = grandTotal;
    grandTotalLabel.textAlignment = UITextAlignmentRight;
    [orderHolderLabel addSubview:grandTotalLabel];
    
    //Add ordernumber to order label
    UILabel *orderNumberLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 23, 100, 20)];
    orderNumberLabel.font = [UIFont systemFontOfSize:11.0f];
    orderNumberLabel.backgroundColor = [UIColor clearColor];
    orderNumberLabel.text = orderId;
    [orderHolderLabel addSubview:orderNumberLabel];
    
    //NSLog(@"All fields: %@", [orderHolder valueForKey:@"data-items"]);

}

//For handling action when user selects row
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    //Put data from row into the designated singleton
    NSString *orderId = [[NSString alloc]init];
    NSString *orderStatus = [[NSString alloc] init];
    
    if(!searching){
        orderId = [[NSString alloc] initWithFormat:@"%@", [[[[orderHolder valueForKey:@"data-items"] objectAtIndex:indexPath.section]objectAtIndex:indexPath.row] valueForKey:@"increment_id"]];
        orderStatus = [[NSString alloc] initWithFormat:@"%@", [[[[orderHolder valueForKey:@"data-items"] objectAtIndex:indexPath.section]objectAtIndex:indexPath.row] valueForKey:@"status"]];
    } else {
        orderId = [[NSString alloc] initWithFormat:@"%@", [[copyListOfOrders objectAtIndex:indexPath.row] valueForKey:@"increment_id"]];
        orderStatus = [[NSString alloc] initWithFormat:@"%@", [[copyListOfOrders objectAtIndex:indexPath.row] valueForKey:@"status"]];
    }
    
    OrderSingleton *sharedOrder = [OrderSingleton orderSingleton];
    sharedOrder.orderId = orderId;
    sharedOrder.orderStatus = orderStatus;
    
    if(sharedOrder.orderId != nil)
    {
        OrderInfoVC *dashboard = [[OrderInfoVC alloc]init];
        NSMutableArray *viewControllers = [NSMutableArray arrayWithArray:[[self navigationController] viewControllers]];
        [viewControllers addObject:dashboard];
        [[self navigationController] setViewControllers:viewControllers animated:YES];
    } else {
        [self makeAlert:@"Geen Order ID" message:@"Kon de order niet inladen omdat er geen order id is." button:@"Ok"];
    }
    
}

//For preventing user from selecting row when searching
- (NSIndexPath *)tableView :(UITableView *)theTableView willSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if(letUserSelectRow){
        return indexPath;
    } else {
        return nil;
    }
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
                              cancelButtonTitle:@"Annuleren"
                              otherButtonTitles:buttonTitle, nil];
        
        [alert show];
    }
}

@end
