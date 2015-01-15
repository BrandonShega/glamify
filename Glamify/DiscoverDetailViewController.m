//
//  DiscoverDetailViewController.m
//  Glamify
//
//  Created by Brandon Shega on 1/10/15.
//  Copyright (c) 2015 Brandon Shega. All rights reserved.
//

#import "DiscoverDetailViewController.h"

@interface DiscoverDetailViewController ()
{
    PFUser *postingUser;
}

@end

@implementation DiscoverDetailViewController

@synthesize glamId, imageView, glamName, followLabel, followButton;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (BOOL)prefersStatusBarHidden
{
    return YES;
}

- (void)viewDidAppear:(BOOL)animated
{
    
    [super viewDidAppear:animated];
    
}

- (void)viewWillAppear:(BOOL)animated
{

    [super viewWillAppear:animated];

    PFQuery *query = [PFQuery queryWithClassName:@"Glam"];
    [query whereKey:@"objectId" equalTo:self.glamId];

    PFObject *object = [query getFirstObject];

    PFFile *imageFile = [object objectForKey:@"imageFile"];
    postingUser = [object objectForKey:@"user"];
    NSData *imageData = [imageFile getData];
    UIImage *image = [UIImage imageWithData:imageData];

    imageView.image = image;
    glamName.text = [object objectForKey:@"name"];

    PFQuery *following = [PFQuery queryWithClassName:@"Activity"];
    [following whereKey:@"type" equalTo:@"follow"];

    //PFQuery *fromUs = [PFQuery queryWithClassName:@"Activity"];
    [following whereKey:@"fromUser" equalTo:[PFUser currentUser]];

    //PFQuery *toPoster = [PFQuery queryWithClassName:@"Activity"];
    [following whereKey:@"toUser" equalTo:postingUser];

    //PFQuery *activityQuery = [PFQuery orQueryWithSubqueries:@[fromUs, following, toPoster]];

    [following findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {

        if (!error) {

            if (![objects count] == 0) {

                followButton.hidden = YES;
                followLabel.hidden = NO;

            }

        } else {

            NSLog(@"Error: %@ %@", error, [error userInfo]);

        }

    }];

}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)followButton:(id)sender
{
    
    PFObject *activity = [PFObject objectWithClassName:@"Activity"];
    
    [activity setObject:[PFUser currentUser] forKey:@"fromUser"];
    [activity setObject:postingUser forKey:@"toUser"];
    [activity setObject:@"follow" forKey:@"type"];
    
    [activity save];
    
    followButton.hidden = YES;
    followLabel.hidden = NO;
    
    
}

- (IBAction)doneButton:(id)sender
{
    
    [self dismissViewControllerAnimated:YES completion:nil];
    
}
@end
