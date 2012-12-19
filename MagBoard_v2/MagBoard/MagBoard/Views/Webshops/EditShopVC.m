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

@synthesize shopName, shopUrl,username, password, passwordSwitch, message, setAlertTitle, empty, sharedShop, editShop, urlRegEx, urlTest, apiResponse;

- (void)viewDidLoad
{
    [super viewDidLoad];
    //Get shop data
    sharedShop = [ShopSingleton shopSingleton];
    
	// Do any additional setup after loading the view.
    [self constructHeader];
    [self makeForm];
    
    //Query opzetten om webshop met username op te halen
    NSString *findQuery = [[NSString alloc] initWithFormat:@"url == '%@'", shopUrl.text];
    editShop = [Webshop where:findQuery].first;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)constructHeader
{
    UILabel* navBarTitle = [CustomNavBar setNavBarTitle:@"Edit webshop"];
    self.navigationItem.titleView = navBarTitle;
    self.navigationItem.leftBarButtonItem = [UIBarButtonItem styledBarButtonItemWithTarget:self selector:@selector(backButtonTouched) title:@"Back"];
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
    UIScrollView* scrollView = [[TPKeyboardAvoidingScrollView alloc] initWithFrame:CGRectMake(0, 0, 320.0, [constants getScreenHeight])];
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
    shopName.delegate = self;
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
    shopUrl.delegate = self;
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
    username.delegate = self;
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
    if([sharedShop password] == NULL || [[sharedShop password] isEqualToString:@""]) {
        passwordSwitch.on = NO;
    } else {
        passwordSwitch.on = YES;
    }
    [scrollView addSubview:passwordSwitch];
    
    // Make cancel button
    UIButton *cancelButton = [UIButton buttonWithType:UIButtonTypeCustom];
    cancelButton.frame = CGRectMake(11.0, [constants getScreenHeight] - 120, 145.0, 43.0);
    [cancelButton setTitle:@"Delete" forState:UIControlStateNormal];
    cancelButton.titleLabel.font = [UIFont boldSystemFontOfSize:14];
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
    addShopButton.frame = CGRectMake(165.0, [constants getScreenHeight] - 120, 145.0, 43.0);
    [addShopButton setTitle:@"Save" forState:UIControlStateNormal];
    addShopButton.titleLabel.font = [UIFont boldSystemFontOfSize:14];
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
    if([buttonTitle isEqualToString:@"Delete"])
    {
        BlockAlertView *alert = [BlockAlertView
                                 alertWithTitle:alertTitle
                                 message:alertMessage];
        
        [alert setCancelButtonWithTitle:@"Cancel" block:^{
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
    //Checken of velden gevuld zijn
    //Checken of velden gevuld zijn
    if([shopName.text isEqualToString:@""] || shopName.text == nil){
        setAlertTitle = @"No name";
        message = @"Please enter a name for your webshop";
        empty = TRUE;
        [self makeAlert:setAlertTitle message:message button:@"Ok"];
    } else if (![self validateUrl:shopUrl.text]){
        setAlertTitle = @"Incorrect URL";
        message = @"Please enter a correct URL, for example www.yourwebshop.com";
        empty = TRUE;
        [self makeAlert:setAlertTitle message:message button:@"Ok"];
    } else if ([username.text isEqualToString:@""] || username.text == nil){
        setAlertTitle = @"No gebruikersnaam";
        message = @"Please enter a username for your webshop";
        empty = TRUE;
        [self makeAlert:setAlertTitle message:message button:@"Ok"];
    }  else {
        empty = FALSE;
    }
    
    //Als er geen webshops bestaan met dezelfde gegevens als opgegeven dan gegevens opslaan
    if(empty == FALSE)
    {
        editShop.name = shopName.text;
        editShop.url = shopUrl.text;
        editShop.username = username.text;
        
        //Als de switch op save password staat dan password ook opslaan
        if(passwordSwitch.on)
        {
            editShop.password = password.text;
        } else {
            editShop.password = @"";
        }
        
        //Als de webshop is opgeslagen terug gaan naar de main view
        if(editShop.save)
        {
            NSLog(@"shop gesaved");
            [self updateOrders];
            
            //If url is changed, get new thumbnail
            if(![shopUrl.text isEqualToString:[sharedShop shopUrl]]){
                NSLog(@"Shop URL changed");
                [self updateThumbnail];
            }
            [self backButtonTouched];
        }
    }
}

-(void)deleteButtonTouched
{
    NSLog(@"Delete shop touched");
    [self makeAlert:@"Delete webshop" message:@"Are you sure you want to remove this account from MagBoard?" button:@"Delete"];
}

-(void)deleteShop
{
    //Query opzetten om webshop met username op te halen
    NSString *findQuery = [[NSString alloc] initWithFormat:@"url == '%@'", [sharedShop shopUrl]];
    Webshop *findShop = [Webshop where:findQuery].first;
    
    //Delete shop from core data
    [findShop delete];
    
    //Set new referer
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    int oldId = [[defaults objectForKey:@"lastShop"] integerValue];
    int newId;
    if(oldId != 0){
        newId = oldId - 1;
    } else {
        newId = oldId;
    }
    [defaults setInteger:newId forKey:@"lastShop"];
    [defaults synchronize];
    
    //Return to home screen
    [self deleteThumbnail];
    [self backButtonTouched];
}

//For hiding keyboard when done is tapped
- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return 0;
}



-(void)updateOrders
{
    NSLog(@"Update orders with:%@,%@, %@, ", shopUrl.text, username.text, password.text);
    
    [self loginRequest:shopUrl.text magUsername:username.text magPassword:password.text  magRequestFunction:@"salesOrderList" magRequestParams:nil magUpdate:YES];
    
}
// Actions for getting, updating or deleting the thumbnail
-(void)updateThumbnail
{
    //Delete old thumbnail
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSString *docDir = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    NSString *oldPngFilePath = [NSString stringWithFormat:@"%@/%@.png",docDir, [sharedShop shopUrl]];
    NSLog(@"Old PNG: %@", oldPngFilePath);
    if ([fileManager fileExistsAtPath:oldPngFilePath]){
        [self deleteThumbnail];
    }
    
    //Look for new Thumbnail
    NSLog(@"Getting thumbnail from Magento Shop:%@,%@, %@, ", shopUrl.text, username.text, password.text);
    [self thumbnailRequest:shopUrl.text magUsername:username.text magPassword:password.text  magRequestFunction:@"webshopWebthumbThumburl"];
    
}

-(void)deleteThumbnail
{
    NSString *docDir = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    NSString *pngFilePath = [NSString stringWithFormat:@"%@/%@.png",docDir, [sharedShop shopUrl]];
    NSFileManager *fileManager = [NSFileManager defaultManager];
    [fileManager removeItemAtPath:pngFilePath error:NULL];
}

-(void)saveThumbnail
{
    NSLog(@"Saving thumbnail:%@", [apiResponse valueForKey:@"data-items"]);
    NSString *docDir = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    NSString *imageUrl = [[NSString alloc]initWithFormat:@"%@", [apiResponse valueForKey:@"data-items"]];
    NSData *imageData = [[NSData alloc] initWithContentsOfURL: [NSURL URLWithString: imageUrl]];
    
    NSString *pngFilePath = [NSString stringWithFormat:@"%@/%@.png",docDir, shopUrl.text];
    NSData *imageFile = [NSData dataWithData:UIImagePNGRepresentation([UIImage imageWithData:imageData])];
    [imageFile writeToFile:pngFilePath atomically:YES];
}

-(void)thumbnailRequest:(NSString *)magShopUrl magUsername:(NSString *)magUsername magPassword:(NSString *)magPassword magRequestFunction:(NSString *)magRequestFunction
{
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    [params setObject:magShopUrl forKey:@"url"];
    [params setObject:magUsername forKey:@"username"];
    [params setObject:magPassword forKey:@"password"];
    [params setObject:magRequestFunction forKey:@"requestFunction"];
    
    
    [[LRResty client] post:[constants apiUrl] payload:params delegate:self];
}

//Make request for logging in en fetching orders
-(void)loginRequest:(NSString *)magShopUrl magUsername:(NSString *)magUsername magPassword:(NSString *)magPassword magRequestFunction:(NSString *)magRequestFunction magRequestParams:(NSString *)magRequestParams magUpdate:(bool)magUpdate
{
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    [params setObject:magShopUrl forKey:@"url"];
    [params setObject:magUsername forKey:@"username"];
    [params setObject:magPassword forKey:@"password"];
    [params setObject:magRequestFunction forKey:@"requestFunction"];
    if(magRequestParams){
        [params setObject:magRequestParams forKey:@"requestParams"];
    }
    if(magUpdate == YES){
        [params setObject:@"1" forKey:@"update"];
    } else if(magUpdate == NO) {
        [params setObject:@"0" forKey:@"update"];
    }
    
    [[LRResty client] post:[constants apiUrl] payload:params delegate:self];
}
//Catch response for request
- (void)restClient:(LRRestyClient *)client receivedResponse:(LRRestyResponse *)response;
{
    // do something with the response
    if(response.status == 200) {
        
        apiResponse = [NSJSONSerialization JSONObjectWithData:[response responseData] options:kNilOptions error:nil];
        NSLog(@"%@", [apiResponse valueForKey:@"message"]);
        if([[apiResponse valueForKey:@"message"]isEqualToString:@"1001"]){
            NSLog(@"Shop orders have been added to the cache.");
        } else if([[apiResponse valueForKey:@"message"]isEqualToString:@"1006"]) {
            [self saveThumbnail];
        } else {
            NSLog(@"Shop orders have not been cached error: %@", [apiResponse valueForKey:@"status"]);
        }
    }
    
}
@end
