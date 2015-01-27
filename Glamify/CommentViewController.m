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
    
    PFQuery *glamQuery = [PFQuery queryWithClassName:@"Glam"];
    
    [glamQuery whereKey:@"objectId" equalTo:glamId];
    
    PFObject *glam = [glamQuery getFirstObject];

    PFQuery *commentQuery = [PFQuery queryWithClassName:@"Activity"];
    
    [commentQuery whereKey:@"type" equalTo:@"comment"];
    [commentQuery whereKey:@"glam" equalTo:glam];
    
    [commentQuery findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        
        if (!error) {
            
            comments = objects;
            
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
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseIdentifier forIndexPath:indexPath];
    
    if (cell != nil) {
        
        PFObject *comment = [comments objectAtIndex:indexPath.row];
        
        PFUser *user = comment[@"fromUser"];
        
        [user fetchIfNeeded];
        
        NSString *firstName = (user[@"firstName"] == nil) ? @"" : user[@"firstName"];
        NSString *lastName = (user[@"lastName"] == nil) ? @"" : user[@"lastName"];
        
        NSString *posterName = [NSString stringWithFormat:@"%@ %@", firstName, lastName];
        
        NSString *commentContent = comment[@"content"];
        
        cell.textLabel.numberOfLines = 3;
        cell.textLabel.font = [UIFont systemFontOfSize:12.0];
        cell.textLabel.text = [NSString stringWithFormat:@"%@ - %@", posterName, commentContent];
        
    }
    
    return cell;
    
}

- (IBAction)commentDone:(id)sender
{
    commentString = [commentText text];
    
    [self.delegate didAddComment:commentString];
    [self dismissViewControllerAnimated:YES completion:nil];
    
}

- (IBAction)commentCancel:(id)sender
{
    
    [self dismissViewControllerAnimated:YES completion:nil];
    
}
@end
