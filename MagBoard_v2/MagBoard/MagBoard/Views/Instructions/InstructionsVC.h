//
//  InstructionsVC.h
//  MagBoard
//
//  Created by Dennis de Jong on 31-10-12.
//  Copyright (c) 2012 Dennis de Jong. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface InstructionsVC : UIViewController <UIScrollViewDelegate>
{
    UIScrollView *instructionsHolder;
    int scrollMove;
}

-(void)addScrollView;
-(void)constructHeader;
-(void)backButtonTouched;
-(void)readMagboardInstructions;

@end
