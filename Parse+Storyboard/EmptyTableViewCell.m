//
//  EmptyTableViewCell.m
//  Denarri
//
//  Created by Andrew Ghobrial on 11/16/14.
//  Copyright (c) 2014 Juan Figuera. All rights reserved.
//

#import "EmptyTableViewCell.h"

@implementation EmptyTableViewCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void) layoutSubviews {
    [super layoutSubviews];
    self.imageView.frame = CGRectMake(0.0,
                                      0.0,
                                      0,
                                      0);
    self.imageView.contentMode = UIViewContentModeScaleAspectFit;
}

@end
