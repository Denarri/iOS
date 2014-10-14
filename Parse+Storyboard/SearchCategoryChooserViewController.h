//
//  Denarri iOS App
//
//  Created by Andrew Ghobrial.
//  Copyright (c) 2014 Denarri. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SearchViewController.h"

@interface SearchCategoryChooserViewController : SearchViewController

@property (nonatomic, copy) NSNumber *chosenCategory;
@property (nonatomic, copy) NSString *chosenCategoryName;

@property (strong, nonatomic) NSString *itemSearch;
@property (strong, nonatomic) NSString *itemPriority;
//@property (strong, nonatomic) IBOutlet UITextField *itemSearch;


@end
