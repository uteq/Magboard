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
    UILabel* navBarTitle = [CustomNavBar setNavBarTitle:@"Instructions"];
    self.navigationItem.titleView = navBarTitle;
    self.navigationItem.leftBarButtonItem = [UIBarButtonItem styledBarButtonItemWithTarget:self selector:@selector(backButtonTouched) title:@"Back"];
}

//Draw dots for scroller
-(void)shopsControlDots
{
    pageControl = [[UIPageControl alloc] initWithFrame:CGRectMake(20.0f, [constants getScreenHeight] - 103, 280.0f, 40.0f)];
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
    instructionsScroller = [[UIScrollView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, 320.0f, [constants getScreenHeight] - 40)];
    [instructionsScroller setContentSize:CGSizeMake(1920, 320)];
    instructionsScroller.showsHorizontalScrollIndicator = YES;
    instructionsScroller.delegate = self;
    instructionsScroller.pagingEnabled = YES;
    
    [self.view addSubview:instructionsScroller];
    [self readMagboardInstructions];
}

//Read contents of plist file with instructions
- (void)readMagboardInstructions{

    for(int i = 0; i < 7; i++){
        
        int xPos = 320;
        int xPosDoubler = i - 1;
        
        NSString *image = [[NSString alloc] initWithFormat:@"instr_%d", i];
        
        UIImageView *imageForStep = [[UIImageView alloc] initWithFrame:CGRectMake((xPos * xPosDoubler) + 10, 10.0f, 300.0f, 369.0f)];
        [imageForStep setImage:[UIImage imageNamed:image]];
        [instructionsScroller addSubview:imageForStep];
        
        NSLog(@"%d", i);
        if(i == 6){
            
            UIButton *addShopButton = [UIButton buttonWithType:UIButtonTypeCustom];
            addShopButton.frame = CGRectMake((xPos * xPosDoubler) + 10, 336.0, 300.0, 43.0);
            [addShopButton setTitle:@"Add webshop" forState:UIControlStateNormal];
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
