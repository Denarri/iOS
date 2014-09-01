//
//  Denarri iOS App
//
//  Created by Andrew Ghobrial and Chris Meseha on 03/01/14.
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
    // Add new item to MatchCenter with the criteria from the matching userCategory instance, plus the search term
    
    [PFCloud callFunctionInBackground:@"addToMatchCenter"
                       withParameters:@{
                                        @"searchTerm": self.itemSearch,
                                        @"categoryId": self.matchingCategoryId1,
                                        @"minPrice": self.matchingCategoryMinPrice1,
                                        @"maxPrice": self.matchingCategoryMaxPrice1,
                                        @"itemCondition": self.matchingCategoryCondition1,
                                        @"itemLocation": self.matchingCategoryLocation1
                                        }
                                block:^(NSString *result, NSError *error) {
                                    
                                    if (!error) {
                                        NSLog(@"'%@'", result);
                                    }
                                }];
    
    [self.tabBarController setSelectedIndex:1];
    //[self performSegueWithIdentifier:@"UserCategoryChooserToMatchCenterSegue" sender:nil];

    
}

- (IBAction)category2ButtonClick:(id)sender

{
    self.chosenCategory = self.matchingCategoryId2;
    
    
    
    // Add new item to MatchCenter Array with the criteria from the matching userCategory instance, plus the search term
    [PFCloud callFunctionInBackground:@"addToMatchCenter"
                       withParameters:@{
                                        @"searchTerm": self.itemSearch,
                                        @"categoryId": self.matchingCategoryId2,
                                        @"minPrice": self.matchingCategoryMinPrice2,
                                        @"maxPrice": self.matchingCategoryMaxPrice2,
                                        @"itemCondition": self.matchingCategoryCondition2,
                                        @"itemLocation": self.matchingCategoryLocation2,
                                        }
                                block:^(NSString *result, NSError *error) {
                                    
                                    if (!error) {
                                        NSLog(@"'%@'", result);
                                    }
                                }];
    
    
    [self.tabBarController setSelectedIndex:1];
    //[self performSegueWithIdentifier:@"UserCategoryChooserToMatchCenterSegue" sender:nil];
    
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
