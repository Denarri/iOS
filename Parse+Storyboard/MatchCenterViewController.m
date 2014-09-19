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
    self.matchCenter.frame = CGRectMake(0,50,320,self.view.frame.size.height-100);
    _matchCenter.dataSource = self;
    _matchCenter.delegate = self;
    [self.view addSubview:self.matchCenter];
    
    _matchCenterArray = [[NSArray alloc] init];
}

- (void)viewDidAppear:(BOOL)animated
{
    self.matchCenterArray = [[NSArray alloc] init];
    
    // Delay to allow MatchCenter item enough time to be added before pinging ebay
    [NSThread sleepForTimeInterval:2];
    
    [PFCloud callFunctionInBackground:@"MatchCenter"
                       withParameters:@{}
                                block:^(NSArray *result, NSError *error) {
                                    
                                    if (!error) {
                                        _matchCenterArray = result;
                                        [_matchCenter reloadData];
                                        
                                        NSLog(@"Result: '%@'", result);
                                    }
                                }];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return _matchCenterArray.count;
}

//the part where i setup sections and the deleting of said sections

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 21.0f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.01f;
}


- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 21)];
    headerView.backgroundColor = [UIColor lightGrayColor];
    
    _searchTerm = [[[[_matchCenterArray  objectAtIndex:section] objectForKey:@"Top 3"] objectAtIndex:3]objectForKey:@"Search Term"];
    
    UILabel *headerLabel = [[UILabel alloc] initWithFrame:CGRectMake(8, 0, 250, 21)];
    headerLabel.text = [NSString stringWithFormat:@"%@", _searchTerm];
    headerLabel.font = [UIFont boldSystemFontOfSize:[UIFont systemFontSize]];
    headerLabel.textColor = [UIColor whiteColor];
    headerLabel.backgroundColor = [UIColor lightGrayColor];
    [headerView addSubview:headerLabel];
    
    
    UIButton *deleteButton = [UIButton buttonWithType:UIButtonTypeCustom];
    deleteButton.tag = section;
    deleteButton.frame = CGRectMake(300, 2, 17, 17);
    [deleteButton setImage:[UIImage imageNamed:@"xbutton.png"] forState:UIControlStateNormal];
    [deleteButton addTarget:self action:@selector(deleteButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
    [headerView addSubview:deleteButton];
    return headerView;
    
}



- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 3;
}

//- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
//    NSArray *currentSectionArray = _matchCenterArray[section];
//    return currentSectionArray.count;
//}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Initialize cell
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (!cell) {
        // if no cell could be dequeued create a new one
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
    }
    
    // No cell seperators = clean design
    tableView.separatorColor = [UIColor clearColor];
    
    // title of the item
    cell.textLabel.text = _matchCenterArray[indexPath.section][@"Top 3"][indexPath.row][@"Title"];
    cell.textLabel.font = [UIFont boldSystemFontOfSize:14];
    
    // price of the item
    cell.detailTextLabel.text = [NSString stringWithFormat:@"$%@", _matchCenterArray[indexPath.section][@"Top 3"][indexPath.row][@"Price"]];
    cell.detailTextLabel.textColor = [UIColor colorWithRed:0/255.0f green:127/255.0f blue:31/255.0f alpha:1.0f];
    
    // image of the item
    NSData *imageData = [NSData dataWithContentsOfURL:[NSURL URLWithString:_matchCenterArray[indexPath.section][@"Top 3"][indexPath.row][@"Image URL"]]];
    [[cell imageView] setImage:[UIImage imageWithData:imageData]];
    
    return cell;
    
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 65;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    
    self.itemURL = _matchCenterArray[indexPath.section][@"Top 3"][indexPath.row][@"Item URL"];
    
    [self performSegueWithIdentifier:@"WebViewSegue" sender:self];
}


- (void)deleteButtonPressed:(id)sender
{
    // links button
    UIButton *deleteButton = (UIButton *)sender;
    
    // Define the sections title
    NSString *sectionName = _searchTerm = [[[[_matchCenterArray  objectAtIndex:deleteButton.tag] objectForKey:@"Top 3"] objectAtIndex:3]objectForKey:@"Search Term"];
    
    // Run delete function with respective section header as parameter
    [PFCloud callFunctionInBackground:@"deleteFromMatchCenter"
                       withParameters:
                      @{@"searchTerm": sectionName,}
                                block:^(NSDictionary *result, NSError *error) {
                                   if (!error) {
                                       [PFCloud callFunctionInBackground:@"MatchCenter"
                                                          withParameters:@{
                                                                           @"test": @"Hi",
                                                                           }
                                                                   block:^(NSArray *result, NSError *error) {
                                                                       
                                                                       if (!error) {
                                                                           _matchCenterArray = result;
                                                                           [_matchCenter reloadData];
                                                                           
                                                                           NSLog(@"Result: '%@'", result);
                                                                       }
                                                                   }];
   
                                   }
                                }];
}



- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



 #pragma mark - Navigation
 
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
 {
     WebViewController *controller = (WebViewController *) segue.destinationViewController;
     controller.itemURL = self.itemURL;
 }


@end