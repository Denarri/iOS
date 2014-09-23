//
//  CriteriaSettingsViewController.h
//  Denarri
//
//  Created by Andrew Ghobrial on 9/22/14.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>

@interface CriteriaSettingsViewController : UIViewController
@property (weak, nonatomic) IBOutlet UIButton *criteriaSettingsDone;
@property (strong, nonatomic) NSArray *criteriaSettingsArray;
@end
