//
//  DiscoverViewController.h
//  Glamify
//
//  Created by Brandon Shega on 1/10/15.
//  Copyright (c) 2015 Brandon Shega. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>

@interface DiscoverViewController : UIViewController

@property (weak, nonatomic) IBOutlet UIScrollView *photoView;

- (void)loadGlams;

- (void)loadImages:(NSArray *)images;

@end
