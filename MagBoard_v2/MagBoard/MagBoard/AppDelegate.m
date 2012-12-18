//
//  AppDelegate.m
//  MagBoard
//
//  Created by Dennis de Jong on 31-10-12.
//  Copyright (c) 2012 Dennis de Jong. All rights reserved.
//

#import "AppDelegate.h"
#import "AllWebshopsVC.h"

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    // Override point for customization after application launch.
    self.window.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"linnen_bg.png"]];
    
    //Initialize first screen and navigationcontroller
    AllWebshopsVC *shopsOverview = [[AllWebshopsVC alloc] init];
	UINavigationController *localNavigation = [[UINavigationController alloc] initWithRootViewController:shopsOverview];
	[[localNavigation navigationBar] setNeedsDisplay];
	self.navController = localNavigation;
    
    //Set custom colors for navigationbar
    [self.navController setValue:[[CustomNavBar alloc]init] forKeyPath:@"navigationBar"];
    
    [self.window addSubview:self.navController.view];
    [self.window makeKeyAndVisible];
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    NSLog(@"WILL RESIGN ACTIVE");
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    [[CoreDataManager instance] saveContextRecord];
    NSLog(@"DID ENTER BACKGROUND");
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    NSLog(@"DID ENTER FOREGROUND");
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    NSLog(@"DID BECOME ACTIVE");
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Saves changes in the application's managed object context before the application terminates.
    NSLog(@"EXITING");
    [[CoreDataManager instance] saveContextRecord];
}


@end
