//
//  MCSettingsViewController.h
//  Denarri
//
//  Created by Andrew Ghobrial on 9/22/14.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>
#import "MCSettingsFormViewController.h"

@interface MCSettingsViewController : UIViewController
@property (weak, nonatomic) IBOutlet UIButton *mcSettingsDone;
@property (strong, nonatomic) NSArray *mcSettingsArray;

@property (strong, nonatomic) NSString *minPrice;
@property (strong, nonatomic) NSString *maxPrice;
@property (strong, nonatomic) NSString *itemCondition;
@property (strong, nonatomic) NSString *itemLocation;
@property (strong, nonatomic) NSString *searchTerm;
@property (strong, nonatomic) NSString *itemPriority;

@end
