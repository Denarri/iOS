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
    
    self.navigationItem.title = @"Criteria";
    
    // Default values
    self.itemCondition = @"New";
    self.itemLocation = @"US";
    
    // Initialize UISegmentedControls
    UISegmentedControl *conditionSegmentedControl = [[UISegmentedControl alloc] initWithItems:[NSArray arrayWithObjects:@"New Only", @"New/Lightly Used", nil]];
    conditionSegmentedControl.frame = CGRectMake(35, 210, 250, 35);
    conditionSegmentedControl.selectedSegmentIndex = 0;
    conditionSegmentedControl.tintColor = [UIColor blueColor];
    [conditionSegmentedControl addTarget:self action:@selector(conditionValueChanged:) forControlEvents: UIControlEventValueChanged];
    [self.view addSubview:conditionSegmentedControl];
    
    UISegmentedControl *locationSegmentedControl = [[UISegmentedControl alloc] initWithItems:[NSArray arrayWithObjects:@"Faster Shipping", @"Larger Selection", nil]];
    locationSegmentedControl.frame = CGRectMake(35, 320, 250, 35);
    locationSegmentedControl.selectedSegmentIndex = 0;
    locationSegmentedControl.tintColor = [UIColor blueColor];
    [locationSegmentedControl addTarget:self action:@selector(locationValueChanged:) forControlEvents: UIControlEventValueChanged];
    [self.view addSubview:locationSegmentedControl];
    
    
    // Submit button
    UIButton *submitButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    submitButton.frame = CGRectMake(110, 340, 100, 100);
    [submitButton setTitle:@"Submit" forState:UIControlStateNormal];
    [submitButton addTarget:self action:@selector(submitButton:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:submitButton];
    
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

- (void)locationValueChanged:(UISegmentedControl *)locationSegmentedControl {
    
    if(locationSegmentedControl.selectedSegmentIndex == 0)
    {
        self.itemLocation = @"US";
    }
    else if(locationSegmentedControl.selectedSegmentIndex == 1)
    {
        self.itemLocation = @"WorldWide";
    }
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



//add all the info to users respective new category object
- (IBAction)submitButton:(id)sender
{
    if (self.minPrice.text.length > 0 && self.maxPrice.text.length > 0) {
        
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
                                                 
                                                 [PFCloud callFunctionInBackground:@"addToMatchCenter"
                                                                    withParameters:@{
                                                                                     @"searchTerm": self.itemSearch,
                                                                                     @"categoryId": self.chosenCategory,
                                                                                     @"minPrice": self.minPrice.text,
                                                                                     @"maxPrice": self.maxPrice.text,
                                                                                     @"itemCondition": self.itemCondition,
                                                                                     @"itemLocation": self.itemLocation,
                                                                                     }
                                                                             block:^(NSString *result, NSError *error) {
                                                                                 
                                                                                 if (!error) {
                                                                                     NSLog(@"'%@'", result);
                                                                                     
                                                                                     [NSThread sleepForTimeInterval:2];
                                                                                     
                                                                                     [activityIndicator stopAnimating];
                                                                                     
                                                                                     [self.tabBarController setSelectedIndex:1];
                                                                                 }
                                                                             }];
                                                 
                                                 
    
                                                     //[self performSegueWithIdentifier:@"SearchCategoryChooserToMatchCenterSegue" sender:self];

                                             }
                                         }];
    
    }
    else {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Empty fields!" message:@"Make sure all fields are filled in before submitting!" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
    }

}

    
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
//    [PFCloud callFunctionInBackground:@"addToMatchCenter"
//                       withParameters:@{
//                                        @"searchTerm": self.itemSearch,
//                                        @"categoryId": self.chosenCategory,
//                                        @"minPrice": self.minPrice.text,
//                                        @"maxPrice": self.maxPrice.text,
//                                        @"itemCondition": self.itemCondition,
//                                        @"itemLocation": self.itemLocation,
//                                        }
//                                block:^(NSString *result, NSError *error) {
//                                    
//                                    if (!error) {
//                                        NSLog(@"'%@'", result);
//                                    }
//                                }];

}

@end
