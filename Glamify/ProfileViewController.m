//
//  ProfileViewController.m
//  Glamify
//
//  Created by Brandon Shega on 12/18/14.
//  Copyright (c) 2014 Brandon Shega. All rights reserved.
//

#import "ProfileViewController.h"
#import "SettingsViewController.h"

@interface ProfileViewController () <SettingsDelegte>

@end

@implementation ProfileViewController

@synthesize profileImage, user, profileButton, navBar, likeCounter, followerCounter, followingCounter, commentCounter, glamCounter, followButton;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
}

- (BOOL)prefersStatusBarHidden
{
    return YES;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    //Check if we are passing a user in to view their profile as opposed to the current user's profile.
    if (!user) {
        
        user = [PFUser currentUser];
        
    }
    
    //show follow button if we are looking at another user's profile
    if (![user isEqual:[PFUser currentUser]]) {
        
        navBar.hidden = YES;
        followButton.hidden = NO;
        
    
    } else {
        
        navBar.hidden = NO;
        followButton.hidden = YES;
        
    }
    
    __block int followers = 0;
    __block int following = 0;
    __block int comments = 0;
    __block int favorites = 0;
    
    //get image from user and crop it to a circle
    profileImage.file = user[@"image"];
    [profileImage loadInBackground];
    
    profileImage.clipsToBounds = YES;
    profileImage.layer.cornerRadius = 200 / 2.0;
    
    NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
    
    //query to find all glams from a particular user
    PFQuery *glamQuery = [PFQuery queryWithClassName:@"Glam"];
    [glamQuery whereKey:@"user" equalTo:user];
    
    [glamQuery findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        
        if (!error) {
            
            //get count of user's glams
            NSNumber *glamCount = [NSNumber numberWithUnsignedInteger:[objects count]];
            glamCounter.text = [formatter stringFromNumber:glamCount];
            
        } else {
            
            NSLog(@"Error %@ %@", error, [error userInfo]);
            
        }
        
    }];
    
    //query to find all activities
    PFQuery *activityQuery = [PFQuery queryWithClassName:@"Activity"];
    
    [activityQuery findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        
        if (!error) {
        
            //loop through each activity to find out what kind it is and how it relates to the user
            for (PFObject *obj in objects) {
                
                NSString *ourUser = [[PFUser currentUser] objectId];
                NSString *currentUser = [user objectId];
                NSString *toUser = [obj[@"toUser"] objectId];
                NSString *fromUser = [obj[@"fromUser"] objectId];
                NSString *type = obj[@"type"];
                
                //comments
                if ([type isEqual:@"comment"] && [fromUser isEqual:currentUser]) {
                    
                    comments++;
                
                //follows
                } else if ([type  isEqual: @"follow"]) {
                    
                    if ([fromUser isEqual:currentUser]) {
                        
                        following++;
                        
                    } else if ([toUser isEqual:currentUser]) {
                        
                        followers++;
                        
                    }
                    
                    if ([toUser isEqual:currentUser] && [fromUser isEqual:ourUser]) {
                        
                        //are we following this user?
                        [followButton setTitle:@"Unfollow" forState:UIControlStateNormal];
                        NSLog(@"Unfollow");
                        
                    }
                   
                //favorites
                } else if ([type isEqual:@"favorite"]) {
                    
                    if ([toUser isEqual:currentUser] && [fromUser isEqual:ourUser]) {
                        
                        favorites++;
                        
                    }
                    
                }
                
            }
            
            //set labels to their respective counts
            likeCounter.text = [NSString stringWithFormat:@"%d", favorites];
            followerCounter.text = [NSString stringWithFormat:@"%d", followers];
            followingCounter.text = [NSString stringWithFormat:@"%d", following];
            commentCounter.text = [NSString stringWithFormat:@"%d", comments];
            
            
        } else  {
            
            NSLog(@"Error %@ %@", error, [error userInfo]);
            
        }
        
    }];
    
}

- (void)viewDidAppear:(BOOL)animated
{
    
    [super viewDidAppear:animated];
    
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (void)userLoggedOut {
    
    //user logged out so pop them back to the login screen
    [self.navigationController popToRootViewControllerAnimated:YES];
    
}

- (IBAction)settingsButton:(id)sender
{
 
    //open settings view controller
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    SettingsViewController *svc = [storyboard instantiateViewControllerWithIdentifier:@"Settings"];
    
    svc.delegate = self;
    
    [self presentViewController:svc animated:YES completion:nil];
    
}
- (IBAction)followUser:(id)sender
{
    //check if we are following this user, if we are, change the text to unfollow
    if ([followButton.titleLabel.text isEqual:@"Follow"]) {
    
        PFObject *activity = [PFObject objectWithClassName:@"Activity"];
        
        [activity setObject:[PFUser currentUser] forKey:@"fromUser"];
        [activity setObject:user forKey:@"toUser"];
        [activity setObject:@"follow" forKey:@"type"];
        
        [activity saveEventually];
        
        [followButton setTitle:@"Unfollow" forState:UIControlStateNormal];
        
    } else {
        
        PFQuery *activityQuery = [PFQuery queryWithClassName:@"Activity"];
        
        [activityQuery whereKey:@"type" equalTo:@"follow"];
        [activityQuery whereKey:@"fromUser" equalTo:[PFUser currentUser]];
        [activityQuery whereKey:@"toUser" equalTo:user];
        
        [activityQuery getFirstObjectInBackgroundWithBlock:^(PFObject *object, NSError *error) {
           
            [object deleteEventually];
            
        }];
        
        [followButton setTitle:@"Follow" forState:UIControlStateNormal];
        
    }
    
}
@end
