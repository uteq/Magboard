//
//  Users.h
//  MagBoard
//
//  Created by Dennis de Jong on 01-10-12.
//  Copyright (c) 2012 Dennis de Jong. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface Users : NSManagedObject

@property (nonatomic, retain) NSNumber * id;
@property (nonatomic, retain) NSString * password;
@property (nonatomic, retain) NSString * username;
@property (nonatomic, retain) NSSet *webshops;
@end

@interface Users (CoreDataGeneratedAccessors)

- (void)addWebshopsObject:(NSManagedObject *)value;
- (void)removeWebshopsObject:(NSManagedObject *)value;
- (void)addWebshops:(NSSet *)values;
- (void)removeWebshops:(NSSet *)values;

@end
