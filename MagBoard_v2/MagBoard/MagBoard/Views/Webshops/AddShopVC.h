//
//  AddShopVC.h
//  MagBoard
//
//  Created by Dennis de Jong on 31-10-12.
//  Copyright (c) 2012 Dennis de Jong. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AddShopVC : UIViewController <UITextFieldDelegate>

-(void)constructHeader;
-(void)backButtonTouched;
-(void)makeForm;
-(void)loginRequest:(NSString *)magShopUrl magUsername:(NSString *)magUsername magPassword:(NSString *)magPassword magRequestFunction:(NSString *)magRequestFunction magRequestParams:(NSString *)magRequestParams magUpdate:(bool)magUpdate;

@property (strong, nonatomic) UITextField* shopName;
@property (strong, nonatomic) UITextField* shopUrl;
@property (strong, nonatomic) UITextField* username;
@property (strong, nonatomic) UITextField* password;
@property (strong, nonatomic) UISwitch* passwordSwitch;
@property (weak, nonatomic) NSString *message;
@property (weak, nonatomic) NSString *alertTitle;
@property BOOL empty;
@property (weak, nonatomic) NSPredicate *urlTest;
@property (weak, nonatomic) NSString *urlRegEx;
@property (nonatomic, retain) NSMutableDictionary *update;

@end
