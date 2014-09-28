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
    
    // Min Price
    //UITextField *tf = [[UITextField alloc] initWithFrame:CGRectMake(-25, -76, 70, 30)];
    UITextField *tf = [[UITextField alloc] initWithFrame:CGRectMake(10, 25, 70, 30)];
    
    tf.userInteractionEnabled = YES;
    tf.textColor = [UIColor blackColor];
    tf.font = [UIFont fontWithName:@"Helvetica-Neue" size:14];
    tf.backgroundColor=[UIColor whiteColor];
    tf.text= _minPrice;
    
    tf.textAlignment = NSTextAlignmentCenter;
    tf.layer.cornerRadius=8.0f;
    tf.layer.masksToBounds=YES;
    tf.layer.borderColor=[[UIColor lightGrayColor]CGColor];
    tf.layer.borderWidth= 1.0f;
    
    // Max Price
    UITextField *tf1 = [[UITextField alloc] initWithFrame:CGRectMake(125, 25, 70, 30)];
    tf1.userInteractionEnabled = YES;
    tf1.textColor = [UIColor blackColor];
    tf1.font = [UIFont fontWithName:@"Helvetica-Neue" size:14];
    tf1.backgroundColor=[UIColor whiteColor];
    tf1.text= _maxPrice;
    
    tf1.textAlignment = NSTextAlignmentCenter;
    tf1.layer.cornerRadius=8.0f;
    tf1.layer.masksToBounds=YES;
    tf1.layer.borderColor=[[UIColor lightGrayColor]CGColor];
    tf1.layer.borderWidth= 1.0f;
    
    //and so on adjust your view size according to your needs
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(70, 100, 200, 60)];
    
    [view addSubview:tf];
    [view addSubview:tf1];
    [self.view addSubview:view];
    
    // Condition UISegmentedControls
    UISegmentedControl *conditionSegmentedControl = [[UISegmentedControl alloc] initWithItems:[NSArray arrayWithObjects:@"New Only", @"New/Lightly Used", nil]];
    conditionSegmentedControl.frame = CGRectMake(35, 210, 250, 35);
    conditionSegmentedControl.tintColor = [UIColor blueColor];
    
    if ([_itemCondition  isEqual: @"New"]) {
        conditionSegmentedControl.selectedSegmentIndex=0;
    } else if ([_itemCondition  isEqual: @"Used"]) {
        conditionSegmentedControl.selectedSegmentIndex=1;
    }
    
    [conditionSegmentedControl addTarget:self action:@selector(conditionValueChanged:) forControlEvents: UIControlEventValueChanged];
    [self.view addSubview:conditionSegmentedControl];
    
    // Location UISegmentedControls
    UISegmentedControl *locationSegmentedControl = [[UISegmentedControl alloc] initWithItems:[NSArray arrayWithObjects:@"Faster Shipping", @"Larger Selection", nil]];
    locationSegmentedControl.frame = CGRectMake(35, 320, 250, 35);
    locationSegmentedControl.tintColor = [UIColor blueColor];
    
    if ([_itemLocation  isEqual: @"US"]) {
        locationSegmentedControl.selectedSegmentIndex=0;
    } else if ([_itemLocation  isEqual: @"WorldWide"]) {
        locationSegmentedControl.selectedSegmentIndex=1;
    }
    
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
        _itemCondition = @"New";
    }
    else if(conditionSegmentedControl.selectedSegmentIndex == 1)
    {
        _itemCondition = @"Used";
    }
    
    
    NSLog(@"itemCondition: '%@'", _itemCondition);
    
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

- (IBAction)cancelButton:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)submitButton:(id)sender
{
    if (_minPrice.length > 0 && _maxPrice.length > 0) {
        
        NSLog(@"itemCondition: '%@'", _itemCondition);
        
        [PFCloud callFunctionInBackground:@"editMatchCenter"
                           withParameters:@{
                                            @"searchTerm": _searchTerm,
                                            @"minPrice": _minPrice,
                                            @"maxPrice": _maxPrice,
                                            @"itemCondition": _itemCondition,
                                            @"itemLocation": _itemLocation
                                            }
                                    block:^(NSString *result, NSError *error) {
                                        
                                        if (!error) {
                                            NSLog(@"Result: '%@'", result);
                                            [self dismissViewControllerAnimated:YES completion:nil];
                                        }
                                    }];
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
