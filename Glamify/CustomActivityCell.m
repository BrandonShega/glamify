//
//  CustomActivityCell.m
//  Glamify
//
//  Created by Brandon Shega on 12/18/14.
//  Copyright (c) 2014 Brandon Shega. All rights reserved.
//

#import "CustomActivityCell.h"

@implementation CustomActivityCell

@synthesize userImage, activityStatus, cardView;

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)layoutSubviews {
    
    userImage.clipsToBounds = YES;
    userImage.layer.cornerRadius = userImage.frame.size.width / 2;
    
    self.cardView.layer.shadowOffset = CGSizeMake(1, 1);
    self.cardView.layer.shadowColor = [[UIColor blackColor] CGColor];
    self.cardView.layer.shadowRadius = 4.0f;
    self.cardView.layer.shadowOpacity = 0.80f;
    self.cardView.layer.shadowPath = [[UIBezierPath bezierPathWithRect:self.cardView.layer.bounds] CGPath];
    
}

- (void)setLabel:(NSString *)label andImage:(UIImage *)image
{
    
    [activityStatus setText:label];
    [userImage setImage:image];
    
}

@end
