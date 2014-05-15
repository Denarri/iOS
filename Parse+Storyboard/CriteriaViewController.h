//
//  Denarri iOS App
//
//  Created by Andrew Ghobrial and Chris Meseha on 03/01/14.
//  Copyright (c) 2014 Denarri. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>
#import "SearchViewController.h"

@interface CriteriaViewController : UIViewController{

IBOutlet UISegmentedControl *Segment;
}


//@property (nonatomic) IBOutlet UITextField *itemSearch;
@property (weak, nonatomic) IBOutlet UITextField *minPrice;
@property (weak, nonatomic) IBOutlet UITextField *maxPrice;
@property (nonatomic, copy) NSNumber *chosenCategory;
@property (weak, nonatomic) NSString *itemCondition;
@property (weak, nonatomic) NSString *itemLocation;
@property (weak, nonatomic) NSString *itemSearch;

@end
