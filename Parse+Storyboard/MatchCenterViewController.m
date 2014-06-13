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
    }
    return self;
}


- (void)viewDidLoad
{
    [super viewDidLoad];

    self.matchCenter = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewCellStyleSubtitle];
    self.matchCenter.frame = CGRectMake(0,50,320,self.view.frame.size.height-200);
    _matchCenter.dataSource = self;
    _matchCenter.delegate = self;
    [self.view addSubview:self.matchCenter];
    
    self.matchCenterArray = [[NSArray alloc] init];
}

- (void)viewDidAppear:(BOOL)animated
{
    self.matchCenterArray = [[NSArray alloc] init];
    
    [PFCloud callFunctionInBackground:@"MatchCenter"
                       withParameters:@{
                                        @"test": @"Hi",
                                        }
                                block:^(NSDictionary *result, NSError *error) {
                                    
                                    if (!error) {
                                        self.matchCenterArray = [result objectForKey:@"Top 3"];
                                        [_matchCenter reloadData];
                                        
                                        NSLog(@"Test Result: '%@'", result);
                                    }
                                }];
}




- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}




//the part where i setup sections and the deleting of said sections

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 21.0f;
}



- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 21)];
    headerView.backgroundColor = [UIColor lightGrayColor];
    
    _searchTerm = [[self.matchCenterArray firstObject] objectForKey:@"Search Term"];
    
    UILabel *headerLabel = [[UILabel alloc] initWithFrame:CGRectMake(8, 0, 250, 21)];
//    headerLabel.text = [NSString stringWithFormat:@"%@", searchTerm];
//    headerLabel.font = [UIFont boldSystemFontOfSize:[UIFont systemFontSize]];
//    headerLabel.textColor = [UIColor whiteColor];
    headerLabel.backgroundColor = [UIColor lightGrayColor];
    [headerView addSubview:headerLabel];
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.tag = section + 1000;
    button.frame = CGRectMake(300, 2, 17, 17);
    [button setImage:[UIImage imageNamed:@"xbutton.png"] forState:UIControlStateNormal];
    [button addTarget:self action:@selector(deleteButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
    [headerView addSubview:button];
    return headerView;
}



- (IBAction)deleteButtonPressed:(UIButton *)sender {
    
    NSLog(@"Search Term: '%@'", _searchTerm);
    
    [PFCloud callFunctionInBackground:@"deleteFromMatchCenter"
                       withParameters:@{
                                        @"searchTerm": _searchTerm,
                                       }
                                block:^(NSDictionary *result, NSError *error) {
                                    
                                    if (!error) {
                                        NSLog(@"Result: '%@'", result);
                                    }
                                }];
    
    
//    NSInteger section = sender.tag - 1000;
//    [self.objects removeObjectAtIndex:section];
//    [self.tableView deleteSections:[NSIndexSet indexSetWithIndex:section] withRowAnimation:UITableViewRowAnimationAutomatic];
//    
//    // reload sections to get the new titles and tags
//    NSInteger sectionCount = [self.objects count];
//    NSIndexSet *indexes = [NSMutableIndexSet indexSetWithIndexesInRange:NSMakeRange(0, sectionCount)];
//    [self.tableView reloadSections:indexes withRowAnimation:UITableViewRowAnimationNone];
}




- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
     return [self.matchCenterArray count];
}



- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Initialize cell
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (!cell) {
        // if no cell could be dequeued create a new one
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
    }
    
    // populate dictionary with results
    NSDictionary *matchCenterDictionary= [self.matchCenterArray objectAtIndex:indexPath.row];
    
    // title of the item
    cell.textLabel.text = [matchCenterDictionary objectForKey:@"Title"];
    cell.textLabel.font = [UIFont boldSystemFontOfSize:12];

    // price of the item
    cell.detailTextLabel.text = [NSString stringWithFormat:@"$%@", [matchCenterDictionary objectForKey:@"Price"]];
    cell.detailTextLabel.textColor = [UIColor colorWithRed:0/255.0f green:127/255.0f blue:31/255.0f alpha:1.0f];

    // image of the item
    NSData *imageData = [NSData dataWithContentsOfURL:[NSURL URLWithString:[matchCenterDictionary objectForKey:@"Image URL"]]];
    [[cell imageView] setImage:[UIImage imageWithData:imageData]];
    //imageView.frame = CGRectMake(45.0,10.0,10,10);
    
    return cell;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


/*
#pragma mark - Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
