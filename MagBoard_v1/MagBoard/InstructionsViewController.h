//
//  InstructionsViewController.h
//  MagBoard
//
//  Created by Dennis de Jong on 25-09-12.
//  Copyright (c) 2012 Dennis de Jong. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface InstructionsViewController : UIViewController <UIScrollViewDelegate>
{
    UIScrollView *instructionsHolder;
    int scrollMove;
}

-(void)addScrollView;
-(IBAction)goToNextInstruction:(id)sender;

@end
