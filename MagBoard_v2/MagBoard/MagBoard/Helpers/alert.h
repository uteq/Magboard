//
//  Alert.h
//  MagBoard
//
//  Created by Dennis de Jong on 22-11-12.
//  Copyright (c) 2012 Dennis de Jong. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Alert : NSObject

+(BlockAlertView*)makeAlert:(NSString*)alertTitle message:(NSString*)alertMessage button:(NSString *)buttonTitle target:(id)target selector:(SEL)selector;

@end
