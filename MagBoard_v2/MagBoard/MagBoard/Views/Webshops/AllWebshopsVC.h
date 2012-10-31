//
//  AllWebshopsVC.h
//  MagBoard
//
//  Created by Dennis de Jong on 31-10-12.
//  Copyright (c) 2012 Dennis de Jong. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AllWebshopsVC : UIViewController <UITableViewDelegate, UITableViewDataSource, LRRestyClientResponseDelegate>

@property (strong, nonatomic) UITableView* shopsTable;
@property (strong, nonatomic) UILabel* noShopsLabel;

-(void)drawNavigationBar;
-(void)makeTable;
-(void)makeButtons;
-(NSArray*)fetchAllShops;

@end
