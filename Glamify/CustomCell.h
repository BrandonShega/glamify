//
//  CustomCell.h
//  Glamify
//
//  Created by Brandon Shega on 12/18/14.
//  Copyright (c) 2014 Brandon Shega. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>
#import "Glam.h"
#import "FavoriteButton.h"
#import <Parse/Parse.h>
#import "CommentViewController.h"
#import <ParseUI/ParseUI.h>

@interface CustomCell : PFTableViewCell <commentDelegate>

@property (weak, nonatomic) IBOutlet UILabel *glamName;
@property (weak, nonatomic) IBOutlet PFImageView *glamImage;
@property (weak, nonatomic) NSString *glamNameString;
@property (weak, nonatomic) IBOutlet UIView *headerView;
@property (weak, nonatomic) IBOutlet PFImageView *postersImage;
@property (weak, nonatomic) IBOutlet UILabel *postersName;
@property (weak, nonatomic) IBOutlet FavoriteButton *favoriteButton;
@property (weak, nonatomic) IBOutlet UIView *cardView;
@property (weak, nonatomic) IBOutlet FavoriteButton *commentButton;

- (void)assignGlam:(Glam *)glamToAssign;
- (IBAction)favoriteAction:(FavoriteButton *)sender;
- (IBAction)commentAction:(FavoriteButton *)sender;

@end
