//
//  Denarri iOS App
//
//  Created by Andrew Ghobrial.
//  Copyright (c) 2014 Denarri. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SearchViewController.h"

@interface UserCategoryChooserViewController : UIViewController

@property (strong, nonatomic) NSString *itemSearch;


//@property (weak, nonatomic) IBOutlet UITextField *itemSearch;

@property (strong, nonatomic) NSNumber *matchingCategoryId1;
@property (strong, nonatomic) NSNumber *matchingCategoryId2;

@property (strong, nonatomic) NSString *matchingCategoryName1;
@property (strong, nonatomic) NSString *matchingCategoryName2;

@property (strong, nonatomic) NSString *matchingCategoryCondition1;
@property (strong, nonatomic) NSString *matchingCategoryCondition2;

@property (strong, nonatomic) NSString *matchingCategoryLocation1;
@property (strong, nonatomic) NSString *matchingCategoryLocation2;

@property (strong, nonatomic) NSNumber *matchingCategoryMaxPrice1;
@property (strong, nonatomic) NSNumber *matchingCategoryMaxPrice2;

@property (strong, nonatomic) NSNumber *matchingCategoryMinPrice1;
@property (strong, nonatomic) NSNumber *matchingCategoryMinPrice2;

@property (nonatomic, copy) NSNumber *chosenCategory;

@end
