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

@synthesize profileImage;

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
    
    PFUser *user = [PFUser currentUser];
    
    PFFile *imageFile = user[@"image"];
    NSData *imageData = [imageFile getData];
    UIImage *image = [UIImage imageWithData:imageData];
    
    profileImage.image = image;
    
    profileImage.clipsToBounds = YES;
    profileImage.layer.cornerRadius = 200 / 2.0;
    
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
@end
