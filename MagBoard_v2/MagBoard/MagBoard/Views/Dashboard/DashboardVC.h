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
@property (nonatomic, strong) UIView *dashboardContent;
@property (nonatomic, strong) UIImageView *statisticsPointer;
@property (nonatomic, strong) UIImageView *statisticsHolder;
@property (nonatomic, strong) UIImageView *lastOrdersHolder;
@property (nonatomic, strong) UILabel *percentage;
@property (nonatomic, strong) UILabel *quantity;
@property (nonatomic, strong) UILabel *revenue;
@property (nonatomic, strong) UILabel *revenueSmall;
@property (nonatomic, strong) UILabel *tax;
@property (nonatomic, strong) UILabel *shipping;
@property (nonatomic, strong) UIView *graphHolder;
@property (nonatomic, strong) UIImageView *graphContent;
@property (nonatomic, strong) UILabel *graphText;

-(void)constructHeader;
-(void)constructTabBar;
-(void)loginRequest:(NSString *)shopUrl username:(NSString *)username password:(NSString *)password request:(NSString *)requestFunction requestParams:(NSString *)requestParams;
-(void)makeAlert:(NSString*)alertTitle message:(NSString*)alertMessage button:(NSString *)buttonTitle;
-(void)backButtonTouched;
-(void)dashboardToday;
@end
