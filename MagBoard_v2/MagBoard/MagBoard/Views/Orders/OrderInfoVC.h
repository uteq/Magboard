//
//  OrderInfoVCViewController.h
//  MagBoard
//
//  Created by Leo Flapper on 05-11-12.
//  Copyright (c) 2012 Dennis de Jong. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface OrderInfoVC : UIViewController <UIScrollViewDelegate, UITableViewDataSource, LRRestyClientResponseDelegate>
{
    UIScrollView *orderInfoScrollView;
    int productsHolderHeight;
    int scrollViewHeight;
}

@property (nonatomic, retain) NSMutableDictionary* orderInfoHolder;
@property (nonatomic, retain) ShopSingleton* shopInfo;
@property (nonatomic, retain) OrderSingleton* orderInfo;
@property (nonatomic, retain) UIView *subHeader;
@property (nonatomic, retain) UIButton *createInvoice;
@property (nonatomic, retain) UIColor *headerColor;

//For making request for order details
-(void)loginRequest:(NSString *)shopUrl username:(NSString *)username password:(NSString *)password request:(NSString *)requestFunction requestParams:(NSString *)requestParams;

//For changing status of order
-(void)setOrderOnHold;
-(void)setOrderCancel;
-(void)setOrderInvoice;
-(void)requestInvoice;
-(void)requestHold:(NSString*)type;


@end
