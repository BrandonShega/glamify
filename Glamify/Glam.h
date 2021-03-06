//
//  Glam.h
//  Glamify
//
//  Created by Brandon Shega on 12/18/14.
//  Copyright (c) 2014 Brandon Shega. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Parse/Parse.h>

@interface Glam : NSObject
{
    
    NSInteger likes;
    
}

@property (weak, nonatomic) PFUser *user;
@property (weak, nonatomic) NSString *name;
@property (weak, nonatomic) NSString *glamId;
@property (weak, nonatomic) NSString *category;
@property (weak, nonatomic) NSMutableArray *comments;
@property (weak, nonatomic) NSMutableArray *products;
@property (weak, nonatomic) NSData *image;
@property (weak, nonatomic) NSData *thumbnail;
@property (weak, nonatomic) NSData *posterImage;
@property (weak, nonatomic) PFFile *glamImageFile;

- (void)saveGlam;

@end
