//
//  DashboardVC.m
//  MagBoard
//
//  Created by Dennis de Jong on 03-10-12.
//  Copyright (c) 2012 Dennis de Jong. All rights reserved.
//

#import "DashboardVC.h"
#import "Webshop.h"
#import "ShopSingleton.h"

//Imports for networking
#import "LRResty.h"

@interface DashboardVC ()

@end

@implementation DashboardVC

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        [[self view] setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"linnen_bg@2x.png"]]];
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
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    [params setObject:@"firstname" forKey:@"description"];
    [params setObject:@"status" forKey:@"entity_id"];
    
    [[LRResty client] post:@"http://www.magboard.nl/soap.php" payload:params
                 withBlock:^(LRRestyResponse *response){
                     if(response.status == 200) {
                         NSLog(@"Successful response %@", [response asString]);
                     }
                 }];

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
