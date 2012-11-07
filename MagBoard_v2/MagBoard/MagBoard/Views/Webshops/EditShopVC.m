//
//  EditShopVC.m
//  MagBoard
//
//  Created by Dennis de Jong on 06-11-12.
//  Copyright (c) 2012 Dennis de Jong. All rights reserved.
//

#import "EditShopVC.h"

@interface EditShopVC ()

@end

@implementation EditShopVC

@synthesize shopName, shopUrl,username, password, passwordSwitch, message, alertTitle, empty, sharedShop;

- (void)viewDidLoad
{
    [super viewDidLoad];
    //Get shop data
    sharedShop = [ShopSingleton shopSingleton];
    
	// Do any additional setup after loading the view.
    [self constructHeader];
    [self makeForm];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)constructHeader
{
    UILabel* navBarTitle = [CustomNavBar setNavBarTitle:@"Shop wijzigen"];
    self.navigationItem.titleView = navBarTitle;
    self.navigationItem.leftBarButtonItem = [UIBarButtonItem styledBarButtonItemWithTarget:self selector:@selector(backButtonTouched) title:@"Terug"];
}

-(void)backButtonTouched
{
    NSMutableArray *viewControllers = [NSMutableArray arrayWithArray:[[self navigationController] viewControllers]];
    [viewControllers removeLastObject];
    [[self navigationController] setViewControllers:viewControllers animated:YES];
}

//Construct the form for adding webshop
-(void)makeForm
{
    
    //Make scroll holder for automatic input focus
    UIScrollView* scrollView = [[TPKeyboardAvoidingScrollView alloc] initWithFrame:CGRectMake(0, 0, 320.0, 440.0)];
    [self.view addSubview:scrollView];
    
    //Input field for shop name
    UIImageView* backgroundForName = [[UIImageView alloc] initWithFrame:CGRectMake(11.0, 30.0, 297.0, 38.0)];
    backgroundForName.image = [UIImage imageNamed:@"input_black_full_width"];
    [scrollView addSubview:backgroundForName];
    
    shopName = [[UITextField alloc] initWithFrame:CGRectMake(20, 40, 277, 38)];
    shopName.text = [sharedShop shopName];
    shopName.textAlignment = UITextAlignmentLeft;
    shopName.font = [UIFont boldSystemFontOfSize:14];
    shopName.adjustsFontSizeToFitWidth = YES;
    shopName.textColor = [UIColor whiteColor];
    shopName.returnKeyType = UIReturnKeyDone;
    [scrollView addSubview:shopName];
    
    //Input field for shop url
    UIImageView* backgroundForUrl = [[UIImageView alloc] initWithFrame:CGRectMake(11.0, 80.0, 297.0, 38.0)];
    backgroundForUrl.image = [UIImage imageNamed:@"input_black_full_width"];
    [scrollView addSubview:backgroundForUrl];
    
    shopUrl = [[UITextField alloc] initWithFrame:CGRectMake(20, 90, 277, 38)];
    shopUrl.text = [sharedShop shopUrl];
    shopUrl.textAlignment = UITextAlignmentLeft;
    shopUrl.font = [UIFont boldSystemFontOfSize:14];
    shopUrl.adjustsFontSizeToFitWidth = YES;
    shopUrl.autocapitalizationType = UITextAutocapitalizationTypeNone;
    shopUrl.textColor = [UIColor whiteColor];
    shopUrl.returnKeyType = UIReturnKeyDone;
    [scrollView addSubview:shopUrl];
    
    //Input field for username
    UIImageView* backgroundForUsername = [[UIImageView alloc] initWithFrame:CGRectMake(11.0, 130.0, 297.0, 38.0)];
    backgroundForUsername.image = [UIImage imageNamed:@"input_black_full_width"];
    [scrollView addSubview:backgroundForUsername];
    
    username = [[UITextField alloc] initWithFrame:CGRectMake(20, 140, 277, 38)];
    username.text = [sharedShop username];
    username.textAlignment = UITextAlignmentLeft;
    username.font = [UIFont boldSystemFontOfSize:14];
    username.adjustsFontSizeToFitWidth = YES;
    username.autocapitalizationType = UITextAutocapitalizationTypeNone;
    username.textColor = [UIColor whiteColor];
    username.returnKeyType = UIReturnKeyDone;
    [scrollView addSubview:username];
    
    //Input field for password
    UIImageView* backgroundForPassword = [[UIImageView alloc] initWithFrame:CGRectMake(11.0, 180.0, 297.0, 38.0)];
    backgroundForPassword.image = [UIImage imageNamed:@"input_black_full_width"];
    [scrollView addSubview:backgroundForPassword];
    
    password = [[UITextField alloc] initWithFrame:CGRectMake(20, 190, 277, 38)];
    password.text = [sharedShop password];
    password.textAlignment = UITextAlignmentLeft;
    password.font = [UIFont boldSystemFontOfSize:14];
    password.adjustsFontSizeToFitWidth = YES;
    password.secureTextEntry = TRUE;
    password.autocapitalizationType = UITextAutocapitalizationTypeNone;
    password.textColor = [UIColor whiteColor];
    password.returnKeyType = UIReturnKeyDone;
    [scrollView addSubview:password];
    
    //Switch for saving password
    UILabel* labelForSwitch = [[UILabel alloc] initWithFrame:CGRectMake(11.0, 240.0, 150.0, 30.0)];
    labelForSwitch.backgroundColor = [UIColor clearColor];
    labelForSwitch.font = [UIFont boldSystemFontOfSize:14];
    labelForSwitch.text = @"Wachtwoord opslaan";
    labelForSwitch.textColor = [UIColor whiteColor];
    labelForSwitch.shadowColor = [UIColor blackColor];
    labelForSwitch.shadowOffset = CGSizeMake(1, 1);
    [scrollView addSubview:labelForSwitch];
    
    passwordSwitch = [[UISwitch alloc] initWithFrame:CGRectMake(230.0, 240.0, 50.0, 30.0)];
    if([sharedShop password] == NULL || [[sharedShop password] isEqualToString:@""]) {
        passwordSwitch.on = NO;
    } else {
        passwordSwitch.on = YES;
    }
    [scrollView addSubview:passwordSwitch];
    
    // Make cancel button
    UIButton *cancelButton = [UIButton buttonWithType:UIButtonTypeCustom];
    cancelButton.frame = CGRectMake(11.0, 360.0, 145.0, 43.0);
    [cancelButton setTitle:@"Verwijderen" forState:UIControlStateNormal];
    [cancelButton setFont:[UIFont boldSystemFontOfSize:14]];
    cancelButton.backgroundColor = [UIColor clearColor];
    [cancelButton setTitleColor:[UIColor colorWithRed:42.0/255.0 green:43.0/255.0 blue:53.0/255.0 alpha:1] forState:UIControlStateNormal ];
    cancelButton.titleLabel.shadowColor = [UIColor whiteColor];
    cancelButton.titleLabel.shadowOffset = CGSizeMake(0, 0);
    
    UIImage *buttonImageNormal = [UIImage imageNamed:@"button_half_grey.png"];
    [cancelButton setBackgroundImage:buttonImageNormal forState:UIControlStateNormal];
    
    [cancelButton addTarget:self action:@selector(deleteButtonTouched) forControlEvents:UIControlEventTouchUpInside];
    
    [scrollView addSubview:cancelButton];
    
    //Make Save button
    UIButton *addShopButton = [UIButton buttonWithType:UIButtonTypeCustom];
    addShopButton.frame = CGRectMake(165.0, 360.0, 145.0, 43.0);
    [addShopButton setTitle:@"Opslaan" forState:UIControlStateNormal];
    [addShopButton setFont:[UIFont boldSystemFontOfSize:14]];
    addShopButton.backgroundColor = [UIColor clearColor];
    [addShopButton setTitleColor:[UIColor colorWithRed:42.0/255.0 green:43.0/255.0 blue:53.0/255.0 alpha:1.0] forState:UIControlStateNormal ];
    addShopButton.titleLabel.shadowColor = [UIColor whiteColor];
    addShopButton.titleLabel.shadowOffset = CGSizeMake(0, 0);
    
    UIImage *addShopButtonImageNormal = [UIImage imageNamed:@"button_half_grey.png"];
    [addShopButton setBackgroundImage:addShopButtonImageNormal forState:UIControlStateNormal];
    
    [addShopButton addTarget:self action:@selector(saveWebshop) forControlEvents:UIControlEventTouchUpInside];
    
    [scrollView addSubview:addShopButton];
    
}

//Make alert
-(void)makeAlert:(NSString*)alertTitle message:(NSString*)alertMessage button:(NSString *)buttonTitle
{
    if([buttonTitle isEqualToString:@"Verwijderen"])
    {
        BlockAlertView *alert = [BlockAlertView
                                 alertWithTitle:alertTitle
                                 message:alertMessage];
        
        [alert setCancelButtonWithTitle:@"Ok" block:^{
        }];
        
        [alert setDestructiveButtonWithTitle:buttonTitle block:^{
            [self deleteShop];
        }];
        
        [alert show];
    }
    else {
        
        BlockAlertView *alert = [BlockAlertView
                                 alertWithTitle:alertTitle
                                 message:alertMessage];
        
        [alert setCancelButtonWithTitle:@"Ok" block:^{
        }];
        
        [alert addButtonWithTitle:buttonTitle block:^{
        }];
        
        [alert show];
    }
    
}

//Function for validating url
- (BOOL)validateUrl:(NSString *)candidate {
    NSString *urlRegEx =
    @"((www)*|([0-9]*)|([-|_])*)+([\\.|/]((\\w)*|([0-9]*)|([-|_])*))+";
    NSPredicate *urlTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", urlRegEx];
    return [urlTest evaluateWithObject:candidate];
}

//Functie die ervoor zorgt dat de gegevens van de webshop worden opgeslagen
- (void)saveWebshop
{
    //Query opzetten om webshop met username op te halen
    NSString *findQuery = [[NSString alloc] initWithFormat:@"url == '%@'", shopUrl.text];
    Webshop *findShop = [Webshop where:findQuery].first;
    
    //Checken of velden gevuld zijn
    if([shopName.text isEqualToString:@""] || shopName.text == nil){
        alertTitle = @"Geen naam";
        message = @"U dient een naam op te geven voor uw webshop";
        empty = TRUE;
        [self makeAlert:alertTitle message:message button:@"Ok"];
    } else if (![self validateUrl:shopUrl.text]){
        alertTitle = @"Onjuiste URL";
        message = @"U dient een correcte url op te geven voor uw webshop. Bijvoorbeeld www.uwdomein.nl";
        empty = TRUE;
        [self makeAlert:alertTitle message:message button:@"Ok"];
    } else if ([username.text isEqualToString:@""] || username.text == nil){
        alertTitle = @"Geen gebruikersnaam";
        message = @"U dient een username op te geven voor uw webshop";
        empty = TRUE;
        [self makeAlert:alertTitle message:message button:@"Ok"];
    } else {
        empty = FALSE;
    }
    
    //Als er geen webshops bestaan met dezelfde gegevens als opgegeven dan gegevens opslaan
    if(empty == FALSE)
    {
        findShop.name = shopName.text;
        findShop.url = shopUrl.text;
        
        //Als de switch op save password staat dan password ook opslaan
        if(passwordSwitch.on)
        {
            findShop.password = password.text;
        } else {
            findShop.password = @"";
        }
        
        findShop.username = username.text;
        
        //Als de webshop is opgeslagen terug gaan naar de main view
        if(findShop.save)
        {
            NSLog(@"shop gesaved");
            [self backButtonTouched];
        }
    }
}

-(void)deleteButtonTouched
{
    NSLog(@"Delete shop touched");
    [self makeAlert:@"Webshop verwijderen" message:@"Weet u zeker dat u deze webshop uit de applicatie wilt verwijderen?" button:@"Verwijderen"];
}

-(void)deleteShop
{
    //Query opzetten om webshop met username op te halen
    NSString *findQuery = [[NSString alloc] initWithFormat:@"url == '%@'", [sharedShop shopUrl]];
    Webshop *findShop = [Webshop where:findQuery].first;
    [findShop delete];
    [self backButtonTouched];
}

@end
