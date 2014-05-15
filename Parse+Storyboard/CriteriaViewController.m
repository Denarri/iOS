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
    
    
    
    
    // Condition UISegment
//    UIScrollView *conditionScroll = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, 320, 435)];
//    conditionScroll.contentSize = CGSizeMake(320, 300);
//    conditionScroll.showsHorizontalScrollIndicator = YES;
    
//    NSArray *conditionArray = [NSArray arrayWithObjects: @"Only New", @"Any", nil];
//    UISegmentedControl *conditionSegmentedControl = [[UISegmentedControl alloc] initWithItems:conditionArray];
//    conditionSegmentedControl.frame = CGRectMake(87, 190, 157, 30);
//    [conditionSegmentedControl addTarget:self action:@selector(ConditionSegmentControlAction:) forControlEvents: UIControlEventValueChanged];
//    conditionSegmentedControl.selectedSegmentIndex = 0;
//    [conditionScroll addSubview:conditionSegmentedControl];
//    [self.view addSubview:conditionScroll];
    
    
    // Location UISegment
//    UIScrollView *locationScroll = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, 320, 435)];
//    locationScroll.contentSize = CGSizeMake(320, 100);
//    locationScroll.showsHorizontalScrollIndicator = YES;
    
//    NSArray *locationArray = [NSArray arrayWithObjects: @"Fast Shipping", @"Large Selection", nil];
//    UISegmentedControl *locationSegmentedControl = [[UISegmentedControl alloc] initWithItems:locationArray];
//    locationSegmentedControl.frame = CGRectMake(67, 275, 200, 30);
//    [locationSegmentedControl addTarget:self action:@selector(LocationSegmentControlAction:) forControlEvents: UIControlEventValueChanged];
//    locationSegmentedControl.selectedSegmentIndex = 0;
//    [locationScroll addSubview:locationSegmentedControl];
//    [self.view addSubview:locationScroll];
    
    
    // Submit button
    UIButton *submitButton = [UIButton buttonWithType:UIButtonTypeRoundedRect]; // Create Round Rect Type button.
    submitButton.frame = CGRectMake(100, 100, 100, 100); // define position and width and height for the button.
    [submitButton setTitle:@"Submit" forState:UIControlStateNormal];
    
    [submitButton addTarget:self action:@selector(submitButton:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:submitButton];
    
    
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
    //if (self.minPrice.text.length > 0 && self.maxPrice.text.length > 0) {
    
        [PFCloud callFunctionInBackground:@"userCategorySave"
                           withParameters:@{@"categoryId": self.chosenCategory,
                                              @"minPrice": @"220",
                                              @"maxPrice": @"356",
                                         @"itemCondition": self.itemCondition,
                                          @"itemLocation": self.itemLocation}
                                         block:^(NSString *result, NSError *error) {
         
                                             if (!error) {
                                                 NSLog(@"Criteria successfully saved.");
    
                                                     [self performSegueWithIdentifier:@"SearchCategoryChooserToMatchCenterSegue" sender:self];

                                             }
                                         }];
    
    //}

}

    
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
    
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.

}

    


@end
