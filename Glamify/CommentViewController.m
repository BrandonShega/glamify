//
//  CommentViewController.m
//  Glamify
//
//  Created by Brandon Shega on 12/18/14.
//  Copyright (c) 2014 Brandon Shega. All rights reserved.
//

#import "CommentViewController.h"

@interface CommentViewController () <UITableViewDataSource, UITableViewDelegate>
{
    
    NSArray *comments;
    
}

@end

@implementation CommentViewController

@synthesize commentString, commentText, commentTable, glamId;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    //set delegate and datasource for comment table view
    commentTable.delegate = self;
    commentTable.dataSource = self;
    
    [commentTable setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    
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
    
    //find all glams where the glam id is equal to the one we are editing comments for
    PFQuery *glamQuery = [PFQuery queryWithClassName:@"Glam"];
    
    [glamQuery whereKey:@"objectId" equalTo:glamId];
    
    PFObject *glam = [glamQuery getFirstObject];

    //find all comments that are currently for this glam
    PFQuery *commentQuery = [PFQuery queryWithClassName:@"Activity"];
    
    [commentQuery whereKey:@"type" equalTo:@"comment"];
    [commentQuery whereKey:@"glam" equalTo:glam];
    
    [commentQuery findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        
        if (!error) {
            
            comments = objects;
            
            //reload comment table after they are found
            [commentTable reloadData];
            
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

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
 
    return 1;
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    return [comments count];
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    NSString *reuseIdentifier = @"Cell";
    
    //create cell for comments view table
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseIdentifier forIndexPath:indexPath];
    
    if (cell != nil) {
        
        //create comment object
        PFObject *comment = [comments objectAtIndex:indexPath.row];
        
        PFUser *user = comment[@"fromUser"];
        
        //fetch user info if needed
        [user fetchIfNeeded];
        
        NSString *firstName = (user[@"firstName"] == nil) ? @"" : user[@"firstName"];
        NSString *lastName = (user[@"lastName"] == nil) ? @"" : user[@"lastName"];
        
        NSString *posterName = [NSString stringWithFormat:@"%@ %@", firstName, lastName];
        
        NSString *commentContent = comment[@"content"];
        
        //set comment text to cell's label
        cell.textLabel.numberOfLines = 3;
        cell.textLabel.font = [UIFont systemFontOfSize:12.0];
        cell.textLabel.text = [NSString stringWithFormat:@"%@ - %@", posterName, commentContent];
        
    }
    
    return cell;
    
}

- (IBAction)commentDone:(id)sender
{
    //grab comment from text and pass back to feed view controller to save
    commentString = [commentText text];
    
    [self.delegate didAddComment:commentString];
    [self dismissViewControllerAnimated:YES completion:nil];
    
}

- (IBAction)commentCancel:(id)sender
{
    
    [self dismissViewControllerAnimated:YES completion:nil];
    
}
@end
