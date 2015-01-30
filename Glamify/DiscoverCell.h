//
//  DiscoverCell.h
//  Glamify
//
//  Created by Brandon Shega on 12/18/14.
//  Copyright (c) 2014 Brandon Shega. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DiscoverCell : UICollectionViewCell

@property (weak, nonatomic) IBOutlet UIImageView *discoverImage;

- (void)setImage:(UIImage *) image;

@end
