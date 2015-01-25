//
//  ProfileViewController.h
//  Glamify
//
//  Created by Brandon Shega on 12/18/14.
//  Copyright (c) 2014 Brandon Shega. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>
#import <Parse/Parse.h>

@interface ProfileViewController : UIViewController

@property (weak, nonatomic) IBOutlet UIImageView *profileImage;
- (IBAction)settingsButton:(id)sender;
@property (weak, nonatomic) IBOutlet UIScrollView *glamScrollView;

@property (weak, nonatomic) PFUser *user;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *profileButton;
@property (weak, nonatomic) IBOutlet UINavigationBar *navBar;
@property (weak, nonatomic) IBOutlet UILabel *likeCounter;
@property (weak, nonatomic) IBOutlet UILabel *followerCounter;
@property (weak, nonatomic) IBOutlet UILabel *followingCounter;
@property (weak, nonatomic) IBOutlet UILabel *commentCounter;
@property (weak, nonatomic) IBOutlet UILabel *glamCounter;
@property (weak, nonatomic) IBOutlet UIButton *followButton;
@property (weak, nonatomic) IBOutlet UILabel *followLabel;

- (IBAction)followUser:(id)sender;
@end
