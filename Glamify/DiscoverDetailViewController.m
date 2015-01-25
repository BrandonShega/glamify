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
    
    
    
    
}

- (IBAction)doneButton:(id)sender
{
    
    [self dismissViewControllerAnimated:YES completion:nil];
    
}
@end
