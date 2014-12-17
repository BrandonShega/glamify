//
//  CustomButton.m
//  Glamify
//
//  Created by Brandon Shega on 12/16/14.
//  Copyright (c) 2014 Brandon Shega. All rights reserved.
//

#import "CustomButton.h"
#import "StyleKit.h"

@implementation CustomButton


// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
    [StyleKit drawCanvas1WithFrame:self.bounds];
}


@end
