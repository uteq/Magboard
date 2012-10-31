//
//  AllWebshopsVC.h
//  MagBoard
//
//  Created by Dennis de Jong on 31-10-12.
//  Copyright (c) 2012 Dennis de Jong. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AllWebshopsVC : UIViewController <UITableViewDelegate, UITableViewDataSource>

@property (strong, nonatomic) UITableView* shopsTable;

-(void)drawNavigationBar;
-(void)makeTable;
-(void)makeButtons;
-(NSArray*)fetchAllShops;

@end
