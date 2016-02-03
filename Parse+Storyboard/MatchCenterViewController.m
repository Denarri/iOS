//
//  Denarri iOS App
//
//  Created by Andrew Ghobrial.
//  Copyright (c) 2014 Denarri. All rights reserved.
//

#import "MatchCenterViewController.h"
#import <UIKit/UIKit.h>
#import "MatchCenterCell.h"
#import "EmptyTableViewCell.h"


@interface MatchCenterViewController () <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) UITableView *matchCenter;
@property (nonatomic, assign) BOOL matchCenterDone;
@property (nonatomic, assign) BOOL visibleCell;

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
    
    _matchCenterDone = NO;
    
    // Swipe to delete initial stuff
    self.matchCenter.allowsMultipleSelectionDuringEditing = NO;
    
    // Set up MatchCenter table
    self.matchCenter = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewCellStyleSubtitle];
    self.matchCenter.frame = CGRectMake(0,63,self.view.frame.size.width,self.view.frame.size.height);
    self.edgesForExtendedLayout = UIRectEdgeAll;
    self.matchCenter.contentInset = UIEdgeInsetsMake(0.0f, 0.0f, CGRectGetHeight(self.tabBarController.tabBar.frame), 0.0f);
    _matchCenter.dataSource = self;
    _matchCenter.delegate = self;
    [self.view addSubview:self.matchCenter];
    
    _matchCenterData = [[NSArray alloc] init];
    
    
    // Pull to refresh
    UIRefreshControl *refreshControl = [[UIRefreshControl alloc] init];
    [refreshControl addTarget:self action:@selector(refresh:) forControlEvents:UIControlEventValueChanged];
    [self.matchCenter addSubview:refreshControl];
    
    
    // Preparing for MC and indicating loading
    self.matchCenterData = [[NSArray alloc] init];
    UIActivityIndicatorView *activityIndicator = [[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    activityIndicator.center = CGPointMake(self.view.frame.size.width / 2.0, self.view.frame.size.height / 2.0);
    [self.view addSubview: activityIndicator];
    [activityIndicator startAnimating];
    
    _matchCenterDone = NO;
    
    // Disable ability to scroll until table is MatchCenter table is done loading
    self.matchCenter.scrollEnabled = NO;
    _matchCenter.userInteractionEnabled = NO;
    
    [PFCloud callFunctionInBackground:@"MatchCenter3"
                       withParameters:@{}
                                block:^(NSArray *result, NSError *error) {
                                    
                                    if (!error) {
                                        _matchCenterData = result;
                                        
                                        [activityIndicator stopAnimating];
                                        
                                        [_matchCenter reloadData];
                                        
                                        _matchCenterDone = YES;
                                        _matchCenter.userInteractionEnabled = YES;
                                        self.matchCenter.scrollEnabled = YES;
                                        NSLog(@"Result: '%@'", result);
                                    }
                                }];
    
}

- (void)viewWillAppear:(BOOL)animated
{
    [self.navigationController setNavigationBarHidden:NO animated:YES];

    // Navbar Title
    CGRect frame = CGRectMake(0, 0, 100, 44);
    UILabel *label = [[UILabel alloc] initWithFrame:frame];
    label.backgroundColor = [UIColor clearColor];
    label.font = [UIFont systemFontOfSize:20.0];
    label.textAlignment = NSTextAlignmentCenter;
    label.textColor = [UIColor whiteColor];
    label.text = @"MatchCenter";
    self.navigationItem.titleView = label;
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemEdit target:self action:@selector(editButtonAction:)];

//    // Refreshing
//    UIImageView *refreshImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"refresh.png"]];
//    refreshImageView.frame = CGRectMake(280, 30, 30, 30);
//    refreshImageView.userInteractionEnabled = YES;
//    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(refreshPressed:)];
//    [refreshImageView addGestureRecognizer:tapGesture];
//    [self.view addSubview:refreshImageView];
}

- (IBAction)editButtonAction:(id)sender {
    [self performSegueWithIdentifier:@"CriteriaSettingsSegue" sender:self];
    NSLog(@"Edit button tapped");
}


// Pull to refresh
- (void)refresh:(UIRefreshControl *)refreshControl {
    
    _matchCenter.userInteractionEnabled = NO;
    
    NSLog(@"Refresh requested");
    self.matchCenterData = [[NSArray alloc] init];
    
    UIActivityIndicatorView *activityIndicator = [[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    activityIndicator.center = CGPointMake(self.view.frame.size.width / 2.0, self.view.frame.size.height / 2.0);
    [self.view addSubview: activityIndicator];
    [activityIndicator startAnimating];
    
    // Disable ability to scroll until table is MatchCenter table is done loading
    self.matchCenter.scrollEnabled = NO;
    _matchCenterDone = NO;
    
    [PFCloud callFunctionInBackground:@"MatchCenter3"
                       withParameters:@{}
                                block:^(NSArray *result, NSError *error) {
                                    
                                    if (!error) {
                                        _matchCenterData = result;
                                        
                                        [activityIndicator stopAnimating];
                                        
                                        [_matchCenter reloadData];
                                        
                                        _matchCenterDone = YES;
                                        _matchCenter.userInteractionEnabled = YES;
                                        self.matchCenter.scrollEnabled = YES;
                                        NSLog(@"Result: '%@'", result);
                                    }
                                }];
    
    // Do your job, when done:
    [refreshControl endRefreshing];
}

// Override to support conditional editing of the table view.
// This only needs to be implemented if you are going to be returning NO
// for some items. By default, all items are editable.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return YES if you want the specified item to be editable.
    return YES;
}

// Code that runs when user hits delete
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        //add code here for when you hit delete
        NSLog(@"Swipe to delete initiated!");
        
        // Show activity indicator
        UIActivityIndicatorView *activityIndicator = [[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
        activityIndicator.center = CGPointMake(self.view.frame.size.width / 2.0, self.view.frame.size.height / 2.0);
        [self.view addSubview: activityIndicator];
        [activityIndicator startAnimating];
        
        // Define the sections title
        NSString *sectionName = [[[[_matchCenterData  objectAtIndex:indexPath.section] objectForKey:@"Top 3"] objectAtIndex:0]objectForKey:@"Search Term"];
        
        _matchCenter.userInteractionEnabled = NO;
        // Run delete function with respective section header as parameter
        [PFCloud callFunctionInBackground:@"deleteFromMatchCenter"
                           withParameters: @{@"searchTerm": sectionName,}
                                    block:^(NSDictionary *result, NSError *error) {
                                        if (!error) {
                                            [NSThread sleepForTimeInterval: 1];
                                            [PFCloud callFunctionInBackground:@"MatchCenter3"
                                                               withParameters:@{}
                                                                        block:^(NSArray *result, NSError *error) {
                                                                            
                                                                            if (!error) {
                                                                                _matchCenterData = result;
                                                                                [activityIndicator stopAnimating];
                                                                                [_matchCenter reloadData];
                                                                                _matchCenter.userInteractionEnabled = YES;
                                                                                NSLog(@"Result: '%@'", result);
                                                                            }
                                                                        }];
                                            
                                        }
                                    }];
        
    }
}


- (void)viewDidAppear:(BOOL)animated
{
    if (self.didAddNewItem == NO) {
        NSLog(@"No item added, don't refresh!");
    }
    
    if (self.didAddNewItem == YES) {
        NSLog(@"New item added, refresh the MC");
        
        // Start loading indicator
        UIActivityIndicatorView *activityIndicator = [[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
        activityIndicator.center = CGPointMake(self.view.frame.size.width / 2.0, self.view.frame.size.height / 2.0);
        [self.view addSubview: activityIndicator];
        [activityIndicator startAnimating];
        
        // Disable ability to scroll until table is MatchCenter table is done loading
        self.matchCenter.scrollEnabled = NO;
        _matchCenterDone = NO;
        _matchCenter.userInteractionEnabled = NO;
        
        // Add new item to MatchCenter Array with the criteria from the matching userCategory instance, plus the search term
        [PFCloud callFunctionInBackground:@"addToMatchCenter"
                           withParameters:@{
                                            @"searchTerm": self.itemSearch,
                                            @"categoryId": self.matchingCategoryId,
                                            @"minPrice": self.matchingCategoryMinPrice,
                                            @"maxPrice": self.matchingCategoryMaxPrice,
                                            @"itemCondition": self.matchingCategoryCondition,
                                            @"itemLocation": self.matchingCategoryLocation,
                                            @"itemPriority": self.itemPriority,
                                            }
                                    block:^(NSString *result, NSError *error) {
                                        
                                        if (!error) {
                                            NSLog(@"'%@'", result);
                                            self.matchCenterData = [[NSArray alloc] init];
                                            
                                            [PFCloud callFunctionInBackground:@"MatchCenter3"
                                                               withParameters:@{}
                                                                        block:^(NSArray *result, NSError *error) {
                                                                            
                                                                            if (!error) {
                                                                                _matchCenterData = result;
                                                                                [_matchCenter reloadData];
                                                                                [activityIndicator stopAnimating];
                                                                                
                                                                                // Reenable scrolling/reset didAddNewItem bool
                                                                                _matchCenter.userInteractionEnabled = YES;
                                                                                _matchCenterDone = YES;
                                                                                self.matchCenter.scrollEnabled = YES;
                                                                                self.didAddNewItem = NO;
                                                                                NSLog(@"Result: '%@'", result);
                                                                            }
                                                                        }];
                                            
                                        }
                                    }];
        
        
    }
    else {
        NSLog(@"No refreshing required");
    }
    
    
    
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return _matchCenterData.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 0.0001f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.0001f;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    return nil;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    return nil;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}


// Cell layout
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    //load top 3 data
    NSDictionary *currentSectionDictionary = _matchCenterData[indexPath.section];
    NSArray *top3ArrayForSection = currentSectionDictionary[@"Top 3"];
    
    
    // if no results for that item
    if (top3ArrayForSection.count-1 < 1) {
        
        // Initialize cell
        static NSString *CellIdentifier = @"MatchCenterCell";
        EmptyTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        if (!cell) {
            // if no cell could be dequeued create a new one
            cell = [[EmptyTableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
        }
        
        // title of the item
        _searchTerm = [[[[_matchCenterData  objectAtIndex:indexPath.section] objectForKey:@"Top 3"] objectAtIndex:0]objectForKey:@"Search Term"];
        cell.textLabel.text = [NSString stringWithFormat:@"No results found for %@...yet!", _searchTerm];
        cell.textLabel.font = [UIFont systemFontOfSize:12];
        cell.textLabel.textColor = [UIColor whiteColor];
        cell.detailTextLabel.text = [NSString stringWithFormat:@""];
        cell.backgroundColor = [UIColor lightGrayColor];
        
        // Cell shadow
        cell.layer.shadowOpacity = 0.1;
        cell.layer.shadowRadius = 3;
        cell.layer.shadowColor = [UIColor blackColor].CGColor;
        cell.layer.shadowOffset = CGSizeMake(0.0, 4.0);

        return cell;
    }
    
    // if results for that item found
    else {
        
        // Cell Identifier
        static NSString *SecondCellIdentifier = @"SecondMatchCenterCell";
        MatchCenterCell *cell = [tableView dequeueReusableCellWithIdentifier:SecondCellIdentifier];
        if (!cell) {
            // if no cell could be dequeued create a new one
            cell = [[MatchCenterCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:SecondCellIdentifier];
        }
        
        
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        // Separator style
        tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        
        // title of the item
        _searchTerm = [[[[_matchCenterData  objectAtIndex:indexPath.section] objectForKey:@"Top 3"] objectAtIndex:0]objectForKey:@"Search Term"];
        cell.textLabel.text = _searchTerm;
        cell.textLabel.font = [UIFont systemFontOfSize:18];
        cell.textLabel.textColor = [UIColor whiteColor];
        cell.textLabel.shadowColor = [UIColor blackColor];
        cell.textLabel.shadowOffset = CGSizeMake(0.0, 0.0);
        cell.textLabel.layer.shadowRadius = 3.0;
        cell.textLabel.layer.shadowOpacity = 0.7;

        // Best price
        NSString *price = [NSString stringWithFormat:@"$%@", _matchCenterData[indexPath.section][@"Top 3"][indexPath.row+1][@"Price"]];
        cell.detailTextLabel.text = [NSString stringWithFormat:@"Best Price:%@", price];
        cell.detailTextLabel.textColor = [UIColor colorWithRed:0.51 green:0.90 blue:0.51 alpha:1.0];
        cell.detailTextLabel.shadowColor = [UIColor blackColor];
        cell.detailTextLabel.layer.shadowOffset = CGSizeMake(0.0, 2.0);
        cell.detailTextLabel.layer.shadowRadius = 3.0;
        cell.detailTextLabel.layer.shadowOpacity = 0.5;
        
        // Display placeholder while downloading images using background thread
        cell.backgroundColor = [UIColor lightGrayColor];
        cell.imageView.image = nil;
        
        // asynchronously download image
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^{
            
            // Load image data from URL
            NSData *imageData = [NSData dataWithContentsOfURL:[NSURL URLWithString:_matchCenterData[indexPath.section][@"Top 3"][indexPath.row+1][@"Image URL"]]];
            
            dispatch_async(dispatch_get_main_queue(), ^{
                // Setup Cell background imageView with blur
                UIImage *blurredImage=[[UIImage imageWithData:imageData] stackBlur:1];
                UIImageView *imageView = [[UIImageView alloc]initWithImage:blurredImage];
                imageView.contentMode = UIViewContentModeScaleAspectFill;
                imageView.clipsToBounds = YES;
                cell.backgroundView = imageView;
            });
            
        });
        
        // Cell shadow
        cell.layer.shadowOpacity = 0.05;
        cell.layer.shadowRadius = 3;
        cell.layer.shadowColor = [UIColor blackColor].CGColor;
        cell.layer.shadowOffset = CGSizeMake(0.0, 4.0);
        
        return cell;
    }
    
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 85;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    _searchTerm = [[[[_matchCenterData  objectAtIndex:indexPath.section] objectForKey:@"Top 3"] objectAtIndex:0]objectForKey:@"Search Term"];
    NSLog(@"The search term that was just selected: %@", _searchTerm);
    //Set _sectionSelected variable to the section index
    self.sectionSelected = indexPath.section;
    self.sectionSelectedSearchTerm = _searchTerm;
    
[self performSegueWithIdentifier:@"MCExpandedSegue" sender:self];
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



#pragma mark - Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"MCExpandedSegue"]){
        // Opens item in browser
        MCExpandedViewController *controller = (MCExpandedViewController *) segue.destinationViewController;
        controller.sectionSelected = self.sectionSelected;
        controller.sectionSelectedSearchTerm = self.sectionSelectedSearchTerm;
        NSLog(@"The search term we're sending over is: '%@", self.sectionSelectedSearchTerm);
    }
}



@end