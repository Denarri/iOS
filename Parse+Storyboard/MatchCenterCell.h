//
//  MatchCenterCell.h
//  Denarri
//
//  Created by Andrew Ghobrial on 2/2/16.
//  Copyright © 2016 Juan Figuera. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MatchCenterCell : UITableViewCell

@property (strong, nonatomic) IBOutlet UILabel *titleLabel;
@property (strong, nonatomic) IBOutlet UILabel *bestMatchLabel;
@property (strong, nonatomic) IBOutlet UILabel *conditionLabel;

@end
