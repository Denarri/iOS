//
//  Denarri iOS App
//
//  Created by Andrew Ghobrial.
//  Copyright (c) 2014 Denarri. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SearchViewController.h"
#import "CriteriaViewController.h"
#import "WSCoachMarksView.h"

@interface SearchCategoryChooserViewController : UIViewController

@property (nonatomic, copy) NSNumber *chosenCategory;
@property (nonatomic, copy) NSString *chosenCategoryName;

@property (strong, nonatomic) NSString *itemSearch;
@property (strong, nonatomic) NSString *itemPriority;
@property (strong, nonatomic) NSString *itemLocation;

@property (nonatomic, copy) NSString *topCategory1;
@property (nonatomic, copy) NSString *topCategory2;
@property (nonatomic, copy) NSNumber *topCategoryId1;
@property (nonatomic, copy) NSNumber *topCategoryId2;

//@property (strong, nonatomic) IBOutlet UITextField *itemSearch;


@end
