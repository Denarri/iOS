//
//  Denarri iOS App
//
//  Created by Andrew Ghobrial and Chris Meseha on 03/01/14.
//  Copyright (c) 2014 Denarri. All rights reserved.
//

#import "SearchViewController.h"
#import "MatchCenterViewController.h"
#import "SearchCategoryChooserViewController.h"

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
    [self.nextButtonOutlet addTarget:self action:@selector(nextButton:) forControlEvents:UIControlEventTouchUpInside];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}




- (IBAction)nextButton:(id)sender
{
    if (self.itemSearch.text.length > 0) {
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
                                        
                                                // Condition of Matching Category
                                                NSDictionary *dictionary5 = [resultArray objectAtIndex:5];
                                                _matchingCategoryCondition = [dictionary5 objectForKey:@"Matching Category Condition"];
                                        
                                                // Location of Matching Category
                                                NSDictionary *dictionary6 = [resultArray objectAtIndex:6];
                                                _matchingCategoryLocation = [dictionary6 objectForKey:@"Matching Category Location"];
                                        
                                                // Max Price of Matching Category
                                                NSDictionary *dictionary7 = [resultArray objectAtIndex:7];
                                                _matchingCategoryMaxPrice = [dictionary7 objectForKey:@"Matching Category MaxPrice"];
                                        
                                                // Min Price of Matching Category
                                                NSDictionary *dictionary8 = [resultArray objectAtIndex:8];
                                                _matchingCategoryMinPrice = [dictionary8 objectForKey:@"Matching Category MinPrice"];
                                        
                                                // CategoryId of Matching Category
                                                NSDictionary *dictionary10 = [resultArray objectAtIndex:10];
                                                _matchingCategoryId = [dictionary10 objectForKey:@"Matching Category Id"];
                                        
                                        
                        
                                        
                                        
                                        
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
                                            
                                            // if 1 match found
                                            if ([numberOfMatches intValue] == 1 ){
                                                [self performSegueWithIdentifier:@"ShowMatchCenterSegue" sender:self];
                                            }
                                            
                                            // if 2 matches found
                                            else if ([numberOfMatches intValue] == 2){
                                                [self performSegueWithIdentifier:@"ShowUserCategoryChooserSegue" sender:self];
                                                //default to selected categories criteria  -> send to matchcenter
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
}






#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{

    
    
    if ([segue.identifier isEqualToString:@"ShowMatchCenterSegue"]) {
        MatchCenterViewController *controller = (MatchCenterViewController *) segue.destinationViewController;
        
        
        // Add new item to MatchCenter Array with the criteria from the matching userCategory instance, plus the search term
        [PFCloud callFunctionInBackground:@"addToMatchCenter"
                           withParameters:@{
                                            @"searchTerm": self.itemSearch.text,
                                            @"categoryId": self.matchingCategoryId,
                                              @"minPrice": self.matchingCategoryMinPrice,
                                              @"maxPrice": self.matchingCategoryMaxPrice,
                                         @"itemCondition": self.matchingCategoryCondition,
                                          @"itemLocation": self.matchingCategoryLocation,
                                            }
                                    block:^(NSString *result, NSError *error) {
                                        
                                        if (!error) {
                                            NSLog(@"'%@'", result);
                                        }
                                    }];
        
        
        
        // Send over the matching item criteria
        controller.itemSearch = self.itemSearch.text;
        controller.matchingCategoryMinPrice = self.matchingCategoryMinPrice;
        controller.matchingCategoryMaxPrice = self.matchingCategoryMaxPrice;
        controller.matchingCategoryCondition = self.matchingCategoryCondition;
        controller.matchingCategoryLocation = self.matchingCategoryLocation;
    }
    
    
    else if([segue.identifier isEqualToString:@"ShowSearchCategoryChooserSegue"]){
        
        SearchCategoryChooserViewController *controller = (SearchCategoryChooserViewController *) segue.destinationViewController;
        
        // Send over the search query as well as both categories to the Category Chooser VC
        controller.itemSearch.text = self.itemSearch.text;
        controller.topCategory1 = self.topCategory1;
        controller.topCategory2 = self.topCategory2;
        controller.topCategoryId1 = self.topCategoryId1;
        controller.topCategoryId2 = self.topCategoryId2;
        
    }
    
    else if([segue.identifier isEqualToString:@"ShowCriteriaSegue"]){
        
        
        
        CriteriaViewController *controller = (CriteriaViewController *) segue.destinationViewController;
        
        // Send over the search query as well as the specific category to CriteriaVC to use
        controller.itemSearch = self.itemSearch.text;
        controller.chosenCategory = self.topCategoryId1;
    }
    
  
    
    
}






@end
