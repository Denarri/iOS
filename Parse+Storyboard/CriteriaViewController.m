//
//  Denarri iOS App
//
//  Created by Andrew Ghobrial.
//  Copyright (c) 2014 Denarri. All rights reserved.
//

#import "CriteriaViewController.h"

@interface CriteriaViewController ()

@end

@implementation CriteriaViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // Setup coach marks
    NSArray *coachMarks = @[
                            @{
                                @"rect": [NSValue valueWithCGRect:(CGRect){{25,90},{270,190}}],
                                @"caption": @"Denarri learns your preferences, so you never have to repeat yourself. The next time you shop for this type of item, it'll remember your criteria, so you can skip this step!"
                                },
                            ];
    
    self.coachMarksView = [[WSCoachMarksView alloc] initWithFrame:self.tabBarController.view.bounds coachMarks:coachMarks];
    [self.tabBarController.view addSubview:self.coachMarksView];
    self.coachMarksView.animationDuration = 0.5f;
    self.coachMarksView.enableContinueLabel = YES;
    
    self.navigationItem.title = @"Criteria";
    
    // Default values
    self.itemCondition = @"New";
    
    // Initialize UISegmentedControls
    UISegmentedControl *conditionSegmentedControl = [[UISegmentedControl alloc] initWithItems:[NSArray arrayWithObjects:@"New Only", @"New/Lightly Used", nil]];
    conditionSegmentedControl.frame = CGRectMake(35, 230, 250, 35);
    conditionSegmentedControl.selectedSegmentIndex = 0;
    conditionSegmentedControl.tintColor = [UIColor blueColor];
    [conditionSegmentedControl addTarget:self action:@selector(conditionValueChanged:) forControlEvents: UIControlEventValueChanged];
    [self.view addSubview:conditionSegmentedControl];
    
    // Submit button
    self.submitButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    self.submitButton.frame = CGRectMake(110, 260, 100, 100);
    [self.submitButton setTitle:@"Submit" forState:UIControlStateNormal];
    [self.submitButton addTarget:self action:@selector(submitButton:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.submitButton];
    
    

}



- (void)viewDidAppear:(BOOL)animated
{
    // Show coach marks
    BOOL coachMarksShown = [[NSUserDefaults standardUserDefaults] boolForKey:@"WSCoachMarksShown"];
    if (coachMarksShown == NO) {
        // Don't show again
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"WSCoachMarksShown"];
        [[NSUserDefaults standardUserDefaults] synchronize];
        
        // Show coach marks
        [self.coachMarksView start];
    }
    
    NSLog(@"'%@'", self.itemLocation);
    self.submitButton.userInteractionEnabled = YES;
    
}


- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    for (UIView * txt in self.view.subviews){
        if ([txt isKindOfClass:[UITextField class]] && [txt isFirstResponder]) {
            [txt resignFirstResponder];
        }
    }
}

- (void)conditionValueChanged:(UISegmentedControl *)conditionSegmentedControl {
    
    if(conditionSegmentedControl.selectedSegmentIndex == 0)
    {
        self.itemCondition = @"New";
    }
    else if(conditionSegmentedControl.selectedSegmentIndex == 1)
    {
        self.itemCondition = @"Used";
    }
}

//- (void)locationValueChanged:(UISegmentedControl *)locationSegmentedControl {
//    
//    if(locationSegmentedControl.selectedSegmentIndex == 0)
//    {
//        self.itemLocation = @"US";
//    }
//    else if(locationSegmentedControl.selectedSegmentIndex == 1)
//    {
//        self.itemLocation = @"WorldWide";
//    }
//}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



//add all the info to users respective new category object
- (IBAction)submitButton:(id)sender
{
    if (self.minPrice.text.length > 0 && self.maxPrice.text.length > 0) {
        
        self.submitButton.userInteractionEnabled = NO;
        
        UIActivityIndicatorView *activityIndicator = [[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
        activityIndicator.center = CGPointMake(self.view.frame.size.width / 3.0, self.view.frame.size.height / 3.0);
        [self.view addSubview: activityIndicator];
        
        [activityIndicator startAnimating];
        
        [PFCloud callFunctionInBackground:@"userCategorySave"
                           withParameters:@{@"categoryId": self.chosenCategory,
                                            
                                            @"minPrice": self.minPrice.text,
                                            @"maxPrice": self.maxPrice.text,
                                            @"itemCondition": self.itemCondition,
                                            @"itemLocation": self.itemLocation,
                                            
                                            @"categoryName": self.chosenCategoryName,
                                            }
                                    block:^(NSString *result, NSError *error) {
                                        
                                        if (!error) {
                                            NSLog(@"Criteria successfully saved.");
                                            
                                            UIViewController *toViewController = [self.tabBarController viewControllers][1];
                                            if ([toViewController isKindOfClass:[MatchCenterViewController class]]) {
                                                MatchCenterViewController *matchViewController = (MatchCenterViewController *)toViewController;
                                                
                                                matchViewController.didAddNewItem = YES;
                                                
                                                // Send over the matching item criteria
                                                matchViewController.itemSearch = self.itemSearch;
                                                matchViewController.matchingCategoryId = self.chosenCategory;
                                                matchViewController.matchingCategoryMinPrice = self.minPrice.text;
                                                matchViewController.matchingCategoryMaxPrice = self.maxPrice.text;
                                                matchViewController.matchingCategoryCondition = self.itemCondition;
                                                matchViewController.matchingCategoryLocation = self.itemLocation;
                                                matchViewController.itemPriority = self.itemPriority;
                                                
                                                NSLog(@"alright they're set, time to switch");
                                            }
                                            [self.tabBarController setSelectedIndex:1];
                                        }
                                    }];
        
    }
    else {
        if ([UIAlertController class]) {
            // Alert the iOS8 way
            UIAlertController * alert=   [UIAlertController
                                          alertControllerWithTitle:@"Empty fields!"
                                          message:@"Make sure all fields are filled in before submitting!"
                                          preferredStyle:UIAlertControllerStyleAlert];
            
            UIAlertAction* ok = [UIAlertAction
                                 actionWithTitle:@"OK"
                                 style:UIAlertActionStyleDefault
                                 handler:^(UIAlertAction * action)
                                 {
                                     [alert dismissViewControllerAnimated:YES completion:nil];
                                     
                                 }];
            [alert addAction:ok];
            [self presentViewController:alert animated:YES completion:nil];
        } else {
            // Alert the iOS7 way
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Empty fields!" message:@"Make sure all fields are filled in before submitting!" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
            [alert show];
        }
    }

}

    
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {

}

@end
