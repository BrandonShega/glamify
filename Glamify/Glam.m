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

@synthesize user, name, category, comments, products, image, glamId, thumbnail, glamImageFile;

- (void)saveGlam
{
    
    PFObject *glamToSave = [PFObject objectWithClassName:@"Glam"];
    
    NSMutableArray *productArray = [NSMutableArray array];
    
    for (Product *eachProduct in self.products) {
        
        NSMutableDictionary *productDict = [NSMutableDictionary dictionary];
        
        productDict[@"name"] = eachProduct.name;
        productDict[@"productURL"] = eachProduct.productURL;
        
        [productArray addObject:productDict];
        
    }
    
    NSArray *arrayCopy = [productArray copy];
    
    glamToSave[@"user"] = self.user;
    glamToSave[@"name"] = self.name;
    glamToSave[@"products"] = arrayCopy;
    
    PFFile *imageFile = [PFFile fileWithName:@"Image.jpg" data:self.image];
    
    
    
    [imageFile saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        
        if (!error) {
            
            glamToSave[@"imageFile"] = imageFile;
            //glamToSave.ACL = [PFACL ACLWithUser:self.user];
            
            [glamToSave saveInBackground];
            
        } else {
            
            NSLog(@"Error %@ %@", error, [error userInfo]);
        }
        
    }];
}

@end
