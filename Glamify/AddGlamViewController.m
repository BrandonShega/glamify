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
#import "UIImage+Resize.h"
#import "UIImage+RoundedCorner.h"

@interface AddGlamViewController () <UIAlertViewDelegate, UIPickerViewDataSource, UIPickerViewDelegate>

@end

@implementation AddGlamViewController;

@synthesize productTableView, glamNameText, glamImage, category, glamCategory;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    productArray = [[NSMutableArray alloc] init];
    
    [productTableView setDelegate:self];
    [productTableView setDataSource:self];
    
    [category setDelegate:self];
    [category setDataSource:self];
    
    data = [[NSArray alloc] initWithObjects:@"Makeup", @"Hair", @"Outfit", @"Nails", @"Cosmetics", nil];
    
    UIPickerView *picker = [[UIPickerView alloc] init];
    self.glamCategory.inputView = picker;
    
    picker.dataSource = self;
    picker.delegate = self;
    
}

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    return [data count];
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    return [data objectAtIndex:row];
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    
    self.glamCategory.text = [data objectAtIndex:row];
    [self.glamCategory resignFirstResponder];
    
}

- (void)galleryImage
{
    
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
    
    picker.delegate = (id <UINavigationControllerDelegate, UIImagePickerControllerDelegate>) self;
    picker.allowsEditing = NO;
    picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    
    [self presentViewController:picker animated:YES completion:nil];
    
}

- (void)cameraImage
{
    
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
    
    picker.delegate = (id <UINavigationControllerDelegate, UIImagePickerControllerDelegate>) self;
    picker.allowsEditing = NO;
    picker.sourceType = UIImagePickerControllerSourceTypeCamera;
    
    [self presentViewController:picker animated:YES completion:nil];
    
}

- (void)chooseImage
{
    
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Image Selector" message:@"How would you like to add an image?" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:nil, nil];
    
    [alert addButtonWithTitle:@"Camera"];
    [alert addButtonWithTitle:@"Gallery"];
    
    [alert show];
    
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    
    switch (buttonIndex) {
        case 1:
            if (![UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error!" message:@"There is no camera on this device" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
                [alert show];
            } else {
                [self cameraImage];
            }
            break;
        case 2:
            [self galleryImage];
            break;
        default:
            break;
    }
    
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    
    UIImage *chosenImage = info[UIImagePickerControllerOriginalImage];
    [glamImage setImage:chosenImage forState:UIControlStateNormal];
    
    [picker dismissViewControllerAnimated:YES completion:nil];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (BOOL)prefersStatusBarHidden
{
    return YES;
}

- (void)viewDidAppear:(BOOL)animated
{
    
    [super viewDidAppear:animated];
    
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
//- (IBAction)addProductButton:(id)sender
//{
//    
//    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
//    AddProductViewController *pvc = [storyboard instantiateViewControllerWithIdentifier:@"AddProductViewController"];
//    [pvc setModalPresentationStyle:UIModalPresentationFullScreen];
//    
//    pvc.delegate = self;
//    
//    [self presentViewController:pvc animated:YES completion:nil];
//    
//}

//Create new glam object and then save to database
- (IBAction)saveGlamButton:(id)sender
{
    
    Glam *newGlam = [[Glam alloc] init];
    PFUser *currentUser = [PFUser currentUser];
    UIImage *currentImage = [self.glamImage imageForState:UIControlStateNormal];
    
    //UIImage *resized =  [currentImage resizedImageWithContentMode:UIViewContentModeScaleAspectFit bounds:CGSizeMake(560.0f, 560.0f) interpolationQuality:kCGInterpolationHigh];
    
    NSData *imageData = UIImageJPEGRepresentation(currentImage, 0.05f);
    
    newGlam.name = [glamNameText text];
    newGlam.user = currentUser;
    newGlam.products = productArray;
    newGlam.image = imageData;
    
    [newGlam saveGlam];
    
    glamNameText.text = @"";
    [productArray removeAllObjects];
    [productTableView reloadData];
    UIImage *defaultImage = [UIImage imageNamed:@"imagepicker"];
    [glamImage setImage:defaultImage forState:UIControlStateNormal];
    [self.tabBarController setSelectedIndex:0];
    
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Success!" message:@"Glam saved successfully" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
    
    [alert show];
    
    
}

- (IBAction)addImageButton:(id)sender
{
    
    [self chooseImage];
    
}
@end
