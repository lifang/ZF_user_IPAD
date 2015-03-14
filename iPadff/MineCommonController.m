//
//  MineCommonController.m
//  iPadff
//
//  Created by 黄含章 on 15/3/11.
//  Copyright (c) 2015年 LanTaiPro. All rights reserved.
//

#import "MineCommonController.h"
#import "BaseInformationViewController.h"
#import "MyShopViewController.h"
#import "MyOrderViewController.h"
#import "AfterSellViewController.h"
#import "ApplyPlanViewController.h"

@interface MineCommonController ()

@end

@implementation MineCommonController

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:NO];
    self.navigationController.navigationBarHidden = YES;
}


-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:NO];
    self.navigationController.navigationBarHidden = NO;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationController.navigationBarHidden = YES;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)setLeftViewWith:(ChooseViewType)choosetype
{
    ChooseView *chooseView = [[ChooseView alloc]initWithFrame:CGRectMake(0, 0, 160.f, SCREEN_HEIGHT) With:choosetype];
    if (iOS7) {
        chooseView = [[ChooseView alloc]initWithFrame:CGRectMake(0, 0, 160.f, SCREEN_WIDTH) With:choosetype];
    }
    [chooseView.orderBtn addTarget:self action:@selector(orderClick) forControlEvents:UIControlEventTouchUpInside];
    [chooseView.aftersellBtn addTarget:self action:@selector(aftersellBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [chooseView.messageBtn addTarget:self action:@selector(messageBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [chooseView.shopBtn addTarget:self action:@selector(shopBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [chooseView.applyBtn addTarget:self action:@selector(applyBtnClick) forControlEvents:UIControlEventTouchUpInside];
    
    self.chooseView = chooseView;
    [self.view addSubview:chooseView];

}

//我的订单
-(void)orderClick
{
    MyOrderViewController *myOrderVC = [[MyOrderViewController alloc]init];
    myOrderVC.navigationController.navigationBarHidden = YES;
    [self.navigationController pushViewController:myOrderVC animated:NO];
}
//售后记录
-(void)aftersellBtnClick
{
    AfterSellViewController *afterVC = [[AfterSellViewController alloc]init];
    afterVC.navigationController.navigationBarHidden = YES;
    [self.navigationController pushViewController:afterVC animated:NO];
}
//我的信息
-(void)messageBtnClick
{
    BaseInformationViewController *baseInformationVC = [[BaseInformationViewController alloc]init];
    [self.navigationController pushViewController:baseInformationVC animated:NO];
}
//我的商户
-(void)shopBtnClick
{
    MyShopViewController *shopVC = [[MyShopViewController alloc]init];
    [self.navigationController pushViewController:shopVC animated:NO];
}
//申请进度查询
-(void)applyBtnClick
{
    ApplyPlanViewController *applyPlanVC = [[ApplyPlanViewController alloc]init];
    [self.navigationController pushViewController:applyPlanVC animated:NO];
}



@end
