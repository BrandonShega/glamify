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
@property (weak, nonatomic) NSString *category;
@property (weak, nonatomic) NSMutableArray *comments;
@property (weak, nonatomic) NSMutableArray *products;

- (void)saveGlam;

@end
