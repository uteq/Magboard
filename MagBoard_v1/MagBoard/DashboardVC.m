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
        [self makeConnection:sharedShop.shopUrl username:sharedShop.username password:sharedShop.password];
    }
    return self;
}

-(void)makeConnection:(NSString *)shopUrl username:(NSString *)username password:(NSString *)password
{
    
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    [params setObject:shopUrl forKey:@"url"];
    [params setObject:username forKey:@"username"];
    [params setObject:password forKey:@"password"];
    
    [[LRResty client] post:@"http://www.magboard.nl/soap.php" payload:params
                 withBlock:^(LRRestyResponse *response){
                     if(response.status == 200) {;
                         
                         NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:[response responseData] options:kNilOptions error:nil];
                         
                         for(NSDictionary*keys in [dict valueForKey:@"data-items"]){
                             NSLog(@"%@", [keys valueForKey:@"customer_email"]);
                         }
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
