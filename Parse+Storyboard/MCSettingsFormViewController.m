//
//  MCSettingsFormViewController.m
//  Denarri
//
//  Created by Andrew Ghobrial on 9/24/14.
//  Copyright (c) 2014 Juan Figuera. All rights reserved.
//

#import "MCSettingsFormViewController.h"

@interface MCSettingsFormViewController ()
@property (weak, nonatomic) IBOutlet UIButton *cancelButton;

@end

@implementation MCSettingsFormViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = @"Criteria";
    
    // Search Term
    self.tf2 = [[UITextField alloc] initWithFrame:CGRectMake(35, 80, 250, 30)];
    
    [self.view addSubview:self.tf2];
    
    self.tf2.userInteractionEnabled = YES;
    self.tf2.textColor = [UIColor blackColor];
    self.tf2.font = [UIFont fontWithName:@"Helvetica-Neue" size:12];
    self.tf2.backgroundColor=[UIColor whiteColor];
    self.tf2.textAlignment = NSTextAlignmentCenter;
    self.tf2.text = _searchTerm;
    
    self.tf2.textAlignment = NSTextAlignmentCenter;
    self.tf2.layer.cornerRadius=3.0f;
    self.tf2.layer.masksToBounds=YES;
    self.tf2.layer.borderColor=[[UIColor lightGrayColor]CGColor];
    self.tf2.layer.borderWidth= 1.0f;
    
    // Min Price
    self.tf = [[UITextField alloc] initWithFrame:CGRectMake(75, 153, 70, 30)];

    [self.view addSubview:self.tf];
    
    self.tf.userInteractionEnabled = YES;
    self.tf.textColor = [UIColor blackColor];
    self.tf.font = [UIFont fontWithName:@"Helvetica-Neue" size:14];
    self.tf.backgroundColor=[UIColor whiteColor];
    self.tf.text = _minPrice;
    
    self.tf.textAlignment = NSTextAlignmentCenter;
    self.tf.layer.cornerRadius=3.0f;
    self.tf.layer.masksToBounds=YES;
    self.tf.layer.borderColor=[[UIColor lightGrayColor]CGColor];
    self.tf.layer.borderWidth= 1.0f;
    
    // Max Price
    self.tf1 = [[UITextField alloc] initWithFrame:CGRectMake(190, 153, 70, 30)];
    
    [self.view addSubview:self.tf1];
    
    self.tf1.userInteractionEnabled = YES;
    self.tf1.textColor = [UIColor blackColor];
    self.tf1.font = [UIFont fontWithName:@"Helvetica-Neue" size:14];
    self.tf1.backgroundColor=[UIColor whiteColor];
    self.tf1.text = _maxPrice;
    
    self.tf1.textAlignment = NSTextAlignmentCenter;
    self.tf1.layer.cornerRadius=3.0f;
    self.tf1.layer.masksToBounds=YES;
    self.tf1.layer.borderColor=[[UIColor lightGrayColor]CGColor];
    self.tf1.layer.borderWidth= 1.0f;

    
    // Item Condition
    UISegmentedControl *conditionSegmentedControl = [[UISegmentedControl alloc] initWithItems:[NSArray arrayWithObjects:@"New Only", @"New/Lightly Used", nil]];
    conditionSegmentedControl.frame = CGRectMake(35, 223, 250, 35);
    if ([self.itemCondition  isEqual: @"New"]) {
        conditionSegmentedControl.selectedSegmentIndex = 0;
    }
    else {
        conditionSegmentedControl.selectedSegmentIndex = 1;
    }
    conditionSegmentedControl.tintColor = [UIColor colorWithRed:40/255.0f green:167/255.0f blue:255/255.0f alpha:1.0f];
    [conditionSegmentedControl addTarget:self action:@selector(conditionValueChanged:) forControlEvents: UIControlEventValueChanged];
    [self.view addSubview:conditionSegmentedControl];
    
    // Item priority
    UISegmentedControl *prioritySegmentedControl = [[UISegmentedControl alloc] initWithItems:[NSArray arrayWithObjects:@"Just Browsing", @"Need It Soon", nil]];
    prioritySegmentedControl.frame = CGRectMake(35, 313, 250, 35);
    if ([self.itemPriority  isEqual: @"Low"]) {
        prioritySegmentedControl.selectedSegmentIndex = 0;
    }
    else {
        prioritySegmentedControl.selectedSegmentIndex = 1;
    }
    prioritySegmentedControl.tintColor = [UIColor colorWithRed:40/255.0f green:167/255.0f blue:255/255.0f alpha:1.0f];
    [prioritySegmentedControl addTarget:self action:@selector(priorityValueChanged:) forControlEvents: UIControlEventValueChanged];
    [self.view addSubview:prioritySegmentedControl];
    
    // Submit button
    UIButton *submitButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    submitButton.frame = CGRectMake(110, 330, 100, 100);
    submitButton.tintColor = [UIColor colorWithRed:40/255.0f green:167/255.0f blue:255/255.0f alpha:1.0f];
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
        _itemCondition = @"New";
    }
    else if(conditionSegmentedControl.selectedSegmentIndex == 1)
    {
        _itemCondition = @"Used";
    }
    
    
    NSLog(@"itemCondition: '%@'", _itemCondition);
    
}

- (void)priorityValueChanged:(UISegmentedControl *)prioritySegmentedControl {
    
    if(prioritySegmentedControl.selectedSegmentIndex == 0)
    {
        self.itemPriority = @"Low";
        self.itemLocation = @"WorldWide";
    }
    else if(prioritySegmentedControl.selectedSegmentIndex == 1)
    {
        self.itemPriority = @"High";
        self.itemLocation = @"US";
    }
    
     NSLog(@"itemPriority: '%@'", self.itemPriority);
}

- (IBAction)cancelButton:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)submitButton:(id)sender
{
    if (self.tf.text.length > 0 && self.tf1.text.length > 0) {
        
        UIActivityIndicatorView *activityIndicator = [[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
        activityIndicator.center = CGPointMake(self.view.frame.size.width / 3.0, self.view.frame.size.height / 3.0);
        [self.view addSubview: activityIndicator];
        
        [activityIndicator startAnimating];
        
        NSLog(@"searchTerm I'm about to use is: '%@'", self.tf2.text);
        
        [PFCloud callFunctionInBackground:@"editMatchCenter2"
                           withParameters:@{
                                            @"originalSearchTerm": _searchTerm,
                                            @"newSearchTerm": self.tf2.text,
                                              @"minPrice": self.tf.text,
                                              @"maxPrice": self.tf1.text,
                                         @"itemCondition": _itemCondition,
                                          @"itemLocation": _itemLocation,
                                          @"itemPriority": self.itemPriority,
                                            }
                                    block:^(NSString *result, NSError *error) {
                                        
                                        if (!error) {
                                            NSLog(@"Result: '%@'", result);
                                            
                                            [activityIndicator startAnimating];
                                            
                                            [self dismissViewControllerAnimated:YES completion:nil];
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

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
