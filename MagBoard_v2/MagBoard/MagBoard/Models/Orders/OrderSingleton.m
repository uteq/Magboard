//
//  OrderSingleton.m
//  MagBoard
//
//  Created by Leo Flapper on 05-11-12.
//  Copyright (c) 2012 Dennis de Jong. All rights reserved.
//

#import "OrderSingleton.h"
static OrderSingleton *sharedOrder = nil;

@implementation OrderSingleton

@synthesize orderId;

+ (id)orderSingleton
{
    @synchronized(self)
    {
        //Check of de global variable wel geinitialiseerd is
        if (sharedOrder == nil)
            //Niet geinitialiseerd, dan init uitvoeren!
            sharedOrder = [[self alloc] init];
    }
    //Return altijd hetzelfde geheugen adres.
    return sharedOrder;
}

//De init functie van de singleton
- (id)init
{
    //Roep de init functie van NSObject aan.
    if (self = [super init])
    {
        orderId = [self orderId];
    }
    return self;
}

@end
