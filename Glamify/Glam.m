//
//  Glam.m
//  Glamify
//
//  Created by Brandon Shega on 12/18/14.
//  Copyright (c) 2014 Brandon Shega. All rights reserved.
//

#import "Glam.h"
#import "Product.h"

@implementation Glam

@synthesize user, name, category, comments, products, image;

- (void)saveGlam
{
    
    PFObject *glamToSave = [PFObject objectWithClassName:@"Glam"];
    
    NSMutableArray *productArray = [NSMutableArray array];
    
    for (Product *eachProduct in self.products) {
        
        NSMutableDictionary *productDict = [NSMutableDictionary dictionary];
        
        [productDict setObject:eachProduct.name forKey:@"name"];
        [productDict setObject:eachProduct.productURL forKey:@"productURL"];
        
        [productArray addObject:productDict];
        
    }
    
    NSArray *arrayCopy = [productArray copy];
    
    glamToSave[@"user"] = self.user;
    glamToSave[@"name"] = self.name;
    glamToSave[@"products"] = arrayCopy;
    
    //save glam and retrieve ID to upload associated image
    [glamToSave save];
    
    NSString *objectID = [glamToSave objectId];
    
    PFFile *imageFile = [PFFile fileWithName:@"Image.jpg" data:self.image];
    
    [imageFile saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        
        if (!error) {
            
            PFObject *glamPhoto = [PFObject objectWithClassName:@"GlamPhoto"];
            glamPhoto[@"imageFile"] = imageFile;
            glamPhoto[@"user"] = self.user;
            glamPhoto[@"glam"] = objectID;
            
            glamPhoto.ACL = [PFACL ACLWithUser:self.user];
            
            [glamPhoto saveInBackground];
        } else {
            
            NSLog(@"Error %@ %@", error, [error userInfo]);
        }
        
    }];
}

@end
