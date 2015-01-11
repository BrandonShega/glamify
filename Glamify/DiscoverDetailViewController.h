//
//  DiscoverDetailViewController.h
//  Glamify
//
//  Created by Brandon Shega on 1/10/15.
//  Copyright (c) 2015 Brandon Shega. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>

@interface DiscoverDetailViewController : UIViewController

@property (weak, nonatomic) NSString *glamId;

@property (weak, nonatomic) IBOutlet UIImageView *imageView;

@property (weak, nonatomic) IBOutlet UILabel *glamName;
@property (weak, nonatomic) IBOutlet UILabel *followLabel;
@property (weak, nonatomic) IBOutlet UIButton *followButton;

- (IBAction)followButton:(id)sender;
- (IBAction)doneButton:(id)sender;

@end
