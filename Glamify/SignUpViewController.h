//
//  SignUpViewController.h
//  Glamify
//
//  Created by Brandon Shega on 12/18/14.
//  Copyright (c) 2014 Brandon Shega. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>

@interface SignUpViewController : UIViewController
{
    NSString *username;
    NSString *password;
    NSString *verifyPassword;
}

@property (weak, nonatomic) IBOutlet UITextField *usernameText;
@property (weak, nonatomic) IBOutlet UITextField *passwordText;
@property (weak, nonatomic) IBOutlet UITextField *verifyPasswordText;

- (IBAction)signupButton:(id)sender;
- (IBAction)cancelSignup:(id)sender;

@end
