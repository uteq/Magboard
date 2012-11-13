//
//  UIBarButtonItem.h
//  MagBoard
//
//  Created by Dennis de Jong on 31-10-12.
//  Copyright (c) 2012 Dennis de Jong. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UIBarButtonItem (StyledButton)

+ (UIBarButtonItem *)styledBarButtonItemWithTarget:(id)target selector:(SEL)selector title:(NSString *)buttonTitle;
+ (UIBarButtonItem *)styledSettingsButtonItemWithTarget:(id)target selector:(SEL)selector;
+ (UIButton *)styledSubHeaderButtonWithTarget:(id)target selector:(SEL)selector name:(NSString*)name;

@end
