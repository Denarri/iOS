//
//  Denarri iOS App
//
//  Created by Andrew Ghobrial.
//  Copyright (c) 2014 Denarri. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>
#import <Parse/PFCloud.h>
#import "CriteriaViewController.h"


@interface SearchViewController : UIViewController

@property (weak, nonatomic) IBOutlet UIButton *nextButtonOutlet;
@property (nonatomic, copy) NSString *topCategory1;
@property (nonatomic, copy) NSString *topCategory2;
@property (nonatomic, copy) NSNumber *topCategoryId1;
@property (nonatomic, copy) NSNumber *topCategoryId2;
@property (strong, nonatomic) IBOutlet UITextField *itemSearch;

@property (strong, nonatomic) NSString *matchingCategoryCondition1;
@property (strong, nonatomic) NSString *matchingCategoryCondition2;

@property (strong, nonatomic) NSString *matchingCategoryLocation1;
@property (strong, nonatomic) NSString *matchingCategoryLocation2;

@property (strong, nonatomic) NSNumber *matchingCategoryMaxPrice1;
@property (strong, nonatomic) NSNumber *matchingCategoryMaxPrice2;

@property (strong, nonatomic) NSNumber *matchingCategoryMinPrice1;
@property (strong, nonatomic) NSNumber *matchingCategoryMinPrice2;

@property (strong, nonatomic) NSNumber *matchingCategoryId1;
@property (strong, nonatomic) NSNumber *matchingCategoryId2;

@property (strong, nonatomic) NSString *matchingCategoryName1;
@property (strong, nonatomic) NSString *matchingCategoryName2;



@end
