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
#import "AFURLConnectionOperation.h"
#import "AFHTTPRequestOperation.h"
#import "AFJSONRequestOperation.h"
#import "AFOAuth2Client.h"
#import "AFHTTPClient.h"

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
    /*NSString *urlString = [[NSString alloc] initWithFormat:@"http://%@/", shopUrl];
    NSURL *url = [NSURL URLWithString:urlString];
    AFOAuth2Client *oauthClient = [AFOAuth2Client clientWithBaseURL:url];
    [oauthClient registerHTTPOperationClass:[AFJSONRequestOperation class]];
    
    [oauthClient authenticateUvsingOAuthWithPath:@"/oauth/token"
                                       username:username
                                       password:password
                                       clientID:@""
                                          secret:@""
                                        success:^(AFOAuthAccount *account) {
                                            NSLog(@"Credentials: %@", credential.accessToken);
                                            // If you are already using AFHTTPClient in your application, this would be a good place to set your `Authorization` header.
                                            // [HTTPClient setAuthorizationHeaderWithToken:credential.accessToken];
                                        }
                                        failure:^(NSError *error) {
                                            NSLog(@"Error: %@", error);
                                        }];
     */
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
