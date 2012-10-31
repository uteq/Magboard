//
//  AllWebshopsVC.m
//  MagBoard
//
//  Created by Dennis de Jong on 31-10-12.
//  Copyright (c) 2012 Dennis de Jong. All rights reserved.
//

#import "AllWebshopsVC.h"
#import "OrdersVC.h"
#import "AddShopVC.h"
#import "InstructionsVC.h"

@interface AllWebshopsVC ()

@end

@implementation AllWebshopsVC

@synthesize shopsTable, noShopsLabel;

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    [self drawNavigationBar];
    [self makeTable];
    [self makeButtons];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    [shopsTable reloadData];
    // Release any retained subviews of the main view.
}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:YES];
    [shopsTable reloadData];
    NSLog(@"shops table did appear");
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//Navigationbar opmaken
-(void)drawNavigationBar
{
    // Create image for custom title
    UIImage *titleImage = [UIImage imageNamed: @"logo.png"];
    UIImageView *titleImageview = [[UIImageView alloc] initWithImage: titleImage];
    
    // set the text view to the image view
    self.navigationItem.titleView = titleImageview;
}

//Fetch all shops from Core Data
-(NSArray*)fetchAllShops
{
    NSArray *allShops = [Webshop all];
    return allShops;
}

-(void)makeTable
{
    if([self fetchAllShops] == NULL)
    {
        NSLog(@"There are no shops");
        // Add label for text when no shops are available
        noShopsLabel = [[UILabel alloc] initWithFrame:CGRectMake(44.0f, 140.0f, 232.0f, 20.0f)];
        [noShopsLabel setFont:[UIFont systemFontOfSize:14]];
        [noShopsLabel setTextColor:[UIColor whiteColor]];
        UIImage *image = [UIImage imageNamed:@"no_shops_text"];
        noShopsLabel.backgroundColor = [UIColor colorWithPatternImage:image];
        [noShopsLabel setTextAlignment:UITextAlignmentCenter];
        [noShopsLabel setNumberOfLines:0];
        [self.view addSubview:noShopsLabel];
        
        //Tableview toevoegen aan de view
        shopsTable = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, 320, 300)];
        shopsTable.dataSource = self;
        shopsTable.delegate = self;
        shopsTable.backgroundColor = [UIColor clearColor];
        shopsTable.separatorColor = [UIColor clearColor];
        [self.view addSubview:shopsTable];
    }
    else
    {
        NSLog(@"There are shops");
        //Tableview toevoegen aan de view
        shopsTable = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, 320, 300)];
        shopsTable.dataSource = self;
        shopsTable.delegate = self;
        shopsTable.backgroundColor = [UIColor clearColor];
        shopsTable.separatorColor = [UIColor clearColor];
        [self.view addSubview:shopsTable];
    }
}

-(void)makeButtons
{
    // Make instructions button
    UIButton *instructionsButton = [UIButton buttonWithType:UIButtonTypeCustom];
    instructionsButton.frame = CGRectMake(15.0, 310.0, 290.0, 43.0);
    [instructionsButton setTitle:@"Instructies" forState:UIControlStateNormal];
    [instructionsButton setFont:[UIFont boldSystemFontOfSize:14]];
    instructionsButton.backgroundColor = [UIColor clearColor];
    [instructionsButton setTitleColor:[UIColor colorWithRed:42.0/255.0 green:43.0/255.0 blue:53.0/255.0 alpha:1] forState:UIControlStateNormal ];
    instructionsButton.titleLabel.shadowColor = [UIColor whiteColor];
    instructionsButton.titleLabel.shadowOffset = CGSizeMake(0, 0);
    
    UIImage *buttonImageNormal = [UIImage imageNamed:@"button_full_width_grey.png"];
    [instructionsButton setBackgroundImage:buttonImageNormal forState:UIControlStateNormal];
    
    [instructionsButton addTarget:self action:@selector(goToInstructions) forControlEvents:UIControlEventTouchUpInside];
    
    [self.view addSubview:instructionsButton];
    
    //Make add shop button
    UIButton *addShopButton = [UIButton buttonWithType:UIButtonTypeCustom];
    addShopButton.frame = CGRectMake(15.0, 360.0, 290.0, 43.0);
    [addShopButton setTitle:@"Webshop toevoegen" forState:UIControlStateNormal];
    [addShopButton setFont:[UIFont boldSystemFontOfSize:14]];
    addShopButton.backgroundColor = [UIColor clearColor];
    [addShopButton setTitleColor:[UIColor colorWithRed:42.0/255.0 green:43.0/255.0 blue:53.0/255.0 alpha:1.0] forState:UIControlStateNormal ];
    addShopButton.titleLabel.shadowColor = [UIColor whiteColor];
    addShopButton.titleLabel.shadowOffset = CGSizeMake(0, 0);
    
    UIImage *addShopButtonImageNormal = [UIImage imageNamed:@"button_full_width_grey.png"];
    [addShopButton setBackgroundImage:addShopButtonImageNormal forState:UIControlStateNormal];
    
    [addShopButton addTarget:self action:@selector(goToAddShop) forControlEvents:UIControlEventTouchUpInside];
    
    [self.view addSubview:addShopButton];
}

//Aangeven hoeveel hoeveel items er moeten worden getoond in de table
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if([[self fetchAllShops] count] > 0){
        noShopsLabel.backgroundColor = [UIColor clearColor];
    }
    return [[self fetchAllShops] count];
}

// Hoogte van de cellen setten
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 75;
}

//Hier wordt de inhoud van de cel bepaald
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *webshopCell = @"WebshopCell";
    
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
    NSString *name = [[[self fetchAllShops] objectAtIndex:indexPath.row] name];
    NSString *username = [[[self fetchAllShops] objectAtIndex:indexPath.row] username];
    
    
    // Setting text bubble
    UILabel *bubble = [[UILabel alloc] initWithFrame:CGRectMake(18.0f, 20.0f, 284.0f, 58.0f)];
    [bubble.layer setBorderColor: [[UIColor clearColor] CGColor]];
    [bubble.layer setBorderWidth: 1.0];
    [bubble.layer setCornerRadius: 5];
    bubble.clipsToBounds = YES;
    UIColor *lightGrey = [UIColor colorWithRed:227.0f/255.0f green:227.0f/255.0f blue:227.0f/255.0f alpha:1.0];
    UIColor *whiteColor = [UIColor colorWithRed:255.0f/255.0f green:255.0f/255.0f blue:255.0f/255.0f alpha:1.0];
    CAGradientLayer *gradient = [CAGradientLayer layer];
    gradient.frame = [[bubble layer] bounds];
    gradient.cornerRadius = 7;
    gradient.colors = [NSArray arrayWithObjects:
                       (id)whiteColor.CGColor,
                       (id)lightGrey.CGColor,
                       nil];
    gradient.locations = [NSArray arrayWithObjects:
                          [NSNumber numberWithFloat:0.0f],
                          [NSNumber numberWithFloat:0.7],
                          nil];
    [[bubble layer] insertSublayer:gradient atIndex:0];
    [cell addSubview:bubble];
    
    
    // Setting name
    UILabel *nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(10.0f, 0.0f, 200.0f, 30.0f)];
    nameLabel.font = [UIFont boldSystemFontOfSize:14.0f];
    nameLabel.text = name;
    nameLabel.backgroundColor = [UIColor clearColor];
    [bubble addSubview:nameLabel];
    
    // Setting subject
    NSString *subjectText = [[NSString alloc] initWithFormat:@"Gebruikersnaam: %@", username];
    UILabel *subject = [[UILabel alloc] initWithFrame:CGRectMake(10.0f, 30.0f, 270.0f, 20.0f)];
    subject.font = [UIFont systemFontOfSize:13.0f];
    subject.backgroundColor = [UIColor clearColor];
    subject.text = subjectText;
    [bubble addSubview:subject];
    
}

//Hier wordt bepaald welke actie er wordt gedaan als de gebruiker op de shop drukt
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    //Data van de betreffende row in een singleton drukken
    Webshop *webshop = [[self fetchAllShops] objectAtIndex:indexPath.row];
    ShopSingleton *sharedShop = [ShopSingleton shopSingleton];
    sharedShop.shopUrl = webshop.url;
    sharedShop.shopName = webshop.name;
    sharedShop.username = webshop.username;
    sharedShop.password = webshop.password;
    
    if(sharedShop.password != nil)
    {
        OrdersVC *dashboard = [[OrdersVC alloc]init];
        NSMutableArray *viewControllers = [NSMutableArray arrayWithArray:[[self navigationController] viewControllers]];
        //[viewControllers removeLastObject];
        [viewControllers addObject:dashboard];
        [[self navigationController] setViewControllers:viewControllers animated:YES];
    } else {
        [self makeAlert:@"Kon niet inloggen" message:@"Kon niet inloggen omdat het wachtwoord niet is opgelagen"];
    }
    
}

//Make alert
-(void)makeAlert:(NSString*)alertTitle message:(NSString*)alertMessage
{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:alertTitle message:alertMessage delegate:self cancelButtonTitle:@"Annuleer" otherButtonTitles:@"Ok", nil];
    [alert show];
}

-(void)goToInstructions
{
    NSLog(@"Instructions button is pressed");
    
    InstructionsVC *instructionsView = [[InstructionsVC alloc]init];
    [[self  navigationController] pushViewController:instructionsView animated:YES];
}

-(void)goToAddShop
{
    NSLog(@"Add shop button is pressed");
    
    AddShopVC *addShopView = [[AddShopVC alloc]init];
    [[self  navigationController] pushViewController:addShopView animated:YES];
}


@end
