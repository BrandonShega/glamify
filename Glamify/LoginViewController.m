//
//  LoginViewController.m
//  Glamify
//
//  Created by Brandon Shega on 12/16/14.
//  Copyright (c) 2014 Brandon Shega. All rights reserved.
//

#import "LoginViewController.h"
#import "MainViewController.h"
#import "SignUpViewController.h"

@interface LoginViewController ()

@end

@implementation LoginViewController

@synthesize userText, passwordText;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidAppear:(BOOL)animated {
    
    [super viewDidAppear:animated];
    
    self.navigationController.navigationBarHidden = YES;
    
    NSLog(@"%@", username);
    
    if (username != NULL && password != NULL) {
        
        [self performSegueWithIdentifier:@"loginSegue" sender:self];
        
    }
    
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)unwindSignupViewController:(UIStoryboardSegue *)unwindSegue
{
    
    if ([unwindSegue.sourceViewController isKindOfClass:[SignUpViewController class]]) {
        
        SignUpViewController *svc = unwindSegue.sourceViewController;
        
        username = svc.usernameText.text;
        password = svc.passwordText.text;
        
    }
    
}

- (IBAction)loginButton:(id)sender
{
    
    username = [userText text];
    password = [passwordText text];
    
    if ([username isEqualToString:@"test"] && [password isEqualToString:@"test"]) {
        
        [self performSegueWithIdentifier:@"loginSegue" sender:self];
        
    } else {
        
        [[[UIAlertView alloc] initWithTitle:@"Error"
                                    message:@"Please enter valid credentials"
                                   delegate:nil
                          cancelButtonTitle:@"OK"
                          otherButtonTitles:nil] show];
        
    }
    
}
@end
