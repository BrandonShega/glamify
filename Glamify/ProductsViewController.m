//
//  ProductsViewController.m
//  Glamify
//
//  Created by Brandon Shega on 1/15/15.
//  Copyright (c) 2015 Brandon Shega. All rights reserved.
//

#import "ProductsViewController.h"
#import "AddProductViewController.h"
#import "Product.h"

@interface ProductsViewController () <ProductDelegate, UITableViewDataSource, UITableViewDelegate>

@end

@implementation ProductsViewController

@synthesize productArray, productsTable;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    productArray = [[NSMutableArray alloc] init];
    
    [productsTable setDelegate:self];
    [productsTable setDataSource:self];
    
}

- (BOOL)prefersStatusBarHidden
{
    return YES;
}

- (void)productViewControllerDismissedwithProduct:(Product *)product
{
    
    [productArray addObject:product];
    
    [productsTable reloadData];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [productArray count];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    NSString *cellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier forIndexPath:indexPath];
    
    if (cell != nil) {
        
        Product *product = [productArray objectAtIndex:indexPath.row];
        
        cell.textLabel.text = product.name;
        
    }
    
    return cell;
    
}

- (IBAction)backButton:(id)sender
{
    
    [self.navigationController popViewControllerAnimated:YES];
    
}

- (IBAction)addProduct:(id)sender
{
    
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    AddProductViewController *apvc = [storyboard instantiateViewControllerWithIdentifier:@"AddProductViewController"];
    [apvc setModalPresentationStyle:UIModalPresentationFullScreen];
    
    apvc.delegate = self;
    
    [self presentViewController:apvc animated:YES completion:nil];
    
}
@end
