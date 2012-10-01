//
//  AddShopTVC.m
//  MagBoard
//
//  Created by Dennis de Jong on 01-10-12.
//  Copyright (c) 2012 Dennis de Jong. All rights reserved.
//

#import "AddShopTVC.h"

@interface AddShopTVC ()

@end

@implementation AddShopTVC
@synthesize delegate;
@synthesize managedObjectContext = __managedObjectContext;

- (void)viewDidUnload
{
    [super viewDidUnload];
}
- (IBAction)save:(id)sender
{
    NSLog(@"Telling the AddRoleTVC Delegate that Save was tapped on the AddRoleTVC");
    
    Webshop *webshop = [NSEntityDescription insertNewObjectForEntityForName:@"Webshop"
                                               inManagedObjectContext:self.managedObjectContext];
    
    webshop.name = _webshopNameTextField.text;
    webshop.url = _urlTextField.text;
    webshop.username = _usernameTextField.text;
    webshop.password = _passwordTextField.text;
    
    if([self.managedObjectContext save:nil])  // write to database
        NSLog(@"Heeft naar db geschreven");
    
    [self.delegate theSaveButtonOnTheAddShopTVCWasTapped:self];
}

-(IBAction)textFieldReturn:(id)sender
{
    [sender resignFirstResponder];
    NSLog(@"Jaap");
}

@end
