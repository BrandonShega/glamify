//
//  AddGlamViewController.m
//  Glamify
//
//  Created by Brandon Shega on 12/18/14.
//  Copyright (c) 2014 Brandon Shega. All rights reserved.
//

#import "AddGlamViewController.h"
#import "AddProductViewController.h"

@interface AddGlamViewController () <ProductDelegate>

@end

@implementation AddGlamViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    productArray = [[NSMutableArray alloc] init];
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
    
    
    
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)addProductButton:(id)sender
{
    
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    AddProductViewController *pvc = [storyboard instantiateViewControllerWithIdentifier:@"AddProductViewController"];
    [pvc setModalPresentationStyle:UIModalPresentationFullScreen];
    
    pvc.delegate = self;
    
    [self presentViewController:pvc animated:YES completion:nil];
    
}
@end
