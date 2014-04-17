//
//  Parse+Storyboard
//
//  Created by Andrew Ghobrial and Chris Meseha on 03/01/14.
//  Copyright (c) 2014 Denarri. All rights reserved.
//

#import "CriteriaViewController.h"

@interface CriteriaViewController ()
@property (weak, nonatomic) IBOutlet UITextField *minPrice;
@property (weak, nonatomic) IBOutlet UITextField *maxPrice;
@property (weak, nonatomic) IBOutlet UISegmentedControl *itemCondition;
@property (weak, nonatomic) IBOutlet UISegmentedControl *itemLocation;
@property (weak, nonatomic) IBOutlet UIButton *submitButton;


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
    
}



- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


// Grabs previously searched item, sends criteria over to ebay


- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if (sender != self.submitButton) return;
    if ((self.minPrice.text.length > 0) && (self.maxPrice.text.length > 0)) {
        
        // Every userCategory object associated with a particular user
        PFObject *userCategory= [PFObject objectWithClassName:@"userCategory"];
        [userCategory setObject:[PFUser currentUser] forKey:@"createdBy"];
        
        
        // Every price/condition/location object associated with a particular user
        
        
        userCategory[@"categoryId"] = @1234567;
        userCategory[@"minPrice"] = @200;
        userCategory[@"maxPrice"] = @250;
        userCategory[@"itemCondition"] = @"Any";
        userCategory[@"itemLocation"] = @"Worldwide";
        [userCategory saveInBackground];
        
        
    }
    
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    
}


@end
