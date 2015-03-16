//
//  AddressViewController.m
//  iPadff
//
//  Created by 黄含章 on 15/3/13.
//  Copyright (c) 2015年 LanTaiPro. All rights reserved.
//

#import "AddressViewController.h"
#import "AddressCell.h"

@interface AddressViewController ()<UITableViewDataSource,UITableViewDelegate>

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
        _addressTableView.delegate = self;
        _addressTableView.dataSource = self;
    }
    return _addressTableView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.swithView setSelectedBtnAtIndex:3];
    NSLog(@"当前是~~~~~~~~~~~~%d",self.Index);
    [self.view addSubview:self.addressTableView];
    [self setupFooterView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)setupFooterView
{
    UIButton *addAddressBtn = [[UIButton alloc]init];
    addAddressBtn.frame = CGRectMake(0, 0, 100, 40);
    [addAddressBtn setTitle:@"新增地址" forState:UIControlStateNormal];
    [addAddressBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [addAddressBtn setBackgroundColor:[UIColor orangeColor]];
    _addressTableView.tableFooterView = addAddressBtn;
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
        cell.textLabel.text = @"123123";
        return cell;
    }else{
        static NSString *ID = @"AddressCell2";
        AddressCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
        if (cell == nil) {
            cell = [[AddressCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:ID];
        }
        cell.textLabel.text = @"asdasd";
        return cell;

    }
    
}

@end
