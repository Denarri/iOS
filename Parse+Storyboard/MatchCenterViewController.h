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
#import "WebViewController.h"

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

@property (strong, nonatomic) NSArray *matchCenterArray;
@property (strong, nonatomic) NSString *searchTerm;
@property (strong, nonatomic) NSString *itemURL;
@property (assign) NSInteger expandedSection;
@property (assign) BOOL results;
@property (assign) NSInteger rowCount;
//@property (nonatomic, assign) int didAddNewItem;
@property (assign) BOOL didAddNewItem;

@property (strong, nonatomic) IBOutlet UIButton *editButton;


@property (weak, nonatomic) IBOutlet UIButton *moreButton;
@property (strong) NSMutableSet *expandedSections;

@end

@interface MoreButton : UIButton
@property (assign) NSInteger expandedSection;
@property (assign) NSInteger sectionIndex;
@end