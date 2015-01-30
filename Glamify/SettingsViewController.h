//
//  SettingsViewController.h
//  Glamify
//
//  Created by Brandon Shega on 12/18/14.
//  Copyright (c) 2014 Brandon Shega. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>

@protocol SettingsDelegte <NSObject>

- (void)userLoggedOut;

@end

@interface SettingsViewController : UIViewController

@property (nonatomic, weak) id<SettingsDelegte> delegate;

@property (weak, nonatomic) IBOutlet UITextField *firstNameText;
@property (weak, nonatomic) IBOutlet UITextField *lastNameText;
@property (weak, nonatomic) IBOutlet UITextField *youtubeText;
@property (weak, nonatomic) IBOutlet UITextView *profileText;
@property (weak, nonatomic) IBOutlet UIButton *profilePicture;

- (void)cameraImage;
- (void)galleryImage;
- (void)chooseImage;

- (IBAction)changePictureButton:(id)sender;

- (IBAction)settingsDone:(id)sender;

- (IBAction)saveButton:(id)sender;

- (IBAction)logoutButton:(id)sender;

@end
