//
//  AddGlamViewController.h
//  Glamify
//
//  Created by Brandon Shega on 12/18/14.
//  Copyright (c) 2014 Brandon Shega. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AddGlamViewController : UIViewController <UIImagePickerControllerDelegate, UITableViewDataSource, UITableViewDelegate>
{
    NSMutableArray *productArray;
}

- (IBAction)addProductButton:(id)sender;

@property (weak, nonatomic) IBOutlet UITableView *productTableView;

@end
