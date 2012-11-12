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

@property (strong, nonatomic) UITextField* shopName;
@property (strong, nonatomic) UITextField* shopUrl;
@property (strong, nonatomic) UITextField* username;
@property (strong, nonatomic) UITextField* password;
@property (strong, nonatomic) UISwitch* passwordSwitch;
@property (weak, nonatomic) NSString *message;
@property (weak, nonatomic) NSString *alertTitle;
@property (strong, nonatomic) ShopSingleton * sharedShop;
@property BOOL empty;
@property (strong, nonatomic) Webshop *editShop;

@end
