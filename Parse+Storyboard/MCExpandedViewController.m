//
//  MCExpandedViewController.m
//  Denarri
//
//  Created by Andrew Ghobrial on 12/11/15.
//

#import "MCExpandedViewController.h"
#import <UIKit/UIKit.h>
#import "MCExpandedCell.h"
#import "EmptyTableViewCell.h"

@interface MCExpandedViewController () <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) UITableView *matchCenter;
@property (nonatomic, assign) BOOL matchCenterDone;
@property (nonatomic, assign) BOOL hasPressedShowMoreButton;
@property (nonatomic, assign) BOOL visibleCell;

@end

@implementation MCExpandedViewController

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
    
    self.expandedSection = -1;
    _matchCenterDone = NO;
    _hasPressedShowMoreButton = NO;
    
    // Set up MatchCenter table
    self.matchCenter = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewCellStyleSubtitle];
    self.matchCenter.frame = CGRectMake(0,0,self.view.frame.size.width,self.view.frame.size.height);
    self.edgesForExtendedLayout = UIRectEdgeAll;
    self.matchCenter.contentInset = UIEdgeInsetsMake(0.0f, 0.0f, CGRectGetHeight(self.tabBarController.tabBar.frame), 0.0f);
    _matchCenter.dataSource = self;
    _matchCenter.delegate = self;
    [self.view addSubview:self.matchCenter];

    
    _matchCenterArray = [[NSArray alloc] init];
    
    // Pull to refresh
    UIRefreshControl *refreshControl = [[UIRefreshControl alloc] init];
    [refreshControl addTarget:self action:@selector(refresh:) forControlEvents:UIControlEventValueChanged];
    [self.matchCenter addSubview:refreshControl];
    
    
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

- (IBAction)editButtonAction:(id)sender {
    [self performSegueWithIdentifier:@"CriteriaSettingsSegue" sender:self];
    NSLog(@"OH YEAAAAA");
}

- (void)refresh:(UIRefreshControl *)refreshControl {
    
    NSLog(@"Refresh requested");
    
    self.matchCenterArray = [[NSArray alloc] init];
    
    UIActivityIndicatorView *activityIndicator = [[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    activityIndicator.center = CGPointMake(self.view.frame.size.width / 2.0, self.view.frame.size.height / 2.0);
    [self.view addSubview: activityIndicator];
    [activityIndicator startAnimating];
    
    
    // Disable ability to scroll until table is MatchCenter table is done loading
    _matchCenterDone = NO;
    self.matchCenter.scrollEnabled = NO;
    
    // Ping Parse, eBay, etc APIs
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
    
    // After doing job, when done:
    [refreshControl endRefreshing];
}

- (void)viewDidAppear:(BOOL)animated
{
    if (self.didAddNewItem == NO) {
        NSLog(@"KHARA!");
    }
    
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

- (void)viewWillAppear:(BOOL)animated
{
    
    CGRect frame = CGRectMake(0, 0, 100, 44);
    UILabel *label = [[UILabel alloc] initWithFrame:frame];
    label.backgroundColor = [UIColor clearColor];
    label.font = [UIFont systemFontOfSize:20.0];
    label.textAlignment = NSTextAlignmentCenter;
    label.textColor = [UIColor whiteColor];
    label.text = [NSString stringWithFormat:@"%@", _sectionSelectedSearchTerm];
    self.navigationItem.titleView = label;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return _matchCenterArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
        return 0.0001f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    
    if (section == self.sectionSelected) {
        return 45;
    }
    
    else {
        return 0.0001f;
    }
    
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
        return nil;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    
    if (section == _sectionSelected) {
        UIView *view = [[UIView alloc] initWithFrame:CGRectZero];
        view.backgroundColor = [UIColor whiteColor];
        
        MoreButton *moreButton = [MoreButton buttonWithType:UIButtonTypeCustom];
        moreButton.frame = CGRectMake(0, 0, 35, 15);
        
        CGPoint centerImageView = view.center;
        centerImageView.x = self.view.center.x;
        centerImageView.y = 20;
        moreButton.center = centerImageView;

        
        moreButton.sectionIndex = section;
        
        if (self.expandedSection == -1){
            [moreButton setImage:[UIImage imageNamed:@"DownArrow.png"] forState:UIControlStateNormal];
        }
        else {
            if (self.expandedSection == section) {
                [moreButton setImage:[UIImage imageNamed:@"UpArrow.png"] forState:UIControlStateNormal];
            }
            else {
                [moreButton setImage:[UIImage imageNamed:@"DownArrow.png"] forState:UIControlStateNormal];
            }
            
        }
        
        [moreButton addTarget:self action:@selector(moreButtonSelected:) forControlEvents:UIControlEventTouchUpInside];
        [view addSubview:moreButton];
        
        return view;

    }
    
    else {
        return nil;
    }
}

- (void)moreButtonSelected:(MoreButton *)button {
    
    // Indicates which section is the expanded one
    
    // If none are expanded, set it as the section that you just tapped to expand
    if (self.expandedSection == -1) {
        self.expandedSection = button.sectionIndex;
    }
    // If more button is tapped on already expanded section, set expanded section to null, and contract it
    else {
        self.expandedSection = -1;
    }
    
    [_matchCenter reloadData];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSDictionary *currentSectionDictionary = _matchCenterArray[section];
    NSArray *top3ArrayForSection = currentSectionDictionary[@"Top 3"];
    
    // If the section corresponds to the one selected in the previous view
    if (section == self.sectionSelected) {
        
        // If no results, display single cell with "no results" text
        if (top3ArrayForSection.count-1 < 1){
            return 1;
        }
        //
        
        // If anywhere between 1-3 results, display respective # of results
        else if (top3ArrayForSection.count-1 == 1){
            return 1;
        }
        
        else if (top3ArrayForSection.count-1 == 2){
            return 2;
        }
        
        else if (top3ArrayForSection.count-1 == 3){
            return 3;
        }
        //
        
        // If section's expanded, display max number of results set by server code
        else if (section == self.expandedSection) {
            return top3ArrayForSection.count-1;
        }
        //
        
        else {
            return 4;
        }

    }
    
    // Hide all the other sections
    else {
        return 0;
    }
    
}


// Cell layout
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    //load top 3 data
    NSDictionary *currentSectionDictionary = _matchCenterArray[indexPath.section];
    NSArray *top3ArrayForSection = currentSectionDictionary[@"Top 3"];
    
    // if no results for that item
    if (top3ArrayForSection.count-1 < 1) {
        
        // Initialize cell
        static NSString *CellIdentifier = @"MCExpandedCell";
        EmptyTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        if (!cell) {
            // if no cell could be dequeued create a new one
            cell = [[EmptyTableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
        }
        
        // title of the item
        cell.textLabel.text = @"No items found, but we'll keep a lookout for you!";
        cell.textLabel.font = [UIFont systemFontOfSize:12];
        
        cell.detailTextLabel.text = [NSString stringWithFormat:@""];
        [cell.imageView setImage:[UIImage imageNamed:@""]];
        
        return cell;
    }
    
    // if results for that item found
    else {
        
        // Change this [1]
        static NSString *SecondCellIdentifier = @"SecondMCExpandedCell";
        MCExpandedCell *cell = [tableView dequeueReusableCellWithIdentifier:SecondCellIdentifier];
        if (!cell) {
            // if no cell could be dequeued create a new one
            cell = [[MCExpandedCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:SecondCellIdentifier];
        }
        
        tableView.separatorColor = [UIColor clearColor];
        
        // title of the item
        cell.textLabel.text = _matchCenterArray[indexPath.section][@"Top 3"][indexPath.row+1][@"Title"];
        cell.textLabel.font = [UIFont systemFontOfSize:14];
        
        // price + condition of the item
        NSString *price = [NSString stringWithFormat:@"$%@", _matchCenterArray[indexPath.section][@"Top 3"][indexPath.row+1][@"Price"]];
        NSString *condition = [NSString stringWithFormat:@"%@", _matchCenterArray[indexPath.section][@"Top 3"][indexPath.row+1][@"Item Condition"]];
        
        cell.detailTextLabel.text = [NSString stringWithFormat:@"%@ - %@", price, condition];
        cell.detailTextLabel.textColor = [UIColor colorWithRed:0.384 green:0.722 blue:0.384 alpha:1];
        
        // Best Match label, applied to top result
        if (indexPath.row == 0) {
            cell.bestMatchLabel.text = @"Best Match";
            cell.bestMatchLabel.font = [UIFont systemFontOfSize:12];
            cell.bestMatchLabel.textColor = [UIColor colorWithRed:0.18 green:0.541 blue:0.902 alpha:1];
            
            [cell.contentView addSubview:cell.bestMatchLabel];
            [cell.bestMatchLabel setHidden:NO];
        } else {
            [cell.bestMatchLabel setHidden:YES];
        }
        
        // Load images using background thread to avoid the laggy tableView
        [cell.imageView setImage:[UIImage imageNamed:@"Placeholder.png"]];
        
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^{
            // Download or get images here
            NSData *imageData = [NSData dataWithContentsOfURL:[NSURL URLWithString:_matchCenterArray[indexPath.section][@"Top 3"][indexPath.row+1][@"Image URL"]]];
            
            // Use main thread to update the view. View changes are always handled through main thread
            dispatch_async(dispatch_get_main_queue(), ^{
                // Refresh image view here
                [cell.imageView setImage:[UIImage imageWithData:imageData]];
                cell.imageView.layer.cornerRadius = 2.5;
                
                cell.imageView.contentMode = UIViewContentModeScaleAspectFill;
                cell.imageView.clipsToBounds = YES;
                
            });
        });
        return cell;
    }
    
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 70;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (_matchCenterDone == YES) {
        self.itemURL = _matchCenterArray[indexPath.section][@"Top 3"][indexPath.row+1][@"Item URL"];
        NSLog(@"The URL IS:'%@", self.itemURL);
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
    if ([segue.identifier isEqualToString:@"WebViewSegue"]){
        // Opens item in browser
        WebViewController *controller = (WebViewController *) segue.destinationViewController;
        controller.itemURL = self.itemURL;
    }
}


@end

@implementation MoreButton
@end
