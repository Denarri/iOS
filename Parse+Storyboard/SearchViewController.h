//
//  Denarri iOS App
//
//  Created by Andrew Ghobrial and Chris Meseha on 03/01/14.
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



@end
