//
//  ShopsTVC.h
//  MagBoard
//
//  Created by Dennis de Jong on 01-10-12.
//  Copyright (c) 2012 Dennis de Jong. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AddShopTVC.h" // so this class can be a AddShopTVCDelegate
#import "CoreDataTableViewController.h" // so we can fetch
#import "User.h"
#import "Webshop.h"

@interface ShopsTVC : CoreDataTableViewController <AddShopTVCDelegate>

@property (strong, nonatomic) NSFetchedResultsController *fetchedResultsController;
@property (strong, nonatomic) NSManagedObjectContext *managedObjectContext;

- (IBAction)pushToInfoVC:(id)sender;

@end
