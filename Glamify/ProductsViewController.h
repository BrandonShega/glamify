//
//  ProductsViewController.h
//  Glamify
//
//  Created by Brandon Shega on 1/15/15.
//  Copyright (c) 2015 Brandon Shega. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ProductsViewController : UIViewController

@property (strong, nonatomic) NSMutableArray *productArray;

- (IBAction)backButton:(id)sender;
- (IBAction)addProduct:(id)sender;
@property (weak, nonatomic) IBOutlet UITableView *productsTable;

@end
