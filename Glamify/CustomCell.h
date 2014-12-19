//
//  CustomCell.h
//  Glamify
//
//  Created by Brandon Shega on 12/18/14.
//  Copyright (c) 2014 Brandon Shega. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CustomCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *glamName;
@property (weak, nonatomic) IBOutlet UIImageView *glamImage;
@property (weak, nonatomic) NSString *glamNameString;

- (void)setLabel:(NSString *)label;

@end
