//
//  DashboardVC.h
//  MagBoard
//
//  Created by Dennis de Jong on 03-10-12.
//  Copyright (c) 2012 Dennis de Jong. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Webshop.h"

@interface DashboardVC : UIViewController<UITableViewDelegate, UITableViewDataSource>

-(void)makeConnection:(NSString *)shopUrl username:(NSString *)username password:(NSString *)password;

@end
