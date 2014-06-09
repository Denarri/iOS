//
//  Denarri iOS App
//
//  Created by Andrew Ghobrial and Chris Meseha on 03/01/14.
//  Copyright (c) 2014 Denarri. All rights reserved.
//

#import "MatchCenterViewController.h"
#import <UIKit/UIKit.h>

@interface MatchCenterViewController () <UITableViewDataSource, UITableViewDelegate>
@property (nonatomic, strong) UITableView *matchCenter;
@end

@implementation MatchCenterViewController



- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
//        self.matchCenter = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
//        _matchCenter.dataSource = self;
//        _matchCenter.delegate = self;
//        [self.view addSubview:self.matchCenter];
    }
    return self;
    
    
    
}









- (void)viewDidLoad
{

    [super viewDidLoad];
    
    

    self.matchCenter = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
    self.matchCenter.frame = CGRectMake(0,50,320,self.view.frame.size.height-200);
    _matchCenter.dataSource = self;
    _matchCenter.delegate = self;
    [self.view addSubview:self.matchCenter];
    
    self.matchCenterArray = [[NSArray alloc] init];
    

    
}

- (void)viewDidAppear:(BOOL)animated
{
    
    self.matchCenterArray = [[NSArray alloc] init];
    
    [PFCloud callFunctionInBackground:@"MatchCenterTest"
                       withParameters:@{
                                        @"test": @"Hi",
                                        }
                                block:^(NSDictionary *result, NSError *error) {
                                    
                                    if (!error) {
                                         self.matchCenterArray = [result objectForKey:@"Top 3"];
                                        
                                        
                                        dispatch_async(dispatch_get_main_queue(), ^{
                                            [_matchCenter reloadData];
                                        });
                                        
                                        
                                        NSLog(@"Test Result: '%@'", result);
                                    }
                                }];
    
    [self.matchCenter registerClass:[UITableViewCell class] forCellReuseIdentifier:@"Cell"];


}




- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
     return [self.matchCenterArray count];
}



- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    
    NSDictionary *matchCenterDictionary= [self.matchCenterArray objectAtIndex:indexPath.row];
    
    cell.textLabel.text = [matchCenterDictionary objectForKey:@"Title"];// title of the first object
    
    cell.detailTextLabel.text = [matchCenterDictionary objectForKey:@"Price"];
    
    return cell;
    
    
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
