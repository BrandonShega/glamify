//
//  SettingsViewController.m
//  Glamify
//
//  Created by Brandon Shega on 12/18/14.
//  Copyright (c) 2014 Brandon Shega. All rights reserved.
//

#import "SettingsViewController.h"
#import "LoginViewController.h"

@interface SettingsViewController () <UITextViewDelegate, UIImagePickerControllerDelegate, UIAlertViewDelegate>

@end

@implementation SettingsViewController
{
    BOOL takingPicture;
}

@synthesize firstNameText, lastNameText, youtubeText, profileText, profilePicture;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    //set UITextView properties
    self.profileText.delegate = self;
    self.profileText.text = @"Describe a little about yourself and what you do.";
    self.profileText.textColor = [UIColor lightGrayColor];
    
}

- (void)galleryImage
{

    //user chose gallery to pick their image
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];

    picker.delegate = (id <UINavigationControllerDelegate, UIImagePickerControllerDelegate>) self;
    picker.allowsEditing = NO;
    picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;

    //present picker view controller
    [self presentViewController:picker animated:YES completion:nil];

}

- (void)cameraImage
{
    //user chose camera to pick their image
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];

    picker.delegate = (id <UINavigationControllerDelegate, UIImagePickerControllerDelegate>) self;
    picker.allowsEditing = NO;
    picker.sourceType = UIImagePickerControllerSourceTypeCamera;

    //present picker view controller
    [self presentViewController:picker animated:YES completion:nil];

}

- (void)chooseImage
{
    //create alert to ask how the user would like to choose their image
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Image Selector" message:@"How would you like to add an image?" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:nil, nil];

    [alert addButtonWithTitle:@"Camera"];
    [alert addButtonWithTitle:@"Gallery"];

    [alert show];

}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{

    //perform method based on which button the user tapped during the alert
    switch (buttonIndex) {
        case 1:
            if (![UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error!" message:@"There is no camera on this device" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
                [alert show];
            } else {
                [self cameraImage];
            }
            break;
        case 2:
            [self galleryImage];
            break;
        default:
            break;
    }

}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{

    //after user chooses an image, we set it to their profile picture
    UIImage *chosenImage = info[UIImagePickerControllerOriginalImage];
    [profilePicture setImage:chosenImage forState:UIControlStateNormal];

    takingPicture = YES;

    [picker dismissViewControllerAnimated:YES completion:nil];

}

- (void)textViewDidBeginEditing:(UITextView *)textView
{
 
    //remove placeholder text for UITextView
    if ([textView.text isEqualToString:@"Describe a little about yourself and what you do."]) {
        
        textView.text = @"";
        textView.textColor = [UIColor blackColor];
        
    }
    [textView becomeFirstResponder];
    
}

- (void)textViewDidEndEditing:(UITextView *)textView
{
    
    //set placeholder text for UITextView
    if ([textView.text isEqualToString:@""]) {
        
        textView.text = @"Describe a little about yourself and what you do.";
        textView.textColor = [UIColor lightGrayColor];
        
    }
    [textView resignFirstResponder];
    
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
    
    //fetch user info if we are using it
    [user fetchIfNeeded];
    
    NSString *firstName = user[@"firstName"];
    NSString *lastName = user[@"lastName"];
    NSString *youtube = user[@"youtube"];
    NSString *profile = user[@"profile"];

    //check if user is currently taking a picture
    if (!takingPicture) {

        PFFile *imageFile = user[@"image"];
        NSData *imageData = [imageFile getData];
        UIImage *profileImage = [UIImage imageWithData:imageData];

        [profilePicture setImage:profileImage forState:UIControlStateNormal];

    }
    
    //set all labels to their respective variables
    self.firstNameText.text = firstName;
    self.lastNameText.text = lastName;
    self.youtubeText.text = youtube;
    self.profileText.text = profile;
    self.profileText.textColor = [UIColor blackColor];
    
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)changePictureButton:(id)sender
{
    //user clicked on their photo to change it
    [self chooseImage];

}

- (IBAction)settingsDone:(id)sender
{
    
    //hide settings view controller
    [self dismissViewControllerAnimated:YES completion:nil];
    
}

- (IBAction)saveButton:(id)sender
{
    //get current user
    PFObject *user = [PFUser currentUser];
    
    //store text fields into variables
    NSString *firstName = [firstNameText text];
    NSString *lastName = [lastNameText text];
    NSString *youtube = [youtubeText text];
    NSString *profile = [profileText text];

    //get their current profile image
    UIImage *profileImage = [profilePicture imageForState:UIControlStateNormal];
    NSData *imageData = UIImageJPEGRepresentation(profileImage, 0.05f);

    PFFile *imageFile = [PFFile fileWithName:@"profile.jpg" data:imageData];

    //save image in background
    [imageFile saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {

        if (!error) {
            
            //save the user after image is uploaded
            user[@"image"] = imageFile;
            [user setObject:firstName forKey:@"firstName"];
            [user setObject:lastName forKey:@"lastName"];
            [user setObject:youtube forKey:@"youtube"];
            [user setObject:profile forKey:@"profile"];
            [user save];

        } else {
            
            NSLog(@"Error: %@ %@", error, [error userInfo]);

        }

    }];
    
    //present user with success alert
    [[[UIAlertView alloc] initWithTitle:@"Success" message:@"Your profile has been saved!" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil] show];
    
}

- (IBAction)logoutButton:(id)sender
{
    //logout current user out
    [PFUser logOut];
    [self dismissViewControllerAnimated:YES completion:nil];
    [self.delegate userLoggedOut];
    
}
@end
