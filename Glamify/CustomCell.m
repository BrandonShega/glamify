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
    
    self.headerView.layer.shadowColor = [[UIColor blackColor] CGColor];
    self.headerView.layer.shadowOffset = CGSizeZero;
    self.headerView.layer.shadowRadius = 4.0f;
    self.headerView.layer.shadowOpacity = 1.0f;
    
    UIBezierPath *path = [UIBezierPath bezierPath];
    
    [path moveToPoint:CGPointMake(CGRectGetWidth(self.headerView.frame) / 2, CGRectGetHeight(self.headerView.frame) /2 )];
    [path addLineToPoint:CGPointMake(CGRectGetWidth(self.headerView.frame), CGRectGetHeight(self.headerView.frame))];
    [path addLineToPoint:CGPointMake(0, CGRectGetHeight(self.headerView.frame))];
    [path closePath];
    
    self.headerView.layer.shadowPath = path.CGPath;
    
    postersImage.clipsToBounds = YES;
    postersImage.layer.cornerRadius = 20;
    
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

- (void)setLabel:(NSString *)nameString andImage:(UIImage *)image andPostersImage:(UIImage *)posterImage andPostersName:(NSString *)posterNameString
{
    [glamName setText:nameString];
    [postersName setText:posterNameString];
    
    [glamImage setImage:image];
    [postersImage setImage:posterImage];
}

- (void)assignGlam:(Glam *)glamToAssign
{
    favoriteButton.glamId = glamToAssign.glamId;
    favoriteButton.toUser = glamToAssign.user;
    
    commentButton.glamId = glamToAssign.glamId;
    
    PFQuery *glamQuery = [PFQuery queryWithClassName:@"Glam"];
    
    [glamQuery whereKey:@"objectId" equalTo:glamToAssign.glamId];
    PFObject *glam = [glamQuery getFirstObject];
    
    PFQuery *activityQuery = [PFQuery queryWithClassName:@"Activity"];
    
    [activityQuery whereKey:@"glam" equalTo:glam];
    [activityQuery whereKey:@"toUser" equalTo:glamToAssign.user];
    [activityQuery whereKey:@"fromUser" equalTo:[PFUser currentUser]];
    
    NSNumberFormatter *numberFormatter = [[NSNumberFormatter alloc] init];
    
    [activityQuery findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
       
        if (!error) {
            
            if ([objects count] > 0) {
                
                [favoriteButton setSelected:YES];
                
                NSNumber *favCount = [NSNumber numberWithInteger:[objects count]];
                
                
                [favoriteButton setTitle:[numberFormatter stringFromNumber:favCount] forState:UIControlStateSelected];
                
            } else {
                
                [favoriteButton setSelected:NO];
                NSNumber *favCount = [NSNumber numberWithInteger:[objects count]];
                
                
                [favoriteButton setTitle:[numberFormatter stringFromNumber:favCount] forState:UIControlStateNormal];
            }
            
        } else {
            
            NSLog(@"Error: %@ %@", error, [error userInfo]);
            
        }
        
    }];
    
}

- (IBAction)favoriteAction:(FavoriteButton *)sender
{
    
    NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
    
    NSNumber *favCount = [formatter numberFromString:sender.titleLabel.text];
    
    if (![favoriteButton isSelected]) {
        
        PFObject *activity = [PFObject objectWithClassName:@"Activity"];
        
        PFQuery *query = [PFQuery queryWithClassName:@"Glam"];
        [query whereKey:@"objectId" equalTo:sender.glamId];
        PFObject *glam = [query getFirstObject];
        
        activity[@"type"] = @"favorite";
        activity[@"toUser"] = sender.toUser;
        activity[@"fromUser"] = [PFUser currentUser];
        activity[@"glam"] = glam;
        
        [activity save];
        
        favCount = [NSNumber numberWithInt:[favCount intValue] + 1];
        
        [favoriteButton setSelected:YES];
        [favoriteButton setTitle:[formatter stringFromNumber:favCount] forState:UIControlStateSelected];
        
    } else {
        
        PFQuery *glamQuery = [PFQuery queryWithClassName:@"Glam"];
        
        [glamQuery whereKey:@"objectId" equalTo:sender.glamId];
        PFObject *glam = [glamQuery getFirstObject];
        
        PFQuery *activityQuery = [PFQuery queryWithClassName:@"Activity"];
        
        [activityQuery whereKey:@"glam" equalTo:glam];
        [activityQuery whereKey:@"toUser" equalTo:sender.toUser];
        [activityQuery whereKey:@"fromUser" equalTo:[PFUser currentUser]];
        
        PFObject *activity = [activityQuery getFirstObject];
        
        [activity delete];
        
        if ([favCount intValue] > 0) {
         
            favCount = [NSNumber numberWithInt:[favCount intValue] - 1];
            
        }
        
        [favoriteButton setSelected:NO];
        [favoriteButton setTitle:[formatter stringFromNumber:favCount] forState:UIControlStateNormal];
        
    }
    
}

- (IBAction)commentAction:(FavoriteButton *)sender
{
    
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    CommentViewController *cvc = [storyboard instantiateViewControllerWithIdentifier:@"commentViewController"];
    
    cvc.delegate = self;
    
    [appDelegate.window.rootViewController presentViewController:cvc animated:YES completion:nil];
    
}

- (void) didAddComment:(NSString *)comment
{
    
    NSLog(@"%@", commentButton.glamId);
    
    NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
    
    NSNumber *commentCount = [formatter numberFromString:commentButton.titleLabel.text];
    
    commentCount = [NSNumber numberWithInt:[commentCount intValue] + 1];
    
    PFQuery *glamQuery = [PFQuery queryWithClassName:@"Glam"];
    
    [glamQuery whereKey:@"objectId" equalTo:commentButton.glamId];
    PFObject *glam = [glamQuery getFirstObject];
    
    PFObject *activity = [PFObject objectWithClassName:@"Activity"];
    
    activity[@"type"] = @"comment";
    activity[@"fromUser"] = [PFUser currentUser];
    activity[@"glam"] = glam;
    activity[@"content"] = comment;
    
    [activity save];
    
    [commentButton setSelected:YES];
    [commentButton setTitle:[formatter stringFromNumber:commentCount] forState:UIControlStateSelected];
    
}

@end
