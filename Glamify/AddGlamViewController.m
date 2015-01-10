//
//  AddGlamViewController.m
//  Glamify
//
//  Created by Brandon Shega on 12/18/14.
//  Copyright (c) 2014 Brandon Shega. All rights reserved.
//

#import "AddGlamViewController.h"
#import "AddProductViewController.h"
#import "Product.h"
#import "Glam.h"

@interface AddGlamViewController () <ProductDelegate>

@end

@implementation AddGlamViewController

@synthesize productTableView, glamNameText;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    productArray = [[NSMutableArray alloc] init];
    
    [productTableView setDelegate:self];
    [productTableView setDataSource:self];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (BOOL)prefersStatusBarHidden
{
    return YES;
}

#pragma mark ProductDelegate
- (void)productViewControllerDismissedwithProduct:(Product *)product
{
    
    [productArray addObject:product];
    
}

- (void)viewDidAppear:(BOOL)animated
{
    
    [super viewDidAppear:animated];

    
//    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
//    
//    picker.delegate = self;
//    picker.allowsEditing = NO;
//    picker.sourceType = UIImagePickerControllerSourceTypeCamera;
//    
//    [self presentViewController:picker animated:YES completion:nil];
    
    [productTableView reloadData];
    
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [productArray count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    static NSString *cellIdentifier = @"Cell";
    
    UITableViewCell *cell = [self.productTableView dequeueReusableCellWithIdentifier:cellIdentifier forIndexPath:indexPath];
    
    if (cell == nil) {
        
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"Cell"];
        
    }
    
    Product *product = [productArray objectAtIndex:indexPath.row];
    
    cell.textLabel.text = product.name;
    
    return cell;
    
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

//Open modal for user to add a product to glam
- (IBAction)addProductButton:(id)sender
{
    
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    AddProductViewController *pvc = [storyboard instantiateViewControllerWithIdentifier:@"AddProductViewController"];
    [pvc setModalPresentationStyle:UIModalPresentationFullScreen];
    
    pvc.delegate = self;
    
    [self presentViewController:pvc animated:YES completion:nil];
    
}

//Create new glam object and then save to database
- (IBAction)saveGlamButton:(id)sender
{
    
    Glam *newGlam = [[Glam alloc] init];
    PFUser *currentUser = [PFUser currentUser];
    
    newGlam.name = [glamNameText text];
    newGlam.user = currentUser;
    newGlam.products = productArray;
    
    [newGlam saveGlam];
    
}
@end
