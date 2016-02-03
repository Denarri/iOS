//
//  MCExpandedCell.h
//  Denarri
//
//  Created by Andrew Ghobrial on 11/11/14.
//  Copyright (c) 2014 Juan Figuera. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface MCExpandedCell : UITableViewCell

@property (strong, nonatomic) IBOutlet UILabel *titleLabel;
@property (strong, nonatomic) IBOutlet UILabel *bestMatchLabel;
@property (strong, nonatomic) IBOutlet UILabel *conditionLabel;


@end
