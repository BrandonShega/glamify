//
//  CustomCell.m
//  Glamify
//
//  Created by Brandon Shega on 12/18/14.
//  Copyright (c) 2014 Brandon Shega. All rights reserved.
//

#import "CustomCell.h"
#import "Glam.h"

@implementation CustomCell

@synthesize glamImage, glamName, glamNameString, headerView, postersImage, postersName, favoriteButton;

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
    postersImage.layer.cornerRadius = 25;
    
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
    
    PFQuery *glamQuery = [PFQuery queryWithClassName:@"Glam"];
    
    [glamQuery whereKey:@"objectId" equalTo:glamToAssign.glamId];
    PFObject *glam = [glamQuery getFirstObject];
    
    PFQuery *activityQuery = [PFQuery queryWithClassName:@"Activity"];
    
    [activityQuery whereKey:@"glam" equalTo:glam];
    [activityQuery whereKey:@"toUser" equalTo:glamToAssign.user];
    [activityQuery whereKey:@"fromUser" equalTo:[PFUser currentUser]];
    
    [activityQuery findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
       
        if (!error) {
            
            if ([objects count] > 0) {
                
                [favoriteButton setTitle:@"Unfavorite" forState:UIControlStateNormal];
                
            } else {
                
                [favoriteButton setTitle:@"Favorite" forState:UIControlStateNormal];
                
            }
            
        } else {
            
            NSLog(@"Error: %@ %@", error, [error userInfo]);
            
        }
        
    }];
    
}

- (IBAction)favoriteAction:(FavoriteButton *)sender
{
    
    if ([[favoriteButton titleForState:UIControlStateNormal] isEqualToString:@"Favorite"]) {
        
        PFObject *activity = [PFObject objectWithClassName:@"Activity"];
        
        PFQuery *query = [PFQuery queryWithClassName:@"Glam"];
        [query whereKey:@"objectId" equalTo:sender.glamId];
        PFObject *glam = [query getFirstObject];
        
        activity[@"type"] = @"favorite";
        activity[@"toUser"] = sender.toUser;
        activity[@"fromUser"] = [PFUser currentUser];
        activity[@"glam"] = glam;
        
        [activity save];
        
        [favoriteButton setTitle:@"Unfavorite" forState:UIControlStateNormal];
        
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
        
        [favoriteButton setTitle:@"Favorite" forState:UIControlStateNormal];
        
    }
    
}


@end
