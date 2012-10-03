//
//  ShopsViewController.m
//  MagBoard
//
//  Created by Dennis de Jong on 25-09-12.
//  Copyright (c) 2012 Dennis de Jong. All rights reserved.
//

#import "ShopsViewController.h"
#import "ObjectiveRecord.h"
#import "Webshop.h"

@interface ShopsViewController ()

@end

@implementation ShopsViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // Set text for navigationbar
    self.navigationItem.title=@"MagBoard";

}

-(void)viewDidAppear:(BOOL)animated
{
    //Check list of shops
    NSLog(@"%@", [self fetchAllShops]);
    
    if([self fetchAllShops] == NULL)
    {
        // Add label for text when no shops are available
        UILabel *noShopsText = [[UILabel alloc] initWithFrame:CGRectMake(20.0f, 150.0f, 280.0f, 70.0f)];
        [noShopsText setText:@"U heeft nog geen webshops toegevoegd aan MagBoard. Klik op 'Shop toevoegen' om te beginnen."];
        [noShopsText setFont:[UIFont systemFontOfSize:13.0f]];
        [noShopsText setTextColor:[UIColor blackColor]];
        [noShopsText setTextAlignment:UITextAlignmentCenter];
        [noShopsText setNumberOfLines:0];
        [self.view addSubview:noShopsText];
    }
    else
    {
        //Tableview toevoegen aan de view
        UITableView *shopsTable = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, 320, 320)];
        shopsTable.dataSource = self;
        shopsTable.delegate = self;
        [self.view addSubview:shopsTable];
        
        for(Webshop *shop in [self fetchAllShops])
        {
            //counter++;
            NSLog(@"%@", shop.name);
        }
    }
}

//Aangeven hoeveel hoeveel items er moeten worden getoond in de table
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [[self fetchAllShops] count];
}

//Hier wordt de inhoud van de cel bepaald
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *webshopCell = @"WebshopCell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:webshopCell];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:webshopCell];
    }
    
    [self configureCell:cell atIndexPath:indexPath];
    
    return cell;
}

- (void)configureCell:(UITableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath
{
    NSString *label = [[[self fetchAllShops] objectAtIndex:indexPath.row] name];
    cell.textLabel.text = [NSString stringWithFormat:@"%@", label];
}

//Met deze functie worden alle webshops opgehaald
-(NSArray*)fetchAllShops
{
    NSArray *allShops = [Webshop all];
    return allShops;
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

//Deze actie brengt de gebruiker naar de pagina om een webshop toe te voegen
- (IBAction)goToAddShop:(id)sender
{
    [self performSelector:@selector(makeBackButton)];
    [self performSegueWithIdentifier:@"goToAddShop" sender:nil];
}

//Deze actie brengt de bezoeker naar de instructies pagina
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
