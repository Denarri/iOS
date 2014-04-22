//
//  Denarri iOS App
//
//  Created by Andrew Ghobrial and Chris Meseha on 03/01/14.
//  Copyright (c) 2014 Denarri. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>

@interface CriteriaViewController : UIViewController{

IBOutlet UISegmentedControl *Segment;
}

-(IBAction)conditionToggle;

-(IBAction)itemLocationToggle;

@property (nonatomic) IBOutlet UITextField *itemSearch;

@end
