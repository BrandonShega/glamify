//
//  FavoriteButton.h
//  Glamify
//
//  Created by Brandon Shega on 1/15/15.
//  Copyright (c) 2015 Brandon Shega. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>

@interface FavoriteButton : UIButton

@property NSString *glamId;
@property PFUser *toUser;

@end
