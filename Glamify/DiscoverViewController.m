//
//  DiscoverViewController.m
//  Glamify
//
//  Created by Brandon Shega on 1/10/15.
//  Copyright (c) 2015 Brandon Shega. All rights reserved.
//

#import "DiscoverViewController.h"
#import "Glam.h"
#import "FeedViewControllerTableViewController.h"

@interface DiscoverViewController () <UISearchBarDelegate>
{
    NSMutableArray *glamArray;
}

@end

@implementation DiscoverViewController

#define IMAGE_HEIGHT 75
#define IMAGE_WIDTH 75
#define NUMBER_OF_COLUMNS 4
#define PADDING 4

@synthesize photoView, discoverSearch, searchType;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [discoverSearch setDelegate:self];
    
    //set up custom navigation bar
    self.navigationController.navigationBar.barTintColor = [UIColor colorWithRed:1.00 green:0.36 blue:0.47 alpha:1.0];
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    self.navigationController.navigationBar.titleTextAttributes = @{NSForegroundColorAttributeName: [UIColor whiteColor]};
    
    //glamArray = [[NSMutableArray alloc] init];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidAppear:(BOOL)animated
{
    
    [super viewDidAppear:animated];
    

}

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText
{
    //this function runs everytime the user types something into the search box
    
    //we only want to search if there is at least one character in the box
    if ([searchText length] > 1) {
        
        //remove all current subviews from the main view
        NSArray *viewsToRemove = [photoView subviews];
        
        for (UIView *v in viewsToRemove) {
            //remove subviews
            [v removeFromSuperview];
        }
        
        //determine if the user is searching by category or by user
        switch (searchType.selectedSegmentIndex) {
                
            case 0: {
                
                //query to find all glams where the category contains the search text
                PFQuery *query= [PFQuery queryWithClassName:@"Glam"];
                
                [query whereKey:@"category" containsString:searchText];
                
                [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
                    
                    if (!error) {
                        
                        //load all glams into the view
                        [self loadImages:objects];
                        
                    } else {
                        
                        NSLog(@"Error: %@ %@", error, [error userInfo]);
                        
                    }
                    
                }];
                
            }
                
                break;
                
            case 1: {
                
                __block NSArray *searchGlams = [[NSArray alloc] init];
                
                //query to find all users where the name contains the search text
                PFQuery *nameQuery = [PFUser query];
                
                [nameQuery whereKey:@"name" containsString:searchText];
                
                [nameQuery findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
                   
                    if (!error) {
                        
                        //find glams that match these users
                        PFQuery *glamQuery = [PFQuery queryWithClassName:@"Glam"];
                        
                        [glamQuery whereKey:@"user" containedIn:objects];
                        
                        searchGlams = [glamQuery findObjects];
                        
                        //load all glams into the view
                        [self loadImages:searchGlams];
                        
                    } else {
                        
                        NSLog(@"Error: %@ %@", error, [error userInfo]);
                        
                    }
                    
                }];
                
            }
    
                break;
                
            default:
                break;
                
        }
        
        
        
    } else if ([searchText length] == 0) {
        
        //if search text is length 0, return all original glams
        [self loadGlams];
        
    }
    
}

- (void)viewWillAppear:(BOOL)animated
{

    [super viewWillAppear:animated];

    //load glams on page before it appears
    [self loadGlams];

}

- (BOOL)prefersStatusBarHidden
{
    return YES;
}

- (void)loadGlams
{
    //find all glams that don't belong to the user and display them on the page
    PFQuery *query = [PFQuery queryWithClassName:@"Glam"];
    
    //query.limit = 50;
    
    [query whereKey:@"user" notEqualTo:[PFUser currentUser]];
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {

        if (!error) {

            [self loadImages:objects];

        } else {

            NSLog(@"Error: %@ %@", error, [error userInfo]);

        }

    }];
    
}

- (void)imageClicked:(GlamButton *)sender
{
    //if user clicks on glam, load it into the view controller
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    
    FeedViewControllerTableViewController *fvc = [storyboard instantiateViewControllerWithIdentifier:@"feedViewController"];
    
    //set glam ID and view controller title
    fvc.glamId = sender.glamid;
    fvc.title = @"Detail";
    
    [self.navigationController pushViewController:fvc animated:YES];
    
}

- (void)loadImages:(NSArray *)images
{
    
        //create array to store images
        NSMutableArray *imageArray = [NSMutableArray array];
        
        for (PFObject *object in images) {
            
            PFFile *imageFile = [object objectForKey:@"imageFile"];

            NSData *data = [imageFile getData];
            
            //create new glam object
            Glam *glam = [[Glam alloc] init];
            
            //set image data and ID
            glam.image = data;
            glam.glamId = [object objectId];
            
            //add to image array
            [imageArray addObject:glam];
            
        }
        

        for (int i = 0; i < [imageArray count]; i++) {
            
            //create glam object
            Glam *eachGlam = [imageArray objectAtIndex:i];
            
            //create custom glam button
            GlamButton *glamButton = [GlamButton buttonWithType:UIButtonTypeCustom];

            UIImage *image = [UIImage imageWithData:eachGlam.image];

            //set image for glam button
            [glamButton setImage:image forState:UIControlStateNormal];

            //set glam id for glam button so we know which one the user clicks on to load that glam
            glamButton.glamid = eachGlam.glamId;

            //set frame of each glam button
            glamButton.frame = CGRectMake(IMAGE_WIDTH * (i % NUMBER_OF_COLUMNS) + PADDING * (i % NUMBER_OF_COLUMNS) + PADDING, IMAGE_HEIGHT * (i / NUMBER_OF_COLUMNS) + PADDING * (i / NUMBER_OF_COLUMNS) + PADDING, IMAGE_WIDTH, IMAGE_HEIGHT);

            //scale picture to fit
            glamButton.imageView.contentMode = UIViewContentModeScaleAspectFill;

            //add trigger for when user clicks on a glam
            [glamButton addTarget:self action:@selector(imageClicked:) forControlEvents:UIControlEventTouchUpInside];

            //add glam button to main view
            [photoView addSubview:glamButton];

        }
    
        //calculate number of rows
        int rows = (int)imageArray.count / NUMBER_OF_COLUMNS;

        //calculate height of main view
        int height = IMAGE_HEIGHT * rows + PADDING * rows;

        //set size of main view
        photoView.contentSize = CGSizeMake(self.view.frame.size.width, height);
            
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
