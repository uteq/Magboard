//
//  AllWebshopsVC.h
//  MagBoard
//
//  Created by Dennis de Jong on 31-10-12.
//  Copyright (c) 2012 Dennis de Jong. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AllWebshopsVC : UIViewController <UIScrollViewDelegate>

@property (strong, nonatomic) UIScrollView* shopsScroller;
@property (strong, nonatomic) UILabel* noShopsLabel;
@property (strong, nonatomic) NSArray* allShops;            //For holding the shops from database
@property (assign, nonatomic) int scrollerAtIndex;          //For saving the index for the scrollview
@property (strong, nonatomic) UIPageControl * pageControl;  //For making the pagination dots

//Make up interface
-(void)drawNavigationBar;
-(void)makeScrollview;
-(void)addShopsToScrollview;
-(void)makeButtons;
-(void)makeAlert;
-(void)fetchAllShops;
-(void)scrollToWebshop;

//Actions for buttons
-(void)goToInstructions;
-(void)goToAddShop;
-(void)settingsButtonTouched;
-(void)goToOrdersPage;

@end
