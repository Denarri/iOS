//
//  MatchCenterCell.m
//  Denarri
//
//  Created by Andrew Ghobrial on 11/11/14.
//  Copyright (c) 2014 Juan Figuera. All rights reserved.
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
    CGRect cvf = self.contentView.frame;
    self.imageView.frame = CGRectMake(0.0,
                                      0.0,
                                      cvf.size.height-1,
                                      cvf.size.height-1);
    self.imageView.contentMode = UIViewContentModeScaleAspectFit;
    
    CGRect frame = CGRectMake(cvf.size.height + 5,
                              self.textLabel.frame.origin.y-10,
                              cvf.size.width - cvf.size.height - 2*1,
                              self.textLabel.frame.size.height);
    self.textLabel.frame = frame;
    
    frame = CGRectMake(cvf.size.height + 5,
                       self.detailTextLabel.frame.origin.y-8,
                       cvf.size.width - cvf.size.height - 2*1,
                       self.detailTextLabel.frame.size.height);
    self.detailTextLabel.frame = frame;
    
    frame = CGRectMake(cvf.size.height + 5,
                       self.bestMatchLabel.frame.origin.y,
                       cvf.size.width - cvf.size.height - 2*1,
                       self.bestMatchLabel.frame.size.height);
    self.bestMatchLabel.frame = frame;
    
}

@end
