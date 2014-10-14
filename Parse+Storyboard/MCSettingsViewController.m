//
//  MCSettingsViewController.m
//  Denarri
//
//  Created by Andrew Ghobrial on 9/22/14.
//

#import "MCSettingsViewController.h"

@interface MCSettingsViewController () <UITableViewDataSource, UITableViewDelegate>
@property (nonatomic, strong) UITableView *mcSettingsTable;

@end

@implementation MCSettingsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UIActivityIndicatorView *activityIndicator = [[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    activityIndicator.center = CGPointMake(self.view.frame.size.width / 2.0, self.view.frame.size.height / 2.0);
    [self.view addSubview: activityIndicator];
    
    [activityIndicator startAnimating];
    
    self.mcSettingsTable = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewCellStyleDefault];
    self.mcSettingsTable.frame = CGRectMake(0,50,320,self.view.frame.size.height-100);
    _mcSettingsTable.dataSource = self;
    _mcSettingsTable.delegate = self;
    [self.view addSubview:self.mcSettingsTable];
    
    _mcSettingsArray = [[NSArray alloc] init];
    
    [PFCloud callFunctionInBackground:@"mcSettings"
                       withParameters:@{}
                                block:^(NSArray *result, NSError *error) {
                                    
                                    if (!error) {
                                        _mcSettingsArray = result;
                                        
                                        [activityIndicator stopAnimating];
                                        
                                        [_mcSettingsTable reloadData];
                                        self.mcSettingsTable.scrollEnabled = YES;
                                        NSLog(@"Result: '%@'", result);
                                    }
                                }];

}

- (void)viewDidAppear:(BOOL)animated
{
//    self.mcSettingsArray = [[NSArray alloc] init];
    
    // Disable ability to scroll until table is MatchCenter table is done loading
//    self.mcSettingsTable.scrollEnabled = NO;
    
//    [PFCloud callFunctionInBackground:@"mcSettings"
//                       withParameters:@{}
//                                block:^(NSArray *result, NSError *error) {
//                                    
//                                    if (!error) {
//                                        _mcSettingsArray = result;
//                                        [_mcSettingsTable reloadData];
//                                        self.mcSettingsTable.scrollEnabled = YES;
//                                        NSLog(@"Result: '%@'", result);
//                                    }
//                                }];

}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _mcSettingsArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (!cell) {
        // if no cell could be dequeued create a new one
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
    }
    
    // No cell seperators = clean design
    tableView.separatorColor = [UIColor clearColor];
    
    // title of the item
    
    PFObject *item = _mcSettingsArray[indexPath.row];
    NSString *searchTerm = item[@"searchTerm"];
    cell.textLabel.text = searchTerm;
    
    cell.textLabel.font = [UIFont boldSystemFontOfSize:14];
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    self.minPrice = _mcSettingsArray[indexPath.row][@"minPrice"];
    self.maxPrice = _mcSettingsArray[indexPath.row][@"maxPrice"];
    self.itemCondition = _mcSettingsArray[indexPath.row][@"itemCondition"];
    self.itemLocation = _mcSettingsArray[indexPath.row][@"itemLocation"];
    self.searchTerm = _mcSettingsArray[indexPath.row][@"searchTerm"];
    self.itemPriority = _mcSettingsArray[indexPath.row][@"itemPriority"];
    
    [self performSegueWithIdentifier:@"MCSettingsToMCFormSegue" sender:self];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)mcSettingsDone:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}



#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    MCSettingsFormViewController *controller = (MCSettingsFormViewController *) segue.destinationViewController;
    
    controller.searchTerm = self.searchTerm;
    controller.minPrice = self.minPrice;
    controller.maxPrice = self.maxPrice;
    controller.itemCondition = self.itemCondition;
    controller.itemLocation = self.itemLocation;
    controller.itemPriority = self.itemPriority;
}


@end
