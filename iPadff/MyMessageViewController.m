//
//  MyMessageViewController.m
//  iPadff
//
//  Created by 黄含章 on 15/3/11.
//  Copyright (c) 2015年 LanTaiPro. All rights reserved.
//

#import "MyMessageViewController.h"
#import "SwitchView.h"

@interface MyMessageViewController ()

@end

@implementation MyMessageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setLeftViewWith:ChooseViewMyMessage];
    self.view.backgroundColor = kColor(252, 251, 251, 1.0);
    [self setupHeaderView];
}

-(void)setupHeaderView
{
    NSArray *nameArr = [NSArray arrayWithObjects:@"基础信息",@"安全",@"地址管理",@"积分", nil];
    SwitchView *swithView = [[SwitchView alloc]initWithFrame:CGRectMake(160.f, 0, SCREEN_WIDTH - 160.f, 80) With:nameArr];
    [self.view addSubview:swithView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
