//
//  CustomNavBar.m
//  MagBoard
//
//  Created by Dennis de Jong on 31-10-12.
//  Copyright (c) 2012 Dennis de Jong. All rights reserved.
//

#import "CustomNavBar.h"

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
    self.layer.shadowColor = [UIColor blackColor].CGColor;
    self.layer.shadowOpacity = 1;
    self.layer.shadowOffset = CGSizeMake(0,01);
    CGRect shadowPath = CGRectMake(self.layer.bounds.origin.x - 10, self.layer.bounds.size.height - 6, self.layer.bounds.size.width + 20, 5);
    self.layer.shadowPath = [UIBezierPath bezierPathWithRect:shadowPath].CGPath;
    self.layer.shouldRasterize = YES;
    
}

+(UILabel*)setNavBarTitle:(NSString*)title
{
    UILabel *navBarTitle = [[UILabel alloc] initWithFrame:CGRectMake(60, 3, 200, 30)];
    navBarTitle.text = title;
    navBarTitle.font = [UIFont boldSystemFontOfSize:16];
    navBarTitle.textColor = [UIColor whiteColor];
    navBarTitle.backgroundColor = [UIColor clearColor];
    navBarTitle.textAlignment = UITextAlignmentCenter;
    navBarTitle.shadowColor = [UIColor blackColor];
    navBarTitle.shadowOffset = CGSizeMake(1, 1);
    
    return navBarTitle;
}

@end
