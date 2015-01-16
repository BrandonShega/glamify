//
//  FeedViewControllerTableViewController.m
//  Glamify
//
//  Created by Brandon Shega on 12/18/14.
//  Copyright (c) 2014 Brandon Shega. All rights reserved.
//

#import "FeedViewControllerTableViewController.h"
#import "Glam.h"
#import "CustomCell.h"

@interface FeedViewControllerTableViewController ()
{
    
    NSMutableArray *glamArray;
    
}

@end

@implementation FeedViewControllerTableViewController

@synthesize feedTableView;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
    [feedTableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    PFQuery *followQuery = [PFQuery queryWithClassName:@"Activity"];
    
    [followQuery whereKey:@"fromUser" equalTo:[PFUser currentUser]];
    [followQuery whereKey:@"type" equalTo:@"follow"];

    NSLog(@"%@", [followQuery findObjects]);
    
    PFQuery *glamQuery = [PFQuery queryWithClassName:@"Glam"];
    
    [glamQuery whereKey:@"user" matchesKey:@"toUser" inQuery:followQuery];

    [glamQuery findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {

        if (!error) {

            glamArray = [NSMutableArray arrayWithArray:objects];

            [self.feedTableView reloadData];

        } else {

            NSLog(@"Error: %@ %@", error, [error userInfo]);

        }

    }];

}

- (BOOL)prefersStatusBarHidden
{
    return YES;
}


#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    return [glamArray count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    // Configure the cell...
    
    CustomCell *cell = (CustomCell *)[feedTableView dequeueReusableCellWithIdentifier:@"Cell"];
    
    if (cell == nil) {
        
        cell = [[CustomCell alloc] init];
        
        PFObject *glam = [glamArray objectAtIndex:indexPath.row];
        
        NSString *glamName = [glam objectForKey:@"name"];
        
        PFFile *imageFile = [glam objectForKey:@"imageFile"];
        [imageFile getDataInBackgroundWithBlock:^(NSData *data, NSError *error) {

            if (!error) {

                UIImage *glamImage = [UIImage imageWithData:data];

                [cell setLabel:glamName andImage:glamImage];

            } else {

                NSLog(@"Error: %@ %@", error, [error userInfo]);

            }


        }];

        
    }
    
    return cell;
}


/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)commentButton:(id)sender {
}
@end
