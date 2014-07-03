//
//  Denarri iOS App
//
//  Created by Andrew Ghobrial and Chris Meseha on 03/01/14.
//  Copyright (c) 2014 Denarri. All rights reserved.
//

#import "CriteriaViewController.h"

@interface CriteriaViewController ()
@property (weak, nonatomic) IBOutlet UISegmentedControl *itemConditionSegment;
@property (weak, nonatomic) IBOutlet UISegmentedControl *itemLocationSegment;


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
  
    [self addMinTextField];
    [self addMaxTextField];
    
    
    // Condition UISegment
    UISegmentedControl *conditionSegmentedControl = [[UISegmentedControl alloc] initWithItems:[NSArray arrayWithObjects:@"Only New", @"Any", nil]];
    conditionSegmentedControl.frame = CGRectMake(87, 190, 157, 30);
    conditionSegmentedControl.selectedSegmentIndex = 0;
    conditionSegmentedControl.tintColor = [UIColor blackColor];
    [conditionSegmentedControl addTarget:self action:@selector(ConditionSegmentControlAction:) forControlEvents: UIControlEventValueChanged];
    [self.view addSubview:conditionSegmentedControl];
    
    
    // Location UISegment
    UISegmentedControl *locationSegmentedControl = [[UISegmentedControl alloc] initWithItems:[NSArray arrayWithObjects:@"Fast Shipping", @"Large Selection", nil]];
    locationSegmentedControl.frame = CGRectMake(67, 275, 200, 30);
    locationSegmentedControl.selectedSegmentIndex = 0;
    locationSegmentedControl.tintColor = [UIColor blackColor];
    [locationSegmentedControl addTarget:self action:@selector(LocationSegmentControlAction:) forControlEvents: UIControlEventValueChanged];
    [self.view addSubview:locationSegmentedControl];
    
    
    
    
    // Submit button
    UIButton *submitButton = [UIButton buttonWithType:UIButtonTypeRoundedRect]; // Create Round Rect Type button.
    submitButton.frame = CGRectMake(100, 100, 100, 100); // define position and width and height for the button.
    [submitButton setTitle:@"Submit" forState:UIControlStateNormal];
    
    [submitButton addTarget:self action:@selector(submitButton:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:submitButton];

    
    
}



-(void)addMinTextField{
    // This allocates a label
    UILabel *prefixLabel = [[UILabel alloc]initWithFrame:CGRectZero];
    // This sets the font for the label
    [prefixLabel setFont:[UIFont boldSystemFontOfSize:14]];
    // This fits the frame to size of the text
    [prefixLabel sizeToFit];
	
    // This allocates the textfield and sets its frame
    UITextField *minPrice = [[UITextField  alloc] initWithFrame:
                             CGRectMake(70, 105, 75, 30)];
    
    // This sets the border style of the text field
    minPrice.borderStyle = UITextBorderStyleRoundedRect;
    minPrice.contentVerticalAlignment =
    UIControlContentVerticalAlignmentCenter;
    [minPrice setFont:[UIFont boldSystemFontOfSize:12]];
    
    //Placeholder text is displayed when no text is typed
    minPrice.placeholder = @"150";
    
    //Prefix label is set as left view and the text starts after that
    minPrice.leftView = prefixLabel;
    
    //It set when the left prefixLabel to be displayed
    minPrice.leftViewMode = UITextFieldViewModeAlways;
    
    // Adds the textField to the view.
    [self.view addSubview:minPrice];
    
    // sets the delegate to the current class
    minPrice.delegate = self;
}

-(void)addMaxTextField{
    // This allocates a label
    UILabel *prefixLabel = [[UILabel alloc]initWithFrame:CGRectZero];
    // This sets the font for the label
    [prefixLabel setFont:[UIFont boldSystemFontOfSize:14]];
    // This fits the frame to size of the text
    [prefixLabel sizeToFit];
    
    UITextField *maxPrice = [[UITextField  alloc] initWithFrame:
                             CGRectMake(185, 105, 75, 30)];
    
    //for max price
    maxPrice.borderStyle = UITextBorderStyleRoundedRect;
    maxPrice.contentVerticalAlignment =
    UIControlContentVerticalAlignmentCenter;
    [maxPrice setFont:[UIFont boldSystemFontOfSize:12]];
    
    //Placeholder text is displayed when no text is typed
    maxPrice.placeholder = @"300";
    
    //Prefix label is set as left view and the text starts after that
    maxPrice.leftView = prefixLabel;
    
    //It set when the left prefixLabel to be displayed
    maxPrice.leftViewMode = UITextFieldViewModeAlways;
    
    // Adds the textField to the view.
    [self.view addSubview:maxPrice];
    
    // sets the delegate to the current class
    maxPrice.delegate = self;
}



- (void)ConditionSegmentControlAction:(UISegmentedControl *)segment
{
    if(segment.selectedSegmentIndex == 0)
    {
        // set condition to new
        self.itemCondition = @"new";
    }
    else if (segment.selectedSegmentIndex == 1)
    {
        // set condition to all
        self.itemCondition = @"all";
    }
}

- (void)LocationSegmentControlAction:(UISegmentedControl *)segment
{
    if(segment.selectedSegmentIndex == 0)
    {
        // set location to us
        self.itemLocation = @"US";
    }
    else if (segment.selectedSegmentIndex == 1)
    {
        // set clocation to worldwide
        self.itemLocation = @"Worldwide";
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
    //if (self.minPriceField.text.length > 0 && self.maxPrice.text.length > 0) {
    
        [PFCloud callFunctionInBackground:@"userCategorySave"
                           withParameters:@{@"categoryId": self.chosenCategory,
                                              @"minPrice": self.minPrice,
                                            @"maxPrice": self.maxPrice,
                                       @"itemCondition": self.itemCondition,
                                        @"itemLocation": self.itemLocation,
                                        @"categoryName": self.chosenCategoryName,
                                            }
                                         block:^(NSString *result, NSError *error) {
         
                                             if (!error) {
                                                 NSLog(@"Criteria successfully saved.");
    
                                                     [self performSegueWithIdentifier:@"SearchCategoryChooserToMatchCenterSegue" sender:self];

                                             }
                                         }];
    
    //}

}

    
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    

    
//    [PFCloud callFunctionInBackground:@"addToMatchCenter"
//                       withParameters:@{
//                                        @"searchTerm": self.itemSearch,
//                                        @"categoryId": self.chosenCategory,
//                                        @"minPrice": self.minPrice,
//                                        @"maxPrice": self.maxPrice,
//                                        @"itemCondition": self.itemCondition,
//                                        @"itemLocation": self.itemLocation,
//                                        }
//                                block:^(NSString *result, NSError *error) {
//                                    
//                                    if (!error) {
//                                        NSLog(@"'%@'", result);
//                                    }
//                                }];
    
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.

}

    


@end
