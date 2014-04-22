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
                                        if (!error) {
                                            NSLog(@"The result is '%@'", result);
                                            
                                            if ([result intValue] == 1) {
                                                [self performSegueWithIdentifier:@"ShowMatchCenterSegue" sender:self];
                                            } else {
                                                [self performSegueWithIdentifier:@"ShowCriteriaSegue" sender:self];
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
        controller.itemSearch = self.itemSearch.text;
        }

    
}






@end
