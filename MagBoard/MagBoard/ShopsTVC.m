//
//  ShopsTVC.m
//  MagBoard
//
//  Created by Dennis de Jong on 01-10-12.
//  Copyright (c) 2012 Dennis de Jong. All rights reserved.
//

#import "ShopsTVC.h"
#import "User.h"
#import "InfoVC.h"

@interface ShopsTVC ()

@end

@implementation ShopsTVC

@synthesize fetchedResultsController = __fetchedResultsController;
@synthesize managedObjectContext = __managedObjectContext;

- (void)setupFetchedResultsController
{
    // 1 - Decide what Entity you want
    NSString *entityName = @"Webshop"; // Put your entity name here
    NSLog(@"Setting up a Fetched Results Controller for the Entity named %@", entityName);
    
    // 2 - Request that Entity
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:entityName];
    
    // 3 - Filter it if you want
    //request.predicate = [NSPredicate predicateWithFormat:@"Webshop.name = Blah"];
    
    // 4 - Sort it if you want
    request.sortDescriptors = [NSArray arrayWithObject:[NSSortDescriptor sortDescriptorWithKey:@"name"
                                                                                     ascending:YES
                                                                                      selector:@selector(localizedCaseInsensitiveCompare:)]];
    // 5 - Fetch it
    self.fetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:request
                                                                        managedObjectContext:self.managedObjectContext
                                                                          sectionNameKeyPath:nil
                                                                                   cacheName:nil];
    [self performFetch];
}


- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self setupFetchedResultsController];
}

//This is the function which returns the number of table rows to display in the tvc
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    int numberOfRows = 0;
    
    //If there are no rows fetched show 1 row
    if([self.fetchedResultsController.fetchedObjects count] != 0){
        numberOfRows = [self.fetchedResultsController.fetchedObjects count];
    } else {
        numberOfRows = 1;
    }
    NSLog(@"%d", numberOfRows);
    return numberOfRows;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Shop cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    // Configure the cell...
    if([self.fetchedResultsController.fetchedObjects count] != 0)
    {
        Webshop *webshop = [self.fetchedResultsController objectAtIndexPath:indexPath];
        cell.textLabel.text = webshop.name;
         NSLog(@"JAAAAAAAP");
    } else {
        cell.textLabel.text = @"Er zijn helaas geen webshops beschikbaar, klik op het + tekentje bovenin de applicatie om een shop toe te voegen.";
         NSLog(@"JAAAAAAAP");
    }
    
    return cell;
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
	if ([segue.identifier isEqualToString:@"Add Shop Segue"])
	{
        NSLog(@"Setting RolesTVC as a delegate of AddRolesTVC");
        
        AddShopTVC *addShopTVC = segue.destinationViewController;
        addShopTVC.delegate = self;
        addShopTVC.managedObjectContext = self.managedObjectContext;
	}
}

- (void)theSaveButtonOnTheAddShopTVCWasTapped:(AddShopTVC *)controller
{
    // do something here like refreshing the table or whatever
    
    // close the delegated view
    [controller.navigationController popViewControllerAnimated:YES];
}

//Action to push to the info view
- (IBAction)pushToInfoVC:(id)sender {
    InfoVC *infoScreen = [[InfoVC alloc] init];
    [self.navigationController pushViewController:infoScreen animated:YES];
}
@end
