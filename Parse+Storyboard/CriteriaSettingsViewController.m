//
//  CriteriaSettingsViewController.m
//  Denarri
//
//  Created by Andrew Ghobrial on 9/22/14.
//

#import "CriteriaSettingsViewController.h"

@interface CriteriaSettingsViewController () <UITableViewDataSource, UITableViewDelegate>
@property (nonatomic, strong) UITableView *criteriaSettingsTable;

@end

@implementation CriteriaSettingsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    
    
    self.criteriaSettingsTable = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewCellStyleDefault];
    self.criteriaSettingsTable.frame = CGRectMake(0,50,320,self.view.frame.size.height-100);
    _criteriaSettingsTable.dataSource = self;
    _criteriaSettingsTable.delegate = self;
    [self.view addSubview:self.criteriaSettingsTable];
    
    _criteriaSettingsArray = [[NSArray alloc] init];
}

- (void)viewDidAppear:(BOOL)animated
{
    self.criteriaSettingsArray = [[NSArray alloc] init];
    
    // Disable ability to scroll until table is MatchCenter table is done loading
    self.criteriaSettingsTable.scrollEnabled = NO;
    
    [PFCloud callFunctionInBackground:@""
                       withParameters:@{}
                                block:^(NSArray *result, NSError *error) {
                                    
                                    if (!error) {
                                        _criteriaSettingsArray = result;
                                        [_criteriaSettingsTable reloadData];
                                        self.criteriaSettingsTable.scrollEnabled = YES;
                                        NSLog(@"Result: '%@'", result);
                                    }
                                }];

}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 3;
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
    cell.textLabel.text = [NSString stringWithFormat:@"taameya"];
    cell.textLabel.font = [UIFont boldSystemFontOfSize:14];
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    
    return cell;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)criteriaSettingsDone:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
