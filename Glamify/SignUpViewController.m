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
    
    if ([username isEqualToString:@"test"] && [password isEqualToString:@"test"] && [verifyPassword isEqualToString:@"test"]) {
        
        return YES;
        
    } else {
        
        return NO;
        
    }
    
}

- (IBAction)signupButton:(id)sender
{
    
    username = [usernameText text];
    password = [passwordText text];
    verifyPassword = [verifyPasswordText text];
    
    if ([username isEqualToString:@""] && [password isEqualToString:@""] && [verifyPassword isEqualToString:@""]) {
        
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
