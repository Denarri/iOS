//
//  CustomTabBarViewController.m
//  Parse+Storyboard
//
//  Created by Andrew Ghobrial on 8/28/14.
//  Copyright (c) 2014 Juan Figuera. All rights reserved.
//

#import "CustomTabBar.h"

@interface CustomTabBar ()

@end

@implementation CustomTabBar

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
    // Do any additional setup after loading the view.
    
    UITabBar *tabBar = self.tabBar;
    UITabBarItem *tabBarItem1 = [tabBar.items objectAtIndex:0];
    UITabBarItem *tabBarItem2 = [tabBar.items objectAtIndex:1];
    
    tabBarItem1.title = @"Buy";
    tabBarItem2.title = @"MatchCenter";
    
    
    UITabBarItem *item1 = [tabBar.items objectAtIndex:0];
    UITabBarItem *item2 = [tabBar.items objectAtIndex:1];
    
    
    [item1 setImage:[[UIImage imageNamed:@"Search.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
    [item1 setSelectedImage:[[UIImage imageNamed:@"Search.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
    
    [item2 setImage:[[UIImage imageNamed:@"MatchCenter.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
    [item2 setSelectedImage:[[UIImage imageNamed:@"MatchCenter.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
    

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
