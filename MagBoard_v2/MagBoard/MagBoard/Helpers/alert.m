//
//  Alert.m
//  MagBoard
//
//  Created by Dennis de Jong on 22-11-12.
//  Copyright (c) 2012 Dennis de Jong. All rights reserved.
//

#import "Alert.h"

@implementation Alert

+(BlockAlertView*)makeAlert:(NSString*)alertTitle message:(NSString*)alertMessage button:(NSString *)buttonTitle target:(id)target selector:(SEL)selector
{
    if([buttonTitle isEqualToString:@"607"] || [buttonTitle isEqualToString:@"608"])
    {
        BlockAlertView *alert = [BlockAlertView
                                 alertWithTitle:alertTitle
                                 message:alertMessage];
        
        [alert setCancelButtonWithTitle:@"Ok" block:^{
            [target selector];
        }];
        [alert show];
        return alert;
    }
    else {
        
        BlockAlertView *alert = [BlockAlertView
                                 alertWithTitle:alertTitle
                                 message:alertMessage];
        
        [alert setCancelButtonWithTitle:@"Ok" block:^{
            [target selector];
        }];
        [alert show];
        return alert;
    }
}

@end
