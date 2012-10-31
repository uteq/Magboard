//
//  OrdersVC.m
//  MagBoard
//
//  Created by Dennis de Jong on 31-10-12.
//  Copyright (c) 2012 Dennis de Jong. All rights reserved.
//

#import "OrdersVC.h"

@interface OrdersVC ()

@end

@implementation OrdersVC

@synthesize shopInfo, orderHolder, loadingIcon, ordersTable;

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    [self constructHeader];
    shopInfo = [ShopSingleton shopSingleton];
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
    UILabel* navBarTitle = [CustomNavBar setNavBarTitle:@"Shop toevoegen"];
    self.navigationItem.titleView = navBarTitle;
    self.navigationItem.leftBarButtonItem = [UIBarButtonItem styledBackBarButtonItemWithTarget:self selector:@selector(backButtonTouched)];
}

-(void)backButtonTouched
{
    NSMutableArray *viewControllers = [NSMutableArray arrayWithArray:[[self navigationController] viewControllers]];
    [viewControllers removeLastObject];
    [[self navigationController] setViewControllers:viewControllers animated:YES];
}

-(void)loadingRequest
{
    loadingIcon = [[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
	loadingIcon.frame = CGRectMake(0.0, 0.0, 40.0, 40.0);
	loadingIcon.center = self.view.center;
    [loadingIcon startAnimating];
	[self.view addSubview: loadingIcon];
}

-(void)loginRequest:(NSString *)shopUrl username:(NSString *)username password:(NSString *)password requestFunction:(NSString *)requestFunction
{
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    [params setObject:shopUrl forKey:@"url"];
    [params setObject:username forKey:@"username"];
    [params setObject:password forKey:@"password"];
    [params setObject:requestFunction forKey:@"requestFunction"];
    
    [[LRResty client] post:@"http://www.magboard.nl/api/index.php" payload:params delegate:self];
}

- (void)restClient:(LRRestyClient *)client receivedResponse:(LRRestyResponse *)response;
{
    // do something with the response
    if(response.status == 200) {
        
        orderHolder = [NSJSONSerialization JSONObjectWithData:[response responseData] options:kNilOptions error:nil];
        NSLog(@"Status: %@", [orderHolder valueForKey:@"session"]);
        
        if([orderHolder valueForKey:@"session"] == NULL)
        {
            //[self backButtonTouched];
        }
    }
    else
    {
        NSLog(@"Er ging iets mis %d", [response status]);
    }
    
    [loadingIcon stopAnimating];
    [self makeTable];
}

//Hier wordt de table geinitialiseerd
-(void)makeTable
{
    
    if(orderHolder == NULL)
    {
        // Add label for text when no shops are available
        UILabel *noShopsText = [[UILabel alloc] initWithFrame:CGRectMake(20.0f, 130.0f, 280.0f, 90.0f)];
        [noShopsText setText:@"Er zijn nog geen orders geplaatst op uw webshop, of u heeft geen juiste logingegevens ingevoerd of de url is incorrect..."];
        [noShopsText setFont:[UIFont systemFontOfSize:12]];
        [noShopsText setTextColor:[UIColor whiteColor]];
        [noShopsText setBackgroundColor:[UIColor clearColor]];
        [noShopsText setTextAlignment:UITextAlignmentCenter];
        [noShopsText setNumberOfLines:0];
        [self.view addSubview:noShopsText];
    }
    else
    {
        //Tableview toevoegen aan de view
        ordersTable = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, 320, 410)];
        ordersTable.dataSource = self;
        ordersTable.delegate = self;
        ordersTable.backgroundColor = [UIColor clearColor];
        ordersTable.separatorColor = [UIColor clearColor];
        [self.view addSubview:ordersTable];
    }
    NSLog(@"Number of orders: %d", [[orderHolder valueForKey:@"data-items"] count]);
    
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
    static NSString *webshopCell = @"OrderCell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:webshopCell];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:webshopCell];
    }
    
    [self configureCell:cell atIndexPath:indexPath];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    return cell;
}

- (void)configureCell:(UITableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath
{
    NSString* firstName = [[NSString alloc] initWithFormat:@"%@", [[[orderHolder valueForKey:@"data-items"] objectAtIndex:indexPath.row] valueForKey:@"firstname"]];
    NSString* lastName = [[NSString alloc] initWithFormat:@"%@", [[[orderHolder valueForKey:@"data-items"] objectAtIndex:indexPath.row] valueForKey:@"lastname"]];
    NSString* totalValue = [[NSString alloc] initWithFormat:@"%@", [[[orderHolder valueForKey:@"data-items"] objectAtIndex:indexPath.row] valueForKey:@"base_grand_total"]];
    NSString* orderId = [[NSString alloc] initWithFormat:@"%@", [[[orderHolder valueForKey:@"data-items"] objectAtIndex:indexPath.row] valueForKey:@"increment_id"]];
    
    NSString* totalName = [[NSString alloc] initWithFormat:@"%@ %@", firstName, lastName];
    NSString* grandTotal = [[NSString alloc] init];
    float value = [totalValue floatValue];
    
    //If number only has zeros as digits behind the dot
    NSArray *findZeros = [totalValue componentsSeparatedByString:@"."];
    NSString *behindComma = [[NSString alloc] initWithFormat:[@"%@", findZeros objectAtIndex:1]];
    
    if([behindComma compare: @"0000"]){
        grandTotal = [NSString stringWithFormat:@"€ %.2f", value];
    } else {
        grandTotal = [NSString stringWithFormat:@"€ %.0f,-", value];
    }
    
    //Add orderlabel image to table cell
    UILabel *orderHolderLabel = [[UILabel alloc] initWithFrame:CGRectMake(10.0f, 20.0f, 301.0f, 53.0f)];
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
    
    NSLog(@"All fields: %@", [orderHolder valueForKey:@"data-items"]);
    
}

@end
