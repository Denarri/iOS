//
//  Denarri iOS App
//
//  Created by Andrew Ghobrial and Chris Meseha on 03/01/14.
//  Copyright (c) 2014 Denarri. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>
#import "AsyncImageView.h"
#import "SearchViewController.h"

@interface MatchCenterViewController : UIViewController <UITableViewDataSource>

@property (nonatomic) IBOutlet NSString *itemSearch;
@property (nonatomic, strong) NSArray *imageURLs;

@property (strong, nonatomic) NSString *matchingCategoryCondition;
@property (strong, nonatomic) NSString *matchingCategoryLocation;
@property (strong, nonatomic) NSNumber *matchingCategoryMaxPrice;
@property (strong, nonatomic) NSNumber *matchingCategoryMinPrice;

@end
