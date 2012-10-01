//
//  AddShopTVC.h
//  MagBoard
//
//  Created by Dennis de Jong on 01-10-12.
//  Copyright (c) 2012 Dennis de Jong. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "User.h"
#import "Webshop.h"

@class AddShopTVC;

@protocol AddShopTVCDelegate
- (void)theSaveButtonOnTheAddShopTVCWasTapped:(AddShopTVC *)controller;
@end

@interface AddShopTVC : UITableViewController
@property (nonatomic, weak) id <AddShopTVCDelegate> delegate;
@property (weak, nonatomic) IBOutlet UITextField *webshopNameTextField;
@property (weak, nonatomic) IBOutlet UITextField *urlTextField;
@property (weak, nonatomic) IBOutlet UITextField *usernameTextField;
@property (weak, nonatomic) IBOutlet UITextField *passwordTextField;
@property (strong, nonatomic) NSManagedObjectContext *managedObjectContext;

- (IBAction)save:(id)sender;

@end
