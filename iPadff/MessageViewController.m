//
//  MessageViewController.m
//  iPadff
//
//  Created by 黄含章 on 15/3/3.
//  Copyright (c) 2015年 LanTaiPro. All rights reserved.
//

#import "MessageViewController.h"
#import "MessageViewCell.h"
#import "MessageChildViewController.h"

@interface MessageViewController ()

@property(nonatomic,assign)BOOL isSelected;

@property(nonatomic,strong)UIButton *konggeBtn;

@property(nonatomic,assign)BOOL isAll;

@end

@implementation MessageViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupNavBar];
    self.isAll = NO;
}

- (void)viewWillAppear:(BOOL)animated {
    [self.navigationController.navigationBar setBackgroundImage:[kImageName(@"DarkGray")
                                                                 resizableImageWithCapInsets:UIEdgeInsetsMake(1, 0, 43, 0)]
                                                  forBarMetrics:UIBarMetricsDefault];
}

- (void)viewWillDisappear:(BOOL)animated {
    [self.navigationController.navigationBar setBackgroundImage:[kImageName(@"orange")
                                                                 resizableImageWithCapInsets:UIEdgeInsetsMake(21, 1, 21, 1)]
                                                  forBarMetrics:UIBarMetricsDefault];
}

-(void)setupNavBar
{
    self.view.backgroundColor = [UIColor whiteColor];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    NSDictionary *attributes = [NSDictionary dictionaryWithObjectsAndKeys:[UIColor whiteColor],NSForegroundColorAttributeName,[UIFont boldSystemFontOfSize:22],NSFontAttributeName, nil];
    [self.navigationController.navigationBar setTitleTextAttributes:attributes];
    [self.navigationController.navigationBar setBackgroundImage:[UIImage resizedImage:@"DarkGray"] forBarPosition:UIBarPositionTop barMetrics:UIBarMetricsDefault];
    
    UIView *navbarView = [[UIView alloc]init];
    navbarView.userInteractionEnabled = YES;
    UIButton *konggeBtn = [[UIButton alloc]init];
    [konggeBtn setBackgroundImage:[UIImage imageNamed:@"noSelected1"] forState:UIControlStateNormal];
    [konggeBtn addTarget:self action:@selector(konggeClicked:) forControlEvents:UIControlEventTouchUpInside];
    self.konggeBtn = konggeBtn;
    self.isSelected = YES;
    konggeBtn.frame = CGRectMake(100, -10, 30, 30);
    
    UIButton *readBtn = [[UIButton alloc]init];
    CALayer *readBtnLayer = [readBtn layer];
    [readBtnLayer setMasksToBounds:YES];
    [readBtnLayer setCornerRadius:2.0];
    [readBtnLayer setBorderWidth:1.0];
    [readBtnLayer setBorderColor:[[UIColor whiteColor] CGColor]];
    readBtn.backgroundColor = [UIColor clearColor];
    [readBtn setTitle:@"标记为已读" forState:UIControlStateNormal];
    readBtn.frame = CGRectMake(70, -24, 120, 40);
    
    UIButton *deleteBtn = [[UIButton alloc]init];
    CALayer *deleteBtnLayer = [deleteBtn layer];
    [deleteBtnLayer setMasksToBounds:YES];
    [deleteBtnLayer setCornerRadius:2.0];
    [deleteBtnLayer setBorderWidth:1.0];
    [deleteBtnLayer setBorderColor:[[UIColor whiteColor] CGColor]];
    [deleteBtn setTitle:@"删除" forState:UIControlStateNormal];
    deleteBtn.frame = CGRectMake(CGRectGetMaxX(readBtn.frame) + 10, -24, 120, 40);
    
    UIBarButtonItem *withBar = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:self action:nil];
    withBar.width = 10;
    UIBarButtonItem *leftBar = [[UIBarButtonItem alloc]initWithCustomView:konggeBtn];
    UIBarButtonItem *withBar1 = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:self action:nil];
    withBar1.width = 20;
    UIBarButtonItem *zhongjianBar = [[UIBarButtonItem alloc]initWithCustomView:readBtn];
    UIBarButtonItem *withBar2 = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:self action:nil];
    withBar2.width = 15;
    UIBarButtonItem *rightBar = [[UIBarButtonItem alloc]initWithCustomView:deleteBtn];
    NSArray *arr = [NSArray arrayWithObjects:withBar,leftBar,withBar1,zhongjianBar,withBar2,rightBar, nil];
    
    self.navigationItem.leftBarButtonItems = arr;
}

-(void)konggeClicked:(id)sender
{
    if (self.isSelected == YES) {
        [_konggeBtn setBackgroundImage:[UIImage imageNamed:@"selected"] forState:UIControlStateNormal];
        _isAll = YES;
        [self.tableView reloadData];
    }
    else{
        [_konggeBtn setBackgroundImage:[UIImage imageNamed:@"noSelected1"] forState:UIControlStateNormal];
        _isAll = NO;
        [self.tableView reloadData];
    }
    self.isSelected = !_isSelected;
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
    return 10;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    MessageViewCell *cell =[MessageViewCell cellWithTableView:tableView];
    cell.textLabel.text = @"黑金卡的哈驾驶机动按键设计都金卡的加拉科技的......";
    cell.detailTextLabel.text = @"2014-10-20";
    cell.timeLabel.text = @"20:23:23";
    cell.btnStatus = _isAll;
    [cell btnClicked];
    return  cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
//    DynamicStatus *status = [_listArray objectAtIndex:indexPath.row];
//    DynamicChildViewController *dynamicVC = [[DynamicChildViewController alloc]init];
//    dynamicVC.page =  status.ids;
//    [self.navigationController pushViewController:dynamicVC animated:YES];
//    SLog(@"点击了第%ld行",indexPath.row);
    MessageChildViewController *messageChildV = [[MessageChildViewController alloc]init];
    messageChildV.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:messageChildV animated:YES];
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
