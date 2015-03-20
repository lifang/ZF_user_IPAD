//
//  MyMessageViewController.m
//  iPadff
//
//  Created by 黄含章 on 15/3/11.
//  Copyright (c) 2015年 LanTaiPro. All rights reserved.
//

#import "MyMessageViewController.h"
#import "SafeViewController.h"
#import "BaseInformationViewController.h"
#import "AddressViewController.h"
#import "IntegralViewController.h"

@interface MyMessageViewController ()<SwitchViewClicked>


@end

@implementation MyMessageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setLeftViewWith:ChooseViewMyMessage];
    NSLog(@"%d",ChooseViewMyMessage);
    self.view.backgroundColor = kColor(252, 251, 251, 1.0);
    [self setupHeaderView];
}

-(void)setupHeaderView
{
    NSArray *nameArr = [NSArray arrayWithObjects:@"基础信息",@"安全",@"地址管理",@"积分", nil];
    SwitchView *swithView = [[SwitchView alloc]initWithFrame:CGRectMake(160.f, 0, SCREEN_WIDTH - 160.f, 80) With:nameArr];
    self.swithView = swithView;
    _swithView.SwitchViewClickedDelegate = self;
    [self.view addSubview:_swithView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - SwitchView Delegate
-(void)SwitchViewClickedAtIndex:(int)Index
{
    NSLog(@"点击了第%d个按钮",Index);
    self.Index = Index;
    switch (Index) {
        case 1:
        {
        BaseInformationViewController *informationVC = [[BaseInformationViewController alloc]init];
            informationVC.Index = Index;
        [self.navigationController pushViewController:informationVC animated:NO];
        }
        break;
        case 2:
        {
        SafeViewController *safeVC = [[SafeViewController alloc]init];
            safeVC.Index = Index;
        [self.navigationController pushViewController:safeVC animated:NO];
        }
        break;
        case 3:
        {
            AddressViewController *addressVC = [[AddressViewController alloc]init];
            addressVC.Index = Index;
            [self.navigationController pushViewController:addressVC animated:NO];
        }
            break;
        case 4:
        {
            IntegralViewController *integralVC = [[IntegralViewController alloc]init];
            integralVC.Index = Index;
            [self.navigationController pushViewController:integralVC animated:NO];
        }
            break;
            
        default:
            break;
    }
}


@end
