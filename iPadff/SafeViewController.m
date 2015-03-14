//
//  SafeViewController.m
//  iPadff
//
//  Created by 黄含章 on 15/3/13.
//  Copyright (c) 2015年 LanTaiPro. All rights reserved.
//

#import "SafeViewController.h"

@interface SafeViewController ()

@end

@implementation SafeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    NSLog(@"当前是~~~~~~~~~~~~%d",self.Index);
    self.view.backgroundColor = [UIColor cyanColor];
    [self.swithView setSelectedBtnAtIndex:2];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
