//
//  CustomNavBar.m
//  MagBoard
//
//  Created by Dennis de Jong on 15-10-12.
//  Copyright (c) 2012 Dennis de Jong. All rights reserved.
//

#import "CustomNavBar.h"
#import <QuartzCore/QuartzCore.h>

@implementation CustomNavBar

- (void)drawRect:(CGRect)rect
{
    [super drawRect:rect];
    
    UIImage *image = [UIImage imageNamed: @"navbar.png"];
    [image drawInRect:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
}

-(void)willMoveToWindow:(UIWindow *)newWindow{
    [super willMoveToWindow:newWindow];
    [self applyDefaultStyle];
}

- (void)applyDefaultStyle {
    // add the drop shadow
    self.layer.shadowColor = [[UIColor blackColor] CGColor];
    self.layer.shadowOffset = CGSizeMake(0.0, 0.01);
    self.layer.shadowOpacity = 1.0;
    self.layer.masksToBounds = NO;
    self.layer.shouldRasterize = YES;
}


@end
