//
//  SearchTests.m
//  MagBoard
//
//  Created by Dennis de Jong on 16-12-12.
//  Copyright (c) 2012 Dennis de Jong. All rights reserved.
//

#import <GHUnitIOS/GHUnit.h>
#import "Helpers.h"
#import "OrdersVC.h"

@interface SearchTests : GHTestCase
{
    UISearchBar *searchBar;
    NSMutableDictionary *orderHolder;
    NSMutableArray *copyListOfOrders;
}
@end

@implementation SearchTests

- (BOOL)shouldRunOnMainThread
{
    // By default NO, but if you have a UI test or test dependent on running on the main thread return YES.
    // Also an async test that calls back on the main thread, you'll probably want to return YES.
    return NO;
}

- (void)setUpClass
{
    // Run at start of all tests in the class
}

- (void)tearDownClass
{
    // Run at end of all tests in the class
}

- (void)setUp
{
    // Run before each test method    
    searchBar = [[UISearchBar alloc] init];
    orderHolder = [[NSMutableDictionary alloc] init];
    [self setUpTestDict];
}

- (void)tearDown
{
    // Run after each test method
}

//Search logic
- (void) searchTableView
{
    NSString *searchText = searchBar.text;
    copyListOfOrders = [[NSMutableArray alloc] init];
    
    for (int i = 0; i < [[orderHolder objectForKey:@"data-items"] count]; i++) {
        
        for(int u = 0; u < [[[orderHolder objectForKey:@"data-items"] objectAtIndex:i] count]; u++){
            
            if(u != 0){
                
                //For searching on first- & lastname
                NSString *firstName = [[NSString alloc] initWithFormat:@"%@", [[[[orderHolder objectForKey:@"data-items"] objectAtIndex:i] objectAtIndex:u] objectForKey:@"firstname"]];
                NSString *lastName = [[NSString alloc] initWithFormat:@"%@", [[[[orderHolder objectForKey:@"data-items"] objectAtIndex:i] objectAtIndex:u] objectForKey:@"lastname"]];
                NSString *totalName = [[NSString alloc] initWithFormat:@"%@ %@", firstName, lastName];
                NSRange titleResultsRange = [totalName rangeOfString:searchText options:NSCaseInsensitiveSearch];
                
                //For searching on ordernumber
                NSString *orderNumber = [[NSString alloc] initWithFormat:@"%@", [[[[orderHolder objectForKey:@"data-items"] objectAtIndex:i] objectAtIndex:u] objectForKey:@"increment_id"]];
                NSRange orderNumberResultsRange = [orderNumber rangeOfString:searchText options:NSCaseInsensitiveSearch];
                
                if(titleResultsRange.length > 0 || orderNumberResultsRange.length > 0){
                    [copyListOfOrders addObject:[[[orderHolder objectForKey:@"data-items"] objectAtIndex:i] objectAtIndex:u]];
                }
                
            }
            
        }
        
    }
    
}

- (void)setUpTestDict
{
    NSMutableDictionary *dataItem1 = [[NSMutableDictionary alloc] init];
    [dataItem1 setValue:@"100000001" forKey:@"increment_id"];
    [dataItem1 setValue:@"Dennis" forKey:@"firstname"];
    [dataItem1 setValue:@"de Jong" forKey:@"lastname"];
    
    NSDictionary *dateDict = [[NSDictionary alloc] initWithObjectsAndKeys:@"12 december 2012", @"date", nil];
    
    NSMutableArray *array1 = [[NSMutableArray alloc] init];
    [array1 addObject:dateDict];
    [array1 addObject:dataItem1];
    
    NSMutableDictionary *dataItem2 = [[NSMutableDictionary alloc] init];
    [dataItem2 setValue:@"100000002" forKey:@"increment_id"];
    [dataItem2 setValue:@"Leo" forKey:@"firstname"];
    [dataItem2 setValue:@"Flapper" forKey:@"lastname"];
    
    NSMutableArray *array2 = [[NSMutableArray alloc] init];
    [array2 addObject:dateDict];
    [array2 addObject:dataItem2];
    
    NSMutableDictionary *dataItem3 = [[NSMutableDictionary alloc] init];
    [dataItem3 setValue:@"100000003" forKey:@"increment_id"];
    [dataItem3 setValue:@"Nathan" forKey:@"firstname"];
    [dataItem3 setValue:@"Jansen" forKey:@"lastname"];
    
    NSMutableArray *array3 = [[NSMutableArray alloc] init];
    [array3 addObject:dateDict];
    [array3 addObject:dataItem3];
    
    NSMutableArray*dataItems = [[NSMutableArray alloc] init];
    [dataItems addObject:array1];
    [dataItems addObject:array2];
    [dataItems addObject:array3];
    
    [orderHolder setValue:dataItems forKey:@"data-items"];
    [orderHolder setValue:@"1002" forKey:@"message"];
    [orderHolder setValue:@"d865b14289c0491f5e3d2d113969939e" forKey:@"session"];
}

- (void)testSearchForWordExists
{
    //Set up search word
    searchBar.text = @"Dennis";
    NSString *searchWord = searchBar.text;
    GHTestLog(@"There should be a result when searching with searchword: %@", searchWord);
    
    //Perform search
    [self searchTableView];
    
    //Set result & assertion
    int result = [copyListOfOrders count];
    int expectedResult = 1;
    GHTestLog(@"Aantal resultaten %d", result);
    
    GHAssertGreaterThanOrEqual(result, expectedResult,@"Expected searchresults are greater than 0");
    
}

- (void)testSearchForWordDoesntExist
{
    //Set up search word
    searchBar.text = @"Henk van der wal";
    NSString *searchWord = searchBar.text;
    GHTestLog(@"There should NOT be a result when searching with searchword: %@", searchWord);
    
    //Perform search
    [self searchTableView];
    
    //Set result & assertion
    int result = [copyListOfOrders count];
    int expectedResult = 0;
    GHTestLog(@"Aantal resultaten %d", result);
    
    GHAssertGreaterThanOrEqual(result, expectedResult,@"Expected searchresults are 0");
    
}

- (void)testSearchForOrderNumberExists
{
    //Set up search word
    searchBar.text = @"2";
    NSString *searchWord = searchBar.text;
    GHTestLog(@"There should be a result when searching with ordernumber: %@", searchWord);
    
    //Perform search
    [self searchTableView];
    
    //Set result & assertion
    int result = [copyListOfOrders count];
    int expectedResult = 1;
    GHTestLog(@"Aantal resultaten %d", result);
    
    GHAssertGreaterThanOrEqual(result, expectedResult,@"Expected searchresults are greater than 0");
    
}

- (void)testSearchForOrderNumberDoesntExist
{
    //Set up search word
    searchBar.text = @"999";
    NSString *searchWord = searchBar.text;
    GHTestLog(@"There should NOT be a result when searching with ordernumber: %@", searchWord);
    
    //Perform search
    [self searchTableView];
    
    //Set result & assertion
    int result = [copyListOfOrders count];
    int expectedResult = 0;
    GHTestLog(@"Aantal resultaten %d", result);
    
    GHAssertGreaterThanOrEqual(result, expectedResult,@"Expected searchresults are 0");
    
}

@end

