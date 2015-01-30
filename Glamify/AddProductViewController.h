//
//  AddProductViewController.h
//  Glamify
//
//  Created by Brandon Shega on 12/18/14.
//  Copyright (c) 2014 Brandon Shega. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Product.h"

@protocol ProductDelegate <NSObject>

- (void)productViewControllerDismissedwithProduct:(Product *)product;

@end

@interface AddProductViewController : UIViewController

@property (weak, nonatomic) IBOutlet UITextField *productNameText;
@property (weak, nonatomic) IBOutlet UITextField *productURLText;

@property (nonatomic, weak) id<ProductDelegate> delegate;

- (IBAction)doneProduct:(id)sender;

@end
