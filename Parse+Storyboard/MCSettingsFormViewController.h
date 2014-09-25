//
//  MCSettingsFormViewController.h
//  Denarri
//
//  Created by Andrew Ghobrial on 9/24/14.
//  Copyright (c) 2014 Juan Figuera. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>

@interface MCSettingsFormViewController : UIViewController

@property (strong, nonatomic) NSString *minPrice;
@property (strong, nonatomic) NSString *maxPrice;
@property (strong, nonatomic) NSString *itemCondition;
@property (strong, nonatomic) NSString *itemLocation;

@end
