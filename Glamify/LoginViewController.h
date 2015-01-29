//
//  LoginViewController.h
//  Glamify
//
//  Created by Brandon Shega on 12/16/14.
//  Copyright (c) 2014 Brandon Shega. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LoginViewController : UIViewController <UITextFieldDelegate>
{
    
    NSString *username;
    NSString *password;
    
}

@property (weak, nonatomic) IBOutlet UITextField *userText;
@property (weak, nonatomic) IBOutlet UITextField *passwordText;
@property (weak, nonatomic) IBOutlet UIButton *loginButton;

- (IBAction)loginButton:(id)sender;
- (IBAction)unwindSignupViewController:(UIStoryboardSegue *)unwindSegue;

@end
