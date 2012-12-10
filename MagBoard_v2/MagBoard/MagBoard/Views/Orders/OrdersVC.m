//
//  OrdersVC.m
//  MagBoard
//
//  Created by Dennis de Jong on 31-10-12.
//  Copyright (c) 2012 Dennis de Jong. All rights reserved.
//

#import "OrdersVC.h"
#import "OrderInfoVC.h"
#import "Alert.h"

@interface OrdersVC ()

@end

@implementation OrdersVC

@synthesize shopInfo, orderHolder,loadingHolder, loadingIcon, ordersTable, searchBar, searching, letUserSelectRow, searchOverlay, sorting;

- (void)viewDidLoad
{
    [super viewDidLoad];
    shopInfo = [ShopSingleton shopSingleton];
    // Do any additional setup after loading the view.
    [self constructHeader];
    [self constructTabBar];
    
    lastOrderIncrementalId = 0;
    firstRun = YES;
    searching = NO;
    sorting = NO;
    letUserSelectRow = YES;
    
    [self loginRequest:[shopInfo shopUrl] username:[shopInfo username] password:[shopInfo password]  request:@"salesOrderList" requestParams:nil update:NO];
    [self loadingRequest];
}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:YES];
    if(ordersTable){
        [self loginRequest:[shopInfo shopUrl] username:[shopInfo username] password:[shopInfo password]  request:@"salesOrderList" requestParams:nil update:YES];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark construct view

///////////////////////////////////////////////////////
//////////////// Construct view ///////////////////////
///////////////////////////////////////////////////////


-(void)constructHeader
{
    //UILabel* navBarTitle = [CustomNavBar setNavBarTitle:[shopInfo shopName]];
    UIButton *titleLabel = [UIButton buttonWithType:UIButtonTypeCustom];
    [titleLabel setTitle:[shopInfo shopName] forState:UIControlStateNormal];
    titleLabel.frame = CGRectMake(0, 0, 200, 44);
    titleLabel.font = [UIFont boldSystemFontOfSize:16];
    titleLabel.titleLabel.shadowColor = [UIColor blackColor];
    titleLabel.titleLabel.shadowOffset = CGSizeMake(1, 1);
    [titleLabel addTarget:self action:@selector(titleTap) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.titleView = titleLabel;
    self.navigationItem.leftBarButtonItem = [UIBarButtonItem styledBarButtonItemWithTarget:self selector:@selector(backButtonTouched) title:@"Shops"];
}

-(void)titleTap
{
    [ordersTable scrollRectToVisible:CGRectMake(0, 0, 1, 1) animated:YES];
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
    UIButton *dashboardButton = [UIBarButtonItem styledSubHeaderButtonWithTarget:self selector:@selector(goToDashboard) name:@"dashboard" disabled:NO];
    UIButton *ordersButton = [UIBarButtonItem styledSubHeaderButtonWithTarget:self selector:nil name:@"ordersSelected" disabled:NO];
    [tabBar addSubview:dashboardButton];
    [tabBar addSubview:ordersButton];
}

#pragma mark Button actions

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
    sorting = NO;
    self.navigationItem.rightBarButtonItem = nil;
    self.navigationItem.rightBarButtonItem = [UIBarButtonItem styledBarButtonItemWithTarget:self selector:@selector(showSortFilter) title:@"Filter"];
    ordersTable.scrollEnabled = YES;
    
    [ordersTable reloadData];
    
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0];
    ordersTable.frame = CGRectMake(0, 0, 320, 365);
    [UIView commitAnimations];
    
    [searchOverlay removeFromSuperview];
}

#pragma mark Requests

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
    loadingText.text = @"Loading orders...";
    
    loadingIcon = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
	loadingIcon.center = loadingHolder.center;
    [loadingIcon startAnimating];
    
    [self.view addSubview:loadingHolder];
	[loadingHolder addSubview: loadingIcon];
    [loadingHolder addSubview:loadingText];
}

//Make request for logging in en fetching orders
-(void)loginRequest:(NSString *)shopUrl username:(NSString *)username password:(NSString *)password request:(NSString *)requestFunction requestParams:(NSString *)requestParams update:(bool)update
{
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    [params setObject:shopUrl forKey:@"url"];
    [params setObject:username forKey:@"username"];
    [params setObject:password forKey:@"password"];
    [params setObject:requestFunction forKey:@"requestFunction"];
    if(requestParams){
        [params setObject:requestParams forKey:@"requestParams"];    
    }
    if(update == YES){
        [params setObject:@"1" forKey:@"update"];
    } else {
        [params setObject:@"0" forKey:@"update"];
    }

    [[LRResty client] post:@"http://www.leoflapper.nl/api2/index.php" payload:params delegate:self];
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
            [self makeAlert:@"Incorrect login" message:@"Username and password don't match. Please check your login credentials and try again." button:@"607"];
        }
        //if incorrect url
        else if([[orderHolder valueForKey:@"message"] isEqualToString:@"608"] || [[orderHolder valueForKey:@"message"] isEqualToString:@"1000"]) {
            [self makeAlert:@"Incorrect URL" message:@"No webshop found on this URL. Please check the URL for errors and try again." button:@"608"];
        }
        //if the soap can't be loaded
        else if([[orderHolder valueForKey:@"message"] isEqualToString:@"621"]){
            BlockAlertView *alertSOAPError = [BlockAlertView alertWithTitle:@"Magento Server Problem" message:@"Something went wrong while loading the orders. Please ensure SOAP is installed on your server."];
            [alertSOAPError addButtonWithTitle:@"Ok" block:^{
                [self backButtonTouched];
            }];
            [alertSOAPError show];
        }
        //if all is ok
        else {
            if(ordersTable){
                [ordersTable reloadData];
                [self checkNewOrders];
            } else {
                [loadingIcon stopAnimating];
                [loadingHolder removeFromSuperview];
                [self makeTable];
                [self checkNewOrders];
                self.navigationItem.rightBarButtonItem = [UIBarButtonItem styledBarButtonItemWithTarget:self selector:@selector(showSortFilter) title:@"Filter"];
            }
            if(firstRun == YES){
                [self updateOrders];
                firstRun = NO;
            }
        }
    }
    else
    {
        NSLog(@"Something went wrong: %d", [response status]);

        if(firstRun == YES){
           [self backButtonTouched]; 
        }
    }
    
    NSLog(@"Status: %@", [orderHolder valueForKey:@"session"]);
    NSLog(@"Code: %@", [orderHolder valueForKey:@"message"]);
    
}
                 
-(void)checkNewOrders
{
    if(lastOrderIncrementalId){
        int newestOrderIncrementalId = [[[[[orderHolder valueForKey:@"data-items"] objectAtIndex:0] objectAtIndex:1] valueForKey:@"increment_id"]intValue];
        
        int newOrders = newestOrderIncrementalId - lastOrderIncrementalId;
        if(newOrders != 0){
            if(newOrders == 1){
                NSString *notificationText = [[NSString alloc] initWithFormat:@"There's 1 new order"];
                [AJNotificationView showNoticeInView:self.view
                                                type:AJNotificationTypeDefault
                                               title:notificationText
                                     linedBackground:AJLinedBackgroundTypeDisabled
                                           hideAfter:2.5f
                                              offset:0.0f
                                               delay:0.0f
                                            response:^{[self titleTap];}
                 ];

            
            
            } else {
                NSString *notificationText = [[NSString alloc] initWithFormat:@"There are %d new orders", newOrders];
                [AJNotificationView showNoticeInView:self.view
                                                type:AJNotificationTypeDefault
                                               title:notificationText
                                     linedBackground:AJLinedBackgroundTypeDisabled
                                           hideAfter:2.5f
                                              offset:0.0f
                                               delay:0.0f
                                            response:^{
                                                NSLog(@"User tapped the notification");
                                            }
                 ];
            }
             
        } else {
           
            
        }
       
        
        lastOrderIncrementalId = newestOrderIncrementalId;
    } else {
        lastOrderIncrementalId = [[[[[orderHolder valueForKey:@"data-items"] objectAtIndex:0] objectAtIndex:1] valueForKey:@"increment_id"]intValue];
    }
}
-(void)updateOrders
{
    [self loginRequest:[shopInfo shopUrl] username:[shopInfo username] password:[shopInfo password]  request:@"salesOrderList" requestParams:nil update:YES];
}
#pragma mark Filter

-(void)showSortFilter
{

    BlockAlertView *alert = [BlockAlertView
                             alertWithTitle:@"Filter your orders by status"
                             message:nil];
    
    [alert setCancelButtonWithTitle:@"All orders" block:^{
        [self sortTableView:@"all orders"];
    }];
    [alert setCancelButtonWithTitle:@"Pending" block:^{
        [self sortTableView:@"pending"];
    }];
    [alert setCancelButtonWithTitle:@"Processing" block:^{
        [self sortTableView:@"processing"];
    }];
    [alert setCancelButtonWithTitle:@"Completed" block:^{
        [self sortTableView:@"complete"];
    }];
    [alert setCancelButtonWithTitle:@"Holded" block:^{
        [self sortTableView:@"holded"];
    }];
    [alert setCancelButtonWithTitle:@"Canceled" block:^{
        [self sortTableView:@"canceled"];
    }];
    
    [alert show];
    
}

//Sort logic
-(void)sortTableView:(NSString*)status
{
    
    NSLog(@"%@", status);
    
    copyListOfOrders = [[NSMutableArray alloc] init];
    
    if(![status isEqualToString:@"all orders"]){
        
        for (int i = 0; i < [[orderHolder objectForKey:@"data-items"] count]; i++) {
            
            for(int u = 0; u < [[[orderHolder objectForKey:@"data-items"] objectAtIndex:i] count]; u++){
                
                if(u != 0 && ![status isEqualToString:@"all orders"]){
                    
                    //For searching on first- & lastname
                    NSString *ordersStatus = [[NSString alloc] initWithFormat:@"%@", [[[[orderHolder objectForKey:@"data-items"] objectAtIndex:i] objectAtIndex:u] objectForKey:@"status"]];
                    NSRange statusResultsRange = [ordersStatus rangeOfString:status options:NSCaseInsensitiveSearch];
                    
                    if(statusResultsRange.length > 0){
                        [copyListOfOrders addObject:[[[orderHolder objectForKey:@"data-items"] objectAtIndex:i] objectAtIndex:u]];
                    } 
                    
                }
                
            }
            
        }
    
        sorting = YES;
        [ordersTable reloadData];
        
        NSString *notificationText = [[NSString alloc] initWithFormat:@"Showing %@", status];
        [AJNotificationView showNoticeInView:self.view
                                        type:AJNotificationTypeDefault
                                       title:notificationText
                             linedBackground:AJLinedBackgroundTypeDisabled
                                   hideAfter:1.0f];
    } else {
        
        sorting = NO;
        [ordersTable reloadData];
        
        NSString *notificationText = [[NSString alloc] initWithFormat:@"Showing %@", status];
        [AJNotificationView showNoticeInView:self.view
                                        type:AJNotificationTypeDefault
                                       title:notificationText
                             linedBackground:AJLinedBackgroundTypeDisabled
                                   hideAfter:1.0f];
        
    }
}

#pragma mark Search orders

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
    ordersTable.frame = CGRectMake(0, 0, 320, [constants getScreenHeight] - 280);
    [UIView commitAnimations];
    
    [searchOverlay removeFromSuperview];
    [self makeSearchOverlay];
}

- (void) searchBarSearchButtonClicked:(UISearchBar *)theSearchBar {
    
    //Resign the keyboard
    [theSearchBar resignFirstResponder];
    
    //Update height of tableview
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0];
    ordersTable.frame = CGRectMake(0, 0, 320, 365);
    [UIView commitAnimations];
    
    //Update the header button
    self.navigationItem.rightBarButtonItem = nil;
    self.navigationItem.rightBarButtonItem = [UIBarButtonItem styledBarButtonItemWithTarget:self selector:@selector(showSortFilter) title:@"Filter"];
    [searchOverlay removeFromSuperview];
}


-(void)makeSearchOverlay
{
    UITapGestureRecognizer *singleFingerTap =
    [[UITapGestureRecognizer alloc] initWithTarget:self
                                            action:@selector(doneSearching)];
    
    searchOverlay = [[UIView alloc] initWithFrame:CGRectMake(0, 44, 320, [constants getScreenHeight] - 320)];
    searchOverlay.backgroundColor = [UIColor colorWithRed:0/255 green:0/255 blue:0/255 alpha:0.8f];
    [searchOverlay addGestureRecognizer:singleFingerTap];
    [searchOverlay removeFromSuperview];
    [self.view addSubview:searchOverlay];
}

//Search logic 
- (void) searchTableView {
    
    NSString *searchText = searchBar.text;
    copyListOfOrders = [[NSMutableArray alloc] init];
    
    for (int i = 0; i < [[orderHolder objectForKey:@"data-items"] count]; i++) {
        
        for(int u = 0; u < [[[orderHolder objectForKey:@"data-items"] objectAtIndex:i] count]; u++){
        
            if(u != 0){
                
                //For searching on first- & lastname
                NSString *firstName = [[NSString alloc] initWithFormat:@"%@", [[[[orderHolder objectForKey:@"data-items"] objectAtIndex:i] objectAtIndex:u] objectForKey:@"firstname"]];
                NSString *lastName = [[NSString alloc] initWithFormat:@"%@", [[[[orderHolder objectForKey:@"data-items"] objectAtIndex:i] objectAtIndex:u] objectForKey:@"lastname"]];
                NSString *totalName = [[NSString alloc] initWithFormat:@"%@ %@", firstName, lastName];
                NSRange titleResultsRange = [totalName rangeOfString:searchText options:NSCaseInsensitiveSearch];
                
                //For searching on ordernumber
                NSString *orderNumber = [[NSString alloc] initWithFormat:@"%@", [[[[orderHolder objectForKey:@"data-items"] objectAtIndex:i] objectAtIndex:u] objectForKey:@"increment_id"]];
                NSRange orderNumberResultsRange = [orderNumber rangeOfString:searchText options:NSCaseInsensitiveSearch];
                
                if(titleResultsRange.length > 0 || orderNumberResultsRange.length > 0){
                    [copyListOfOrders addObject:[[[orderHolder objectForKey:@"data-items"] objectAtIndex:i] objectAtIndex:u]];
                    [searchOverlay removeFromSuperview];
                }
                
            }
            
        }
        
    }
    
}

#pragma mark Make tableview

///////////////////////////////////////////////////////
//////////////// Make tableview ///////////////////////
///////////////////////////////////////////////////////

//Initializing table
-(void)makeTable
{
    //Add view to tableview
    ordersTable = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, 320, [constants getScreenHeight] - 110)];
    ordersTable.dataSource = self;
    ordersTable.delegate = self;
    ordersTable.backgroundColor = [UIColor clearColor];
    ordersTable.separatorColor = [UIColor clearColor];
    [self.view addSubview:ordersTable];
    
    //Add searchbar
    searchBar = [[UISearchBar alloc] initWithFrame:CGRectMake(0,70,320,44)];
    searchBar.delegate = self;
    searchBar.placeholder = @"Search orders by name or ordernumber";
    searchBar.tintColor = [UIColor colorWithRed:48/255 green:47/255 blue:54/255 alpha:1.0];
    [ordersTable setTableHeaderView:searchBar];
}

// Checking the total of sections
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    if(!searching && !sorting){
        return [[orderHolder valueForKey:@"data-items"] count];
    } else {
        return 1;
    }
}


//Checking the total of rows in the section
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if(!searching && !sorting){
        return [[[orderHolder valueForKey:@"data-items"] objectAtIndex:section] count];
    } else {
        if([copyListOfOrders count] != 0){
            return [copyListOfOrders count];
        } else {
            return 1;
        }
    }
}

// Height of the cells
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    //The date row (indexPath.row = 0) has smaller height then the other order cells
    if(!searching && !sorting && indexPath.row == 0){
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
        if(!searching && ! sorting){
            [self configureCell:cell atIndexPath:indexPath];
        } else {
            [self configureCellForSearch:cell atIndexPath:indexPath];
        }
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    //For the date no interaction
    if(!sorting && !searching && indexPath.row == 0){
        cell.userInteractionEnabled = NO;
    } else if (sorting && indexPath.row == 0){
        cell.userInteractionEnabled = YES;
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
    
    if([copyListOfOrders count] != 0){

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
    } else {
    
        UIFont *font = [UIFont fontWithName:@"Lobster 1.3" size:18.0f];
        UILabel *orderName = [[UILabel alloc] initWithFrame:CGRectMake(20, 30, 280, 20)];
        orderName.font = [UIFont boldSystemFontOfSize:12.0f];
        orderName.backgroundColor = [UIColor clearColor];
        orderName.font = font;
        orderName.textAlignment = UITextAlignmentCenter;
        orderName.textColor = [UIColor whiteColor];
        orderName.text = @"Sorry, there are no orders for this status..";
        [cell addSubview:orderName];
    
    }

}

//For handling action when user selects row
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    //Put data from row into the designated singleton
    NSString *orderId = [[NSString alloc]init];
    NSString *orderStatus = [[NSString alloc] init];
    
    if(!searching && !sorting){
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
        [self makeAlert:@"No order ID" message:@"Something went wrong while loading the order." button:@"Ok"];
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
                              cancelButtonTitle:@"Cancel"
                              otherButtonTitles:buttonTitle, nil];
        
        [alert show];
    }
}

@end
