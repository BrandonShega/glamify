//
//  CommentViewController.h
//  Glamify
//
//  Created by Brandon Shega on 12/18/14.
//  Copyright (c) 2014 Brandon Shega. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>

@protocol commentDelegate <NSObject>

- (void)didAddComment:(NSString *)comment;

@end

@interface CommentViewController : UIViewController

- (IBAction)commentDone:(id)sender;
- (IBAction)commentCancel:(id)sender;

@property (nonatomic, weak) id<commentDelegate> delegate;
@property (nonatomic, weak) NSString *commentString;
@property (weak, nonatomic) IBOutlet UITextField *commentText;
@property (weak, nonatomic) IBOutlet UITableView *commentTable;

@property (weak, nonatomic) NSString *glamId;

@end
