//
//  DealRoadController.m
//  iPadff
//
//  Created by 黄含章 on 15/3/5.
//  Copyright (c) 2015年 LanTaiPro. All rights reserved.
//

#import "DealRoadController.h"
#import "DredgeViewCell.h"
#import "TopDealRoadCell.h"

@interface DealRoadController ()<UITextFieldDelegate>

@property(nonatomic,strong)UIButton *publickBtn;
@property(nonatomic,strong)UIButton *privateBtn;
@property(nonatomic,strong)UIButton *huankuanBtn;
@property(nonatomic,strong)UIButton *shenghuochongzhiBtn;
@property(nonatomic,strong)UIButton *huafeichongzhiBtn;

@property(nonatomic,strong)UIView *contentView;

@property(nonatomic,assign)BOOL isChecked;
@property(nonatomic,assign)CGFloat publicX;
@property(nonatomic,assign)CGFloat privateX;
@property(nonatomic,assign)CGFloat huankuanX;
@property(nonatomic,assign)CGFloat shenghuochongzhiX;
@property(nonatomic,assign)CGFloat huafeichongzhiX;
@property(nonatomic,assign)CGFloat privateY;

@property(nonatomic,strong)UITextField *terminalField;
@property(nonatomic,strong)UITextField *dateField1;
@property(nonatomic,strong)UITextField *dateField2;

@property(nonatomic,assign)int buttonIndex;

@end

@implementation DealRoadController

- (void)viewDidLoad {
    
    [super viewDidLoad];
    self.buttonIndex = 1;
    [self setupNavBar];
    [self setupHeaderView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)setupNavBar
{
    self.title = @"交易流水";
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

-(void)setupHeaderView
{
    //创建头部View
    UIView *headerView = [[UIView alloc]init];
    headerView.backgroundColor = kColor(226, 226, 226, 1.0);
    headerView.frame = CGRectMake(0, 0, SCREEN_WIDTH, 260);
    if (iOS7) {
        headerView.frame = CGRectMake(0, 0, SCREEN_HEIGHT, 260);
    }
    //创建头部按钮
    UIButton *publicBtn = [[UIButton alloc]init];
    self.isChecked = YES;
    self.publickBtn = publicBtn;
    publicBtn.tag = 10001;
    [publicBtn addTarget:self action:@selector(btnClicked:) forControlEvents:UIControlEventTouchUpInside];
    publicBtn.backgroundColor = [UIColor clearColor];
    [publicBtn setBackgroundImage:[UIImage imageNamed:@"chose_Btn"] forState:UIControlStateNormal];
    publicBtn.titleLabel.font = [UIFont systemFontOfSize:22];
    [publicBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [publicBtn setTitle:@"转账" forState:UIControlStateNormal];
    publicBtn.frame = CGRectMake(headerView.frame.size.width * 0.22 , 40, 120, 40);
    self.publicX = publicBtn.frame.origin.x;
    self.privateY = publicBtn.frame.origin.y;
    [headerView addSubview:publicBtn];
    
    UIButton *privateBtn = [[UIButton alloc]init];
    self.privateBtn = privateBtn;
    privateBtn.tag = 10002;
    [privateBtn addTarget:self action:@selector(btnClicked:) forControlEvents:UIControlEventTouchUpInside];
    privateBtn.backgroundColor = [UIColor clearColor];
    privateBtn.titleLabel.font = [UIFont systemFontOfSize:20];
    [privateBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [privateBtn setTitle:@"消费" forState:UIControlStateNormal];
    privateBtn.frame = CGRectMake(CGRectGetMaxX(publicBtn.frame), 40, 100, 36);
    self.privateX = privateBtn.frame.origin.x;
    [headerView addSubview:privateBtn];
    
    UIButton *huankuan = [[UIButton alloc]init];
    self.huankuanBtn = huankuan;
    huankuan.tag = 10003;
    [huankuan addTarget:self action:@selector(btnClicked:) forControlEvents:UIControlEventTouchUpInside];
    huankuan.backgroundColor = [UIColor clearColor];
    huankuan.titleLabel.font = [UIFont systemFontOfSize:20];
    [huankuan setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [huankuan setTitle:@"还款" forState:UIControlStateNormal];
    huankuan.frame = CGRectMake(CGRectGetMaxX(privateBtn.frame), 40, 100, 36);
    self.huankuanX = huankuan.frame.origin.x;
    [headerView addSubview:huankuan];
    
    UIButton *shenghuochongzhi = [[UIButton alloc]init];
    self.shenghuochongzhiBtn = shenghuochongzhi;
    shenghuochongzhi.tag = 10004;
    [shenghuochongzhi addTarget:self action:@selector(btnClicked:) forControlEvents:UIControlEventTouchUpInside];
    shenghuochongzhi.backgroundColor = [UIColor clearColor];
    shenghuochongzhi.titleLabel.font = [UIFont systemFontOfSize:20];
    [shenghuochongzhi setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [shenghuochongzhi setTitle:@"生活充值" forState:UIControlStateNormal];
    shenghuochongzhi.frame = CGRectMake(CGRectGetMaxX(huankuan.frame), 40, 120, 36);
    self.shenghuochongzhiX = shenghuochongzhi.frame.origin.x;
    [headerView addSubview:shenghuochongzhi];
    
    UIButton *huafeichongzhi = [[UIButton alloc]init];
    self.huafeichongzhiBtn = huafeichongzhi;
    huafeichongzhi.tag = 10005;
    [huafeichongzhi addTarget:self action:@selector(btnClicked:) forControlEvents:UIControlEventTouchUpInside];
    huafeichongzhi.backgroundColor = [UIColor clearColor];
    huafeichongzhi.titleLabel.font = [UIFont systemFontOfSize:20];
    [huafeichongzhi setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [huafeichongzhi setTitle:@"话费充值" forState:UIControlStateNormal];
    huafeichongzhi.frame = CGRectMake(CGRectGetMaxX(shenghuochongzhi.frame), 40, 120, 36);
    self.huafeichongzhiX = huafeichongzhi.frame.origin.x;
    [headerView addSubview:huafeichongzhi];
    
    UIView *contentView = [[UIView alloc]init];
    self.contentView = contentView;
    [self setupContetView];
    contentView.backgroundColor = [UIColor whiteColor];
    contentView.frame = CGRectMake(0, CGRectGetMaxY(publicBtn.frame), SCREEN_WIDTH, 260 - CGRectGetMaxY(publicBtn.frame));
    if (iOS7) {
         contentView.frame = CGRectMake(0, CGRectGetMaxY(publicBtn.frame), SCREEN_HEIGHT, 260 - CGRectGetMaxY(publicBtn.frame));
    }
    [headerView addSubview:contentView];
    
    self.tableView.tableHeaderView = headerView;
}

-(void)setupContetView
{
    UILabel *terminalLabel = [[UILabel alloc]init];
    terminalLabel.font = [UIFont systemFontOfSize:20];
    terminalLabel.text = @"终端号";
    terminalLabel.frame = CGRectMake(40, 40, 70, 40);
    [_contentView addSubview:terminalLabel];
    
    _terminalField = [[UITextField alloc]init];
    _terminalField.borderStyle = UITextBorderStyleLine;
    _terminalField.delegate = self;
    _terminalField.placeholder = @" 12345678897654321";
    [_terminalField setValue:[UIFont systemFontOfSize:20] forKeyPath:@"_placeholderLabel.font"];
    _terminalField.frame = CGRectMake(CGRectGetMaxX(terminalLabel.frame), terminalLabel.frame.origin.y, 260, 40);
    UIButton *rightTerminalBtn = [[UIButton alloc]init];
    rightTerminalBtn.tag = 1050;
    [rightTerminalBtn addTarget:self action:@selector(rightBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    [rightTerminalBtn setBackgroundImage:[UIImage imageNamed:@"arrow_line"] forState:UIControlStateNormal];
    rightTerminalBtn.frame = CGRectMake(CGRectGetMaxX(_terminalField.frame) - 50, terminalLabel.frame.origin.y, 50, 36);
    [_contentView addSubview:_terminalField];
    [_contentView addSubview:rightTerminalBtn];
    
    UILabel *dateLabel = [[UILabel alloc]init];
    dateLabel.text = @"交易日期";
    dateLabel.font = [UIFont systemFontOfSize:20];
    dateLabel.frame = CGRectMake(CGRectGetMaxX(rightTerminalBtn.frame) + 20, terminalLabel.frame.origin.y, 100, 40);
    [_contentView addSubview:dateLabel];
    
    _dateField1 = [[UITextField alloc]init];
    _dateField1.borderStyle = UITextBorderStyleLine;
    _dateField1.delegate = self;
    _dateField1.placeholder = @" 2014-12-22";
    [_dateField1 setValue:[UIFont systemFontOfSize:20] forKeyPath:@"_placeholderLabel.font"];
    _dateField1.frame = CGRectMake(CGRectGetMaxX(dateLabel.frame), terminalLabel.frame.origin.y, 180, 40);
    UIButton *rightTerminalBtn1 = [[UIButton alloc]init];
    rightTerminalBtn1.tag = 1051;
    [rightTerminalBtn1 addTarget:self action:@selector(rightBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    [rightTerminalBtn1 setBackgroundImage:[UIImage imageNamed:@"arrow_line"] forState:UIControlStateNormal];
    rightTerminalBtn1.frame = CGRectMake(CGRectGetMaxX(_dateField1.frame) - 50, terminalLabel.frame.origin.y, 50, 36);
    [_contentView addSubview:_dateField1];
    [_contentView addSubview:rightTerminalBtn1];
    
    UIView *gang = [[UIView alloc]init];
    gang.backgroundColor = [UIColor blackColor];
    gang.frame = CGRectMake(CGRectGetMaxX(_dateField1.frame) + 10, terminalLabel.frame.origin.y + 20, 7, 2);
    [_contentView addSubview:gang];
    
    _dateField2 = [[UITextField alloc]init];
    _dateField2.borderStyle = UITextBorderStyleLine;
    _dateField2.delegate = self;
    _dateField2.placeholder = @" 2014-12-27";
    [_dateField2 setValue:[UIFont systemFontOfSize:20] forKeyPath:@"_placeholderLabel.font"];
    _dateField2.frame = CGRectMake(CGRectGetMaxX(gang.frame) + 10, terminalLabel.frame.origin.y, 180, 40);
    UIButton *rightTerminalBtn2 = [[UIButton alloc]init];
    rightTerminalBtn2.tag = 1052;
    [rightTerminalBtn2 addTarget:self action:@selector(rightBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    [rightTerminalBtn2 setBackgroundImage:[UIImage imageNamed:@"arrow_line"] forState:UIControlStateNormal];
    rightTerminalBtn2.frame = CGRectMake(CGRectGetMaxX(_dateField2.frame) - 50, terminalLabel.frame.origin.y, 50, 36);
    [_contentView addSubview:_dateField2];
    [_contentView addSubview:rightTerminalBtn2];
    
    UIButton *startFindBtn = [[UIButton alloc]init];
    [startFindBtn addTarget:self action:@selector(startFind) forControlEvents:UIControlEventTouchUpInside];
    [startFindBtn setTitle:@"开始查询" forState:UIControlStateNormal];
    [startFindBtn setBackgroundColor:[UIColor orangeColor]];
    [startFindBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    startFindBtn.titleLabel.font = [UIFont systemFontOfSize:18];
    startFindBtn.frame = CGRectMake(_terminalField.frame.origin.x, CGRectGetMaxY(_terminalField.frame) + 30, 100, 40);
    [_contentView addSubview:startFindBtn];
    
    UIButton *startStatisticsBtn = [[UIButton alloc]init];
    [startStatisticsBtn addTarget:self action:@selector(startStatistics) forControlEvents:UIControlEventTouchUpInside];
    [startStatisticsBtn setTitle:@"开始统计" forState:UIControlStateNormal];
    [startStatisticsBtn setBackgroundColor:[UIColor orangeColor]];
    [startStatisticsBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    startStatisticsBtn.titleLabel.font = [UIFont systemFontOfSize:18];
    startStatisticsBtn.frame = CGRectMake(CGRectGetMaxX(startFindBtn.frame) + 60, CGRectGetMaxY(_terminalField.frame) + 30, 100, 40);
    [_contentView addSubview:startStatisticsBtn];
    
}

-(void)startFind
{
    NSLog(@"点击了开始查询！ 为上排第%d个按钮",_buttonIndex);
    
}

-(void)startStatistics
{
    NSLog(@"点击了开始统计！为上排第%d个按钮",_buttonIndex);
}

-(void)rightBtnClicked:(UIButton *)button
{
    if (button.tag == 1050) {
        NSLog(@"点击了终端号！");
    }
    if (button.tag == 1051) {
        NSLog(@"点击了交易日期1");
    }
    if (button.tag == 1052) {
        NSLog(@"点击了交易日期2");
    }
}

-(void)backHome
{
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)btnClicked:(UIButton *)button
{
    //转账
    if (button.tag == 10001) {
        if (_isChecked == YES) {
            //什么都不做
        }
        else{
            _buttonIndex = 1;
            [self.tableView reloadData];
            [_publickBtn setBackgroundImage:[UIImage imageNamed:@"chose_Btn"] forState:UIControlStateNormal];
            _publickBtn.titleLabel.font = [UIFont systemFontOfSize:22];
            _publickBtn.frame = CGRectMake(_publicX, _privateY, 120, 40);
            
            [_privateBtn setBackgroundImage:nil forState:UIControlStateNormal];
            _privateBtn.titleLabel.font = [UIFont systemFontOfSize:20];
            _privateBtn.frame = CGRectMake(_privateX + 10, _privateY, 100, 36);
            
            [_huankuanBtn setBackgroundImage:nil forState:UIControlStateNormal];
            _huankuanBtn.titleLabel.font = [UIFont systemFontOfSize:20];
            _huankuanBtn.frame = CGRectMake(_huankuanX + 10, _privateY, 100, 36);
            
            [_shenghuochongzhiBtn setBackgroundImage:nil forState:UIControlStateNormal];
            _shenghuochongzhiBtn.titleLabel.font = [UIFont systemFontOfSize:20];
            _shenghuochongzhiBtn.frame = CGRectMake(_shenghuochongzhiX + 10, _privateY, 100, 36);
            
            [_huafeichongzhiBtn setBackgroundImage:nil forState:UIControlStateNormal];
            _huafeichongzhiBtn.titleLabel.font = [UIFont systemFontOfSize:20];
            _huafeichongzhiBtn.frame = CGRectMake(_huafeichongzhiX + 10, _privateY, 100, 36);
            
            _isChecked = YES;
        }
    }
    //消费
    if (button.tag == 10002) {
        _buttonIndex = 2;
        _isChecked = NO;
        [self.tableView reloadData];
        [_privateBtn setBackgroundImage:[UIImage imageNamed:@"chose_Btn"] forState:UIControlStateNormal];
        _privateBtn.titleLabel.font = [UIFont systemFontOfSize:22];
        _privateBtn.frame = CGRectMake(_privateX, _privateY, 120, 40);
        
        [_publickBtn setBackgroundImage:nil forState:UIControlStateNormal];
        _publickBtn.titleLabel.font = [UIFont systemFontOfSize:20];
        _publickBtn.frame = CGRectMake(_publicX + 10, _privateY, 100, 36);
        
        [_huankuanBtn setBackgroundImage:nil forState:UIControlStateNormal];
        _huankuanBtn.titleLabel.font = [UIFont systemFontOfSize:20];
        _huankuanBtn.frame = CGRectMake(_huankuanX + 10, _privateY, 100, 36);
        
        [_shenghuochongzhiBtn setBackgroundImage:nil forState:UIControlStateNormal];
        _shenghuochongzhiBtn.titleLabel.font = [UIFont systemFontOfSize:20];
        _shenghuochongzhiBtn.frame = CGRectMake(_shenghuochongzhiX + 10, _privateY, 100, 36);
        
        [_huafeichongzhiBtn setBackgroundImage:nil forState:UIControlStateNormal];
        _huafeichongzhiBtn.titleLabel.font = [UIFont systemFontOfSize:20];
        _huafeichongzhiBtn.frame = CGRectMake(_huafeichongzhiX + 10, _privateY, 100, 36);
    }
    //还款
    if (button.tag == 10003) {
        _buttonIndex = 3;
        _isChecked = NO;
        [_huankuanBtn setBackgroundImage:[UIImage imageNamed:@"chose_Btn"] forState:UIControlStateNormal];
        _huankuanBtn.titleLabel.font = [UIFont systemFontOfSize:22];
        _huankuanBtn.frame = CGRectMake(_huankuanX, _privateY, 120, 40);
        
        [_publickBtn setBackgroundImage:nil forState:UIControlStateNormal];
        _publickBtn.titleLabel.font = [UIFont systemFontOfSize:20];
        _publickBtn.frame = CGRectMake(_publicX + 10, _privateY, 100, 36);
        
        [_privateBtn setBackgroundImage:nil forState:UIControlStateNormal];
        _privateBtn.titleLabel.font = [UIFont systemFontOfSize:20];
        _privateBtn.frame = CGRectMake(_privateX + 10, _privateY, 100, 36);
        
        [_shenghuochongzhiBtn setBackgroundImage:nil forState:UIControlStateNormal];
        _shenghuochongzhiBtn.titleLabel.font = [UIFont systemFontOfSize:20];
        _shenghuochongzhiBtn.frame = CGRectMake(_shenghuochongzhiX + 10, _privateY, 100, 36);
        
        [_huafeichongzhiBtn setBackgroundImage:nil forState:UIControlStateNormal];
        _huafeichongzhiBtn.titleLabel.font = [UIFont systemFontOfSize:20];
        _huafeichongzhiBtn.frame = CGRectMake(_huafeichongzhiX + 10, _privateY, 100, 36);
    }
    //生活充值
    if (button.tag == 10004) {
        _buttonIndex = 4;
        _isChecked = NO;
        [_shenghuochongzhiBtn setBackgroundImage:[UIImage imageNamed:@"chose_Btn"] forState:UIControlStateNormal];
        _shenghuochongzhiBtn.titleLabel.font = [UIFont systemFontOfSize:22];
        _shenghuochongzhiBtn.frame = CGRectMake(_shenghuochongzhiX, _privateY, 120, 40);
        
        [_publickBtn setBackgroundImage:nil forState:UIControlStateNormal];
        _publickBtn.titleLabel.font = [UIFont systemFontOfSize:20];
        _publickBtn.frame = CGRectMake(_publicX + 10, _privateY, 100, 36);
        
        [_privateBtn setBackgroundImage:nil forState:UIControlStateNormal];
        _privateBtn.titleLabel.font = [UIFont systemFontOfSize:20];
        _privateBtn.frame = CGRectMake(_privateX + 10, _privateY, 100, 36);
        
        [_huankuanBtn setBackgroundImage:nil forState:UIControlStateNormal];
        _huankuanBtn.titleLabel.font = [UIFont systemFontOfSize:20];
        _huankuanBtn.frame = CGRectMake(_huankuanX + 10, _privateY, 100, 36);
        
        [_huafeichongzhiBtn setBackgroundImage:nil forState:UIControlStateNormal];
        _huafeichongzhiBtn.titleLabel.font = [UIFont systemFontOfSize:20];
        _huafeichongzhiBtn.frame = CGRectMake(_huafeichongzhiX + 10, _privateY, 100, 36);
    }
    //话费充值
    if (button.tag == 10005) {
        _buttonIndex = 5;
        _isChecked = NO;
        [_huafeichongzhiBtn setBackgroundImage:[UIImage imageNamed:@"chose_Btn"] forState:UIControlStateNormal];
        _huafeichongzhiBtn.titleLabel.font = [UIFont systemFontOfSize:22];
        _huafeichongzhiBtn.frame = CGRectMake(_huafeichongzhiX, _privateY, 120, 40);
        
        [_publickBtn setBackgroundImage:nil forState:UIControlStateNormal];
        _publickBtn.titleLabel.font = [UIFont systemFontOfSize:20];
        _publickBtn.frame = CGRectMake(_publicX + 10, _privateY, 100, 36);
        
        [_privateBtn setBackgroundImage:nil forState:UIControlStateNormal];
        _privateBtn.titleLabel.font = [UIFont systemFontOfSize:20];
        _privateBtn.frame = CGRectMake(_privateX + 10, _privateY, 100, 36);
        
        [_huankuanBtn setBackgroundImage:nil forState:UIControlStateNormal];
        _huankuanBtn.titleLabel.font = [UIFont systemFontOfSize:20];
        _huankuanBtn.frame = CGRectMake(_huankuanX + 10, _privateY, 100, 36);
        
        [_shenghuochongzhiBtn setBackgroundImage:nil forState:UIControlStateNormal];
        _shenghuochongzhiBtn.titleLabel.font = [UIFont systemFontOfSize:20];
        _shenghuochongzhiBtn.frame = CGRectMake(_shenghuochongzhiX + 10, _privateY, 100, 36);
    }
    
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0) {
        return 1;
    }
    else{
       return 5;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        NSString *ID = [NSString stringWithFormat:@"cell%d",_buttonIndex];
        TopDealRoadCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
        if (cell == nil) {
            cell = [[TopDealRoadCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:ID];
        }
        return cell;
    }
    else
    {
    NSString *ID = @"cells";
    DredgeViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (cell == nil) {
        cell = [[DredgeViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:ID];
    }
        cell.terminalLabel.text = @"123123";
        cell.posLabel.text = @"awdaw";
        
    return cell;
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        return 80;
    }else{
        return 100;
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

@end
