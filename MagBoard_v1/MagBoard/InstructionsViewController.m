//
//  InstructionsViewController.m
//  MagBoard
//
//  Created by Dennis de Jong on 25-09-12.
//  Copyright (c) 2012 Dennis de Jong. All rights reserved.
//

#import "InstructionsViewController.h"

@interface InstructionsViewController ()

@end

@implementation InstructionsViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	
    // Set text for navigationbar
    self.navigationItem.title=@"Instructies";
    [[self view] setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"linnen_bg@2x.png"]]];
    scrollMove = 320;
    [self addScrollView];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

//Deze functie voegt een UIScrollView toe aan de instructies pagina
-(void)addScrollView
{
    instructionsHolder = [[UIScrollView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, 320.0f, 440.0f)];
    [instructionsHolder setContentSize:CGSizeMake(1920, 320)];
    instructionsHolder.showsHorizontalScrollIndicator = YES;
    instructionsHolder.pagingEnabled = YES;
    
    [self.view addSubview:instructionsHolder];
    [self readMagboardInstructions];
}


- (IBAction)goToNextInstruction:(id)sender{
    [instructionsHolder setContentOffset:CGPointMake(scrollMove, 0) animated:YES];
    scrollMove=scrollMove+320;
    
}

- (IBAction)goToPreviousInstruction:(id)sender{
    [instructionsHolder setContentOffset:CGPointMake(scrollMove, 0) animated:YES];
    scrollMove=scrollMove-320;
}

- (void)readMagboardInstructions{
    
    //Loading the plist and sorting the Dictionary.
    NSString *path = [[NSBundle mainBundle] bundlePath];
    NSString *finalPath = [path stringByAppendingPathComponent:@"MagboardInstructions.plist"];
    NSDictionary *dict = [[NSDictionary alloc] initWithContentsOfFile:finalPath];
    NSArray *sortedArray = [[dict allKeys] sortedArrayUsingSelector:@selector(caseInsensitiveCompare:)];
    
    //First defining the values of the dictionaries within the dicationary
    //Then count how much dictionaries
    //If dictionary id is same as i then echo the content and put it in the right position of the scrollview
    for(NSString *key in sortedArray) {
        NSDictionary *tempDict = [dict objectForKey:key];
		NSString *title = [tempDict valueForKey:@"title"];
        NSString *text = [tempDict valueForKey:@"text"];
        NSString *image = [tempDict valueForKey:@"image"];
        NSString *shopId = [tempDict valueForKey:@"id"];
        
        int shopIdInt = [shopId intValue];
        for(int i = 0; i < [dict count] + 1; i++){
            
            if(shopIdInt == i){
                int xPos = 320;
                int xPosDoubler = i - 1;
                UILabel *head = [[UILabel alloc] initWithFrame:CGRectMake((xPos * xPosDoubler) + 20, 20.0f, 280.0f, 20.0f)];
                [head setText:title];
                [head setFont:[UIFont boldSystemFontOfSize:16.0f]];
                [head setTextColor:[UIColor whiteColor]];
                [head setBackgroundColor:[UIColor clearColor]];
                [instructionsHolder addSubview:head];
                
                UILabel *textLabel = [[UILabel alloc] initWithFrame:CGRectMake((xPos * xPosDoubler) + 20, 50.0f, 280.0f, 100.0f)];
                [textLabel setText:text];
                [textLabel setFont:[UIFont systemFontOfSize:13.0f]];
                [textLabel setNumberOfLines:0];
                [textLabel setTextColor:[UIColor whiteColor]];
                [textLabel setBackgroundColor:[UIColor clearColor]];
                [instructionsHolder addSubview:textLabel];
                
                UIImageView *imageForStep = [[UIImageView alloc] initWithFrame:CGRectMake((xPos * xPosDoubler) + 20, 150.0f, 250.0f, 200.0f)];
                [imageForStep setImage:[UIImage imageNamed:image]];
                [instructionsHolder addSubview:imageForStep];
                
                /* Next button, but doesn't work properly
                 UIButton *nextButton = [[UIButton alloc] initWithFrame:CGRectMake((xPos * xPosDoubler) + 20, 280.0f, 50.0f, 50.0f)];
                 [nextButton setBackgroundColor:[UIColor yellowColor]];
                 [nextButton setTitle:@"Volgende" forState:UIControlStateNormal];
                 [nextButton addTarget:self
                 action:@selector(goToNextInstruction:)
                 forControlEvents:UIControlEventTouchUpInside];
                 [instructionsHolder addSubview:nextButton]; */
            }
            
        }
        
    }
}
@end
