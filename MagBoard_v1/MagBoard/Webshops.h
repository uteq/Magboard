//
//  Webshops.h
//  MagBoard
//
//  Created by Dennis de Jong on 01-10-12.
//  Copyright (c) 2012 Dennis de Jong. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Users;

@interface Webshops : NSManagedObject

@property (nonatomic, retain) NSNumber * userId;
@property (nonatomic, retain) NSString * webshopName;
@property (nonatomic, retain) NSString * webshopUrl;
@property (nonatomic, retain) Users *users;

@end
