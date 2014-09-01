//
//  Denarri iOS App
//
//  Created by Andrew Ghobrial and Chris Meseha on 03/01/14.
//  Copyright (c) 2014 Denarri. All rights reserved.
//

#import "SearchCategoryChooserViewController.h"
#import "SearchViewController.h"
#import "CriteriaViewController.h"

@interface SearchCategoryChooserViewController ()

@end

@implementation SearchCategoryChooserViewController

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
    
    self.navigationItem.title = @"Categories";
    
    UIButton *category1 = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    category1.frame = CGRectMake(10, 120, 300, 35);
    [category1 setTitle: [NSString stringWithFormat:@"%@", self.topCategory1] forState:UIControlStateNormal];
    [category1 addTarget:self action:@selector(category1ButtonClick:)    forControlEvents:UIControlEventTouchUpInside];
    category1.tag = 1;
    [self.view addSubview: category1];
    
    
    UIButton *category2 = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    category2.frame = CGRectMake(10, 180, 300, 35);
    [category2 setTitle: [NSString stringWithFormat:@"%@", self.topCategory2] forState:UIControlStateNormal];
    [category2 addTarget:self action:@selector(category2ButtonClick:)    forControlEvents:UIControlEventTouchUpInside];
    category1.tag = 2;
    [self.view addSubview: category2];
    
    
}



- (IBAction)category1ButtonClick:(id)sender

{
    self.chosenCategory = self.topCategoryId1;
    self.chosenCategoryName = self.topCategory1;
    [self performSegueWithIdentifier:@"CategoryChooserToCriteriaSegue" sender:nil];
}

- (IBAction)category2ButtonClick:(id)sender

{
    self.chosenCategory = self.topCategoryId2;
    self.chosenCategoryName = self.topCategory2;
    [self performSegueWithIdentifier:@"CategoryChooserToCriteriaSegue" sender:nil];
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - Navigation

// Send the Category Id over to CriteriaViewController
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
 
 CriteriaViewController *controller = (CriteriaViewController *) segue.destinationViewController;
 
 // Send over the search query as well as the specific category to CriteriaVC to use
 controller.chosenCategory = self.chosenCategory;
 controller.chosenCategoryName = self.chosenCategoryName;
 controller.itemSearch = self.itemSearch;
    
    
    
}


@end
