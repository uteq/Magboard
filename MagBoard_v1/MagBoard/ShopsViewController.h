//
//  ShopsViewController.h
//  MagBoard
//
//  Created by Dennis de Jong on 25-09-12.
//  Copyright (c) 2012 Dennis de Jong. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ShopsViewController : UIViewController<UITableViewDelegate, UITableViewDataSource>

- (IBAction)goToAddShop:(id)sender;
- (IBAction)goToInstructions:(id)sender;

-(void)makeBackButton;
-(NSArray*)fetchAllShops;

@end
