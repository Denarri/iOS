//
//  Denarri iOS App
//
//  Created by Andrew Ghobrial and Chris Meseha on 03/01/14.
//  Copyright (c) 2014 Denarri. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>
#import "SearchViewController.h"

@interface CriteriaViewController : UIViewController

//@property (nonatomic) IBOutlet UITextField *itemSearch;

@property (strong, nonatomic) IBOutlet UITextField *minPrice;
@property (strong, nonatomic) IBOutlet UITextField *maxPrice;

//
//@property (strong, nonatomic) IBOutlet UISegmentedControl *conditionSegment;
//@property (strong, nonatomic) IBOutlet UISegmentedControl *locationSegment;
//- (IBAction)conditionSegmentValueChanged:(id)sender;
//- (IBAction)locationSegmentValueChanged:(id)sender;


@property (nonatomic, copy) NSNumber *chosenCategory;
@property (nonatomic, copy) NSString *chosenCategoryName;
@property (strong, nonatomic) NSString *itemCondition;
@property (strong, nonatomic) NSString *itemLocation;
@property (strong, nonatomic) NSString *itemSearch;

@end
