//
//  Denarri iOS App
//
//  Created by Andrew Ghobrial.
//  Copyright (c) 2014 Denarri. All rights reserved.
//

#import "UserCategoryChooserViewController.h"

@interface UserCategoryChooserViewController ()

@end

@implementation UserCategoryChooserViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.navigationItem.title = @"Categories";
    
    UIButton *category1 = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    category1.frame = CGRectMake(10, 120, 300, 35);
    [category1 setTitle: [NSString stringWithFormat:@"%@", self.matchingCategoryName1] forState:UIControlStateNormal];
    [category1 addTarget:self action:@selector(category1ButtonClick:)    forControlEvents:UIControlEventTouchUpInside];
    category1.tag = 1;
    [self.view addSubview: category1];
    
    
    UIButton *category2 = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    category2.frame = CGRectMake(10, 180, 300, 35);
    [category2 setTitle: [NSString stringWithFormat:@"%@", self.matchingCategoryName2] forState:UIControlStateNormal];
    [category2 addTarget:self action:@selector(category2ButtonClick:)    forControlEvents:UIControlEventTouchUpInside];
    category1.tag = 2;
    [self.view addSubview: category2];
    
}

- (IBAction)category1ButtonClick:(id)sender

{
    UINavigationController *navVC = (UINavigationController *)[self.tabBarController viewControllers][1];
    MatchCenterViewController *matchCenter = (MatchCenterViewController *)navVC.topViewController;
    
//    UIViewController *toViewController = [self.tabBarController viewControllers][1];
        
    if ([matchCenter isKindOfClass:[MatchCenterViewController class]]) {
        MatchCenterViewController *matchViewController = (MatchCenterViewController *)matchCenter;
        
        matchViewController.didAddNewItem = YES;
        
        // Send over the matching item criteria
        matchViewController.itemSearch = self.itemSearch;
        matchViewController.matchingCategoryId = self.matchingCategoryId1;
        matchViewController.matchingCategoryMinPrice = self.matchingCategoryMinPrice1;
        matchViewController.matchingCategoryMaxPrice = self.matchingCategoryMaxPrice1;
        matchViewController.matchingCategoryCondition = self.matchingCategoryCondition1;
        matchViewController.matchingCategoryLocation = self.itemLocation;
        matchViewController.itemPriority = self.itemPriority;
        
        NSLog(@"alright they're set, time to switch");
    }
    [self.tabBarController setSelectedIndex:1];
    
}

- (IBAction)category2ButtonClick:(id)sender

{
    UINavigationController *navVC = (UINavigationController *)[self.tabBarController viewControllers][1];
    MatchCenterViewController *matchCenter = (MatchCenterViewController *)navVC.topViewController;
    
    //    UIViewController *toViewController = [self.tabBarController viewControllers][1];
    
    if ([matchCenter isKindOfClass:[MatchCenterViewController class]]) {
        MatchCenterViewController *matchViewController = (MatchCenterViewController *)matchCenter;
        
        matchViewController.didAddNewItem = YES;
        
        // Send over the matching item criteria
        matchViewController.itemSearch = self.itemSearch;
        matchViewController.matchingCategoryId = self.matchingCategoryId2;
        matchViewController.matchingCategoryMinPrice = self.matchingCategoryMinPrice2;
        matchViewController.matchingCategoryMaxPrice = self.matchingCategoryMaxPrice2;
        matchViewController.matchingCategoryCondition = self.matchingCategoryCondition2;
        matchViewController.matchingCategoryLocation = self.itemLocation;
        matchViewController.itemPriority = self.itemPriority;
        
        NSLog(@"alright they're set, time to switch");
    }
    [self.tabBarController setSelectedIndex:1];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
