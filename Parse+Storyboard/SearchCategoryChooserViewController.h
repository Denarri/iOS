//
//  Denarri iOS App
//
//  Created by Andrew Ghobrial and Chris Meseha on 03/01/14.
//  Copyright (c) 2014 Denarri. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SearchViewController.h"

@interface SearchCategoryChooserViewController : SearchViewController

@property (nonatomic, copy) NSNumber *chosenCategory;
@property (nonatomic, copy) NSString *chosenCategoryName;

@property (strong, nonatomic) NSString *itemSearch;
//@property (strong, nonatomic) IBOutlet UITextField *itemSearch;


@end
