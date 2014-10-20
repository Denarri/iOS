//
//  Denarri iOS App
//
//  Created by Andrew Ghobrial.
//  Copyright (c) 2014 Denarri. All rights reserved.
//

#import "MatchCenterViewController.h"
#import <UIKit/UIKit.h>

@interface MatchCenterViewController () <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) UITableView *matchCenter;
@property (nonatomic, assign) BOOL matchCenterDone;
@property (nonatomic, assign) BOOL hasPressedShowMoreButton;

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
    _hasPressedShowMoreButton = NO;
    
    // Set up MatchCenter table
    self.matchCenter = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewCellStyleSubtitle];
    self.matchCenter.frame = CGRectMake(0,70,320,self.view.frame.size.height-100);
    self.edgesForExtendedLayout = UIRectEdgeAll;
    self.matchCenter.contentInset = UIEdgeInsetsMake(0.0f, 0.0f, CGRectGetHeight(self.tabBarController.tabBar.frame), 0.0f);
    _matchCenter.dataSource = self;
    _matchCenter.delegate = self;
    [self.view addSubview:self.matchCenter];
    
    self.expandedSection = -1;
    
    _matchCenterArray = [[NSArray alloc] init];
    
    // Refresh button
    UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"refresh.png"]];
    imageView.frame = CGRectMake(275, 25, 30, 30);
    imageView.userInteractionEnabled = YES;
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(refreshPressed:)];
    [imageView addGestureRecognizer:tapGesture];
    [self.view addSubview:imageView];
    
    // Preparing for MC and indicating loading
    self.matchCenterArray = [[NSArray alloc] init];
    
    UIActivityIndicatorView *activityIndicator = [[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    activityIndicator.center = CGPointMake(self.view.frame.size.width / 2.0, self.view.frame.size.height / 2.0);
    [self.view addSubview: activityIndicator];
    
    [activityIndicator startAnimating];
    
    _matchCenterDone = NO;
    
    // Disable ability to scroll until table is MatchCenter table is done loading
    self.matchCenter.scrollEnabled = NO;
    
    [PFCloud callFunctionInBackground:@"MatchCenter3"
                       withParameters:@{}
                                block:^(NSArray *result, NSError *error) {
                                    
                                    if (!error) {
                                        _matchCenterArray = result;
                                        
                                        [activityIndicator stopAnimating];
                                        
                                        [_matchCenter reloadData];
                                        
                                        _matchCenterDone = YES;
                                        self.matchCenter.scrollEnabled = YES;
                                        NSLog(@"Result: '%@'", result);
                                    }
                                }];
  
}

- (void)refreshPressed:(id)sender
{
    NSLog(@"OOOH BOY THAT TICKLEz");
    
    self.matchCenterArray = [[NSArray alloc] init];
    
    UIActivityIndicatorView *activityIndicator = [[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    activityIndicator.center = CGPointMake(self.view.frame.size.width / 2.0, self.view.frame.size.height / 2.0);
    [self.view addSubview: activityIndicator];
    
    [activityIndicator startAnimating];
    
    _matchCenterDone = NO;
    
    // Disable ability to scroll until table is MatchCenter table is done loading
    self.matchCenter.scrollEnabled = NO;
    
    [PFCloud callFunctionInBackground:@"MatchCenter3"
                       withParameters:@{}
                                block:^(NSArray *result, NSError *error) {
                                    
                                    if (!error) {
                                        _matchCenterArray = result;
                                        
                                        [activityIndicator stopAnimating];
                                        
                                        [_matchCenter reloadData];
                                        
                                        _matchCenterDone = YES;
                                        self.matchCenter.scrollEnabled = YES;
                                        NSLog(@"Result: '%@'", result);
                                    }
                                }];

}

- (void)viewDidAppear:(BOOL)animated
{
    if (self.didAddNewItem == YES) {
        NSLog(@"well then lets refresh the MC");
        
        // Start loading indicator
        UIActivityIndicatorView *activityIndicator = [[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
        activityIndicator.center = CGPointMake(self.view.frame.size.width / 2.0, self.view.frame.size.height / 2.0);
        [self.view addSubview: activityIndicator];
        [activityIndicator startAnimating];
        
        // Disable ability to scroll until table is MatchCenter table is done loading
        self.matchCenter.scrollEnabled = NO;
        _matchCenterDone = NO;
        
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
                                            self.matchCenterArray = [[NSArray alloc] init];
                                            
                                            [PFCloud callFunctionInBackground:@"MatchCenter3"
                                                               withParameters:@{}
                                                                        block:^(NSArray *result, NSError *error) {
                                                                            
                                                                            if (!error) {
                                                                                _matchCenterArray = result;
                                                                                [_matchCenter reloadData];
                                                                                [activityIndicator stopAnimating];
                                                                                
                                                                                // Reenable scrolling/reset didAddNewItem bool
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
    return _matchCenterArray.count;
}

//the part where i setup sections and the deleting of said sections

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 21.0f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 40;
}


- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    UIView *view = [[UIView alloc] initWithFrame:CGRectZero];
    view.backgroundColor = [UIColor whiteColor];
    
    MoreButton *moreButton = [MoreButton buttonWithType:UIButtonTypeCustom];
    moreButton.frame = CGRectMake(0, 0, 320, 35);
    moreButton.sectionIndex = section;
    [moreButton setImage:[UIImage imageNamed:@"downarrow.png"] forState:UIControlStateNormal];
    [moreButton addTarget:self action:@selector(moreButtonSelected:) forControlEvents:UIControlEventTouchUpInside];
    [view addSubview:moreButton];
    
    return view;
}


- (void)moreButtonSelected:(MoreButton *)button {
    self.expandedSection = button.sectionIndex;
    [self.matchCenter reloadData];
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 21)];
    headerView.backgroundColor = [UIColor lightGrayColor];
    
    
    _searchTerm = [[[[_matchCenterArray  objectAtIndex:section] objectForKey:@"Top 3"] objectAtIndex:0]objectForKey:@"Search Term"];
    
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
    NSDictionary *currentSectionDictionary = _matchCenterArray[section];
    NSArray *top3ArrayForSection = currentSectionDictionary[@"Top 3"];
    
    return (top3ArrayForSection.count-1 < 1) ? 1 : top3ArrayForSection.count-1;
}


// Cell layout
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
    
    NSDictionary *currentSectionDictionary = _matchCenterArray[indexPath.section];
    NSArray *top3ArrayForSection = currentSectionDictionary[@"Top 3"];
    
    if (top3ArrayForSection.count-1 < 1) {
        
        // title of the item
        cell.textLabel.text = @"No items found, but we'll keep a lookout for you!";
        cell.textLabel.font = [UIFont boldSystemFontOfSize:12];
        
        // price of the item
        cell.detailTextLabel.text = @"";
        
        // image of the item
        NSData *imageData = [NSData dataWithContentsOfURL:[NSURL URLWithString:@""]];
        [[cell imageView] setImage:[UIImage imageWithData:imageData]];

    }
    
    else {
        
        // title of the item
        cell.textLabel.text = _matchCenterArray[indexPath.section][@"Top 3"][indexPath.row+1][@"Title"];
        cell.textLabel.font = [UIFont boldSystemFontOfSize:14];
        
        // price of the item
        cell.detailTextLabel.text = [NSString stringWithFormat:@"$%@", _matchCenterArray[indexPath.section][@"Top 3"][indexPath.row+1][@"Price"]];
        cell.detailTextLabel.textColor = [UIColor colorWithRed:0/255.0f green:127/255.0f blue:31/255.0f alpha:1.0f];
        
        // image of the item
        NSData *imageData = [NSData dataWithContentsOfURL:[NSURL URLWithString:_matchCenterArray[indexPath.section][@"Top 3"][indexPath.row+1][@"Image URL"]]];
        [[cell imageView] setImage:[UIImage imageWithData:imageData]];
        
    }
    
    return cell;
    
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == self.expandedSection || indexPath.row <= 3) {
        return 65;
    }
    return 0;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (_matchCenterDone == YES) {
        self.itemURL = _matchCenterArray[indexPath.section][@"Top 3"][indexPath.row+1][@"Item URL"];
        [self performSegueWithIdentifier:@"WebViewSegue" sender:self];
    }
}


- (void)deleteButtonPressed:(id)sender
{
    UIActivityIndicatorView *activityIndicator = [[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    activityIndicator.center = CGPointMake(self.view.frame.size.width / 2.0, self.view.frame.size.height / 2.0);
    [self.view addSubview: activityIndicator];
    
    [activityIndicator startAnimating];
    
    // links button
    UIButton *deleteButton = (UIButton *)sender;
    
    // Define the sections title
    NSString *sectionName = _searchTerm = [[[[_matchCenterArray  objectAtIndex:deleteButton.tag] objectForKey:@"Top 3"] objectAtIndex:0]objectForKey:@"Search Term"];
    
    // Run delete function with respective section header as parameter
    [PFCloud callFunctionInBackground:@"deleteFromMatchCenter"
                       withParameters:
                      @{@"searchTerm": sectionName,}
                                block:^(NSDictionary *result, NSError *error) {
                                   if (!error) {
                                       [NSThread sleepForTimeInterval: 1];
                                       [PFCloud callFunctionInBackground:@"MatchCenter3"
                                                          withParameters:@{}
                                                                   block:^(NSArray *result, NSError *error) {
                                                                       
                                                                       if (!error) {
                                                                           _matchCenterArray = result;
                                                                           
                                                                           [activityIndicator stopAnimating];
                                                                           
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
     // Opens item in browser
     WebViewController *controller = (WebViewController *) segue.destinationViewController;
     controller.itemURL = self.itemURL;
 }


@end

@implementation MoreButton
@end