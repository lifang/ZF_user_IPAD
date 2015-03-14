//
//  IntegralViewController.m
//  iPadff
//
//  Created by 黄含章 on 15/3/13.
//  Copyright (c) 2015年 LanTaiPro. All rights reserved.
//

#import "IntegralViewController.h"

@interface IntegralViewController ()

@end

@implementation IntegralViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.swithView setSelectedBtnAtIndex:4];
    NSLog(@"当前是~~~~~~~~~~~~%d",self.Index);
    self.view.backgroundColor = [UIColor yellowColor];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
