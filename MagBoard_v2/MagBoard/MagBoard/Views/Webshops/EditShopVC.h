//
//  EditShopVC.h
//  MagBoard
//
//  Created by Dennis de Jong on 06-11-12.
//  Copyright (c) 2012 Dennis de Jong. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface EditShopVC : UIViewController <UITextFieldDelegate, UIAlertViewDelegate>

-(void)constructHeader;
-(void)backButtonTouched;
-(void)deleteShop;
-(void)makeAlert:(NSString*)alertTitle message:(NSString*)alertMessage button:(NSString *)buttonTitle;
-(void)makeForm;
-(void)loginRequest:(NSString *)magShopUrl magUsername:(NSString *)magUsername magPassword:(NSString *)magPassword magRequestFunction:(NSString *)magRequestFunction magRequestParams:(NSString *)magRequestParams magUpdate:(bool)magUpdate;
-(void)updateThumbnail;
-(void)saveThumbnail;
-(void)thumbnailRequest:(NSString *)magShopUrl magUsername:(NSString *)magUsername magPassword:(NSString *)magPassword magRequestFunction:(NSString *)magRequestFunction;
-(void)deleteThumbnail;

@property (strong, nonatomic) NSMutableDictionary* apiResponse;
@property (strong, nonatomic) UITextField* shopName;
@property (strong, nonatomic) UITextField* shopUrl;
@property (strong, nonatomic) UITextField* username;
@property (strong, nonatomic) UITextField* password;
@property (strong, nonatomic) UISwitch* passwordSwitch;
@property (weak, nonatomic) NSString *message;
@property (weak, nonatomic) NSString *setAlertTitle;
@property (strong, nonatomic) ShopSingleton * sharedShop;
@property BOOL empty;
@property (strong, nonatomic) Webshop *editShop;
@property (weak, nonatomic) NSPredicate *urlTest;
@property (weak, nonatomic) NSString *urlRegEx;

@end
