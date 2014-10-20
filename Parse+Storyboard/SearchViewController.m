//
//  Denarri iOS App
//
//  Created by Andrew Ghobrial.
//  Copyright (c) 2014 Denarri. All rights reserved.
//

#import "SearchViewController.h"
#import "MatchCenterViewController.h"
#import "SearchCategoryChooserViewController.h"
#import "UserCategoryChooserViewController.h"


@interface SearchViewController ()


@property (weak, nonatomic) IBOutlet UIButton *nextButton;

@end

@implementation SearchViewController

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

    _nextButtonOutlet.userInteractionEnabled = YES;
    
    // Navbar Title
    CGRect frame = CGRectMake(0, 0, 400, 44);
    UILabel *label = [[UILabel alloc] initWithFrame:frame];
    label.backgroundColor = [UIColor clearColor];
    label.font = [UIFont systemFontOfSize:20.0];
    label.textAlignment = NSTextAlignmentCenter;
    label.textColor = [UIColor blackColor];
    label.text = @"         Denarri";
    self.navigationItem.titleView = label;
    //self.navigationItem.title = @"Denarri";

    UIButton *button =  [UIButton buttonWithType:UIButtonTypeCustom];
    [button setImage:[UIImage imageNamed:@"settingsgear.png"] forState:UIControlStateNormal];
    [button addTarget:self action:@selector(settingsButton:)forControlEvents:UIControlEventTouchUpInside];
    [button setFrame:CGRectMake(0, 0, 31, 31)];
    
    UIBarButtonItem *barButton = [[UIBarButtonItem alloc] initWithCustomView:button];
    self.navigationItem.rightBarButtonItem = barButton;
    
//    // Item priority
//    UISegmentedControl *prioritySegmentedControl = [[UISegmentedControl alloc] initWithItems:[NSArray arrayWithObjects:@"Just Browsing", @"Need It Soon", nil]];
//    prioritySegmentedControl.frame = CGRectMake(25, 330, 200, 25);
//    prioritySegmentedControl.center = CGPointMake(160.0, 190.0);// for center
//    prioritySegmentedControl.selectedSegmentIndex = 0;
//    prioritySegmentedControl.tintColor = [UIColor blueColor];
//    [prioritySegmentedControl addTarget:self action:@selector(priorityValueChanged:) forControlEvents: UIControlEventValueChanged];
//    [self.view addSubview:prioritySegmentedControl];
    
    
    [self.nextButtonOutlet addTarget:self action:@selector(nextButton:) forControlEvents:UIControlEventTouchUpInside];
    // Do any additional setup after loading the view.
}


- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    for (UIView * txt in self.view.subviews){
        if ([txt isKindOfClass:[UITextField class]] && [txt isFirstResponder]) {
            [txt resignFirstResponder];
        }
    }
}


- (void)viewDidAppear:(BOOL)animated
{
    _nextButtonOutlet.userInteractionEnabled = YES;
    self.itemPriority = @"Low";
    NSLog(@"prioritay:'%@'", self.itemPriority);
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)settingsButton:(id)sender
{
    [self performSegueWithIdentifier:@"CriteriaSettingsSegue" sender:self];
    NSLog(@"OH YEAAAAA");
}

//- (void)priorityValueChanged:(UISegmentedControl *)prioritySegmentedControl {
//    
//    if(prioritySegmentedControl.selectedSegmentIndex == 0)
//    {
//        self.itemPriority = @"Low";
//    }
//    else if(prioritySegmentedControl.selectedSegmentIndex == 1)
//    {
//        self.itemPriority = @"High";
//    }
//    
//    NSLog(@"prioritay:'%@'", self.itemPriority);
//}

- (IBAction)priorityValuechanged:(id)sender {
    if(_itemPrioritySegment.selectedSegmentIndex == 0)
    {
        self.itemPriority = @"Low";
    }
    else if(_itemPrioritySegment.selectedSegmentIndex == 1)
    {
        self.itemPriority = @"High";
    }
    
    NSLog(@"prioritay:'%@'", self.itemPriority);
}


- (IBAction)nextButton:(id)sender
{
    if (self.itemSearch.text.length > 0) {
        
        _nextButtonOutlet.userInteractionEnabled = NO;
        
        UIActivityIndicatorView *activityIndicator = [[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
        activityIndicator.center = CGPointMake(self.view.frame.size.width / 2.0, self.view.frame.size.height / 2.0);
        [self.view addSubview: activityIndicator];
        
        [activityIndicator startAnimating];
        
        [PFCloud callFunctionInBackground:@"eBayCategorySearch"
                           withParameters:@{@"item": self.itemSearch.text}
                                    block:^(NSDictionary *result, NSError *error) {
                                        NSLog(@"'%@'", result);
                                        
                                        // Parses results
                                        
                                        NSArray *resultArray = [result objectForKey:@"results"];
                                        
                                        // Number of Top Categories
                                        NSDictionary *dictionary0 = [resultArray objectAtIndex:0];
                                        NSNumber *numberOfTopCategories = [dictionary0 objectForKey:@"Number of top categories"];
                                        
                                        // Ids of the Top Categories
                                        NSDictionary *dictionary1 = [resultArray objectAtIndex:1];
                                        NSArray *topCategoryIdsArray = [dictionary1 objectForKey:@"Top category Ids"];
                                        
                                        // Names of the Top Categories
                                        NSDictionary *dictionary2 = [resultArray objectAtIndex:2];
                                        NSArray *topCategoryNamesArray = [dictionary2 objectForKey:@"Top category names"];
                                        
                                        // Number of Top Categories matching User Categories
                                        NSDictionary *dictionary3 = [resultArray objectAtIndex:3];
                                        NSNumber *numberOfMatches = [dictionary3 objectForKey:@"Number of matches"];
                                        
                                        
                                        
                                        // Condition of Matching Categories
                                        NSDictionary *dictionary5 = [resultArray objectAtIndex:5];
                                        _matchingCategoryCondition1 = [dictionary5 objectForKey:@"Matching Category Condition 1"];
                                        NSDictionary *dictionary6 = [resultArray objectAtIndex:6];
                                        _matchingCategoryCondition2 = [dictionary6 objectForKey:@"Matching Category Condition 2"];
                                        
                                        // Location of Matching Categories
                                        NSDictionary *dictionary7 = [resultArray objectAtIndex:7];
                                        _matchingCategoryLocation1 = [dictionary7 objectForKey:@"Matching Category Location 1"];
                                        NSDictionary *dictionary8 = [resultArray objectAtIndex:8];
                                        _matchingCategoryLocation2 = [dictionary8 objectForKey:@"Matching Category Location 2"];
                                        
                                        // Max Price of Matching Categories
                                        NSDictionary *dictionary9 = [resultArray objectAtIndex:9];
                                        _matchingCategoryMaxPrice1 = [dictionary9 objectForKey:@"Matching Category MaxPrice 1"];
                                        NSDictionary *dictionary10 = [resultArray objectAtIndex:10];
                                        _matchingCategoryMaxPrice2 = [dictionary10 objectForKey:@"Matching Category MaxPrice 2"];
                                        
                                        // Min Price of Matching Categories
                                        NSDictionary *dictionary11 = [resultArray objectAtIndex:11];
                                        _matchingCategoryMinPrice1 = [dictionary11 objectForKey:@"Matching Category MinPrice 1"];
                                        NSDictionary *dictionary12 = [resultArray objectAtIndex:12];
                                        _matchingCategoryMinPrice2 = [dictionary12 objectForKey:@"Matching Category MinPrice 2"];
                                        
                                        // CategoryId of Matching Categories
                                        NSDictionary *dictionary14 = [resultArray objectAtIndex:14];
                                        _matchingCategoryId1 = [dictionary14 objectForKey:@"Matching Category Id 1"];
                                        NSDictionary *dictionary15 = [resultArray objectAtIndex:15];
                                        _matchingCategoryId2 = [dictionary15 objectForKey:@"Matching Category Id 2"];
                                        
                                        // Category Name of Matching Categories
                                        NSDictionary *dictionary16 = [resultArray objectAtIndex:16];
                                        _matchingCategoryName1 = [dictionary16 objectForKey:@"Matching Category Name 1"];
                                        NSDictionary *dictionary17 = [resultArray objectAtIndex:17];
                                        _matchingCategoryName2 = [dictionary17 objectForKey:@"Matching Category Name 2"];
                                        
                                        
                                        
                                        // Defines where each topCategory name will come from
                                        self.topCategory1 = [topCategoryNamesArray objectAtIndex:0];
                                        if ([numberOfTopCategories intValue] == 2) {
                                            self.topCategory2 = [topCategoryNamesArray objectAtIndex:1];
                                        }
                                        
                                        // Defines where each topCategory ID will come from
                                        self.topCategoryId1 = [topCategoryIdsArray objectAtIndex:0];
                                        if ([numberOfTopCategories intValue] == 2) {
                                            self.topCategoryId2 = [topCategoryIdsArray objectAtIndex:1];
                                        }
                                        
                                        
                                        
                                        
                                        if (!error) {
                                            
                                            // Decides which segue is taken based on results
                                            
                                            [activityIndicator stopAnimating];
                                            
                                            // if 1 match found
                                            if ([numberOfMatches intValue] == 1 ){
                                                
                                                UIViewController *toViewController = [self.tabBarController viewControllers][1];
                                                if ([toViewController isKindOfClass:[MatchCenterViewController class]]) {
                                                    MatchCenterViewController *matchViewController = (MatchCenterViewController *)toViewController;
                                                    
                                                    matchViewController.didAddNewItem = YES;
                                                    
                                                    // Send over the matching item criteria
                                                    matchViewController.itemSearch = self.itemSearch.text;
                                                    matchViewController.matchingCategoryId = self.matchingCategoryId1;
                                                    matchViewController.matchingCategoryMinPrice = self.matchingCategoryMinPrice1;
                                                    matchViewController.matchingCategoryMaxPrice = self.matchingCategoryMaxPrice1;
                                                    matchViewController.matchingCategoryCondition = self.matchingCategoryCondition1;
                                                    matchViewController.matchingCategoryLocation = self.matchingCategoryLocation1;
                                                    matchViewController.itemPriority = self.itemPriority;
                                                    
                                                    NSLog(@"alright they're set, time to switch");

                                                }
                                                [self.tabBarController setSelectedIndex:1];
                                                
                                                //[self performSegueWithIdentifier:@"ShowMatchCenterSegue" sender:self];
                                            }
                                            
                                            // if 2 matches found
                                            else if ([numberOfMatches intValue] == 2){
                                                [self performSegueWithIdentifier:@"ShowUserCategoryChooserSegue" sender:self];
                                            }
                                            
                                            // if no matches found, and 1 top category is returned
                                            else if ([numberOfMatches intValue] == 0 && [numberOfTopCategories intValue] == 1) {
                                                [self performSegueWithIdentifier:@"ShowCriteriaSegue" sender:self];
                                            }
                                            
                                            // if no matches are found, and 2 top categories are returned
                                            else if ([numberOfMatches intValue] == 0 && [numberOfTopCategories intValue] == 2) {
                                                [self performSegueWithIdentifier:@"ShowSearchCategoryChooserSegue" sender:self];
                                            }
                                            
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






#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"ShowMatchCenterSegue"]) {
        
//        MatchCenterViewController *controller = (MatchCenterViewController *) segue.destinationViewController;
//        
//        self.didAddNewItem = 1;
//        controller.didAddNewItem = self.didAddNewItem;
//        
//        NSLog(@"we're about to set controller values before segueing to MC");
//        // Send over the matching item criteria
//        controller.itemSearch = self.itemSearch.text;
//        controller.matchingCategoryId = self.matchingCategoryId1;
//        controller.matchingCategoryMinPrice = self.matchingCategoryMinPrice1;
//        controller.matchingCategoryMaxPrice = self.matchingCategoryMaxPrice1;
//        controller.matchingCategoryCondition = self.matchingCategoryCondition1;
//        controller.matchingCategoryLocation = self.matchingCategoryLocation1;
//        controller.itemPriority = self.itemPriority;
//        
//        NSLog(@"alright they're set, time to switch");
//        
//        [NSThread sleepForTimeInterval:1];
//        [self.tabBarController setSelectedIndex:1];
    }
    
    else if([segue.identifier isEqualToString:@"ShowSearchCategoryChooserSegue"]){
        
        SearchCategoryChooserViewController *controller = (SearchCategoryChooserViewController *) segue.destinationViewController;
        
        // Send over the search query as well as both categories to the Category Chooser VC
        controller.itemSearch = self.itemSearch.text;
        controller.itemPriority = self.itemPriority;
        controller.topCategory1 = self.topCategory1;
        controller.topCategory2 = self.topCategory2;
        controller.topCategoryId1 = self.topCategoryId1;
        controller.topCategoryId2 = self.topCategoryId2;
        
    }
    
    else if([segue.identifier isEqualToString:@"ShowCriteriaSegue"]){
    
        CriteriaViewController *controller = (CriteriaViewController *) segue.destinationViewController;
        
        // Send over the search query as well as the specific category to CriteriaVC to use
        controller.itemSearch = self.itemSearch.text;
        controller.itemPriority = self.itemPriority;
        controller.chosenCategory = self.topCategoryId1;
        controller.chosenCategoryName = self.topCategory1;
    }
    
    
    else if([segue.identifier isEqualToString:@"ShowUserCategoryChooserSegue"]){
        
        UserCategoryChooserViewController *controller = (UserCategoryChooserViewController *) segue.destinationViewController;
        
        // Send over the search query as well as both categories to the Category Chooser VC
        
        controller.itemSearch = self.itemSearch.text;
        controller.itemPriority = self.itemPriority;
        
        controller.matchingCategoryName1 = self.matchingCategoryName1;
        controller.matchingCategoryName2 = self.matchingCategoryName2;
        
        controller.matchingCategoryId1 = self.matchingCategoryId1;
        controller.matchingCategoryId2 = self.matchingCategoryId2;
        
        controller.matchingCategoryMinPrice1 = self.matchingCategoryMinPrice1;
        controller.matchingCategoryMinPrice2 = self.matchingCategoryMinPrice2;
        
        controller.matchingCategoryMaxPrice1 = self.matchingCategoryMaxPrice1;
        controller.matchingCategoryMaxPrice2 = self.matchingCategoryMaxPrice2;
        
        controller.matchingCategoryCondition1 = self.matchingCategoryCondition1;
        controller.matchingCategoryCondition2 = self.matchingCategoryCondition2;
        
        controller.matchingCategoryLocation1 = self.matchingCategoryLocation1;
        controller.matchingCategoryLocation2 = self.matchingCategoryLocation2;
    }

}


@end
