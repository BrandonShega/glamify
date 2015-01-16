//
//  CustomCell.m
//  Glamify
//
//  Created by Brandon Shega on 12/18/14.
//  Copyright (c) 2014 Brandon Shega. All rights reserved.
//

#import "CustomCell.h"

@implementation CustomCell

@synthesize glamImage, glamName, glamNameString, headerView;

- (id)init
{
    
    self = [super init];
    
    if (self) {
        
        
        
    }
    
    return self;
    
}

- (void)layoutSubviews
{
    
    [super layoutSubviews];
    
    self.headerView.layer.masksToBounds = YES;
    self.headerView.layer.shadowColor = (__bridge CGColorRef)([UIColor blackColor]);
    self.headerView.layer.shadowOffset = CGSizeMake(304, 60);
    self.headerView.layer.shadowRadius = 20;
    self.headerView.layer.shadowOpacity = 0.5;
    self.headerView.backgroundColor = [UIColor redColor];
    
}

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setLabel:(NSString *)nameString andImage:(UIImage *)image
{
    [glamName setText:nameString];
    
    [glamImage setImage:image];
}

@end
