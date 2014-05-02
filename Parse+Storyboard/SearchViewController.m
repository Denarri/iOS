//
//  Denarri iOS App
//
//  Created by Andrew Ghobrial and Chris Meseha on 03/01/14.
//  Copyright (c) 2014 Denarri. All rights reserved.
//

#import "SearchViewController.h"

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
                                    block:^(NSString *result, NSError *error) {
                                        NSLog(@"'%@'", result);
                                        
                                        NSData *returnedJSONData = result;
                                        
                                            NSError *jsonerror = nil;
                                        
                                            NSDictionary *categoryData = [NSJSONSerialization
                                                                     JSONObjectWithData:returnedJSONData
                                                                     options:0
                                                                     error:&jsonerror];
//                                            
//                                            if(error) { NSLog(@"JSON was malformed."); }
//                                            
//                                            // validation that it's a dictionary:
//                                            if([categoryData isKindOfClass:[NSDictionary class]])
//                                            {
//                                                NSDictionary *jsonresults = categoryData;
//                                                /* proceed with jsonresults */
//                                            }
//                                            else
//                                            {
//                                                NSLog(@"JSON dictionary wasn't returned.");
//                                            }
                                        
         
                                        
                                        if (!error) {
                                            
                                            
                                            // if 1 match found clear categoryResults and top2 array
                                            if ([[categoryData objectForKey:@"Number of matches"]  isEqual: @"1"]){
                                                [self performSegueWithIdentifier:@"ShowMatchCenterSegue" sender:self];
                                            }
                                            
                                            // if 2 matches found
                                            else if ([[categoryData objectForKey:@"Number of matches"]  isEqual: @"2"]){
                                                [self performSegueWithIdentifier:@"ShowUserCategoryChooserSegue" sender:self];
                                                //default to selected categories criteria  -> send to matchcenter -> clear categoryResults and top2 array
                                            }
                                            
                                            // if no matches found, and 1 top category is returned
                                            else if ([[categoryData objectForKey:@"Number of matches"]  isEqual: @"0"] && [[categoryData objectForKey:@"Number of top categories"]  isEqual: @"1"]) {
                                                [self performSegueWithIdentifier:@"ShowCriteriaSegue" sender:self];
                                            }
                                            // if no matches are found, and 2 top categories are returned
                                            else if ([[categoryData objectForKey:@"Number of matches"]  isEqual: @"0"] && [[categoryData objectForKey:@"Number of top categories"]  isEqual: @"2"]) {
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
    if([segue.identifier isEqualToString:@"ShowCriteriaSegue"]){
        CriteriaViewController *controller = (CriteriaViewController *) segue.destinationViewController;
        controller.itemSearch.text = self.itemSearch.text;
        }

    
}






@end
