//
//  Denarri iOS App
//
//  Created by Andrew Ghobrial and Chris Meseha on 03/01/14.
//  Copyright (c) 2014 Denarri. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>
#import "AsyncImageView.h"

@interface MatchCenterViewController : UIViewController <UITableViewDataSource>

@property (nonatomic) IBOutlet UITextField *itemSearch;
@property (nonatomic, strong) NSArray *imageURLs;

@end
