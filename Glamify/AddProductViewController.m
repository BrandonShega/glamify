//
//  AddProductViewController.m
//  Glamify
//
//  Created by Brandon Shega on 12/18/14.
//  Copyright (c) 2014 Brandon Shega. All rights reserved.
//

#import "AddProductViewController.h"

@interface AddProductViewController ()

@end

@implementation AddProductViewController

@synthesize delegate, productNameText, productURLText;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (BOOL)prefersStatusBarHidden
{
    return YES;
}


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)doneProduct:(id)sender
{
    //create new product object
    Product *newProduct = [[Product alloc] init];
    
    newProduct.name = [productNameText text];
    newProduct.productURL = [productURLText text];
    
    //pass product back to add a glam view controller
    [self.delegate productViewControllerDismissedwithProduct:newProduct];
    [self dismissViewControllerAnimated:YES completion:nil];
    
}
@end
