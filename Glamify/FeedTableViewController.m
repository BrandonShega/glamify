//
//  FeedTableViewController.m
//  Glamify
//
//  Created by Brandon Shega on 1/28/15.
//  Copyright (c) 2015 Brandon Shega. All rights reserved.
//

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
        // Custom the table
        
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
    
//    [followQuery findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
//        
//        if (!error) {
//            activityArray = [objects copy];
//            
//            [self loadObjects];
//                            
//            
//        } else {
//            
//            NSLog(@"Error: %@ %@", error, [error userInfo]);
//            
//        }
//        
//    }];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation
{
    
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

- (PFQuery *)queryForTable
{
    __block PFQuery *query;
    
    if (self.pullToRefreshEnabled) {
        
        query.cachePolicy = kPFCachePolicyNetworkOnly;
        
    }
    
    if (self.objects.count == 0) {
        
        query.cachePolicy = kPFCachePolicyCacheThenNetwork;
        
    }
    
    if (glamId) {
        
        query = [PFQuery queryWithClassName:@"Glam"];
        
        [query whereKey:@"objectId" equalTo:glamId];
        [query includeKey:@"user"];
        
    } else {
        
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

//- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath object:(PFObject *)object
//{
//    
//    
//    static NSString *cellIdentifier = @"Cell";
//    
//    __block NSString *firstName;
//    __block NSString *lastName;
//    __block NSString *posterName;
//    __block PFFile *posterFile;
//    
//    CustomCell *cell = (CustomCell *)[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
//    
//    if (cell != nil) {
//        
//        NSLog(@"%@", [object objectForKey:@"name"]);
//        
//        PFObject *glam = [self.objects objectAtIndex:indexPath.row];
//        
//        NSString *glamName = [glam objectForKey:@"name"];
//        
//        PFUser *user = [glam objectForKey:@"user"];
//        
//        [user fetchIfNeededInBackgroundWithBlock:^(PFObject *object, NSError *error) {
//            
//            firstName = (object[@"firstName"] == nil) ? @"" : object[@"firstName"];
//            lastName = (object[@"lastName"] == nil) ? @"" : object[@"lastName"];
//            posterFile = object[@"image"];
//            
//            posterName = [NSString stringWithFormat:@"%@ %@", firstName, lastName];
//            
//        }];
//        
//        Glam *newGlam = [[Glam alloc] init];
//        
//        NSString *glamID = [glam objectId];
//        
//        newGlam.glamId = glamID;
//        newGlam.user = user;
//        
//        //[cell setLabel:glamName andImage:imageFile andPostersImage:posterFile andPostersName:posterName];
//        PFFile *imageFile = object[@"imageFile"];
//        
//        [cell setLabel:glamName andImage:imageFile andPostersImage:posterFile andPostersName:posterName];
//        
//        //setup touch gesture for header view
//        UITapGestureRecognizer *singleFingerTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(singleTap:)];
//        [cell.headerView addGestureRecognizer:singleFingerTap];
//        cell.headerView.tag = indexPath.row;
//        
//    }
//    
//    return cell;
//    
//}

- (PFTableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath object:(PFObject *)object
{
    
    
    static NSString *cellIdentifier = @"Cell";
    
    CustomCell *cell = (CustomCell *)[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    if (cell != nil) {
        
        [[cell glamName] setText:[object objectForKey:@"name"]];
        
        PFUser *user = [object objectForKey:@"user"];
        
        NSString *firstName = (user[@"firstName"] == nil) ? @"" : user[@"firstName"];
        NSString *lastName = (user[@"lastName"] == nil) ? @"" : user[@"lastName"];
        NSString *posterName = [NSString stringWithFormat:@"%@ %@", firstName, lastName];
        
        [[cell postersName] setText:posterName];
        
        // Load glam image
        cell.glamImage.file = [object objectForKey:@"imageFile"];
        [cell.glamImage loadInBackground];
        
        // Load poster image
        cell.postersImage.file = user[@"image"];
        [cell.postersImage loadInBackground];
        
        
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

- (void)singleTap:(UIGestureRecognizer *)recognizer
{
    
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    
    ProfileViewController *pvc = [storyboard instantiateViewControllerWithIdentifier:@"profileViewController"];
    
    PFObject *glam = [self.objects objectAtIndex:recognizer.view.tag];
    
    PFUser *userId = glam[@"user"];
    
    [userId fetchIfNeededInBackground];
    
    NSString *firstName = (userId[@"firstName"] == nil) ? @"" : userId[@"firstName"];
    NSString *lastName = (userId[@"lastName"] == nil) ? @"" : userId[@"lastName"];
    
    NSString *name = [NSString stringWithFormat:@"%@ %@", firstName, lastName];
    
    pvc.navigationItem.title = name;
    pvc.navBar.hidden = YES;
    
    pvc.user = userId;
    
    [self.navigationController pushViewController:pvc animated:YES];
    
}


@end
