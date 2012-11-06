//
//  UIBarButtonItem.h
//  MagBoard
//
//  Created by Dennis de Jong on 31-10-12.
//  Copyright (c) 2012 Dennis de Jong. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UIBarButtonItem (StyledButton)

+ (UIBarButtonItem *)styledBackBarButtonItemWithTarget:(id)target selector:(SEL)selector;
+ (UIBarButtonItem *)styledCancelBarButtonItemWithTarget:(id)target selector:(SEL)selector;
+ (UIBarButtonItem *)styledSettingsButtonItemWithTarget:(id)target selector:(SEL)selector;
+ (UIBarButtonItem *)styledSubmitBarButtonItemWithTitle:(NSString *)title target:(id)target selector:(SEL)selector;

@end
