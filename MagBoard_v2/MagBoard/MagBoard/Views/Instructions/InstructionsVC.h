//
//  InstructionsVC.h
//  MagBoard
//
//  Created by Dennis de Jong on 31-10-12.
//  Copyright (c) 2012 Dennis de Jong. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface InstructionsVC : UIViewController <UIScrollViewDelegate>

@property (strong, nonatomic) UIScrollView* instructionsScroller;
@property (assign, nonatomic) int scrollerAtIndex;          //For saving the index for the scrollview
@property (strong, nonatomic) UIPageControl * pageControl;  //For making the pagination dots

-(void)addScrollView;
-(void)constructHeader;
-(void)backButtonTouched;
-(void)readMagboardInstructions;

@end
