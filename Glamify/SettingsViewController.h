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

- (IBAction)settingsDone:(id)sender;


- (IBAction)logoutButton:(id)sender;

@end
