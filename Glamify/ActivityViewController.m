//
//  ActivityViewController.m
//  Glamify
//
//  Created by Brandon Shega on 12/18/14.
//  Copyright (c) 2014 Brandon Shega. All rights reserved.
//

#import "ActivityViewController.h"
#import "Activity.h"
#import "CustomActivityCell.h"

@interface ActivityViewController ()
{
    
    NSMutableArray *activityArray;
    
}

@end

@implementation ActivityViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
}

- (void)viewDidAppear:(BOOL)animated
{
    
    [super viewDidAppear:animated];
    
    PFQuery *query = [PFQuery queryWithClassName:@"Activity"];
    [query whereKey:@"fromUser" notEqualTo:[PFUser currentUser]];
    [query whereKey:@"toUser" equalTo:[PFUser currentUser]];
    
    activityArray = [NSMutableArray arrayWithArray:[query findObjects]];
    
}

- (BOOL)prefersStatusBarHidden
{
    return YES;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
//#warning Potentially incomplete method implementation.
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
//#warning Incomplete method implementation.
    // Return the number of rows in the section.
    return [activityArray count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    CustomActivityCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ActivityCell"];
    
    if (cell != NULL) {
        
        PFObject *activity = [activityArray objectAtIndex:indexPath.row];
        
        PFUser *fromUser = [activity objectForKey:@"fromUser"];
        PFUser *toUser = [activity objectForKey:@"toUser"];
        
        [fromUser fetchIfNeeded];
        [toUser fetchIfNeeded];
        
        NSString *message;
        
        NSString *type = [activity objectForKey:@"type"];
        
        if ([type isEqual:@"follow"]) {
            
            message = [NSString stringWithFormat:@"%@ followed you!", [fromUser objectForKey:@"name"]];
            
        } else if ([type isEqual:@"like"]) {
            
            message = [NSString stringWithFormat:@"%@ liked your photo!", [fromUser objectForKey:@"name"]];
            
        } else if ([type isEqual:@"comment"]) {
            
            message = [NSString stringWithFormat:@"%@ commented on your photo!", [fromUser objectForKey:@"name"]];
            
        }
        
        [cell setLabel:message];
        
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

@end
