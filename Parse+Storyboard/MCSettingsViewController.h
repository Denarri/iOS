//
//  MCSettingsViewController.h
//  Denarri
//
//  Created by Andrew Ghobrial on 9/22/14.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>

@interface MCSettingsViewController : UIViewController
@property (weak, nonatomic) IBOutlet UIButton *mcSettingsDone;
@property (strong, nonatomic) NSArray *mcSettingsArray;
@end
