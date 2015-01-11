//
//  SettingsViewController.m
//  Glamify
//
//  Created by Brandon Shega on 12/18/14.
//  Copyright (c) 2014 Brandon Shega. All rights reserved.
//

#import "SettingsViewController.h"
#import "LoginViewController.h"

@interface SettingsViewController ()

@end

@implementation SettingsViewController

@synthesize nameText;

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


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)settingsDone:(id)sender
{
    
    [self dismissViewControllerAnimated:YES completion:nil];
    
}

- (IBAction)saveButton:(id)sender
{
    
    PFObject *user = [PFUser currentUser];
    
    [user setObject:[nameText text] forKeyedSubscript:@"name"];
    [user save];
    
}

- (IBAction)logoutButton:(id)sender
{
    
    [PFUser logOut];
    [self dismissViewControllerAnimated:YES completion:nil];
    [self.delegate userLoggedOut];
    
}
@end
