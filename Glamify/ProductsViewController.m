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
    
    //create new mutable array
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
    //add product to array after product view controller is dismissed
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
    
    //create new cell for product table view
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier forIndexPath:indexPath];
    
    if (cell != nil) {
        
        //set up cell text label
        Product *product = [productArray objectAtIndex:indexPath.row];
        
        cell.textLabel.text = product.name;
        
    }
    
    return cell;
    
}

- (IBAction)backButton:(id)sender
{
    //dismiss product view controller
    [self.navigationController popViewControllerAnimated:YES];
    
}

- (IBAction)addProduct:(id)sender
{
    //show add product view controller
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    AddProductViewController *apvc = [storyboard instantiateViewControllerWithIdentifier:@"AddProductViewController"];
    [apvc setModalPresentationStyle:UIModalPresentationFullScreen];
    
    //set delegate
    apvc.delegate = self;
    
    [self presentViewController:apvc animated:YES completion:nil];
    
}
@end
