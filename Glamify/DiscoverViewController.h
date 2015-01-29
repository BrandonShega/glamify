//
//  DiscoverViewController.h
//  Glamify
//
//  Created by Brandon Shega on 1/10/15.
//  Copyright (c) 2015 Brandon Shega. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>
#import "GlamButton.h"
#import <ParseUI/ParseUI.h>

@interface DiscoverViewController : UIViewController

@property (weak, nonatomic) IBOutlet UIScrollView *photoView;

- (void)loadGlams;

- (void)loadImages:(NSArray *)images;

- (void)imageClicked:(GlamButton *)sender;

@property (weak, nonatomic) IBOutlet UISearchBar *discoverSearch;
@property (weak, nonatomic) IBOutlet UISegmentedControl *searchType;

@end
