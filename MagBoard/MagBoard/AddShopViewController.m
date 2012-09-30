//
//  AddShopViewController.m
//  MagBoard
//
//  Created by Dennis de Jong on 25-09-12.
//  Copyright (c) 2012 Dennis de Jong. All rights reserved.
//

#import "AddShopViewController.h"

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
    // Het hoofdpad plus de MagBoardUserData.plist opvragen
    NSArray *paths = NSSearchPathForDirectoriesInDomains (NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsPath = [paths objectAtIndex:0];
    NSString *plistPath = [documentsPath stringByAppendingPathComponent:@"MagboardUserData.plist"];
    bool passwordSave;
    if(savePassword.on){
        passwordSave = YES;
    } else {
        passwordSave = NO;
    }
    
    // een dictionary creëren aan de hand van de ingevulde velden
    NSDictionary *plistDict = [NSDictionary dictionaryWithObjects: [NSArray arrayWithObjects: nameWebshop.text, urlWebshop.text, username.text, password.text, [NSNumber numberWithBool:passwordSave], nil] forKeys:[NSArray arrayWithObjects: @"WebshopName", @"WebshopUrl", @"Username", @"Password", @"SavePassword", nil]];
    
    NSString *error = nil;
    // NSData creëren aan de hand van de NSDictionary
    NSData *plistData = [NSPropertyListSerialization dataFromPropertyList:plistDict format:NSPropertyListXMLFormat_v1_0 errorDescription:&error];
    
    // als plistdata bestaat
    if(plistData){
        // plistdata schrijven naar de MagBoardUserdata
        [plistData writeToFile:plistPath atomically:YES];
        [registerSuccess setText:@"U bent succesvol geregistreerd"];
    }else{
        NSLog(@"Error in saveData: %@", error);
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
