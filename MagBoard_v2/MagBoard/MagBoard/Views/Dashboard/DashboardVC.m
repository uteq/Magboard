//
//  DashboardVC.m
//  MagBoard
//
//  Created by Dennis de Jong on 17-12-12.
//  Copyright (c) 2012 Dennis de Jong. All rights reserved.
//

#import "DashboardVC.h"

@interface DashboardVC ()

@end

@implementation DashboardVC

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    [self constructHeader];
    [self constructTabBar];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark Construct view

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


#pragma mark Button actions

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

@end
