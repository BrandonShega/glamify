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

@synthesize profileImage, user, profileButton, navBar, likeCounter, followerCounter, followingCounter, commentCounter, glamCounter, followButton, followLabel;

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
    
    if (!user) {
        
        user = [PFUser currentUser];
        
    }
    
    if (![user isEqual:[PFUser currentUser]]) {
        
        navBar.hidden = YES;
        followLabel.hidden = YES;
        followButton.hidden = NO;
        
    
    } else {
        
        navBar.hidden = NO;
        followLabel.hidden = YES;
        followButton.hidden = YES;
        
    }
    
    __block int followers = 0;
    __block int following = 0;
    __block int comments = 0;
    __block int favorites = 0;
    
    PFFile *imageFile = user[@"image"];
    NSData *imageData = [imageFile getData];
    UIImage *image = [UIImage imageWithData:imageData];
    
    profileImage.image = image;
    
    profileImage.clipsToBounds = YES;
    profileImage.layer.cornerRadius = 200 / 2.0;
    
    NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
    
    //glams
    PFQuery *glamQuery = [PFQuery queryWithClassName:@"Glam"];
    [glamQuery whereKey:@"user" equalTo:user];
    
    [glamQuery findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        
        if (!error) {
            
            NSNumber *glamCount = [NSNumber numberWithUnsignedInteger:[objects count]];
            glamCounter.text = [formatter stringFromNumber:glamCount];
            
        } else {
            
            NSLog(@"Error %@ %@", error, [error userInfo]);
            
        }
        
    }];
    
    //activities
    PFQuery *activityQuery = [PFQuery queryWithClassName:@"Activity"];
    
    [activityQuery findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        
        if (!error) {
            
            NSLog(@"%@", objects);
        
            for (PFObject *obj in objects) {
                
                NSString *ourUser = [[PFUser currentUser] objectId];
                NSString *currentUser = [user objectId];
                NSString *toUser = [obj[@"toUser"] objectId];
                NSString *fromUser = [obj[@"fromUser"] objectId];
                NSString *type = obj[@"type"];
                
                if ([type isEqual:@"comment"] && [fromUser isEqual:currentUser]) {
                    
                    comments++;
                    
                } else if ([type  isEqual: @"follow"]) {
                    
                    if ([fromUser isEqual:currentUser]) {
                        
                        following++;
                        
                    } else if ([toUser isEqual:currentUser]) {
                        
                        followers++;
                        
                    }
                    
                    if ([toUser isEqual:currentUser] && [fromUser isEqual:ourUser]) {
                        
                        //are we following this user?
                        followButton.hidden = YES;
                        followLabel.hidden = NO;
                        
                    }
                    
                } else if ([type isEqual:@"favorite"]) {
                    
                    if ([toUser isEqual:currentUser] && [fromUser isEqual:ourUser]) {
                        
                        favorites++;
                        
                    }
                    
                }
                
            }
            
            likeCounter.text = [NSString stringWithFormat:@"%d", favorites];
            followerCounter.text = [NSString stringWithFormat:@"%d", followers];
            followingCounter.text = [NSString stringWithFormat:@"%d", following];
            commentCounter.text = [NSString stringWithFormat:@"%d", comments];
            
            
        } else {
            
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
    
    [self.navigationController popToRootViewControllerAnimated:YES];
    
}

- (IBAction)settingsButton:(id)sender
{
    
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    SettingsViewController *svc = [storyboard instantiateViewControllerWithIdentifier:@"Settings"];
    
    svc.delegate = self;
    
    [self presentViewController:svc animated:YES completion:nil];
    
}
- (IBAction)followUser:(id)sender
{
    
    PFObject *activity = [PFObject objectWithClassName:@"Activity"];
    
    [activity setObject:[PFUser currentUser] forKey:@"fromUser"];
    [activity setObject:user forKey:@"toUser"];
    [activity setObject:@"follow" forKey:@"type"];
    
    [activity save];
    
    followButton.hidden = YES;
    followLabel.hidden = NO;
    
}
@end
