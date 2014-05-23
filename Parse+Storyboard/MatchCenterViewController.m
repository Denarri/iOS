//
//  Denarri iOS App
//
//  Created by Andrew Ghobrial and Chris Meseha on 03/01/14.
//  Copyright (c) 2014 Denarri. All rights reserved.
//

#import "MatchCenterViewController.h"
#import <UIKit/UIKit.h>

@interface MatchCenterViewController () <UITableViewDataSource, UITableViewDelegate>


@property (weak, nonatomic) IBOutlet UITableView *matchCenter;
@property (strong, nonatomic) NSArray *itemsArray;

@end

@implementation MatchCenterViewController


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
    
    //perform search with criteria just submitted
        [PFCloud callFunctionInBackground:@"eBayMatchCenterSearch"
                           withParameters:@{@"item": self.itemSearch,
                                            @"minPrice": @"250",
                                            @"maxPrice": @"400",
                                            @"itemCondition": @"New",
//                                            @"itemLocation": @"US",
                                            }
                                    block:^(NSString *result, NSError *error) {
    
                                        if (!error) {
                                            NSLog(@"The result is '%@'", result);
                                        }
                                    }];
    
    
    
    
//    //1
//    self.matchCenter.dataSource = self;
//    //2
//    self.itemsArray = [[NSArray alloc] initWithObjects:
//                       @"iPhone 5 16GB",
//                       @"iPhone 5 16GB",
//                       @"iPhone 5 16GB",
//                       nil];
    
    
    
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
 {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */










//-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
//    return [self.itemsArray count];
//}
//
//-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
//    //5
//    static NSString *cellIdentifier = @"SettingsCell";
//    
//    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
//    
//    //5.1 you do not need this if you have set SettingsCell as identifier in the storyboard (else you can remove the comments on this code)
//    //    if (cell == nil)
//    //        {
//    //            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellIdentifier];
//    //       }
//    
//    //6
//    NSString *item = [self.itemsArray objectAtIndex:indexPath.row];
//    //7
//    [cell.textLabel setText:item];
//    [cell.detailTextLabel setText:@"$350"];
//    cell.imageView.image = [UIImage imageNamed:@"iPhone 5.jpg"];
//    
//    
//    
//    
//    
//    
//    
////    NSURL *url=[NSURL URLWithString:[self.aryImageUrl objectAtIndex:[indexPath row]]];
////    NSURLRequest *req=[NSURLRequest requestWithURL:url];
////    [NSURLConnection sendAsynchronousRequest:req queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *err) {
////        celltbl.imageView.image=[UIImage imageWithData:data];
////    }];
////    
//    
//    
//    
//    
//    
//    
//    
//    
//    return cell;
//}




@end