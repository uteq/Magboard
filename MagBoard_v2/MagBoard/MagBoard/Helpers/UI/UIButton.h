//
//  UIButton.h
//  MagBoard
//
//  Created by Dennis de Jong on 31-10-12.
//  Copyright (c) 2012 Dennis de Jong. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UIButton (UIButton_StyledButton)

+ (UIButton *)styledButtonWithBackgroundImage:(UIImage *)image font:(UIFont *)font title:(NSString *)title target:(id)target selector:(SEL)selector;

@end
