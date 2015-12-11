//
//  MCExpandedViewController.h
//  Denarri
//
//  Created by Andrew Ghobrial on 12/11/15.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>
#import "AsyncImageView.h"
#import "SearchViewController.h"
#import "WebViewController.h"
#import "WSCoachMarksView.h"

#import "SLExpandableTableView.h"

@interface MCExpandedViewController : UIViewController <UITableViewDataSource>

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
@property (assign) NSInteger rowCount;
@property (assign) BOOL didAddNewItem;
@property (assign) BOOL results;

@property (strong, nonatomic) IBOutlet UIButton *editButton;


@property (weak, nonatomic) IBOutlet UIButton *moreButton;
@property (strong) NSMutableSet *expandedSections;

@end

@interface MoreButton : UIButton
@property (assign) NSInteger expandedSection;
@property (assign) NSInteger sectionIndex;
@end
