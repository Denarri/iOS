//
//  SubclassConfigViewController.h
//  Parse+Storyboard
//
//  Created by Andrew Ghobrial.
//  Copyright (c) 2014 Juan Figuera. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>
#import "DefaultSettingsViewController.h"

@interface SubclassConfigViewController : UIViewController <PFLogInViewControllerDelegate, PFSignUpViewControllerDelegate>

@property (nonatomic, strong) IBOutlet UILabel *welcomeLabel;

- (IBAction)logOutButtonTapAction:(id)sender;

@end
