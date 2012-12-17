//
//  InfoVC.m
//  MagBoard
//
//  Created by Dennis de Jong on 01-10-12.
//  Copyright (c) 2012 Dennis de Jong. All rights reserved.
//

#import "InfoVC.h"

@interface InfoVC ()

@end

@implementation InfoVC

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

-(void)constructScrollView
{
    CGRect bounds = [[UIScreen mainScreen] bounds];
    UIScrollView *instructionsHolder = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, bounds.size.width, bounds.size.height)];
    [instructionsHolder setContentSize:CGSizeMake(320, 1200)];
    instructionsHolder.showsHorizontalScrollIndicator = YES;
    [instructionsHolder setBackgroundColor:[UIColor whiteColor]];
    [self.view addSubview:instructionsHolder];
    
    UILabel *head1 = [[UILabel alloc] initWithFrame:CGRectMake(20.0f, 20.0f, 280.0f, 20.0f)];
    [head1 setText:@"Stap 1"];
    [head1 setFont:[UIFont boldSystemFontOfSize:16.0f]];
    [instructionsHolder addSubview:head1];
    
    UILabel *text1 = [[UILabel alloc] initWithFrame:CGRectMake(20.0f, 60.0f, 280.0f, 80.0f)];
    [text1 setText:@"Created by alterplay. This library contains customizable interactive iOS UI controls, modal and popover windows, and scrollable lists.  This library was designed for iPad and iPhone fullscreen web applications."];
    [text1 setFont:[UIFont systemFontOfSize:13.0f]];
    [text1 setNumberOfLines:0];
    [instructionsHolder addSubview:text1];
    
    UIImageView *imageForStep1 = [[UIImageView alloc] initWithFrame:CGRectMake(20.0f, 160.0f, 280.0f, 200.0f)];
    [imageForStep1 setImage:[UIImage imageNamed:@"magento_4.jpg"]];
    [instructionsHolder addSubview:imageForStep1];
    
    UILabel *head2 = [[UILabel alloc] initWithFrame:CGRectMake(20.0f, 400.0f, 280.0f, 20.0f)];
    [head2 setText:@"Stap 2"];
    [head2 setFont:[UIFont boldSystemFontOfSize:16.0f]];
    [instructionsHolder addSubview:head2];
    
    UILabel *text2 = [[UILabel alloc] initWithFrame:CGRectMake(20.0f, 440.0f, 280.0f, 80.0f)];
    [text2 setText:@"Created by alterplay. This library contains customizable interactive iOS UI controls, modal and popover windows, and scrollable lists.  This library was designed for iPad and iPhone fullscreen web applications."];
    [text2 setFont:[UIFont systemFontOfSize:13.0f]];
    [text2 setNumberOfLines:0];
    [instructionsHolder addSubview:text2];
    
    UIImageView *imageForStep2 = [[UIImageView alloc] initWithFrame:CGRectMake(20.0f, 540.0f, 280.0f, 200.0f)];
    [imageForStep2 setImage:[UIImage imageNamed:@"magento_4.jpg"]];
    [instructionsHolder addSubview:imageForStep2];
    
    UILabel *head3 = [[UILabel alloc] initWithFrame:CGRectMake(20.0f, 780.0f, 280.0f, 20.0f)];
    [head3 setText:@"Stap 3"];
    [head3 setFont:[UIFont boldSystemFontOfSize:16.0f]];
    [instructionsHolder addSubview:head3];
    
    UILabel *text3 = [[UILabel alloc] initWithFrame:CGRectMake(20.0f, 820.0f, 280.0f, 80.0f)];
    [text3 setText:@"Created by alterplay. This library contains customizable interactive iOS UI controls, modal and popover windows, and scrollable lists.  This library was designed for iPad and iPhone fullscreen web applications."];
    [text3 setFont:[UIFont systemFontOfSize:13.0f]];
    [text3 setNumberOfLines:0];
    [instructionsHolder addSubview:text3];
    
    UIImageView *imageForStep3 = [[UIImageView alloc] initWithFrame:CGRectMake(20.0f, 920.0f, 280.0f, 200.0f)];
    [imageForStep3 setImage:[UIImage imageNamed:@"magento_4.jpg"]];
    [instructionsHolder addSubview:imageForStep3];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    self.title = @"Informatie";
    [self constructScrollView];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
