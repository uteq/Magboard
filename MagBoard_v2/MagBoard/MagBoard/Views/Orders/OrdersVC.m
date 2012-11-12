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

@synthesize shopInfo, orderHolder, loadingIcon, ordersTable;

- (void)viewDidLoad
{
    [super viewDidLoad];
    shopInfo = [ShopSingleton shopSingleton];
    // Do any additional setup after loading the view.
    [self constructHeader];
    [self loginRequest:[shopInfo shopUrl] username:[shopInfo username] password:[shopInfo password]  requestFunction:@"salesOrderList"];
    [self loadingRequest];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)constructHeader
{
    UILabel* navBarTitle = [CustomNavBar setNavBarTitle:[shopInfo shopName]];
    self.navigationItem.titleView = navBarTitle;
    self.navigationItem.leftBarButtonItem = [UIBarButtonItem styledBarButtonItemWithTarget:self selector:@selector(backButtonTouched) title:@"Logout"];
}

-(void)backButtonTouched
{
    NSMutableArray *viewControllers = [NSMutableArray arrayWithArray:[[self navigationController] viewControllers]];
    [viewControllers removeLastObject];
    [[self navigationController] setViewControllers:viewControllers animated:YES];
}

//While doing request show loading icon
-(void)loadingRequest
{
    loadingIcon = [[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
	loadingIcon.frame = CGRectMake(0.0, 0.0, 320.0, 440.0);
	loadingIcon.center = self.view.center;
    [loadingIcon startAnimating];
	[self.view addSubview: loadingIcon];
}

//Make request for logging in en fetching orders
-(void)loginRequest:(NSString *)shopUrl username:(NSString *)username password:(NSString *)password requestFunction:(NSString *)requestFunction
{
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    [params setObject:shopUrl forKey:@"url"];
    [params setObject:username forKey:@"username"];
    [params setObject:password forKey:@"password"];
    [params setObject:requestFunction forKey:@"requestFunction"];
    
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
            [loadingIcon stopAnimating];
            [self makeTable];
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

//Hier wordt de table geinitialiseerd
-(void)makeTable
{
    //Tableview toevoegen aan de view
    ordersTable = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, 320, 410)];
    ordersTable.dataSource = self;
    ordersTable.delegate = self;
    ordersTable.backgroundColor = [UIColor clearColor];
    ordersTable.separatorColor = [UIColor clearColor];
    [self.view addSubview:ordersTable];
}

//Aangeven hoeveel hoeveel items er moeten worden getoond in de table
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [[orderHolder valueForKey:@"data-items"] count]; 
}

// Hoogte van de cellen setten
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 65;
}

//Hier wordt de inhoud van de cel bepaald
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
        [self configureCell:cell atIndexPath:indexPath];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    return cell;
}

- (void)configureCell:(UITableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath
{
    NSString* firstName = [[NSString alloc] initWithFormat:@"%@", [[[orderHolder valueForKey:@"data-items"] objectAtIndex:indexPath.row] valueForKey:@"firstname"]];
    NSString* lastName = [[NSString alloc] initWithFormat:@"%@", [[[orderHolder valueForKey:@"data-items"] objectAtIndex:indexPath.row] valueForKey:@"lastname"]];
    NSString* grandTotal = [[NSString alloc] initWithFormat:@"%@", [[[orderHolder valueForKey:@"data-items"] objectAtIndex:indexPath.row] valueForKey:@"grand_total"]];
    NSString* orderId = [[NSString alloc] initWithFormat:@"%@", [[[orderHolder valueForKey:@"data-items"] objectAtIndex:indexPath.row] valueForKey:@"increment_id"]];
    
    NSString* totalName = [[NSString alloc] initWithFormat:@"%@ %@", firstName, lastName];
    //Add orderlabel image to table cell
    UILabel *orderHolderLabel = [[UILabel alloc] initWithFrame:CGRectMake(10.0f, 10.0f, 301.0f, 53.0f)];
    orderHolderLabel.font = [UIFont boldSystemFontOfSize:14.0f];
    //Determine the label for order status
    if([[[[orderHolder valueForKey:@"data-items"] objectAtIndex:indexPath.row] valueForKey:@"status"] isEqualToString:@"pending"])
    {
        UIImage *image = [UIImage imageNamed:@"order_holder_pending"];
        orderHolderLabel.backgroundColor = [UIColor colorWithPatternImage:image];
    }
    else if ([[[[orderHolder valueForKey:@"data-items"] objectAtIndex:indexPath.row] valueForKey:@"status"] isEqualToString:@"complete"])
    {
        UIImage *image = [UIImage imageNamed:@"order_holder_completed"];
        orderHolderLabel.backgroundColor = [UIColor colorWithPatternImage:image];
    }
    else if ([[[[orderHolder valueForKey:@"data-items"] objectAtIndex:indexPath.row] valueForKey:@"status"] isEqualToString:@"processing"])
    {
        UIImage *image = [UIImage imageNamed:@"order_holder_processing"];
        orderHolderLabel.backgroundColor = [UIColor colorWithPatternImage:image];
    }
    else if ([[[[orderHolder valueForKey:@"data-items"] objectAtIndex:indexPath.row] valueForKey:@"status"] isEqualToString:@"canceled"])
    {
        UIImage *image = [UIImage imageNamed:@"order_holder_canceled"];
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


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    //Data van de betreffende row in een singleton drukken
    NSString* orderId = [[NSString alloc] initWithFormat:@"%@", [[[orderHolder valueForKey:@"data-items"] objectAtIndex:indexPath.row] valueForKey:@"increment_id"]];
    
    OrderSingleton *sharedOrder = [OrderSingleton orderSingleton];
    sharedOrder.orderId = orderId;
    
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
