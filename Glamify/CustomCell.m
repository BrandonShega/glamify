//
//  CustomCell.m
//  Glamify
//
//  Created by Brandon Shega on 12/18/14.
//  Copyright (c) 2014 Brandon Shega. All rights reserved.
//

#import "CustomCell.h"
#import "Glam.h"
#import "CommentViewController.h"
#import "AppDelegate.h"
#import "ProfileViewController.h"
#import "AppDelegate.h"

@implementation CustomCell

@synthesize glamImage, glamName, glamNameString, headerView, postersImage, postersName, favoriteButton, cardView, commentButton;

- (id)init
{
    
    self = [super init];
    
    if (self) {
        
        
        
    }
    
    return self;
    
}

- (void)layoutSubviews
{
    
    [super layoutSubviews];
    
    //layout header subview
    self.headerView.layer.shadowColor = [[UIColor blackColor] CGColor];
    self.headerView.layer.shadowOffset = CGSizeZero;
    self.headerView.layer.shadowRadius = 4.0f;
    self.headerView.layer.shadowOpacity = 1.0f;
    
    UIBezierPath *path = [UIBezierPath bezierPath];
    
    //create shadow around header view
    [path moveToPoint:CGPointMake(CGRectGetWidth(self.headerView.frame) / 2, CGRectGetHeight(self.headerView.frame) /2 )];
    [path addLineToPoint:CGPointMake(CGRectGetWidth(self.headerView.frame), CGRectGetHeight(self.headerView.frame))];
    [path addLineToPoint:CGPointMake(0, CGRectGetHeight(self.headerView.frame))];
    [path closePath];
    
    self.headerView.layer.shadowPath = path.CGPath;
    
    //set up poster's image
    postersImage.clipsToBounds = YES;
    postersImage.layer.cornerRadius = 20;
    
    //set up card subview
    self.cardView.layer.shadowOffset = CGSizeMake(1, 1);
    self.cardView.layer.shadowColor = [[UIColor blackColor] CGColor];
    self.cardView.layer.shadowRadius = 4.0f;
    self.cardView.layer.shadowOpacity = 0.80f;
    self.cardView.layer.shadowPath = [[UIBezierPath bezierPathWithRect:self.cardView.layer.bounds] CGPath];
    
}

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)assignGlam:(Glam *)glamToAssign
{
    
    __block BOOL didIComment = NO;
    __block BOOL didIFavorite = NO;
    
    //grab ID and user from glam being passed in and assign to favorite button and comment button
    favoriteButton.glamId = glamToAssign.glamId;
    favoriteButton.toUser = glamToAssign.user;
    
    commentButton.glamId = glamToAssign.glamId;
    
    //query to find glam associated with ID being passed in
    PFQuery *glamQuery = [PFQuery queryWithClassName:@"Glam"];
    [glamQuery whereKey:@"objectId" equalTo:glamToAssign.glamId];
    
    //query to find activites associated with glam with ID being passed in
    PFQuery *activityQuery = [PFQuery queryWithClassName:@"Activity"];
    [activityQuery whereKey:@"glam" matchesKey:@"objectId" inQuery:glamQuery];
    
    NSNumberFormatter *numberFormatter = [[NSNumberFormatter alloc] init];
    
    [activityQuery findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
       
        if (!error) {
            
            //if there are any activities
            if ([objects count] > 0) {
                
                int favCount = 0;
                int commentCount = 0;
                
                for (PFObject *obj in objects) {
                    
                    //get type of activity so we know which to increase
                    if ([obj[@"type"] isEqualToString:@"favorite"]) {
                        
                        favCount++;
                        
                        NSLog(@"%@", obj[@"fromUser"]);
                        NSLog(@"%@", [PFUser currentUser]);
                        
                        //check if we favorited this glam
                        if ([[obj[@"fromUser"] objectId] isEqual:[[PFUser currentUser] objectId]]) {
                            
                            didIFavorite = YES;
                            
                        }
                        
                    } else if ([obj[@"type"] isEqualToString:@"comment"]) {
                        
                        commentCount++;
                        
                        //check if we commented on this glam
                        if ([[obj[@"fromUser"] objectId] isEqual:[[PFUser currentUser] objectId]]) {
                            
                            didIComment = YES;
                            
                        }
                        
                    }
                    
                }
                
                //change comment button to color version if we commented on it
                if (didIComment) {
                    
                    [commentButton setSelected:YES];
                    
                    [commentButton setTitle:[numberFormatter stringFromNumber:[NSNumber numberWithInt:commentCount]] forState:UIControlStateSelected];
                    
                //else leave it black and white
                } else {
                    
                    [commentButton setSelected:NO];
                    
                    [commentButton setTitle:[numberFormatter stringFromNumber:[NSNumber numberWithInt:commentCount]] forState:UIControlStateNormal];
                    
                }
                
                //change favorite button to color version if we favorited it
                if (didIFavorite) {
                    
                    [favoriteButton setSelected:YES];
                    
                    [favoriteButton setTitle:[numberFormatter stringFromNumber:[NSNumber numberWithInt:favCount]] forState:UIControlStateSelected];
                
                //else leave it black and white
                } else {
                    
                    [favoriteButton setSelected:NO];
                    
                    [favoriteButton setTitle:[numberFormatter stringFromNumber:[NSNumber numberWithInt:favCount]] forState:UIControlStateNormal];
                    
                }
                
            }
            
        } else {
            
            NSLog(@"Error: %@ %@", error, [error userInfo]);
            
        }
        
    }];
    
}

//action for when we favorite a glam
- (IBAction)favoriteAction:(FavoriteButton *)sender
{
    
    NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
    
    NSLog(@"%@", sender.titleLabel.text);
    
    //get current amount of favorites
    NSNumber *favCount = [formatter numberFromString:sender.titleLabel.text];
    
    //check if we are favoriting or unfavoriting
    if (![favoriteButton isSelected]) {
        
        //create new activity object
        PFObject *activity = [PFObject objectWithClassName:@"Activity"];
        
        //query to find glam with the ID of the button we tapped
        PFQuery *query = [PFQuery queryWithClassName:@"Glam"];
        [query whereKey:@"objectId" equalTo:sender.glamId];
        [query getFirstObjectInBackgroundWithBlock:^(PFObject *object, NSError *error) {
            
            //set properties of activity
            activity[@"type"] = @"favorite";
            activity[@"toUser"] = sender.toUser;
            activity[@"fromUser"] = [PFUser currentUser];
            activity[@"glam"] = object;
            
            //save new activity
            [activity saveEventually];
            
        }];
        
        //increase favorite count
        favCount = [NSNumber numberWithInt:[favCount intValue] + 1];
        
        //change to color version of button
        [favoriteButton setSelected:YES];
        
    } else {
        
        //query to find glam with the ID of the button we tapped
        PFQuery *glamQuery = [PFQuery queryWithClassName:@"Glam"];
        
        [glamQuery whereKey:@"objectId" equalTo:sender.glamId];
        
        //query to find activities for this glam where we are the from user
        PFQuery *activityQuery = [PFQuery queryWithClassName:@"Activity"];
        
        [activityQuery whereKey:@"glam" matchesKey:@"objectId" inQuery:glamQuery];
        [activityQuery whereKey:@"toUser" equalTo:sender.toUser];
        [activityQuery whereKey:@"fromUser" equalTo:[PFUser currentUser]];
        
        [activityQuery getFirstObjectInBackgroundWithBlock:^(PFObject *object, NSError *error) {
           
            //delete object
            [object deleteEventually];
            
        }];
        
        //if favorite count is more than 0, decrease it by 1
        if ([favCount intValue] > 0) {
         
            favCount = [NSNumber numberWithInt:[favCount intValue] - 1];
            
        }
        
        //set to black and white version of button
        [favoriteButton setSelected:NO];
        
    }
    
    [favoriteButton setTitle:[formatter stringFromNumber:favCount] forState:UIControlStateNormal];
    
}


//action for when we comment on a glam
- (IBAction)commentAction:(FavoriteButton *)sender
{
    //use app delegate to present comment view controller
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    CommentViewController *cvc = [storyboard instantiateViewControllerWithIdentifier:@"commentViewController"];
    
    //set delegate and glam id of comment view controller
    cvc.delegate = self;
    cvc.glamId = sender.glamId;
    
    [appDelegate.window.rootViewController presentViewController:cvc animated:YES completion:nil];
    
}

//function for when we pass back a comment and add it to the glam
- (void) didAddComment:(NSString *)comment
{
    
    NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
    
    //get current comment count
    NSNumber *commentCount = [formatter numberFromString:commentButton.titleLabel.text];
    
    //increase comment count by 1
    commentCount = [NSNumber numberWithInt:[commentCount intValue] + 1];
    
    //query to find glam that matches ID of the button we tapped
    PFQuery *glamQuery = [PFQuery queryWithClassName:@"Glam"];
    
    [glamQuery whereKey:@"objectId" equalTo:commentButton.glamId];
    PFObject *glam = [glamQuery getFirstObject];
    
    //create new activity object
    PFObject *activity = [PFObject objectWithClassName:@"Activity"];
    
    //assign properties of activity object
    activity[@"type"] = @"comment";
    activity[@"fromUser"] = [PFUser currentUser];
    activity[@"glam"] = glam;
    activity[@"content"] = comment;
    
    //save activity object
    [activity save];
    
    //set count and change to color version of button
    [commentButton setSelected:YES];
    [commentButton setTitle:[formatter stringFromNumber:commentCount] forState:UIControlStateSelected];
    
}

@end
