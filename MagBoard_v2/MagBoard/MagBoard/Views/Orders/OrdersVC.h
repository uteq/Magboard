//
//  OrdersVC.h
//  MagBoard
//
//  Created by Dennis de Jong on 31-10-12.
//  Copyright (c) 2012 Dennis de Jong. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface OrdersVC : UIViewController <UITableViewDelegate, UITableViewDataSource, LRRestyClientResponseDelegate, UISearchBarDelegate, UIPickerViewDelegate>
{
    int sections;
    NSMutableArray *copyListOfOrders;
}

//For order table view
@property (nonatomic, retain) NSMutableDictionary *orderHolder;
@property (nonatomic, retain) ShopSingleton *shopInfo;
@property (nonatomic, retain) UIActivityIndicatorView *loadingIcon;
@property (nonatomic, strong) UITableView *ordersTable;
@property (nonatomic, strong) UIView *loadingHolder;

//For searching orders
@property (nonatomic, strong) UIView *searchOverlay;
@property (nonatomic, strong) UISearchBar *searchBar;
@property BOOL searching;
@property BOOL letUserSelectRow;

//For pickerview
@property (nonatomic, strong) UIPickerView *sortingPicker;
@property BOOL pickerShown;
@property BOOL sorting;
@property int pickerSelected;

-(void)sortTableView:(NSString*)status;

-(void)loginRequest:(NSString *)shopUrl username:(NSString *)username password:(NSString *)password request:(NSString *)requestFunction requestParams:(NSString *)requestParams;
-(void)makeTabel;
-(void)constructHeader;
-(void)loadingRequest;
-(void)alertForIncorrectLogin;
-(void)constructTabBar;
-(void)goToDashboard;
-(void)doneSearching;

@end
