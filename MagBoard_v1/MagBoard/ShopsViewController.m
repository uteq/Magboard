//
//  ShopsViewController.m
//  MagBoard
//
//  Created by Dennis de Jong on 25-09-12.
//  Copyright (c) 2012 Dennis de Jong. All rights reserved.
//

#import "ShopsViewController.h"

@interface ShopsViewController ()

@end

@implementation ShopsViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // Set text for navigationbar
    self.navigationItem.title=@"MagBoard";
    
	// Add label for text when no shops are available
    UILabel *noShopsText = [[UILabel alloc] initWithFrame:CGRectMake(20.0f, 150.0f, 280.0f, 70.0f)];
    [noShopsText setText:@"U heeft nog geen webshops toegevoegd aan MagBoard. Klik op 'Shop toevoegen' om te beginnen."];
    [noShopsText setFont:[UIFont systemFontOfSize:13.0f]];
    [noShopsText setTextColor:[UIColor blackColor]];
    [noShopsText setTextAlignment:UITextAlignmentCenter];
    [noShopsText setNumberOfLines:0];
    [self.view addSubview:noShopsText];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (IBAction)goToAddShop:(id)sender
{
    [self performSelector:@selector(makeBackButton)];
    [self performSegueWithIdentifier:@"goToAddShop" sender:nil];
}

- (IBAction)goToInstructions:(id)sender
{
    [self performSelector:@selector(makeBackButton)];
    [self performSegueWithIdentifier:@"goToInstructions" sender:nil];
}

//Make Back button a logout button
-(void)makeBackButton
{
    UIBarButtonItem *backButton = [[UIBarButtonItem alloc] initWithTitle:@"Terug" style:UIBarButtonItemStyleBordered target:nil action:nil]; [[self navigationItem] setBackBarButtonItem:backButton];
}

@end
