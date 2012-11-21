//
//  constants.m
//  MagBoard
//
//  Created by Dennis de Jong on 14-11-12.
//  Copyright (c) 2012 Dennis de Jong. All rights reserved.
//

#import "constants.h"

@implementation constants

+(CGFloat)getScreenHeight
{
    //Set variables for screensize
    CGRect screenRect = [[UIScreen mainScreen] bounds];
    CGFloat screenHeight = screenRect.size.height;
    return screenHeight;
}

@end
