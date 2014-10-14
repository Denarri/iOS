//
//  Denarri iOS App
//
//  Created by Andrew Ghobrial.
//  Copyright (c) 2014 Denarri. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>
#import "SearchViewController.h"

@interface CriteriaViewController : UIViewController

//@property (strong, nonatomic) IBOutlet UITextField *itemSearch;

@property (strong, nonatomic) IBOutlet UITextField *minPrice;
@property (strong, nonatomic) IBOutlet UITextField *maxPrice;
@property (strong, nonatomic) IBOutlet UIButton *submitButton;

@property (nonatomic, copy) NSNumber *chosenCategory;
@property (nonatomic, copy) NSString *chosenCategoryName;
@property (strong, nonatomic) NSString *itemCondition;
@property (strong, nonatomic) NSString *itemLocation;
@property (strong, nonatomic) NSString *itemPriority;
@property (strong, nonatomic) NSString *itemSearch;

@end
