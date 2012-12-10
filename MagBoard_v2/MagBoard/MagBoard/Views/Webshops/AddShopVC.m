//
//  AddShopVC.m
//  MagBoard
//
//  Created by Dennis de Jong on 31-10-12.
//  Copyright (c) 2012 Dennis de Jong. All rights reserved.
//

#import "AddShopVC.h"
#import "AllWebshopsVC.h"

@interface AddShopVC ()

@end

@implementation AddShopVC

@synthesize shopName, shopUrl,username, password, passwordSwitch, message, alertTitle, empty, urlRegEx, urlTest;

- (void)viewDidLoad
{
    [super viewDidLoad];
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
    UILabel* navBarTitle = [CustomNavBar setNavBarTitle:@"Add webshop"];
    self.navigationItem.titleView = navBarTitle;
    self.navigationItem.leftBarButtonItem = [UIBarButtonItem styledBarButtonItemWithTarget:self selector:@selector(backButtonTouched) title:@"Back"];
}

-(void)backButtonTouched
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:@"editShop" forKey:@"referer"];
    [defaults setInteger:0 forKey:@"lastShop"];
    [defaults synchronize];
    
    NSMutableArray *viewControllers = [NSMutableArray arrayWithArray:[[self navigationController] viewControllers]];
    [viewControllers removeLastObject];
    [[self navigationController] setViewControllers:viewControllers animated:YES];
}

//Construct the form for adding webshop
-(void)makeForm
{
    //Make scroll holder for automatic input focus
    UIScrollView* scrollView = [[TPKeyboardAvoidingScrollView alloc] initWithFrame:CGRectMake(0, 0, 320.0, [constants getScreenHeight])];
    [self.view addSubview:scrollView];
    
    //Input field for shop name
    UIImageView* backgroundForName = [[UIImageView alloc] initWithFrame:CGRectMake(11.0, 30.0, 297.0, 38.0)];
    backgroundForName.image = [UIImage imageNamed:@"input_black_full_width"];
    [scrollView addSubview:backgroundForName];
    
    shopName = [[UITextField alloc] initWithFrame:CGRectMake(20, 40, 277, 38)];
    shopName.placeholder = @"Webshop name";  
    shopName.textAlignment = UITextAlignmentLeft;          
    shopName.font = [UIFont boldSystemFontOfSize:14]; 
    shopName.adjustsFontSizeToFitWidth = YES;
    shopName.textColor = [UIColor whiteColor];         
    shopName.returnKeyType = UIReturnKeyDone;
    shopName.delegate = self;
    [scrollView addSubview:shopName];
    
    //Input field for shop url
    UIImageView* backgroundForUrl = [[UIImageView alloc] initWithFrame:CGRectMake(11.0, 80.0, 297.0, 38.0)];
    backgroundForUrl.image = [UIImage imageNamed:@"input_black_full_width"];
    [scrollView addSubview:backgroundForUrl];
    
    shopUrl = [[UITextField alloc] initWithFrame:CGRectMake(20, 90, 277, 38)];
    shopUrl.placeholder = @"Webshop URL";
    shopUrl.textAlignment = UITextAlignmentLeft;
    shopUrl.font = [UIFont boldSystemFontOfSize:14];
    shopUrl.adjustsFontSizeToFitWidth = YES;
    shopUrl.autocapitalizationType = UITextAutocapitalizationTypeNone;
    shopUrl.textColor = [UIColor whiteColor];
    shopUrl.returnKeyType = UIReturnKeyDone;
    shopUrl.delegate = self;
    [scrollView addSubview:shopUrl];
    
    //Input field for username
    UIImageView* backgroundForUsername = [[UIImageView alloc] initWithFrame:CGRectMake(11.0, 130.0, 297.0, 38.0)];
    backgroundForUsername.image = [UIImage imageNamed:@"input_black_full_width"];
    [scrollView addSubview:backgroundForUsername];
    
    username = [[UITextField alloc] initWithFrame:CGRectMake(20, 140, 277, 38)];
    username.placeholder = @"Magento API username";
    username.textAlignment = UITextAlignmentLeft;
    username.font = [UIFont boldSystemFontOfSize:14];
    username.adjustsFontSizeToFitWidth = YES;
    username.autocapitalizationType = UITextAutocapitalizationTypeNone;
    username.textColor = [UIColor whiteColor];
    username.returnKeyType = UIReturnKeyDone;
    username.delegate = self;
    [scrollView addSubview:username];
    
    //Input field for password
    UIImageView* backgroundForPassword = [[UIImageView alloc] initWithFrame:CGRectMake(11.0, 180.0, 297.0, 38.0)];
    backgroundForPassword.image = [UIImage imageNamed:@"input_black_full_width"];
    [scrollView addSubview:backgroundForPassword];
    
    password = [[UITextField alloc] initWithFrame:CGRectMake(20, 190, 277, 38)];
    password.placeholder = @"Magento API password";
    password.textAlignment = UITextAlignmentLeft;
    password.font = [UIFont boldSystemFontOfSize:14];
    password.adjustsFontSizeToFitWidth = YES;
    password.secureTextEntry = TRUE;
    password.autocapitalizationType = UITextAutocapitalizationTypeNone;
    password.textColor = [UIColor whiteColor];
    password.returnKeyType = UIReturnKeyDone;
    password.delegate = self;
    [scrollView addSubview:password];
    
    //Switch for saving password
    UILabel* labelForSwitch = [[UILabel alloc] initWithFrame:CGRectMake(11.0, 240.0, 170.0, 30.0)];
    labelForSwitch.backgroundColor = [UIColor clearColor];
    labelForSwitch.font = [UIFont boldSystemFontOfSize:14];
    labelForSwitch.text = @"Save password";
    labelForSwitch.textColor = [UIColor whiteColor];
    labelForSwitch.shadowColor = [UIColor blackColor];
    labelForSwitch.shadowOffset = CGSizeMake(1, 1);
    [scrollView addSubview:labelForSwitch];
    
    passwordSwitch = [[UISwitch alloc] initWithFrame:CGRectMake(230.0, 240.0, 50.0, 30.0)];
    passwordSwitch.on = YES;
    [scrollView addSubview:passwordSwitch];
    
    // Make cancel button
    UIButton *cancelButton = [UIButton buttonWithType:UIButtonTypeCustom];
    cancelButton.frame = CGRectMake(11.0, [constants getScreenHeight] - 120, 145.0, 43.0);
    [cancelButton setTitle:@"Cancel" forState:UIControlStateNormal];
    [cancelButton setFont:[UIFont boldSystemFontOfSize:14]];
    cancelButton.backgroundColor = [UIColor clearColor];
    [cancelButton setTitleColor:[UIColor colorWithRed:42.0/255.0 green:43.0/255.0 blue:53.0/255.0 alpha:1] forState:UIControlStateNormal ];
    cancelButton.titleLabel.shadowColor = [UIColor whiteColor];
    cancelButton.titleLabel.shadowOffset = CGSizeMake(0, 0);
    
    UIImage *buttonImageNormal = [UIImage imageNamed:@"button_half_grey.png"];
    [cancelButton setBackgroundImage:buttonImageNormal forState:UIControlStateNormal];
    
    [cancelButton addTarget:self action:@selector(backButtonTouched) forControlEvents:UIControlEventTouchUpInside];
    
    [scrollView addSubview:cancelButton];
    
    //Make Save button
    UIButton *addShopButton = [UIButton buttonWithType:UIButtonTypeCustom];
    addShopButton.frame = CGRectMake(165.0, [constants getScreenHeight] - 120, 145.0, 43.0);
    [addShopButton setTitle:@"Save" forState:UIControlStateNormal];
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
    
    BlockAlertView *alert = [BlockAlertView
                             alertWithTitle:alertTitle
                             message:alertMessage];
    
    [alert setCancelButtonWithTitle:@"Ok" block:^{
    }];
    
    [alert show];
}

//Check which button is clicked
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    
}

//Function for validating url
- (BOOL)validateUrl:(NSString *)givenUrl {
    
    if ([givenUrl rangeOfString:@"http"].location != NSNotFound) {
        urlRegEx =
        @"(http|https)://((\\w)*|([0-9]*)|([-|_])*)+([\\.|/]((\\w)*|([0-9]*)|([-|_])*))+";
        urlTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", urlRegEx];
    } else {
        urlRegEx =
        @"((www)*|([0-9]*)|([-|_])*)+([\\.|/]((\\w)*|([0-9]*)|([-|_])*))+";
        urlTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", urlRegEx];
    }
    
    return [urlTest evaluateWithObject:givenUrl];
}

//Functie die ervoor zorgt dat de gegevens van de webshop worden opgeslagen
- (void)saveWebshop
{
    //Query opzetten om webshop met username op te halen
    NSString *findQuery = [[NSString alloc] initWithFormat:@"url == '%@'", shopUrl.text];
    Webshop *findShop = [Webshop where:findQuery].first;
    
    //Checken of velden gevuld zijn
    if([shopName.text isEqualToString:@""] || shopName.text == nil){
        alertTitle = @"No name";
        message = @"Please enter a name for your webshop";
        empty = TRUE;
        [self makeAlert:alertTitle message:message button:@"Ok"];
    } else if (![self validateUrl:shopUrl.text]){
        alertTitle = @"Incorrect URL";
        message = @"Please enter a correct URL, for example www.yourwebshop.com";
        empty = TRUE;
        [self makeAlert:alertTitle message:message button:@"Ok"];
    } else if ([username.text isEqualToString:@""] || username.text == nil){
        alertTitle = @"No gebruikersnaam";
        message = @"Please enter a username for your webshop";
        empty = TRUE;
        [self makeAlert:alertTitle message:message button:@"Ok"];
    } else if (findShop != nil){
        alertTitle = @"Duplicated account";
        message = @"MagBoard already found an account for this webshop. Please enter a different URL or visit the existing webshop.";
        empty = TRUE;
        [self makeAlert:alertTitle message:message button:@"Ok"];
    } else {
        empty = FALSE;
    }
    
    //Als er geen webshops bestaan met dezelfde gegevens als opgegeven dan gegevens opslaan
    if(empty == FALSE)
    {
        Webshop *webshop = [Webshop create];
        webshop.name = shopName.text;
        webshop.url = shopUrl.text;
        
        //Als de switch op save password staat dan password ook opslaan
        if(passwordSwitch.on)
        {
            webshop.password = password.text;
        }
        webshop.username = username.text;
        
        //Als de webshop is opgeslagen terug gaan naar de main view
        if(webshop.save)
        {
            NSLog(@"shop gesaved");
            [self backToHome];
        }
    }
}

-(void)backToHome
{
    
    NSMutableArray *viewControllers = [NSMutableArray arrayWithArray:[[self navigationController] viewControllers]];
    [viewControllers removeAllObjects];
    [[self  navigationController] popToRootViewControllerAnimated:YES];
    
}

//For hiding keyboard when done is tapped
- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
}

@end
