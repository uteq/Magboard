//
//  DashboardVC.h
//  MagBoard
//
//  Created by Dennis de Jong on 17-12-12.
//  Copyright (c) 2012 Dennis de Jong. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DashboardVC : UIViewController

@property (nonatomic, retain) ShopSingleton *shopInfo;
@property (nonatomic, retain) NSMutableDictionary *dashboardHolder;

-(void)constructHeader;
-(void)constructTabBar;
-(void)loginRequest:(NSString *)shopUrl username:(NSString *)username password:(NSString *)password request:(NSString *)requestFunction requestParams:(NSString *)requestParams;
-(void)makeAlert:(NSString*)alertTitle message:(NSString*)alertMessage button:(NSString *)buttonTitle;
-(void)backButtonTouched;
@end
