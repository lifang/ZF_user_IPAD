//
//  TerminalViewController.m
//  iPadff
//
//  Created by 黄含章 on 15/3/5.
//  Copyright (c) 2015年 LanTaiPro. All rights reserved.
//

#import "TerminalViewController.h"
#import "TerminalViewCell.h"

@interface TerminalViewController ()<terminalCellSendBtnClicked>

@end

@implementation TerminalViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupNavBar];
    [self setupHeaderView];
}

-(void)setupHeaderView
{
    UIView *headerView = [[UIView alloc]init];
    headerView.frame = CGRectMake(0, 0, SCREEN_WIDTH, 60);
    if (iOS7) {
        headerView.frame = CGRectMake(0, 0, SCREEN_HEIGHT, 60);
    }
    UIView *bottomView = [[UIView alloc]init];
    UIFont *mainFont = [UIFont systemFontOfSize:14];
    
    UILabel *first = [[UILabel alloc]init];
    first.font = mainFont;
    first.text = @"终端号";
    first.frame = CGRectMake(60, 0, 70, 25);
    [bottomView addSubview:first];
    bottomView.backgroundColor = kColor(226, 226, 226, 1.0);
    
    UILabel *second = [[UILabel alloc]init];
    second.font = mainFont;
    second.text = @"POS机";
    second.frame = CGRectMake(CGRectGetMaxX(first.frame) + 80, 0, 70, 25);
    [bottomView addSubview:second];
    
    UILabel *third = [[UILabel alloc]init];
    third.font = mainFont;
    third.text = @"支付通道";
    third.frame = CGRectMake(CGRectGetMaxX(second.frame) + 60, 0, 90, 25);
    [bottomView addSubview:third];
    
    UILabel *fourth = [[UILabel alloc]init];
    fourth.font = mainFont;
    fourth.text = @"开通状态";
    fourth.frame = CGRectMake(CGRectGetMaxX(third.frame) + 30, 0, 90, 25);
    [bottomView addSubview:fourth];
    
    bottomView.frame = CGRectMake(0, 36, SCREEN_WIDTH, 24);
    if (iOS7) {
        bottomView.frame = CGRectMake(0, 36, SCREEN_HEIGHT, 24);
    }
    [headerView addSubview:bottomView];
    self.tableView.tableHeaderView = headerView;
    
}
-(void)setupNavBar
{
    self.title = @"终端管理";
    self.view.backgroundColor = [UIColor whiteColor];
    NSDictionary *attributes = [NSDictionary dictionaryWithObjectsAndKeys:[UIColor whiteColor],NSForegroundColorAttributeName,[UIFont boldSystemFontOfSize:22],NSFontAttributeName, nil];
    [self.navigationController.navigationBar setTitleTextAttributes:attributes];
    [self.navigationController.navigationBar setBackgroundImage:[UIImage resizedImage:@"orange"] forBarPosition:UIBarPositionTop barMetrics:UIBarMetricsDefault];
    
    UIButton *leftBtn = [[UIButton alloc]init];
    [leftBtn addTarget:self action:@selector(backHome) forControlEvents:UIControlEventTouchUpInside];
    leftBtn.frame = CGRectMake(0, 0, 50, 50);
    [leftBtn setImage:[UIImage imageNamed:@"back_btn_white"] forState:UIControlStateNormal];
    UIBarButtonItem *leftBar = [[UIBarButtonItem alloc]initWithCustomView:leftBtn];
    self.navigationItem.leftBarButtonItem = leftBar;
    
    UIView *footerView = [[UIView alloc]init];
    footerView.backgroundColor = kColor(210, 210, 210, 1.0);
    footerView.frame = CGRectMake(0, 0, SCREEN_WIDTH, 1);
    if (iOS7) {
        footerView.frame = CGRectMake(0, 0, SCREEN_HEIGHT, 1);
    }
    self.tableView.tableFooterView = footerView;
}

-(void)backHome
{
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 5;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSArray *arr = [NSArray arrayWithObjects:@"已开通",@"未开通",@"部分开通",@"已停用",@"已注销", nil];
    NSString *IDs = [NSString stringWithFormat:@"cell-%@",[arr objectAtIndex:indexPath.row]];
    TerminalViewCell *cell = [tableView dequeueReusableCellWithIdentifier:IDs];
    if (cell == nil) {
        cell = [[TerminalViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:IDs];
        cell.TerminalViewCellDelegate = self;
    }
    
    cell.cellStates = @"已开通";
    cell.terminalLabel.text = @"1234567890987612";
    cell.posLabel.text = @"泰山TS900";
    cell.payRoad.text = @"快钱宝";
    if (indexPath.row == 0) {
        cell.dredgeStatus.text = @"已开通";
    }
    if (indexPath.row == 1) {
        cell.dredgeStatus.text = @"未开通";
        cell.cellStates = @"未开通";
    }
    if (indexPath.row == 2) {
        cell.dredgeStatus.text = @"部分开通";
        cell.cellStates = @"部分开通";
    }
    if (indexPath.row == 3) {
        cell.dredgeStatus.text = @"已停用";
        cell.cellStates = @"已停用";
    }
    if (indexPath.row == 4) {
        cell.dredgeStatus.text = @"已注销";
        cell.cellStates = @"已注销";
    }
    return cell;
}

#pragma mark terminalCell的代理
-(void)terminalCellBtnClicked:(int)btnTag
{
    if (btnTag == 1000) {
        NSLog(@"点击了找回POS密码");
    }
    if (btnTag == 1001) {
        NSLog(@"点击了视频认证(已开通)");
    }
    if (btnTag == 2000) {
        NSLog(@"点击了视频认证(未开通)");
    }
    if (btnTag == 2001) {
        NSLog(@"点击了申请开通");
    }
    if (btnTag == 2002) {
        NSLog(@"点击了同步(未开通)");
    }
    if (btnTag == 3000) {
        NSLog(@"点击了找回POS密码（部分开通）");
    }
    if (btnTag == 3001) {
        NSLog(@"点击了视频认证(部分开通)");
    }
    if (btnTag == 3002) {
        NSLog(@"点击了重新申请开通");
    }
    if (btnTag == 3003) {
        NSLog(@"点击了同步（部分开通）");
    }
    if (btnTag == 4000) {
        NSLog(@"点击了更新资料");
    }
    if (btnTag == 4001) {
        NSLog(@"点击了同步（已停用）");
    }
    if (btnTag == 5000) {
        NSLog(@"点击了租凭退换");
    }
    
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    //    DynamicStatus *status = [_listArray objectAtIndex:indexPath.row];
    //    DynamicChildViewController *dynamicVC = [[DynamicChildViewController alloc]init];
    //    dynamicVC.page =  status.ids;
    //    [self.navigationController pushViewController:dynamicVC animated:YES];
    //    SLog(@"点击了第%ld行",indexPath.row);
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 80;
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    if ([tableView respondsToSelector:@selector(setSeparatorInset:)]) {
        [tableView setSeparatorInset:UIEdgeInsetsZero];
    }
    if ([tableView respondsToSelector:@selector(setLayoutMargins:)]) {
        [tableView setLayoutMargins:UIEdgeInsetsZero];
    }
    if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
        [cell setLayoutMargins:UIEdgeInsetsZero];
    }
}

@end
