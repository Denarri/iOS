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


    //perform search with criteria just submitted
    [PFCloud callFunctionInBackground:@"MatchCenterTest"
                       withParameters:@{
                                        @"test": @"Hi",
                                        }
                                block:^(NSString *result, NSError *error) {
                                    
                                    if (!error) {
                                        NSLog(@"Test Result: '%@'", result);
                                    }
                                }];


}

- (void)viewDidAppear:(BOOL)animated
{

    
    [PFCloud callFunctionInBackground:@"MatchCenterTest"
                       withParameters:@{
                                        @"test": @"Hi",
                                        }
                                block:^(NSString *result, NSError *error) {
                                    
                                    if (!error) {
                                        NSLog(@"Test Result: '%@'", result);
                                    }
                                }];



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
