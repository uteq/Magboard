//
//  InstructionsVC.m
//  MagBoard
//
//  Created by Dennis de Jong on 31-10-12.
//  Copyright (c) 2012 Dennis de Jong. All rights reserved.
//

#import "InstructionsVC.h"

@interface InstructionsVC ()

@end

@implementation InstructionsVC

@synthesize pageControl, scrollerAtIndex, instructionsScroller;

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    [self constructHeader];
    [self shopsControlDots];
    [self addScrollView];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)constructHeader
{
    UILabel* navBarTitle = [CustomNavBar setNavBarTitle:@"Instructies"];
    self.navigationItem.titleView = navBarTitle;
    self.navigationItem.leftBarButtonItem = [UIBarButtonItem styledBarButtonItemWithTarget:self selector:@selector(backButtonTouched) title:@"Terug"];
}

//Draw dots for scroller
-(void)shopsControlDots
{
    pageControl = [[UIPageControl alloc] initWithFrame:CGRectMake(20.0f, 370.0f, 280.0f, 40.0f)];
    [pageControl setNumberOfPages:6];
    [pageControl setCurrentPage:0];
    [pageControl setBackgroundColor:[UIColor clearColor]];
    [self.view addSubview:pageControl];
}

//Change dots for scroller
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    int newOffset = scrollView.contentOffset.x;
    scrollerAtIndex = (int)(newOffset/(scrollView.frame.size.width));
    [pageControl setCurrentPage:scrollerAtIndex];
    NSLog(@"scroll changed to %d", scrollerAtIndex);
}

-(void)backButtonTouched
{
    NSMutableArray *viewControllers = [NSMutableArray arrayWithArray:[[self navigationController] viewControllers]];
    [viewControllers removeLastObject];
    [[self navigationController] setViewControllers:viewControllers animated:YES];
}

//Deze functie voegt een UIScrollView toe aan de instructies pagina
-(void)addScrollView
{
    instructionsScroller = [[UIScrollView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, 320.0f, 440.0f)];
    [instructionsScroller setContentSize:CGSizeMake(1920, 320)];
    instructionsScroller.showsHorizontalScrollIndicator = YES;
    instructionsScroller.delegate = self;
    instructionsScroller.pagingEnabled = YES;
    
    [self.view addSubview:instructionsScroller];
    [self readMagboardInstructions];
}

//Read contents of plist file with instructions
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
                [instructionsScroller addSubview:head];
                
                UILabel *textLabel = [[UILabel alloc] initWithFrame:CGRectMake((xPos * xPosDoubler) + 20, 50.0f, 280.0f, 100.0f)];
                [textLabel setText:text];
                [textLabel setFont:[UIFont systemFontOfSize:13.0f]];
                [textLabel setNumberOfLines:0];
                [textLabel setTextColor:[UIColor whiteColor]];
                [textLabel setBackgroundColor:[UIColor clearColor]];
                [instructionsScroller addSubview:textLabel];
                
                UIImageView *imageForStep = [[UIImageView alloc] initWithFrame:CGRectMake((xPos * xPosDoubler) + 20, 150.0f, 250.0f, 200.0f)];
                [imageForStep setImage:[UIImage imageNamed:image]];
                [instructionsScroller addSubview:imageForStep];
                
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
