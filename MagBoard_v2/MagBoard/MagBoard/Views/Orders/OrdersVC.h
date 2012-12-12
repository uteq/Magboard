//
//  OrdersVC.h
//  MagBoard
//
//  Created by Dennis de Jong on 31-10-12.
//  Copyright (c) 2012 Dennis de Jong. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface OrdersVC : UIViewController <UITableViewDelegate, UITableViewDataSource, LRRestyClientResponseDelegate, UISearchBarDelegate, UIPickerViewDelegate, UITextFieldDelegate>
{
    int sections;
    int lastOrderIncrementalId;
    NSMutableArray *copyListOfOrders;
    bool firstRun;
}

//For order table view
@property (nonatomic, retain) NSMutableDictionary *orderHolder;
@property (nonatomic, retain) ShopSingleton *shopInfo;
@property (nonatomic, retain) UIActivityIndicatorView *loadingIcon;
@property (nonatomic, strong) UITableView *ordersTable;
@property (nonatomic, strong) UIView *loadingHolder;
@property (nonatomic, strong) AJNotificationView *loadingPanel;
@property (nonatomic, strong) AJNotificationView *notificationPanel;

//For searching orders
@property (nonatomic, strong) UIView *searchOverlay;
@property (nonatomic, strong) UISearchBar *searchBar;
@property BOOL searching;
@property BOOL letUserSelectRow;

//For filter
@property BOOL sorting;

-(void)sortTableView:(NSString*)status;
-(void)updateOrders;
-(void)loginRequest:(NSString *)shopUrl username:(NSString *)username password:(NSString *)password request:(NSString *)requestFunction requestParams:(NSString *)requestParams update:(bool)update;
-(void)makeTabel;
-(void)constructHeader;
-(void)loadingRequest;
-(void)alertForIncorrectLogin;
-(void)constructTabBar;
-(void)goToDashboard;
-(void)doneSearching;

@end
