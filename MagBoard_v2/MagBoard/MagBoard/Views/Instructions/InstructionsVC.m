//
//  InstructionsVC.m
//  MagBoard
//
//  Created by Dennis de Jong on 31-10-12.
//  Copyright (c) 2012 Dennis de Jong. All rights reserved.
//

#import "InstructionsVC.h"
#import "AddShopVC.h"

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
    int lastInstruction = [dict count];
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
                
                UITextView *textLabel = [[UITextView alloc] initWithFrame:CGRectMake((xPos * xPosDoubler) + 20, 50.0f, 280.0f, 150.0f)];
                textLabel.userInteractionEnabled = NO;
                [textLabel setText:text];
                [textLabel setFont:[UIFont systemFontOfSize:13.0f]];
                [textLabel setTextColor:[UIColor whiteColor]];
                [textLabel setBackgroundColor:[UIColor clearColor]];
                [instructionsScroller addSubview:textLabel];
                
                UIImageView *imageForStep = [[UIImageView alloc] initWithFrame:CGRectMake((xPos * xPosDoubler) + 40, 150.0f, 250.0f, 200.0f)];
                [imageForStep setImage:[UIImage imageNamed:image]];
                [instructionsScroller addSubview:imageForStep];
                
                NSLog(@"%d", i);
                if(i == lastInstruction){
                    UIButton *addShopButton = [UIButton buttonWithType:UIButtonTypeCustom];
                    addShopButton.frame = CGRectMake((xPos * xPosDoubler) + 20, 200.0, 290.0, 43.0);
                    [addShopButton setTitle:@"Voeg een webshop toe" forState:UIControlStateNormal];
                    [addShopButton.titleLabel setFont:[UIFont boldSystemFontOfSize:14]];
                    addShopButton.backgroundColor = [UIColor clearColor];
                    [addShopButton setTitleColor:[UIColor colorWithRed:42.0/255.0 green:43.0/255.0 blue:53.0/255.0 alpha:1.0] forState:UIControlStateNormal ];
                    addShopButton.titleLabel.shadowColor = [UIColor whiteColor];
                    addShopButton.titleLabel.shadowOffset = CGSizeMake(0, 0);
                    
                    UIImage *addShopButtonImageNormal = [UIImage imageNamed:@"button_full_width_grey.png"];
                    [addShopButton setBackgroundImage:addShopButtonImageNormal forState:UIControlStateNormal];
                    
                    [addShopButton addTarget:self action:@selector(goToAddShop) forControlEvents:UIControlEventTouchUpInside];
                    
                    [instructionsScroller addSubview:addShopButton];
                }
                
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

-(void)goToAddShop
{
    NSLog(@"Go to add shop");
    NSMutableArray *viewControllers = [NSMutableArray arrayWithArray:[[self navigationController] viewControllers]];
    [viewControllers removeLastObject];
    AddShopVC *addShopView = [[AddShopVC alloc]init];
    [[self  navigationController] pushViewController:addShopView animated:YES];
}
@end
