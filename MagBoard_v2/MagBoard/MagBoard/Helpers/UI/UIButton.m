//
//  UIButton.m
//  MagBoard
//
//  Created by Dennis de Jong on 31-10-12.
//  Copyright (c) 2012 Dennis de Jong. All rights reserved.
//

#import "UIButton.h"

@implementation UIButton (UIButton_StyledButton)

+ (UIButton *)styledButtonWithBackgroundImage:(UIImage *)image font:(UIFont *)font title:(NSString *)title target:(id)target selector:(SEL)selector
{
    //CGSize textSize = [title sizeWithFont:font];
    //CGSize buttonSize = CGSizeMake(textSize.width + 20.0f, image.size.width);
    
    UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(0.0f, 0.0f, 46, 31)];
    [button addTarget:target action:selector forControlEvents:UIControlEventTouchUpInside];
    [button setBackgroundImage:image forState:UIControlStateNormal];
    [button setTitle:title forState:UIControlStateNormal];
    [button.titleLabel setFont:font];
    
    return button;
}

+ (UIButton *)styledSettingsWithBackgroundImage:(UIImage *)image font:(UIFont *)font title:(NSString *)title target:(id)target selector:(SEL)selector
{
    UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(0.0f, 0.0f, 37, 31)];
    [button addTarget:target action:selector forControlEvents:UIControlEventTouchUpInside];
    [button setBackgroundImage:image forState:UIControlStateNormal];
    [button setTitle:title forState:UIControlStateNormal];
    [button.titleLabel setFont:font];
    
    return button;
}

@end
