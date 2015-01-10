//
//  AddGlamViewController.h
//  Glamify
//
//  Created by Brandon Shega on 12/18/14.
//  Copyright (c) 2014 Brandon Shega. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>

@interface AddGlamViewController : UIViewController <UIImagePickerControllerDelegate, UITableViewDataSource, UITableViewDelegate>
{
    NSMutableArray *productArray;
}

- (IBAction)addProductButton:(id)sender;
- (IBAction)saveGlamButton:(id)sender;
@property (weak, nonatomic) IBOutlet UITextField *glamNameText;

@property (weak, nonatomic) IBOutlet UITableView *productTableView;

@end
