//
//  DealRoadController.m
//  iPadff
//
//  Created by 黄含章 on 15/3/5.
//  Copyright (c) 2015年 LanTaiPro. All rights reserved.
//

#import "DealRoadController.h"
#import "TransferCell.h"
#import "TopDealRoadCell.h"
#import "ConsumptionCell.h"
#import "RepaymentCell.h"
#import "LiferechargeCell.h"
#import "TelephonechargeCell.h"
#import "DealRoadChildController.h"
#import "TerminalChoseCell.h"
#import "AppDelegate.h"
#import "TerminalModel.h"
#import "TradeModel.h"

@interface DealRoadController ()<UITextFieldDelegate>
/** 顶部五个Button */
@property(nonatomic,strong)UIButton *publickBtn;
@property(nonatomic,strong)UIButton *privateBtn;
@property(nonatomic,strong)UIButton *huankuanBtn;
@property(nonatomic,strong)UIButton *shenghuochongzhiBtn;
@property(nonatomic,strong)UIButton *huafeichongzhiBtn;
/** 中间的View */
@property(nonatomic,strong)UIView *contentView;
//按钮状态
@property(nonatomic,assign)BOOL isChecked;
/** 按钮的位置 */
@property(nonatomic,assign)CGFloat publicX;
@property(nonatomic,assign)CGFloat privateX;
@property(nonatomic,assign)CGFloat huankuanX;
@property(nonatomic,assign)CGFloat shenghuochongzhiX;
@property(nonatomic,assign)CGFloat huafeichongzhiX;
@property(nonatomic,assign)CGFloat privateY;
//终端号输入框
@property(nonatomic,strong)UITextField *terminalField;
//开始日期输入框
@property(nonatomic,strong)UITextField *dateField1;
//结束日期输入框
@property(nonatomic,strong)UITextField *dateField2;
//顶部Button的选择Index值
@property(nonatomic,assign)int buttonIndex;
//弹出选择终端号的TableView
@property(nonatomic,strong)UITableView *terminalTableView;
//保存获取的终端号
@property (nonatomic, strong) NSMutableArray *terminalItems;
//交易流水
@property (nonatomic, strong) NSMutableArray *tradeRecords;
/** 选择日期空间 */
@property (nonatomic, strong) UIDatePicker *datePickerStart;
@property (nonatomic, strong) UIDatePicker *datePickerEnd;
/** 开始与结束日期 */
@property(nonatomic,strong)NSString *startTime;
@property(nonatomic,strong)NSString *endTime;
//确认按钮
@property(nonatomic,strong)UIButton *startSure;
@property(nonatomic,strong)UIButton *endSure;

@end

@implementation DealRoadController

//选择终端tableView懒加载
-(UITableView *)terminalTableView
{
    if (!_terminalTableView) {
        _terminalTableView = [[UITableView alloc]init];
        _terminalTableView.tag = 1111;
        _terminalTableView.backgroundColor = kColor(214, 214, 214, 1.0);
        _terminalTableView.delegate = self;
        _terminalTableView.dataSource = self;
    }
    return _terminalTableView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    //初始化数据
    self.buttonIndex = 1;
    _terminalItems = [NSMutableArray array];
    _tradeRecords = [NSMutableArray array];
    //创建导航栏
    [self setupNavBar];
    //创建头部View
    [self setupHeaderView];
    //获取所有的终端号数据
    [self getAllTerminalList];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark 导航栏
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

#pragma mark 创建顶部5个BTN View
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

#pragma mark 创建中间的选择器View
-(void)setupContetView
{
    UILabel *terminalLabel = [[UILabel alloc]init];
    terminalLabel.font = [UIFont systemFontOfSize:20];
    terminalLabel.text = @"终端号";
    terminalLabel.frame = CGRectMake(40, 40, 70, 40);
    [_contentView addSubview:terminalLabel];
    
    _terminalField = [[UITextField alloc]init];
    _terminalField.leftViewMode = UITextFieldViewModeAlways;
    UIView *v = [[UIView alloc]init];
    v.frame = CGRectMake(0, 0, 10, 40);
    _terminalField.leftView = v;
    _terminalField.userInteractionEnabled = NO;
    _terminalField.borderStyle = UITextBorderStyleLine;
    _terminalField.delegate = self;
    _terminalField.placeholder = @"请选择终端号";
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
    UIView *t = [[UIView alloc]init];
    t.frame = CGRectMake(0, 0, 10, 40);
    _dateField1.leftViewMode = UITextFieldViewModeAlways;
    _dateField1.leftView = t;
    _dateField1.placeholder = @"开始日期";
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
    UIView *f = [[UIView alloc]init];
    f.frame = CGRectMake(0, 0, 10, 40);
    _dateField2.leftViewMode = UITextFieldViewModeAlways;
    _dateField2.leftView = f;
    _dateField2.placeholder = @"结束日期";
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

#pragma mark 中间View 按钮的点击事件
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
        [self setupTerminalTableView];
    }
    if (button.tag == 1051) {
        NSLog(@"点击了交易日期1");
        [self setupStartDate];
    }
    if (button.tag == 1052) {
        NSLog(@"点击了交易日期2");
        [self setupEndDate];
    }
}

//创建开始日期选择器
-(void)setupStartDate
{
    UIDatePicker *datePicker = [[UIDatePicker alloc]init];
    datePicker.backgroundColor = kColor(212, 212, 212, 1.0);
    datePicker.datePickerMode = UIDatePickerModeDate;
    datePicker.frame = CGRectMake(_dateField1.frame.origin.x, CGRectGetMaxY(_dateField1.frame) + 80, _dateField1.frame.size.width, 160);
    self.datePickerStart = datePicker;
    [_datePickerStart addTarget:self action:@selector(startPick) forControlEvents:UIControlEventValueChanged];
    UIButton *makeSureBtn = [[UIButton alloc]init];
    makeSureBtn.tag = 1112;
    [makeSureBtn addTarget:self action:@selector(makeSureClick:) forControlEvents:UIControlEventTouchUpInside];
    [makeSureBtn setBackgroundColor:kColor(156, 156, 156, 1.0)];
    [makeSureBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [makeSureBtn setTitle:@"确认" forState:UIControlStateNormal];
    makeSureBtn.titleLabel.font = [UIFont systemFontOfSize:20];
    makeSureBtn.frame = CGRectMake(datePicker.frame.origin.x + datePicker.frame.size.width * 0.6, CGRectGetMaxY(datePicker.frame), datePicker.frame.size.width * 0.4, 30);
    self.startSure = makeSureBtn;
    [self.view addSubview:makeSureBtn];
    [self.view addSubview:_datePickerStart];
}

-(void)startPick
{
    self.startTime = [self stringFromDate:_datePickerStart.date];
}

//创建结束日期选择器
-(void)setupEndDate
{
    UIDatePicker *datePicker = [[UIDatePicker alloc]init];
    datePicker.backgroundColor = kColor(212, 212, 212, 1.0);
    datePicker.datePickerMode = UIDatePickerModeDate;
    datePicker.frame = CGRectMake(_dateField2.frame.origin.x, CGRectGetMaxY(_dateField2.frame) + 80, _dateField2.frame.size.width, 160);
    self.datePickerEnd = datePicker;
    [_datePickerEnd addTarget:self action:@selector(endPick) forControlEvents:UIControlEventValueChanged];
    UIButton *makeSureBtn = [[UIButton alloc]init];
    makeSureBtn.tag = 1113;
    [makeSureBtn addTarget:self action:@selector(makeSureClick:) forControlEvents:UIControlEventTouchUpInside];
    [makeSureBtn setBackgroundColor:kColor(156, 156, 156, 1.0)];
    [makeSureBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [makeSureBtn setTitle:@"确认" forState:UIControlStateNormal];
    makeSureBtn.titleLabel.font = [UIFont systemFontOfSize:20];
    makeSureBtn.frame = CGRectMake(datePicker.frame.origin.x + datePicker.frame.size.width * 0.6, CGRectGetMaxY(datePicker.frame), datePicker.frame.size.width * 0.4, 30);
    self.endSure = makeSureBtn;
    [self.view addSubview:makeSureBtn];
    [self.view addSubview:_datePickerEnd];
}

-(void)endPick
{
    self.endTime = [self stringFromDate:_datePickerEnd.date];
}


-(void)makeSureClick:(UIButton *)button
{
    if (button.tag == 1112) {
        [_startSure removeFromSuperview];
        [_datePickerStart removeFromSuperview];
        [self startPick];
        _dateField1.text = self.startTime;
    }
    if (button.tag == 1113) {
        [_endSure removeFromSuperview];
        [_datePickerEnd removeFromSuperview];
        [self endPick];
        _dateField2.text = self.endTime;
    }
}

//创建选择终端tableView
-(void)setupTerminalTableView
{
    self.terminalTableView.frame = CGRectMake(_terminalField.frame.origin.x, CGRectGetMaxY(_terminalField.frame) + 80, _terminalField.frame.size.width, 160);
    [self.view addSubview:_terminalTableView];
    if (_terminalItems.count != 0) {
        [_terminalTableView reloadData];
    }
}

-(void)backHome
{
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark 顶部BTN的点击切换
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
        [self.tableView reloadData];
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
        _shenghuochongzhiBtn.frame = CGRectMake(_shenghuochongzhiX + 20, _privateY, 100, 36);
        
        [_huafeichongzhiBtn setBackgroundImage:nil forState:UIControlStateNormal];
        _huafeichongzhiBtn.titleLabel.font = [UIFont systemFontOfSize:20];
        _huafeichongzhiBtn.frame = CGRectMake(_huafeichongzhiX + 10, _privateY, 100, 36);
    }
    //生活充值
    if (button.tag == 10004) {
        _buttonIndex = 4;
        _isChecked = NO;
        [self.tableView reloadData];
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
        [self.tableView reloadData];
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
    
    if (tableView.tag == 1111) {
        return 1;
    }else{
        return 2;
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    if (tableView.tag == 1111) {
        return _terminalItems.count;
    }
    
    else{
        if (section == 0) {
            return 1;
        }
        else{
           return 5;
        }
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    //终端选择Cell
    if (tableView.tag == 1111) {
        TerminalChoseCell *cell = [TerminalChoseCell cellWithTableView:tableView];
        TerminalModel *model = [_terminalItems objectAtIndex:indexPath.row];
        cell.textLabel.text = model.terminalNum;
        return cell;
    }
    
else
    //顶部标题Cell
{
    if (indexPath.section == 0) {
        NSString *ID = [NSString stringWithFormat:@"cell%d",_buttonIndex];
        TopDealRoadCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
        cell = [[TopDealRoadCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:ID];
        return cell;
    }
    else
    //内容Cell
    {
        if (_buttonIndex == 1) {
            TransferCell *cell = [TransferCell cellWithTableView:tableView];
            cell.timeLabel.text = @"2014-12-22 20:22:22";
            cell.payLabel.text = @"123456789***456";
            cell.getLabel.text = @"123456789***456";
            cell.terminalLabel.text = @"1234567887654321";
            cell.dealMoney.text = @"￥99999.99";
            cell.dealStates.text = @"成功";
            return cell;
        }
        
        if (_buttonIndex == 3) {
            RepaymentCell *cell = [RepaymentCell cellWithTableView:tableView];
            cell.timeLabel.text = @"2014-12-22 20:22:22";
            cell.payLabel.text = @"123456789***456";
            cell.payToLabel.text = @"123456789***456";
            cell.terminalLabel.text = @"1234567887654321";
            cell.dealMoney.text = @"￥99999.99";
            cell.dealStates.text = @"成功";
            return cell;
        }
        if (_buttonIndex == 4) {
            LiferechargeCell *cell = [LiferechargeCell cellWithTableView:tableView];
            cell.timeLabel.text = @"2014-12-22 20:22:22";
            cell.usernameLabel.text = @"张*名";
            cell.useraccountLabel.text = @"123456789***456";
            cell.terminalLabel.text = @"1234567887654321";
            cell.dealMoney.text = @"￥99999.99";
            cell.dealStates.text = @"成功";
            return cell;
        }
        if (_buttonIndex == 5) {
            TelephonechargeCell *cell = [TelephonechargeCell cellWithTableView:tableView];
            cell.timeLabel.text = @"2014-12-22 20:22:22";
            cell.phoneNumLabel.text = @"156****1775";
            cell.terminalLabel.text = @"1234567887654321";
            cell.dealMoney.text = @"￥99999.99";
            cell.dealStates.text = @"成功";
            return cell;
        }
        
        else {
            ConsumptionCell *cell = [ConsumptionCell cellWithTableView:tableView];
            cell.timeLabel.text = @"2014-12-22 20:22:22";
            cell.settleLabel.text = @"2014-12-22 20:22:22";
            cell.poundageLabel.text = @"￥99999.99";
            cell.terminalLabel.text = @"1234567887654321";
            cell.dealMoney.text = @"￥99999.99";
            cell.dealStates.text = @"成功";
            return cell;
        }
        
    }
}
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView.tag == 1111) {
        return 40;
    }
    else{
    if (indexPath.section == 0) {
        return 80;
    }else{
        return 70;
    }
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

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    //终端选择跳转
    if (tableView.tag == 1111) {
        TerminalModel *model = [_terminalItems objectAtIndex:indexPath.row];
        _terminalField.text = model.terminalNum;
        [_terminalTableView removeFromSuperview];
    }
    else{
    //内容点击跳转
    DealRoadChildController *dealVC = [[DealRoadChildController alloc]init];
    dealVC.tradeID = @"1";
    dealVC.tradeType = TradeTypeTelephoneFare;
    dealVC.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:dealVC animated:YES];
    }
}


#pragma mark - Request

//获取终端号
- (void)getAllTerminalList {
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
    hud.labelText = @"加载中...";
    AppDelegate *delegate = [AppDelegate shareAppDelegate];
    [NetworkInterface getTerminalListWithToken:delegate.token userID:delegate.userID finished:^(BOOL success, NSData *response) {
        NSString *str = [[NSString alloc]initWithData:response encoding:NSUTF8StringEncoding];
        NSLog(@"~~~~~~~%@",str);
        hud.customView = [[UIImageView alloc] init];
        hud.mode = MBProgressHUDModeCustomView;
        [hud hide:YES afterDelay:0.5f];
        if (success) {
            id object = [NSJSONSerialization JSONObjectWithData:response options:NSJSONReadingMutableLeaves error:nil];
            if ([object isKindOfClass:[NSDictionary class]]) {
                NSString *errorCode = [object objectForKey:@"code"];
                if ([errorCode intValue] == RequestFail) {
                    //返回错误代码
                    hud.labelText = [NSString stringWithFormat:@"%@",[object objectForKey:@"message"]];
                }
                else if ([errorCode intValue] == RequestSuccess) {
                    [hud hide:YES];
                    [self parseTerminalDataWithDictionary:object];
                }
            }
            else {
                //返回错误数据
                hud.labelText = kServiceReturnWrong;
            }
        }
        else {
            hud.labelText = kNetworkFailed;
        }
    }];
}

#pragma mark - Data

//解析终端信息
- (void)parseTerminalDataWithDictionary:(NSDictionary *)dict {
    if (![dict objectForKey:@"result"] || ![[dict objectForKey:@"result"] isKindOfClass:[NSArray class]]) {
        return;
    }
    NSArray *terminalList = [dict objectForKey:@"result"];
    for (int i = 0; i < [terminalList count]; i++) {
        TerminalModel *terminal = [[TerminalModel alloc] initWithParseDictionary:[terminalList objectAtIndex:i]];
        [_terminalItems addObject:terminal];
    }
}

- (void)parseTradeDataWithDictionary:(NSDictionary *)dict {
    if (![dict objectForKey:@"result"] || ![[dict objectForKey:@"result"] isKindOfClass:[NSArray class]]) {
        return;
    }
    NSArray *tradeList = [dict objectForKey:@"result"];
    for (int i = 0; i < [tradeList count]; i++) {
        TradeModel *trade = [[TradeModel alloc] initWithParseDictionary:[tradeList objectAtIndex:i]];
        [_tradeRecords addObject:trade];
    }
//    [_tableView reloadData];
}

//将日期转化成字符串yyyy-MM-dd格式
- (NSString *)stringFromDate:(NSDate *)date {
    NSDateFormatter *format = [[NSDateFormatter alloc] init];
    [format setDateFormat:@"yyyy-MM-dd"];
    NSString *dateString = [format stringFromDate:date];
    if ([dateString length] >= 10) {
        return [dateString substringToIndex:10];
    }
    return dateString;
}

//将yyyy-MM-dd格式字符串转化成日期
- (NSDate *)dateFromString:(NSString *)string {
    NSDateFormatter *format = [[NSDateFormatter alloc] init];
    [format setDateFormat:@"yyyy-MM-dd"];
    return [format dateFromString:string];
}

@end
