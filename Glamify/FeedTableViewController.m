//
//  FeedTableViewController.m
//  Glamify
//
//  Created by Brandon Shega on 1/28/15.
//  Copyright (c) 2015 Brandon Shega. All rights reserved.
//

/*
 * NEW VERSION OF VIEW CONTROLLER
 */

#import "FeedTableViewController.h"
#import "CustomCell.h"
#import "UIImage+Resize.h"
#import "UIImage+RoundedCorner.h"
#import "ProfileViewController.h"

@interface FeedTableViewController () {
    NSArray *activityArray;
    PFQuery *followQuery;
}

@end

@implementation FeedTableViewController

@synthesize glamId, reloadOnAppear;

- (id)initWithStyle:(UITableViewStyle)style {
    self = [super initWithStyle:style];
    if (self) {
        // Customize the table
        
        // The className to query on
        self.parseClassName = @"Glam";
        
        // The key of the PFObject to display in the label of the default cell style
        self.textKey = @"name";
        
        // Uncomment the following line to specify the key of a PFFile on the PFObject to display in the imageView of the default cell style
         //self.imageKey = @"imageFile";
        
        // Whether the built-in pull-to-refresh is enabled
        self.pullToRefreshEnabled = YES;
        
        // Whether the built-in pagination is enabled
        self.paginationEnabled = YES;
        
        // The number of objects to show per page
        self.objectsPerPage = 25;
        
        self.reloadOnAppear = YES;
    }
    return self;
}

-(void)viewDidLoad {
    [super viewDidLoad];
    
    [self.tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    
    self.navigationController.navigationBar.barTintColor = [UIColor colorWithRed:1.00 green:0.36 blue:0.47 alpha:1.0];
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    self.navigationController.navigationBar.titleTextAttributes = @{NSForegroundColorAttributeName: [UIColor whiteColor]};
    
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation
{
    //allow only portrait orientation
    return (toInterfaceOrientation == UIInterfaceOrientationPortrait);
    
}

- (void)objectsWillLoad
{
    
    [super objectsWillLoad];
    
}

- (void)objectsDidLoad:(NSError *)error
{
    
    [super objectsDidLoad:error];
    
}

- (BOOL)prefersStatusBarHidden
{
    return YES;
}

#pragma mark - PFQueryTableViewController

//set up query for the view controller table
- (PFQuery *)queryForTable
{
    __block PFQuery *query;
    
    //if pull to refresh is enabled, only allow when there is a network connection
    if (self.pullToRefreshEnabled) {
        
        query.cachePolicy = kPFCachePolicyNetworkOnly;
        
    }
    
    if (self.objects.count == 0) {
        
        query.cachePolicy = kPFCachePolicyCacheThenNetwork;
        
    }
    
    //check if we are passing in a glam ID or getting all glams
    if (glamId) {
        
        //query to find glam of glam ID being passed in
        query = [PFQuery queryWithClassName:@"Glam"];
        
        [query whereKey:@"objectId" equalTo:glamId];
        [query includeKey:@"user"];
        
    } else {
        
        //query to find all glams of users that we are currently following
        followQuery = [PFQuery queryWithClassName:@"Activity"];
        
        [followQuery whereKey:@"fromUser" equalTo:[PFUser currentUser]];
        [followQuery whereKey:@"type" equalTo:@"follow"];
        
        query = [PFQuery queryWithClassName:@"Glam"];
        
        [query whereKey:@"user" matchesKey:@"toUser" inQuery:followQuery];
        [query includeKey:@"user"];
        [query addDescendingOrder:@"createdAt"];
        
    }
    
    return query;
    
}

- (PFTableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath object:(PFObject *)object
{
    
    
    static NSString *cellIdentifier = @"Cell";
    
    //create custom cell for feed
    CustomCell *cell = (CustomCell *)[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    if (cell != nil) {
        
        //set text label of cell
        [[cell glamName] setText:[object objectForKey:@"name"]];
        
        PFUser *user = [object objectForKey:@"user"];
        
        NSString *firstName = (user[@"firstName"] == nil) ? @"" : user[@"firstName"];
        NSString *lastName = (user[@"lastName"] == nil) ? @"" : user[@"lastName"];
        NSString *posterName = [NSString stringWithFormat:@"%@ %@", firstName, lastName];
        
        //set name of poster for cell
        [[cell postersName] setText:posterName];
        
        // Load glam image
        cell.glamImage.file = [object objectForKey:@"imageFile"];
        [cell.glamImage loadInBackground];
        
        // Load poster image
        cell.postersImage.file = user[@"image"];
        [cell.postersImage loadInBackground];
        
        //create new glam object and assign its properties
        Glam *newGlam = [[Glam alloc] init];
        NSString *glamID = [object objectId];
        newGlam.glamId = glamID;
        newGlam.user = user;
        [cell assignGlam:newGlam];
        
        //setup touch gesture for header view
        UITapGestureRecognizer *singleFingerTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(singleTap:)];
        [cell.headerView addGestureRecognizer:singleFingerTap];
        cell.headerView.tag = indexPath.row;
        
    }
    
    return cell;
    
}

//action for when we click on the header of a user's glam
- (void)singleTap:(UIGestureRecognizer *)recognizer
{
    
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    
    //create new profile view controller
    ProfileViewController *pvc = [storyboard instantiateViewControllerWithIdentifier:@"profileViewController"];
    
    //create object for glam that we selected
    PFObject *glam = [self.objects objectAtIndex:recognizer.view.tag];
    
    PFUser *userId = glam[@"user"];
    
    //fetch user info if needed
    [userId fetchIfNeededInBackground];
    
    NSString *firstName = (userId[@"firstName"] == nil) ? @"" : userId[@"firstName"];
    NSString *lastName = (userId[@"lastName"] == nil) ? @"" : userId[@"lastName"];
    
    NSString *name = [NSString stringWithFormat:@"%@ %@", firstName, lastName];
    
    //set navigation title to user's name
    pvc.navigationItem.title = name;
    pvc.navBar.hidden = YES;
    
    //set user ID of user that we tapped on
    pvc.user = userId;
    
    [self.navigationController pushViewController:pvc animated:YES];
    
}


@end
