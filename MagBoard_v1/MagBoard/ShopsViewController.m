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
#import <QuartzCore/QuartzCore.h>

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
        UITableView *shopsTable = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, 320, 350)];
        shopsTable.dataSource = self;
        shopsTable.delegate = self;
        shopsTable.backgroundColor = [UIColor whiteColor];
        shopsTable.separatorColor = [UIColor clearColor];
        [self.view addSubview:shopsTable];
    }
}

//Aangeven hoeveel hoeveel items er moeten worden getoond in de table
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [[self fetchAllShops] count];
}

// Hoogte van de cellen setten
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 85;
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
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    return cell;
}

- (void)configureCell:(UITableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath
{
    NSString *name = [[[self fetchAllShops] objectAtIndex:indexPath.row] name];
    NSString *username = [[[self fetchAllShops] objectAtIndex:indexPath.row] username];
    
    // Setting shadow for text bubble
    UILabel *bubbleShadow = [[UILabel alloc] initWithFrame:CGRectMake(10.0f, 20.0f, 300.0f, 60.0f)];
    bubbleShadow.backgroundColor = [UIColor clearColor];
    bubbleShadow.layer.shadowColor = [UIColor blackColor].CGColor;
    bubbleShadow.layer.shadowOffset = CGSizeMake(1, 1);
    bubbleShadow.layer.shadowOpacity = 0.4;
    bubbleShadow.layer.shadowRadius = 1.0;
    bubbleShadow.clipsToBounds = NO;
    [cell addSubview:bubbleShadow];
    
    
    // Setting text bubble
    UILabel *bubble = [[UILabel alloc] initWithFrame:CGRectMake(2.0f, 2.0f, 300.0f, 58.0f)];
    [bubble.layer setBorderColor: [[UIColor clearColor] CGColor]];
    [bubble.layer setBorderWidth: 1.0];
    [bubble.layer setCornerRadius: 5];
    bubble.clipsToBounds = YES;
    UIColor *lightGrey = [UIColor colorWithRed:227.0f/255.0f green:227.0f/255.0f blue:227.0f/255.0f alpha:1.0];
    UIColor *whiteColor = [UIColor colorWithRed:255.0f/255.0f green:255.0f/255.0f blue:255.0f/255.0f alpha:1.0];
    CAGradientLayer *gradient = [CAGradientLayer layer];
    gradient.frame = [[bubble layer] bounds];
    gradient.cornerRadius = 7;
    gradient.colors = [NSArray arrayWithObjects:
                       (id)whiteColor.CGColor,
                       (id)lightGrey.CGColor,
                       nil];
    gradient.locations = [NSArray arrayWithObjects:
                          [NSNumber numberWithFloat:0.0f],
                          [NSNumber numberWithFloat:0.7],
                          nil];
    [[bubble layer] insertSublayer:gradient atIndex:0];
    [bubbleShadow addSubview:bubble];
    
    
    // Setting name
    UILabel *nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(10.0f, 0.0f, 200.0f, 30.0f)];
    nameLabel.font = [UIFont boldSystemFontOfSize:14.0f];
    nameLabel.text = name;
    nameLabel.backgroundColor = [UIColor clearColor];
    [bubble addSubview:nameLabel];
    
    // Setting subject
    NSString *subjectText = [[NSString alloc] initWithFormat:@"Gebruikersnaam: %@", name];
    UILabel *subject = [[UILabel alloc] initWithFrame:CGRectMake(10.0f, 30.0f, 270.0f, 20.0f)];
    subject.font = [UIFont systemFontOfSize:13.0f];
    subject.backgroundColor = [UIColor clearColor];
    subject.text = subjectText;
    [bubble addSubview:subject];

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
