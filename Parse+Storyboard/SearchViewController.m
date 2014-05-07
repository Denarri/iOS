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

@property (weak, nonatomic) IBOutlet UITextField *itemSearch;
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
                                        
                                                // Names of the Top Categories
                                                NSDictionary *dictionary1 = [resultArray objectAtIndex:1];
                                                NSArray *topCategoriesArray = [dictionary1 objectForKey:@"Top categories"];
                                        
                                                // Number of Top Categories matching User Categories
                                                NSDictionary *dictionary2 = [resultArray objectAtIndex:2];
                                                NSNumber *numberOfMatches = [dictionary2 objectForKey:@"Number of matches"];
                                        
                                                // Names of Top Categories matching User Categories
                                                NSDictionary *dictionary3 = [resultArray objectAtIndex:3];
                                                NSArray *userCategoriesThatMatchSearch = [dictionary3 objectForKey:@"User categories that match search"];
                                        
                                                // Defines where each topCategory ID will come from
                                                self.topCategory1 = [topCategoriesArray objectAtIndex:0];
                                            if ([numberOfTopCategories intValue] == 2) {
                                                self.topCategory2 = [topCategoriesArray objectAtIndex:1];
                                            }
                                       
                                        if (!error) {
                                        
                                        // Decides which segue is taken based on results
                                            
                                            // if 1 match found clear categoryResults and top2 array
                                            if ([numberOfMatches intValue] == 1 ){
                                                [self performSegueWithIdentifier:@"ShowMatchCenterSegue" sender:self];
                                            }
                                            
                                            // if 2 matches found
                                            else if ([numberOfMatches intValue] == 2){
                                                [self performSegueWithIdentifier:@"ShowUserCategoryChooserSegue" sender:self];
                                                //default to selected categories criteria  -> send to matchcenter -> clear categoryResults and top2 array
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
        
        // Send over the search query
        controller.itemSearch.text = self.itemSearch.text;
    }
    
    
    else if([segue.identifier isEqualToString:@"ShowSearchCategoryChooserSegue"]){
        
        SearchCategoryChooserViewController *controller = (SearchCategoryChooserViewController *) segue.destinationViewController;
        
        // Send over the search query as well as both categories to the Category Chooser VC
        controller.itemSearch.text = self.itemSearch.text;
        controller.topCategory1=self.topCategory1;
        controller.topCategory2=self.topCategory2;
    }
    
    else if([segue.identifier isEqualToString:@"ShowCriteriaSegue"]){
        
        CriteriaViewController *controller = (CriteriaViewController *) segue.destinationViewController;
        
        // Send over the search query as well as the specific category to CriteriaVC to use
        controller.itemSearch.text = self.itemSearch.text;
        controller.topCategory1=self.topCategory1;
    }
    

    
}






@end
