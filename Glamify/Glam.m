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
    
    //create glam object to save
    PFObject *glamToSave = [PFObject objectWithClassName:@"Glam"];
    
    NSMutableArray *productArray = [NSMutableArray array];
    
    //grab products from array and create dictionary for the name and URL
    for (Product *eachProduct in self.products) {
        
        NSMutableDictionary *productDict = [NSMutableDictionary dictionary];
        
        productDict[@"name"] = eachProduct.name;
        productDict[@"productURL"] = eachProduct.productURL;
        
        [productArray addObject:productDict];
        
    }
    
    NSArray *arrayCopy = [productArray copy];
    
    //add properties of the glam to save
    glamToSave[@"user"] = self.user;
    glamToSave[@"name"] = self.name;
    glamToSave[@"products"] = arrayCopy;
    
    //create file to upload of glam's image
    PFFile *imageFile = [PFFile fileWithName:@"Image.jpg" data:self.image];
    
    //upload file
    [imageFile saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        
        if (!error) {
            
            glamToSave[@"imageFile"] = imageFile;
            //glamToSave.ACL = [PFACL ACLWithUser:self.user];
            
            //save glam after file upload
            [glamToSave saveInBackground];
            
        } else {
            
            NSLog(@"Error %@ %@", error, [error userInfo]);
        }
        
    }];
}

@end
