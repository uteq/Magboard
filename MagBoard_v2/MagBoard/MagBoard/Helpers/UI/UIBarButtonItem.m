//
//  UIBarButtonItem.m
//  MagBoard
//
//  Created by Dennis de Jong on 31-10-12.
//  Copyright (c) 2012 Dennis de Jong. All rights reserved.
//

#import "UIBarButtonItem.h"
#import "UIButton.h"

@implementation UIBarButtonItem (StyledButton)


//For making custom settings button
+ (UIBarButtonItem *)styledSettingsButtonItemWithTarget:(id)target selector:(SEL)selector;
{
    UIImage *image = [UIImage imageNamed:@"settings_button"];
    //image = [image stretchableImageWithLeftCapWidth:20.0f topCapHeight:20.0f];
    
    NSString *title = NSLocalizedString(@"", nil);
    UIFont *font = [UIFont boldSystemFontOfSize:12.0f];
    
    UIButton *button = [UIButton styledSettingsWithBackgroundImage:image font:font title:title target:target selector:selector];
    button.titleLabel.textColor = [UIColor blackColor];
    
    CGSize textSize = [title sizeWithFont:font];
    CGFloat margin = (button.frame.size.height - textSize.height) / 2;
    CGFloat marginRight = 7.0f;
    CGFloat marginLeft = button.frame.size.width - textSize.width - marginRight;
    [button setTitleEdgeInsets:UIEdgeInsetsMake(margin, marginLeft, margin, marginRight)];
    [button setTitleColor:[UIColor colorWithRed:53.0f/255.0f green:77.0f/255.0f blue:99.0f/255.0f alpha:1.0f] forState:UIControlStateNormal];
    
    return [[UIBarButtonItem alloc] initWithCustomView:button];
}

+ (UIBarButtonItem *)styledBarButtonItemWithTarget:(id)target selector:(SEL)selector title:(NSString *)buttonTitle;
{
    UIImage *image = [UIImage imageNamed:@"bar_button_empty"];
    image = [image stretchableImageWithLeftCapWidth:20.0f topCapHeight:20.0f];
    
    NSString *title = NSLocalizedString(buttonTitle, nil);
    UIFont *font = [UIFont boldSystemFontOfSize:12.0f];
    
    UIButton *button = [UIButton styledButtonWithBackgroundImage:image font:font title:title target:target selector:selector];
    button.titleLabel.textColor = [UIColor whiteColor];
    [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    button.titleLabel.shadowColor = [UIColor blackColor];
    button.titleLabel.shadowOffset = CGSizeMake(1, 1);
    
    return [[UIBarButtonItem alloc] initWithCustomView:button];
}

//Buttons for subheader

+ (UIButton *)styledSubHeaderButtonWithTarget:(id)target selector:(SEL)selector name:(NSString*)name;
{
    UIImage *image = [[UIImage alloc] init];
    CGRect buttonSize = CGRectMake(10.0f, 10.0f, 92.0f, 34.0f);
    
    if([name isEqualToString:@"hold"]){
        image = [UIImage imageNamed:@"hold_button.png"];
        buttonSize = CGRectMake(10.0f, 8.0f, 92.0f, 34.0f);
    } else if ([name isEqualToString:@"cancel"]){
        image = [UIImage imageNamed:@"cancel_button.png"];
        buttonSize = CGRectMake(115.0f, 8.0f, 92.0f, 34.0f);
    } else if ([name isEqualToString:@"invoice"]){
        image = [UIImage imageNamed:@"invoice_button.png"];
        buttonSize = CGRectMake(220.0f, 8.0f, 92.0f, 34.0f);
    } else if ([name isEqualToString:@"dashboard"]){
        image = [UIImage imageNamed:@"tabbar_dashboard.png"];
        buttonSize = CGRectMake(160.0f, 2.0f, 160.0f, 45.0f);
    } else if ([name isEqualToString:@"dashboardSelected"]){
        image = [UIImage imageNamed:@"tabbar_dashboard_active.png"];
        buttonSize = CGRectMake(161.0f, 2.0f, 160.0f, 45.0f);
    } else if ([name isEqualToString:@"orders"]){
        image = [UIImage imageNamed:@"tabbar_orders.png"];
        buttonSize = CGRectMake(0.0f, 1.0f, 159.0f, 45.0f);
    } else if ([name isEqualToString:@"ordersSelected"]){
        image = [UIImage imageNamed:@"tabbar_orders_active.png"];
        buttonSize = CGRectMake(0.0f, 1.0f, 159.0f, 45.0f);
    }
    
    UIButton *button = [[UIButton alloc] initWithFrame:buttonSize];
    [button addTarget:target action:selector forControlEvents:UIControlEventTouchUpInside];
    [button setBackgroundImage:image forState:UIControlStateNormal];
    
    return button;
}


@end
