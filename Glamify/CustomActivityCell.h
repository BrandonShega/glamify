//
//  CustomActivityCell.h
//  Glamify
//
//  Created by Brandon Shega on 12/18/14.
//  Copyright (c) 2014 Brandon Shega. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>

@interface CustomActivityCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *userImage;
@property (weak, nonatomic) IBOutlet UILabel *activityStatus;
@property (weak, nonatomic) IBOutlet UIView *cardView;

- (void)setLabel:(NSString *)label andImage:(UIImage *)image;

@end
