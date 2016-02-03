//
//  Denarri iOS App
//
//  Created by Andrew Ghobrial.
//  Copyright (c) 2014 Denarri. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>
#import "AsyncImageView.h"
#import "SearchViewController.h"
#import "MCExpandedViewController.h"
#import "WSCoachMarksView.h"
#import "MatchCenterCell.h"
#import "UIImage+StackBlur.h"

#import "SLExpandableTableView.h"



@interface MatchCenterViewController : UIViewController <UITableViewDataSource>

@property (strong, nonatomic) NSString *itemSearch;
@property (strong, nonatomic) NSString *itemPriority;
//@property (strong, nonatomic) IBOutlet UITextField *itemSearch;
@property (nonatomic, strong) NSArray *imageURLs;

@property (strong, nonatomic) NSString *matchingCategoryCondition;
@property (strong, nonatomic) NSString *matchingCategoryLocation;
@property (strong, nonatomic) NSNumber *matchingCategoryMaxPrice;
@property (strong, nonatomic) NSNumber *matchingCategoryMinPrice;
@property (strong, nonatomic) NSNumber *matchingCategoryId;

@property (strong, nonatomic) NSArray *matchCenterData;
@property (strong, nonatomic) NSString *searchTerm;
@property (strong, nonatomic) NSString *itemURL;
@property (assign) NSInteger rowCount;
@property (assign) BOOL didAddNewItem;
@property (assign) BOOL results;

@property (assign, nonatomic) NSInteger sectionSelected;
@property (strong, nonatomic) NSString *sectionSelectedSearchTerm;


@property (strong, nonatomic) IBOutlet UIButton *editButton;

@end

//@interface MoreButton : UIButton
//@property (assign) NSInteger expandedSection;
//@property (assign) NSInteger sectionIndex;
//@end