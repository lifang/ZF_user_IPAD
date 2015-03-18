//
//  IntegralViewController.m
//  iPadff
//
//  Created by 黄含章 on 15/3/13.
//  Copyright (c) 2015年 LanTaiPro. All rights reserved.
//

#import "IntegralViewController.h"
#import "IntegralCell.h"

@interface IntegralViewController ()<UITableViewDataSource,UITableViewDelegate>

@property(nonatomic,strong)UITableView *integralTableView;

@property(nonatomic,strong)UILabel *intergralLabel;

@end

@implementation IntegralViewController

-(UITableView *)integralTableView
{
    if (!_integralTableView) {
        _integralTableView = [[UITableView alloc]init];
        _integralTableView.translatesAutoresizingMaskIntoConstraints = NO;
        _integralTableView.delegate = self;
        _integralTableView.dataSource = self;
        _integralTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    }
    return _integralTableView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.swithView setSelectedBtnAtIndex:4];
    NSLog(@"当前是~~~~~~~~~~~~%d",self.Index);
    self.view.backgroundColor = [UIColor whiteColor];
    [self initAndLaoutUI];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)initAndLaoutUI
{
    _intergralLabel = [[UILabel alloc]init];
    _intergralLabel.translatesAutoresizingMaskIntoConstraints = NO;
    _intergralLabel.font = [UIFont systemFontOfSize:22];
    _intergralLabel.textColor = kColor(51, 51, 51, 1.0);
    _intergralLabel.text = @"总积分 ：999999999";
    [self.view addSubview:_intergralLabel];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:_intergralLabel
                                                          attribute:NSLayoutAttributeTop
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:self.view
                                                          attribute:NSLayoutAttributeTop
                                                         multiplier:1.0
                                                           constant:130.f]];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:_intergralLabel
                                                          attribute:NSLayoutAttributeLeft
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:self.view
                                                          attribute:NSLayoutAttributeLeft
                                                         multiplier:1.0
                                                           constant:220.f]];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:_intergralLabel
                                                          attribute:NSLayoutAttributeWidth
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:nil
                                                          attribute:NSLayoutAttributeNotAnAttribute
                                                         multiplier:1.0
                                                           constant:300.f]];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:_intergralLabel
                                                          attribute:NSLayoutAttributeHeight
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:nil
                                                          attribute:NSLayoutAttributeNotAnAttribute
                                                         multiplier:1.0
                                                           constant:50.f]];
    
    UIButton *integralBtn = [[UIButton alloc]init];
    integralBtn.translatesAutoresizingMaskIntoConstraints = NO;
    [integralBtn setTitle:@"积分兑换" forState:UIControlStateNormal];
    [integralBtn setBackgroundColor:kColor(254, 79, 29, 1.0)];
    integralBtn.titleLabel.font = [UIFont systemFontOfSize:20];
    [self.view addSubview:integralBtn];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:integralBtn
                                                          attribute:NSLayoutAttributeTop
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:self.view
                                                          attribute:NSLayoutAttributeTop
                                                         multiplier:1.0
                                                           constant:140.f]];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:integralBtn
                                                          attribute:NSLayoutAttributeLeft
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:_intergralLabel
                                                          attribute:NSLayoutAttributeLeft
                                                         multiplier:1.0
                                                           constant:580.f]];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:integralBtn
                                                          attribute:NSLayoutAttributeWidth
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:nil
                                                          attribute:NSLayoutAttributeNotAnAttribute
                                                         multiplier:1.0
                                                           constant:120.f]];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:integralBtn
                                                          attribute:NSLayoutAttributeHeight
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:nil
                                                          attribute:NSLayoutAttributeNotAnAttribute
                                                         multiplier:1.0
                                                           constant:40.f]];
    
    //添加tableView
    [self.view addSubview:self.integralTableView];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:_integralTableView
                                                          attribute:NSLayoutAttributeTop
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:integralBtn
                                                          attribute:NSLayoutAttributeTop
                                                         multiplier:1.0
                                                           constant:70.f]];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:_integralTableView
                                                          attribute:NSLayoutAttributeLeft
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:self.view
                                                          attribute:NSLayoutAttributeLeft
                                                         multiplier:1.0
                                                           constant:160.f]];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:_integralTableView
                                                          attribute:NSLayoutAttributeRight
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:self.view
                                                          attribute:NSLayoutAttributeRight
                                                         multiplier:1.0
                                                           constant:0.f]];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:_integralTableView
                                                          attribute:NSLayoutAttributeHeight
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:nil
                                                          attribute:NSLayoutAttributeNotAnAttribute
                                                         multiplier:1.0
                                                           constant:SCREEN_HEIGHT - 210.f]];
    if (iOS7) {
        [self.view addConstraint:[NSLayoutConstraint constraintWithItem:_integralTableView
                                                              attribute:NSLayoutAttributeHeight
                                                              relatedBy:NSLayoutRelationEqual
                                                                 toItem:nil
                                                              attribute:NSLayoutAttributeNotAnAttribute
                                                             multiplier:1.0
                                                               constant:SCREEN_WIDTH - 210.f]];
    }
    
    UIView *footerV = [[UIView alloc]init];
    footerV.frame = CGRectMake(0, 0, 1, 1);
    _integralTableView.tableFooterView = footerV;

    
}

#pragma mark - tableview dateSource


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0) {
        return 1;
    }else
    {
        return 3;
    }
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        static NSString *ID = @"IntegralCell1";
        IntegralCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
        if (cell == nil) {
            cell = [[IntegralCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:ID];
        }
        return cell;
    }else{
        static NSString *ID = @"IntegralCell2";
        IntegralCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
        if (cell == nil) {
            cell = [[IntegralCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:ID];
        }
        cell.orderNumLabel.text = @"12346565656";
        cell.tradeTimeLabel.text = @"2012-12-22 20:22:22";
        cell.moneyLabel.text = @"Y123123.12";
        cell.intergralLabel.text = @"+10";
        cell.intergralType.text = @"购买";
        return cell;

    }
    
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        return 30;
    }else{
        return 60;
    }
}
@end
