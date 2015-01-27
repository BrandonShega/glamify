//
//  DiscoverViewController.m
//  Glamify
//
//  Created by Brandon Shega on 1/10/15.
//  Copyright (c) 2015 Brandon Shega. All rights reserved.
//

#import "DiscoverViewController.h"
#import "Glam.h"
#import "DiscoverDetailViewController.h"
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
    
    if ([searchText length] > 1) {
        
        NSArray *viewsToRemove = [photoView subviews];
        
        for (UIView *v in viewsToRemove) {
            [v removeFromSuperview];
        }
        
        switch (searchType.selectedSegmentIndex) {
                
            case 0: {
                
                PFQuery *query= [PFQuery queryWithClassName:@"Glam"];
                
                [query whereKey:@"category" containsString:searchText];
                
                [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
                    
                    if (!error) {
                        
                        [self loadImages:objects];
                        
                    } else {
                        
                        NSLog(@"Error: %@ %@", error, [error userInfo]);
                        
                    }
                    
                }];
                
            }
                
                break;
                
            case 1: {
                
                __block NSArray *searchGlams = [[NSArray alloc] init];
                
                PFQuery *nameQuery = [PFUser query];
                
                [nameQuery whereKey:@"name" containsString:searchText];
                
                [nameQuery findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
                   
                    if (!error) {
                        
                        PFQuery *glamQuery = [PFQuery queryWithClassName:@"Glam"];
                        
                        [glamQuery whereKey:@"user" containedIn:objects];
                        
                        searchGlams = [glamQuery findObjects];
                        
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
        
        [self loadGlams];
        
    }
    
}

- (void)viewWillAppear:(BOOL)animated
{

    [super viewWillAppear:animated];

    [self loadGlams];

}

- (BOOL)prefersStatusBarHidden
{
    return YES;
}

- (void)loadGlams
{
    
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
    
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    
    FeedViewControllerTableViewController *fvc = [storyboard instantiateViewControllerWithIdentifier:@"feedViewController"];
    
    fvc.glamId = sender.glamid;
    fvc.title = @"Detail";
    
    [self.navigationController pushViewController:fvc animated:YES];
    
}

- (void)loadImages:(NSArray *)images
{
        
        NSMutableArray *imageArray = [NSMutableArray array];
        
        for (PFObject *object in images) {
            
            PFFile *imageFile = [object objectForKey:@"imageFile"];

            NSData *data = [imageFile getData];
            
            Glam *glam = [[Glam alloc] init];
            
            glam.image = data;
            glam.glamId = [object objectId];
            
            [imageArray addObject:glam];
            
        }
        

        for (int i = 0; i < [imageArray count]; i++) {

            Glam *eachGlam = [imageArray objectAtIndex:i];

            GlamButton *glamButton = [GlamButton buttonWithType:UIButtonTypeCustom];

            UIImage *image = [UIImage imageWithData:eachGlam.image];

            [glamButton setImage:image forState:UIControlStateNormal];

            glamButton.glamid = eachGlam.glamId;

            glamButton.frame = CGRectMake(IMAGE_WIDTH * (i % NUMBER_OF_COLUMNS) + PADDING * (i % NUMBER_OF_COLUMNS) + PADDING, IMAGE_HEIGHT * (i / NUMBER_OF_COLUMNS) + PADDING * (i / NUMBER_OF_COLUMNS) + PADDING, IMAGE_WIDTH, IMAGE_HEIGHT);

            glamButton.imageView.contentMode = UIViewContentModeScaleAspectFill;

            [glamButton addTarget:self action:@selector(imageClicked:) forControlEvents:UIControlEventTouchUpInside];

            [photoView addSubview:glamButton];

        }

        int rows = (int)imageArray.count / NUMBER_OF_COLUMNS;

        int height = IMAGE_HEIGHT * rows + PADDING * rows;

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
