//
//  SignUpViewController.m
//  Glamify
//
//  Created by Brandon Shega on 12/18/14.
//  Copyright (c) 2014 Brandon Shega. All rights reserved.
//

#import "SignUpViewController.h"

@interface SignUpViewController ()

@end

@implementation SignUpViewController

@synthesize usernameText, passwordText, verifyPasswordText;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
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

- (BOOL)shouldPerformSegueWithIdentifier:(NSString *)identifier sender:(id)sender
{
    
    __block BOOL successful = NO;
    
    //create new user and sign them up in the background
    PFUser *user = [PFUser user];
    
    user.username = [usernameText text];
    user.password = [verifyPasswordText text];
    user.email = [usernameText text];
    
    [user signUpInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        if(!error) {
            
            successful = succeeded;
            
        } else {
            
            //alert user if there was an error signing them up
            NSString *errorString = [error userInfo][@"error"];
            
            [[[UIAlertView alloc] initWithTitle:@"Error"
                                        message:errorString
                                        delegate:nil
                                        cancelButtonTitle:@"OK"
                                        otherButtonTitles:nil] show];
            
            successful = succeeded;
            
        }
        
    }];
    
    return YES;
    
}

- (IBAction)signupButton:(id)sender
{
    
    username = [usernameText text];
    password = [passwordText text];
    verifyPassword = [verifyPasswordText text];
    
    //present error to user if any fields are blank
    if ([username isEqualToString:@""] || [password isEqualToString:@""] || [verifyPassword isEqualToString:@""]) {
        
        [[[UIAlertView alloc] initWithTitle:@"Error"
                                    message:@"Please enter valid credentials"
                                    delegate:nil
                                    cancelButtonTitle:@"OK"
                                    otherButtonTitles:nil] show];
        
    }
    
}

- (IBAction)cancelSignup:(id)sender
{
    
    [self dismissViewControllerAnimated:TRUE completion:nil];
    
}
@end
