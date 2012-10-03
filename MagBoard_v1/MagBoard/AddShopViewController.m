//
//  AddShopViewController.m
//  MagBoard
//
//  Created by Dennis de Jong on 25-09-12.
//  Copyright (c) 2012 Dennis de Jong. All rights reserved.
//

#import "AddShopViewController.h"
#import "ObjectiveRecord.h"
#import "Webshop.h"

@interface AddShopViewController ()

@end

@implementation AddShopViewController
@synthesize nameWebshop;
@synthesize urlWebshop;
@synthesize username;
@synthesize password;
@synthesize savePassword;
@synthesize registerSuccess;

- (void)viewDidLoad
{
    [super viewDidLoad];
	
    // Set text for navigationbar
    self.navigationItem.title=@"Add shop";
}

- (void)viewDidUnload
{
    [self setNameWebshop:nil];
    [self setUrlWebshop:nil];
    [self setUsername:nil];
    [self setPassword:nil];
    [self setSavePassword:nil];
    [self setRegisterSuccess:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

//Functie die ervoor zorgt dat het keyboard verdwijnt als er op de achtergrond wordt geklikt
- (IBAction)resignKeyboard:(id)sender
{
    [nameWebshop resignFirstResponder];
    [urlWebshop resignFirstResponder];
    [username resignFirstResponder];
    [password resignFirstResponder];
}

//Functie die ervoor zorgt dat het password wordt opgeslagen
- (IBAction)savePassword:(id)sender
{
}

//Functie die ervoor zorgt dat de gegevens van de webshop worden opgeslagen
- (IBAction)saveWebshop:(id)sender
{
    //NSArray *shops = [Webshop where:@"name == 'John'"];
    Webshop *webshop = [Webshop create];
    webshop.name = nameWebshop.text;
    webshop.url = urlWebshop.text;
    webshop.username = username.text;
    webshop.password = password.text;
    
    if(webshop.save){
        NSLog(@"shop gesaved");
    }
}

//Functie voor het annuleren van het toevoegen van een webshop
- (IBAction)discardWebshop:(id)sender
{
    [self performSegueWithIdentifier:@"returnHome" sender:nil];
}

//Functie die het keyboard laat verdwijnen als er op return is geklikt
- (BOOL)textFieldShouldReturn:(UITextField *)textfield {
    [nameWebshop resignFirstResponder];
    [urlWebshop resignFirstResponder];
    [username resignFirstResponder];
    [password resignFirstResponder];
    return YES;
}

@end
