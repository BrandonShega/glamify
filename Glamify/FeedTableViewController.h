//
//  FeedTableViewController.h
//  Glamify
//
//  Created by Brandon Shega on 1/28/15.
//  Copyright (c) 2015 Brandon Shega. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>
#import <ParseUI/ParseUI.h>

@interface FeedTableViewController : PFQueryTableViewController

@property (weak, nonatomic) NSString *glamId;
@property(nonatomic, assign) BOOL reloadOnAppear;

@end
