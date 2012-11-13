//
//  OrdersVC.h
//  MagBoard
//
//  Created by Dennis de Jong on 31-10-12.
//  Copyright (c) 2012 Dennis de Jong. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface OrdersVC : UIViewController <UITableViewDelegate, UITableViewDataSource, LRRestyClientResponseDelegate>
{
    int sections;
}

@property (nonatomic, retain) NSMutableDictionary* orderHolder;
@property (nonatomic, retain) ShopSingleton* shopInfo;
@property (nonatomic, retain) UIActivityIndicatorView* loadingIcon;
@property (nonatomic, strong) UITableView* ordersTable;


-(void)loginRequest:(NSString *)shopUrl username:(NSString *)username password:(NSString *)password request:(NSString *)requestFunction requestParams:(NSString *)requestParams;
-(void)makeTabel;
-(void)constructHeader;
-(void)loadingRequest;
-(void)alertForIncorrectLogin;

@end
