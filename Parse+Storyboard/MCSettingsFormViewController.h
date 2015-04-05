//
//  MCSettingsFormViewController.h
//  Denarri
//
//  Created by Andrew Ghobrial on 9/24/14.
//  Copyright (c) 2014 Juan Figuera. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>
#import <Parse/Parse.h>
#import "MatchCenterViewController.h"


@interface MCSettingsFormViewController : UIViewController

@property (strong, nonatomic) NSString *minPrice;
@property (strong, nonatomic) NSString *maxPrice;
@property (strong, nonatomic) NSString *itemCondition;
@property (strong, nonatomic) NSString *itemLocation;
@property (strong, nonatomic) NSString *searchTerm;
@property (strong, nonatomic) NSString *itemPriority;

@property (strong, nonatomic) IBOutlet UITextField *tf;
@property (strong, nonatomic) IBOutlet UITextField *tf1;
@property (strong, nonatomic) IBOutlet UITextField *tf2;

@end
