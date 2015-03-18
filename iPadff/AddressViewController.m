//
//  AddressViewController.m
//  iPadff
//
//  Created by 黄含章 on 15/3/13.
//  Copyright (c) 2015年 LanTaiPro. All rights reserved.
//

#import "AddressViewController.h"
#import "AddressCell.h"

@interface AddressViewController ()<UITableViewDataSource,UITableViewDelegate,AddressCellDelegate>

@property(nonatomic,strong)UITableView *addressTableView;

@end

@implementation AddressViewController

-(UITableView *)addressTableView
{
    if (!_addressTableView) {
        _addressTableView = [[UITableView alloc]init];
        _addressTableView.frame = CGRectMake(160, 140, SCREEN_WIDTH - 160, SCREEN_HEIGHT - 140);
        if (iOS7) {
            _addressTableView.frame = CGRectMake(170, 140, SCREEN_HEIGHT - 160,SCREEN_WIDTH - 140);
        }
    }
    return _addressTableView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.swithView setSelectedBtnAtIndex:3];
    NSLog(@"当前是~~~~~~~~~~~~%d",self.Index);
    [self.view addSubview:self.addressTableView];
    _addressTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _addressTableView.delegate = self;
    _addressTableView.dataSource = self;
    [self setupFooterView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)setupFooterView
{
    UIView *footView = [[UIView alloc]init];
    footView.backgroundColor = [UIColor whiteColor];
    footView.frame = CGRectMake(0, 0, 100, 60);
    UIView *line = [[UIView alloc]init];
    line.backgroundColor = kColor(239, 239, 239, 1.0);
    line.frame = CGRectMake(0, 0, SCREEN_WIDTH - 160, 1);
    if (iOS7) {
        line.frame = CGRectMake(0, 0, SCREEN_HEIGHT - 160, 1);
    }
    [footView addSubview:line];
    UIButton *addAddressBtn = [[UIButton alloc]init];
    addAddressBtn.frame = CGRectMake(20, 10, 120, 40);
    [addAddressBtn setTitle:@"新增地址" forState:UIControlStateNormal];
    [addAddressBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [addAddressBtn setBackgroundColor:kColor(254, 79, 29, 1.0)];
    [footView addSubview:addAddressBtn];
    _addressTableView.tableFooterView = footView;
}

#pragma mark - tableView DateSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0) {
        return 1;
    }else{
        return 3;
    }
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        static NSString *ID = @"AddressCell1";
        AddressCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
        if (cell == nil) {
            cell = [[AddressCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:ID];
        }
        cell.defaultLabel.hidden = YES;
        cell.changeBtn.hidden = YES;
        return cell;
    }else{
        static NSString *ID = @"AddressCell2";
        AddressCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
        if (cell == nil) {
            cell = [[AddressCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:ID];
        }
        cell.AddressCellDelegate = self;
        cell.consigneeLabel.text = @"张三三";
        cell.areaLabel.text = @"江苏省苏州市";
        cell.particularAddressLabel.text = @"吴中区东方大道123号";
        cell.postcodeLabel.text = @"125000";
        cell.telLabel.text = @"1232412424124";
        return cell;

    }
    
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        return 25;
    }
    else
    {
        return 50;
    }
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

#pragma mark - addressDelegate
-(void)changeBtnClicked:(NSString *)selectedID
{
    //点击的id和修改地址事件
}

@end
