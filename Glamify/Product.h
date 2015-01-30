//
//  Product.h
//  Glamify
//
//  Created by Brandon Shega on 1/8/15.
//  Copyright (c) 2015 Brandon Shega. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Product : NSObject

@property (weak, nonatomic) NSString *name;
@property (weak, nonatomic) NSString *reviewURL;
@property (weak, nonatomic) NSString *productURL;

@end
