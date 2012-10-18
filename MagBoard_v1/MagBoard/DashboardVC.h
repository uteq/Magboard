//
//  DashboardVC.h
//  MagBoard
//
//  Created by Dennis de Jong on 03-10-12.
//  Copyright (c) 2012 Dennis de Jong. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Webshop.h"
#import "ShopSingleton.h"
#import "LRResty.h"

@interface DashboardVC : UIViewController <UITableViewDelegate, UITableViewDataSource, LRRestyClientResponseDelegate>

@property (nonatomic, retain) NSMutableDictionary* orderHolder;
@property (nonatomic, retain) ShopSingleton* shopInfo;

-(void)fetchAllOrders:(NSString *)shopUrl username:(NSString *)username password:(NSString *)password request:(NSString *)requestFunction;
-(void)makeTabel;
-(void)drawNavigationBar;

@end
