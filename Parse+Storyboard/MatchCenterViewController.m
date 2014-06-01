//
//  Denarri iOS App
//
//  Created by Andrew Ghobrial and Chris Meseha on 03/01/14.
//  Copyright (c) 2014 Denarri. All rights reserved.
//

#import "MatchCenterViewController.h"
#import <UIKit/UIKit.h>

@interface MatchCenterViewController () <UITableViewDataSource, UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UITableView *matchCenter;
@end

@implementation MatchCenterViewController

{
    NSArray *tableData;
}

//- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [tableData count];
}
//- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    
//}


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

    tableData = [NSArray arrayWithObjects:@"Egg Benedict", @"Mushroom Risotto", @"Full Breakfast", @"Hamburger", @"Ham and Egg Sandwich", @"Creme Brelee", @"White Chocolate Donut", @"Starbucks Coffee", @"Vegetable Curry", @"Instant Noodle with Egg", @"Noodle with BBQ Pork", @"Japanese Noodle with Pork", @"Green Tea", @"Thai Shrimp Cake", @"Angry Birds Cake", @"Ham and Cheese Panini", nil];
    
    //self.tableView.dataSource = self;
    //self.tableView.delegate = self;e

    
    //perform search with criteria just submitted
//    [PFCloud callFunctionInBackground:@"eBayMatchCenterSearch"
//                       withParameters:@{@"item": self.itemSearch.text,
//                                        @"minPrice": self.minPrice.text,
//                                        @"maxPrice": self.maxPrice.text,
//                                        @"itemCondition": self.itemCondition,
//                                        @"itemLocation": self.itemLocation,}
//                                block:^(NSString *result, NSError *error) {
//                                    
//                                    if (!error) {
//                                        NSLog(@"The result is '%@'", result);
//                                        
//                                        if ([result intValue] == 1) {
//                                            [self performSegueWithIdentifier:@"ShowMatchCenterSegue" sender:self];
//                                        } else {
//                                            [self performSegueWithIdentifier:@"ShowCriteriaSegue" sender:self];
//                                        }
//                                        
//                                    }
//                                }];
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
