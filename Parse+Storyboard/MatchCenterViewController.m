//
//  Denarri iOS App
//
//  Created by Andrew Ghobrial and Chris Meseha on 03/01/14.
//  Copyright (c) 2014 Denarri. All rights reserved.
//

#import "MatchCenterViewController.h"

@interface MatchCenterViewController ()

@end

@implementation MatchCenterViewController




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
