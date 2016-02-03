//
//  MatchCenterCell.m
//  Denarri
//
//  Created by Andrew Ghobrial on 2/2/16.
//  Copyright © 2016 Juan Figuera. All rights reserved.
//

#import "MatchCenterCell.h"

@implementation MatchCenterCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.bestMatchLabel  = [[ UILabel alloc]initWithFrame:CGRectMake(90, 35, 70, 40)];
    }
    return self;
}

- (void) layoutSubviews {
    [super layoutSubviews];
    
    self.imageView.frame = CGRectMake(0.0,
                                      0.0,
                                      0.0,
                                      0.0);
    self.imageView.contentMode = UIViewContentModeScaleAspectFit;
    
}

@end

