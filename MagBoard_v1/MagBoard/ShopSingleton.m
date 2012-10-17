//
//  ShopSingleton.m
//  MagBoard
//
//  Created by Dennis de Jong on 03-10-12.
//  Copyright (c) 2012 Dennis de Jong. All rights reserved.
//

#import "ShopSingleton.h"

static ShopSingleton *sharedShop = nil;

@implementation ShopSingleton

@synthesize shopUrl, shopName, username, password;

+ (id)shopSingleton
{
    @synchronized(self)
    {
        //Check of de global variable wel geinitialiseerd is
        if (sharedShop == nil)
            //Niet geinitialiseerd, dan init uitvoeren!
            sharedShop = [[self alloc] init];
    }
    //Return altijd hetzelfde geheugen adres.
    return sharedShop;
}

//De init functie van de singleton
- (id)init
{
    //Roep de init functie van NSObject aan.
    if (self = [super init])
    {
        shopUrl = [self shopUrl];
        shopName = [self shopName];
        username = [self username];
        password = [self password];
    }
    return self;
}

@end
