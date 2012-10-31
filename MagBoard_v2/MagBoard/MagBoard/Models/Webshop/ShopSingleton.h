//
//  ShopSingleton.h
//  MagBoard
//
//  Created by Dennis de Jong on 31-10-12.
//  Copyright (c) 2012 Dennis de Jong. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ShopSingleton : NSObject{
    NSString *shopUrl;
    NSString *shopName;
    NSString *username;
    NSString *password;
}

@property (nonatomic, retain) NSString *shopUrl;
@property (nonatomic, retain) NSString *shopName;
@property (nonatomic, retain) NSString *username;
@property (nonatomic, retain) NSString *password;

+ (id)shopSingleton;

@end