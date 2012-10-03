//
//  DashboardVC.m
//  MagBoard
//
//  Created by Dennis de Jong on 03-10-12.
//  Copyright (c) 2012 Dennis de Jong. All rights reserved.
//

#import "DashboardVC.h"
#import "AFJSONRequestOperation.h"
#import "Webshop.h"
#import "ShopSingleton.h"

@interface DashboardVC ()

@end

@implementation DashboardVC

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        [self. view setBackgroundColor:[UIColor whiteColor]];
        ShopSingleton *sharedShop = [ShopSingleton shopSingleton];
        NSLog(@"url: %@", sharedShop.shopUrl);
        NSLog(@"name: %@", sharedShop.shopName);
        NSLog(@"username: %@", sharedShop.username);
        NSLog(@"password: %@", sharedShop.password);
        UILabel *naam = [[UILabel alloc] initWithFrame:CGRectMake(20, 200, 280, 50)];
        naam.text = sharedShop.shopName;
        [self.view addSubview:naam];
        [self makeConnection:sharedShop.shopUrl username:sharedShop.username password:sharedShop.password];
    }
    return self;
}

-(void)makeConnection:(NSString *)shopUrl username:(NSString *)username password:(NSString *)password
{
    NSURL *url = [NSURL URLWithString:@"http://www.magboard.nl/api/rest/"];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    AFJSONRequestOperation *operation = [AFJSONRequestOperation JSONRequestOperationWithRequest:request success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON) {
        NSLog(@"Public Timeline: %@", JSON);
    } failure:nil];
    [operation start];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
