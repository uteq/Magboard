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
#import "EditShopVC.h"
#import "InstructionsVC.h"

@interface AllWebshopsVC ()

@end

@implementation AllWebshopsVC

@synthesize shopsScroller, noShopsLabel, allShops, pageControl, scrollerAtIndex;

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    [self fetchAllShops];
    if(allShops == nil){
        [self goToInstructions];
    }
    [self drawNavigationBar];
    [self makeButtons];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:YES];
    
    //Refresh scrollview
    [noShopsLabel removeFromSuperview];
    [[self shopsScroller] removeFromSuperview];
    [self fetchAllShops];
    [self makeScrollview];
    
    //Check for edited webshop
    [self scrollToWebshop];
    
    //Refresh scrollnav
    [[self pageControl] removeFromSuperview];
    [self shopsControlDots];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//Function for returning to last edited or visited webshop
-(void)scrollToWebshop
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSInteger scrollPosition = 0;
    
    if([[defaults objectForKey:@"referer"] isEqualToString:@"editShop"]){
        
        scrollPosition = [[defaults objectForKey:@"lastShop"] integerValue];
        
    } else if ([[defaults objectForKey:@"referer"] isEqualToString:@"addShop"]){
    
        scrollPosition = [[defaults objectForKey:@"totalNumberOfShops"] integerValue];
        
    }
    
    CGRect frame = shopsScroller.frame;
    frame.origin.x = frame.size.width * scrollPosition;
    frame.origin.y = 0;
    [shopsScroller scrollRectToVisible:frame animated:NO];
}

//Navigationbar opmaken
-(void)drawNavigationBar
{
    // Create image for custom title
    UIImage *titleImage = [UIImage imageNamed: @"logo.png"];
    UIImageView *titleImageview = [[UIImageView alloc] initWithImage: titleImage];
    if([allShops count] != 0)
    {
        self.navigationItem.rightBarButtonItem = [UIBarButtonItem styledBarButtonItemWithTarget:self selector:@selector(settingsButtonTouched) title:@"Wijzig"];
    }
    
    // set the text view to the image view
    self.navigationItem.titleView = titleImageview;
}

//Fetch all shops from Core Data
-(NSArray*)fetchAllShops
{
    allShops = [Webshop all];
    return allShops;
}

-(void)makeScrollview
{
    if(allShops == NULL)
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
    }
    else
    {
        NSLog(@"There are shops");
        int numberOfShops = [allShops count];
        int widthOfScreen = 320;
        float scrollerWidth = numberOfShops * widthOfScreen;
        shopsScroller = [[UIScrollView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, 320.0f, 300.0f)];
        [shopsScroller setContentSize:CGSizeMake(scrollerWidth, 300.0f)];
        shopsScroller.showsHorizontalScrollIndicator = NO;
        shopsScroller.pagingEnabled = YES;
        
        [self.view addSubview:shopsScroller];
        shopsScroller.delegate = self;
        [self addShopsToScrollview];
    }
}

//Add shops to the scrollview
-(void)addShopsToScrollview
{
    for(int i = 0; i < [allShops count]; i++)
    {
        NSString *name = [[allShops objectAtIndex:i] name];
        int pagePosition = 320 * i;
        
        //Add shopHolder
        UIView * shopHolder = [[UIView alloc] initWithFrame:CGRectMake(pagePosition + 20, 20.0f, 280.0f, 250.0f)];
        shopHolder.backgroundColor = [UIColor clearColor];
        [shopsScroller addSubview:shopHolder];
        
        //Add button for login shop
        UIButton *loginButton = [UIButton buttonWithType:UIButtonTypeCustom];
        loginButton.frame = CGRectMake(23.0, 2.0, 234.0, 230.0);
        loginButton.backgroundColor = [UIColor clearColor];
        [loginButton addTarget:self action:@selector(loginToShop:) forControlEvents:UIControlEventTouchUpInside];
        loginButton.tag = i;
        [shopHolder addSubview:loginButton];
        
        //Add screenshot holder
        UIImage * screenshot = [UIImage imageNamed:@"screenshot_webshop"];
        UIImageView * screenshotHolder = [[UIImageView alloc] initWithFrame:CGRectMake(23.0f, 10.0f, 234.0f, 154.0f)];
        screenshotHolder.image = screenshot;
        [screenshotHolder.layer setBorderColor: [[UIColor whiteColor] CGColor]];
        [screenshotHolder.layer setBorderWidth: 7.0];
//        screenshotHolder.layer.shadowColor = [UIColor blackColor].CGColor;
//        screenshotHolder.layer.shadowOffset = CGSizeMake(0, 2);
//        screenshotHolder.layer.shadowOpacity = 0.8;
        [shopHolder addSubview:screenshotHolder];
        
        //Add shop name
        UILabel *shopName = [[UILabel alloc] initWithFrame:CGRectMake(0, 200.0f, 280.0f, 20.0f)];
        [shopName setText:name];
        shopName.textAlignment = UITextAlignmentCenter;
        [shopName setFont:[UIFont boldSystemFontOfSize:16.0f]];
        [shopName setTextColor:[UIColor whiteColor]];
        [shopName setBackgroundColor:[UIColor clearColor]];
        shopName.shadowColor = [UIColor blackColor];
        shopName.shadowOffset = CGSizeMake(1, 1);
        [shopHolder addSubview:shopName];
    }
}

//Draw dots for scroller
-(void)shopsControlDots
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSInteger scrollPosition = 0;
    
    if([[defaults objectForKey:@"referer"] isEqualToString:@"editShop"]){
        
        scrollPosition = [[defaults objectForKey:@"lastShop"] integerValue];
        
    } else if ([[defaults objectForKey:@"referer"] isEqualToString:@"addShop"]){
        
        scrollPosition = [[defaults objectForKey:@"totalNumberOfShops"] integerValue];
    }
    
    pageControl = [[UIPageControl alloc] initWithFrame:CGRectMake(20.0f, 250.0f, 280.0f, 40.0f)];
    [pageControl setNumberOfPages:[allShops count]];
    [pageControl setCurrentPage:scrollPosition];
    [pageControl setBackgroundColor:[UIColor clearColor]];
    [self.view addSubview:pageControl];
}

//Change dots for scroller
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    int newOffset = scrollView.contentOffset.x;
    scrollerAtIndex = (int)(newOffset/(scrollView.frame.size.width));
    [pageControl setCurrentPage:scrollerAtIndex];
    
    NSLog(@"scroll changed to %d", scrollerAtIndex);
}

-(void)makeButtons
{
    // Make instructions button
    UIButton *instructionsButton = [UIButton buttonWithType:UIButtonTypeCustom];
    instructionsButton.frame = CGRectMake(15.0, 310.0, 290.0, 43.0);
    [instructionsButton setTitle:@"Instructies" forState:UIControlStateNormal];
    [instructionsButton.titleLabel setFont:[UIFont boldSystemFontOfSize:14]];
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
    [addShopButton.titleLabel setFont:[UIFont boldSystemFontOfSize:14]];
    addShopButton.backgroundColor = [UIColor clearColor];
    [addShopButton setTitleColor:[UIColor colorWithRed:42.0/255.0 green:43.0/255.0 blue:53.0/255.0 alpha:1.0] forState:UIControlStateNormal ];
    addShopButton.titleLabel.shadowColor = [UIColor whiteColor];
    addShopButton.titleLabel.shadowOffset = CGSizeMake(0, 0);
    
    UIImage *addShopButtonImageNormal = [UIImage imageNamed:@"button_full_width_grey.png"];
    [addShopButton setBackgroundImage:addShopButtonImageNormal forState:UIControlStateNormal];
    
    [addShopButton addTarget:self action:@selector(goToAddShop) forControlEvents:UIControlEventTouchUpInside];
    
    [self.view addSubview:addShopButton];
}

-(void)goToInstructions
{
    NSLog(@"Instructions button is pressed");
    
    InstructionsVC *instructionsView = [[InstructionsVC alloc]init];
    [[self  navigationController] pushViewController:instructionsView animated:YES];
}

-(void)goToAddShop
{
    //Setting referer for returning to right position of homescreen
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:@"addShop" forKey:@"referer"];
    [defaults setInteger:[allShops count] forKey:@"totalNumberOfShops"];
    [defaults synchronize];
    
    NSLog(@"Add shop button is pressed");
    
    AddShopVC *addShopView = [[AddShopVC alloc]init];
    [[self  navigationController] pushViewController:addShopView animated:YES];
}

//Handle settings button action
-(void)settingsButtonTouched
{
    //Setting referer for returning to right position of homescreen
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:@"editShop" forKey:@"referer"];
    [defaults setInteger:scrollerAtIndex forKey:@"lastShop"];
    [defaults synchronize];
    NSInteger webshopId = [[defaults objectForKey:@"lastShop"] integerValue];
    NSLog(@"Settings button for %d is pressed", webshopId);
    
    //Data van de betreffende row in een singleton drukken
    Webshop *webshop = [allShops objectAtIndex:scrollerAtIndex];
    ShopSingleton *sharedShop = [ShopSingleton shopSingleton];
    sharedShop.shopUrl = webshop.url;
    sharedShop.shopName = webshop.name;
    sharedShop.username = webshop.username;
    sharedShop.password = webshop.password;
    
    //Push to edit view controller
    EditShopVC *editShop = [[EditShopVC alloc]init];
    NSMutableArray *viewControllers = [NSMutableArray arrayWithArray:[[self navigationController] viewControllers]];
    //[viewControllers removeLastObject];
    [viewControllers addObject:editShop];
    [[self navigationController] setViewControllers:viewControllers animated:YES];
    
}

-(void)loginToShop:(id)sender
{
    int shopId = ((UIControl*)sender).tag;
    NSLog(@"Login %d", shopId);
    
    //Data van de betreffende row in een singleton drukken
    Webshop *webshop = [allShops objectAtIndex:shopId];
    ShopSingleton *sharedShop = [ShopSingleton shopSingleton];
    sharedShop.shopUrl = webshop.url;
    sharedShop.shopName = webshop.name;
    sharedShop.username = webshop.username;
    sharedShop.password = webshop.password;
    
    if(sharedShop.password == nil || [[sharedShop password] isEqualToString:@""])
    {
        UITextField *passwordField = [[UITextField alloc] initWithFrame:CGRectMake(12.0, 45.0, 260.0, 25.0)];
        BlockTextPromptAlertView *alert = [BlockTextPromptAlertView
                                           promptWithTitle:@"Inloggen"
                                           message:@"Geef uw wachtwoord op"
                                           textField:&passwordField];
        
        [alert setCancelButtonWithTitle:@"Annuleren" block:^{
        }];
        
        [alert addButtonWithTitle:@"Inloggen" block:^{
            // Do something nasty when this button is pressed
            NSLog(@"Login clicked : %@", passwordField.text);
            sharedShop.password = passwordField.text;
            [self goToOrdersPage];
        }];
        [alert show];
        
    } else {
        
        [self goToOrdersPage];
        
    }
}

-(void)goToOrdersPage
{
    //Set referer
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:@"editShop" forKey:@"referer"];
    [defaults setInteger:scrollerAtIndex forKey:@"lastShop"];
    [defaults synchronize];
    
    OrdersVC *dashboard = [[OrdersVC alloc]init];
    NSMutableArray *viewControllers = [NSMutableArray arrayWithArray:[[self navigationController] viewControllers]];
    //[viewControllers removeLastObject];
    [viewControllers addObject:dashboard];
    [[self navigationController] setViewControllers:viewControllers animated:YES];
}
@end
