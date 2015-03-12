//
//  TerminalChildController.m
//  iPadff
//
//  Created by 黄含章 on 15/3/10.
//  Copyright (c) 2015年 LanTaiPro. All rights reserved.
//

#import "TerminalChildController.h"
#import "NetworkInterface.h"
#import "AppDelegate.h"
#import "RateModel.h"
#import "OpeningModel.h"
#import "FormView.h"
#import "RecordView.h"

@interface TerminalChildController ()

@property (nonatomic, strong) UIScrollView *scrollView;

@property (nonatomic, strong) NSMutableArray *records; //保存追踪记录

@property (nonatomic, strong) NSMutableArray *ratesItems; //保存费率

@property (nonatomic, strong) NSMutableArray *openItems;   //保存开通资料

/**终端信息*/
@property (nonatomic, strong) NSString *status;
@property (nonatomic, strong) NSString *terminalNum;
@property (nonatomic, strong) NSString *brand;
@property (nonatomic, strong) NSString *model;
@property (nonatomic, strong) NSString *channel;
@property (nonatomic, strong) NSString *merchantName;
@property (nonatomic, strong) NSString *merchantPhone;
@property (nonatomic, strong) NSString *orderNumber;
@property (nonatomic, strong) NSString *createTime;
@property (nonatomic, assign) int page;

@end

@implementation TerminalChildController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupNavBar];
    //初始化数据
    _records = [[NSMutableArray alloc] init];
    _ratesItems = [[NSMutableArray alloc] init];
    _openItems = [[NSMutableArray alloc] init];
    [self initAndLayoutUI];
    [self downloadDataWithPage:self.page isMore:YES];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)setupNavBar
{
    self.title = @"终端详情";
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
}

-(void)backHome
{
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - UI

-(void)initAndLayoutUI
{
    _scrollView = [[UIScrollView alloc]init];
    _scrollView.translatesAutoresizingMaskIntoConstraints = NO;
    _scrollView.backgroundColor = kColor(255, 254, 254, 1.0);
    
    [self.view addSubview:_scrollView];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:_scrollView
                                                          attribute:NSLayoutAttributeTop
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:self.view
                                                          attribute:NSLayoutAttributeTop
                                                         multiplier:1.0
                                                           constant:0]];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:_scrollView
                                                          attribute:NSLayoutAttributeLeft
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:self.view
                                                          attribute:NSLayoutAttributeLeft
                                                         multiplier:1.0
                                                           constant:0]];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:_scrollView
                                                          attribute:NSLayoutAttributeRight
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:self.view
                                                          attribute:NSLayoutAttributeRight
                                                         multiplier:1.0
                                                           constant:0]];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:_scrollView
                                                          attribute:NSLayoutAttributeBottom
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:self.view
                                                          attribute:NSLayoutAttributeBottom
                                                         multiplier:1.0
                                                           constant:0]];
    [self initBtn];
    [self initSubViews];
    
}

-(void)initBtn
{
    CGFloat mainBtnW = 110.f;
    CGFloat mainBtnH = 40.f;
    CGFloat mainBtnX = (SCREEN_WIDTH - 180.f);
    if (iOS7) {
        mainBtnX = SCREEN_HEIGHT - 180.f;
    }
    CGFloat mainBtnY = 60.f;
    if ([_dealStatus isEqualToString:@"1"]) {
        //已开通
        for (int i = 0; i < 2; i++) {
            UIButton *button = [[UIButton alloc]init];
            button.titleLabel.font = [UIFont systemFontOfSize:17];
            [button setTitleColor:[UIColor orangeColor] forState:UIControlStateNormal];
            CALayer *readBtnLayer = [button layer];
            [readBtnLayer setMasksToBounds:YES];
            [readBtnLayer setCornerRadius:2.0];
            [readBtnLayer setBorderWidth:1.0];
            [readBtnLayer setBorderColor:[[UIColor orangeColor] CGColor]];
            button.backgroundColor = [UIColor clearColor];
            button.tag = i + 3333;
            [button addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
            button.frame = CGRectMake(mainBtnX - (i * 120), mainBtnY, mainBtnW, mainBtnH);
            [self.scrollView addSubview:button];
            if (i == 0) {
                [button setTitle:@"找回POS密码" forState:UIControlStateNormal];
            }
            else{
                [button setTitle:@"视频认证" forState:UIControlStateNormal];
            }
        }

    }
    if ([_dealStatus isEqualToString:@"2"]) {
        //部分开通
        for (int i = 0; i < 4; i++) {
            UIButton *button = [[UIButton alloc]init];
            button.titleLabel.font = [UIFont systemFontOfSize:17];
            [button setTitleColor:[UIColor orangeColor] forState:UIControlStateNormal];
            CALayer *readBtnLayer = [button layer];
            [readBtnLayer setMasksToBounds:YES];
            [readBtnLayer setCornerRadius:2.0];
            [readBtnLayer setBorderWidth:1.0];
            [readBtnLayer setBorderColor:[[UIColor orangeColor] CGColor]];
            button.backgroundColor = [UIColor clearColor];
            button.tag = i + 4444;
            [button addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
            button.frame = CGRectMake(mainBtnX - (i * 120), mainBtnY, mainBtnW, mainBtnH);
            [self.scrollView addSubview:button];
            if (i == 0) {
                [button setTitle:@"找回POS密码" forState:UIControlStateNormal];
            }
            if (i == 1) {
                [button setTitle:@"视频认证" forState:UIControlStateNormal];
            }
            if (i == 2) {
                [button setTitle:@"重新申请开通" forState:UIControlStateNormal];
            }
            if (i == 3) {
                [button setTitle:@"同步" forState:UIControlStateNormal];
            }

        }

    }
    if ([_dealStatus isEqualToString:@"3"]) {
        //未开通
        for (int i = 0; i < 3; i++) {
            UIButton *button = [[UIButton alloc]init];
            button.titleLabel.font = [UIFont systemFontOfSize:17];
            [button setTitleColor:[UIColor orangeColor] forState:UIControlStateNormal];
            CALayer *readBtnLayer = [button layer];
            [readBtnLayer setMasksToBounds:YES];
            [readBtnLayer setCornerRadius:2.0];
            [readBtnLayer setBorderWidth:1.0];
            [readBtnLayer setBorderColor:[[UIColor orangeColor] CGColor]];
            button.backgroundColor = [UIColor clearColor];
            button.tag = i + 5555;
            [button addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
            button.frame = CGRectMake(mainBtnX - (i * 120), mainBtnY, mainBtnW, mainBtnH);
            [self.scrollView addSubview:button];
            if (i == 0) {
                [button setTitle:@"视频认证" forState:UIControlStateNormal];
            }
            if (i == 1) {
                [button setTitle:@"申请开通" forState:UIControlStateNormal];
            }
            if (i == 2) {
                [button setTitle:@"同步" forState:UIControlStateNormal];
            }
        }

    }
    if ([_dealStatus isEqualToString:@"4"]) {
        //已注销
        for (int i = 0; i < 1; i++) {
            UIButton *button = [[UIButton alloc]init];
            button.titleLabel.font = [UIFont systemFontOfSize:17];
            [button setTitleColor:[UIColor orangeColor] forState:UIControlStateNormal];
            CALayer *readBtnLayer = [button layer];
            [readBtnLayer setMasksToBounds:YES];
            [readBtnLayer setCornerRadius:2.0];
            [readBtnLayer setBorderWidth:1.0];
            [readBtnLayer setBorderColor:[[UIColor orangeColor] CGColor]];
            button.backgroundColor = [UIColor clearColor];
            button.tag = i + 6666;
            [button addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
            button.frame = CGRectMake(mainBtnX - (i * 120), mainBtnY, mainBtnW, mainBtnH);
            [self.scrollView addSubview:button];
            if (i == 0) {
                [button setTitle:@"租凭退换" forState:UIControlStateNormal];
            }
        }

    }
    if ([_dealStatus isEqualToString:@"5"]) {
        //已停用
        for (int i = 0; i < 2; i++) {
            UIButton *button = [[UIButton alloc]init];
            button.titleLabel.font = [UIFont systemFontOfSize:17];
            [button setTitleColor:[UIColor orangeColor] forState:UIControlStateNormal];
            CALayer *readBtnLayer = [button layer];
            [readBtnLayer setMasksToBounds:YES];
            [readBtnLayer setCornerRadius:2.0];
            [readBtnLayer setBorderWidth:1.0];
            [readBtnLayer setBorderColor:[[UIColor orangeColor] CGColor]];
            button.backgroundColor = [UIColor clearColor];
            button.tag = i + 7777;
            [button addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
            button.frame = CGRectMake(mainBtnX - (i * 120), mainBtnY, mainBtnW, mainBtnH);
            [self.scrollView addSubview:button];
            if (i == 0) {
                [button setTitle:@"更新资料" forState:UIControlStateNormal];
            }
            if (i == 1) {
                [button setTitle:@"同步" forState:UIControlStateNormal];
            }
        }
    }
}

-(void)initSubViews
{
    CGFloat topSpace = 30.f;
    CGFloat leftSpace = 70.f;
    CGFloat rightSpace = 70.f;
    CGFloat labelHeight = 20.f;
    CGFloat space = 4.f; //label间垂直间距
    CGFloat lineSpace = 20.f;
    CGFloat titleLabelHeight = 40.f;
    
    //开通状态
    UILabel *statusTitleLabel = [[UILabel alloc]init];
    statusTitleLabel.translatesAutoresizingMaskIntoConstraints = NO;
    statusTitleLabel.backgroundColor = [UIColor clearColor];
    statusTitleLabel.font = [UIFont systemFontOfSize:18];
    statusTitleLabel.text = @"开通状态：";
    [self.scrollView addSubview:statusTitleLabel];
    [self.view addSubview:_scrollView];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:statusTitleLabel
                                                          attribute:NSLayoutAttributeTop
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:self.scrollView
                                                          attribute:NSLayoutAttributeTop
                                                         multiplier:1.0
                                                           constant:topSpace]];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:statusTitleLabel
                                                          attribute:NSLayoutAttributeLeft
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:self.scrollView
                                                          attribute:NSLayoutAttributeLeft
                                                         multiplier:1.0
                                                           constant:leftSpace]];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:statusTitleLabel
                                                          attribute:NSLayoutAttributeWidth
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:nil
                                                          attribute:NSLayoutAttributeNotAnAttribute
                                                         multiplier:1.0
                                                           constant:100]];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:statusTitleLabel
                                                          attribute:NSLayoutAttributeHeight
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:nil
                                                          attribute:NSLayoutAttributeNotAnAttribute
                                                         multiplier:1.0
                                                           constant:labelHeight]];
    
    
    //状态
    UILabel *statusLabel = [[UILabel alloc]init];
    statusLabel.translatesAutoresizingMaskIntoConstraints = NO;
    statusLabel.backgroundColor = [UIColor clearColor];
    statusLabel.font = [UIFont boldSystemFontOfSize:20];
    [self.scrollView addSubview:statusLabel];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:statusLabel
                                                          attribute:NSLayoutAttributeTop
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:statusTitleLabel
                                                          attribute:NSLayoutAttributeTop
                                                         multiplier:1.0
                                                           constant:topSpace * 1.6]];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:statusLabel
                                                          attribute:NSLayoutAttributeLeft
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:self.scrollView
                                                          attribute:NSLayoutAttributeLeft
                                                         multiplier:1.0
                                                           constant:leftSpace]];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:statusLabel
                                                          attribute:NSLayoutAttributeWidth
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:nil
                                                          attribute:NSLayoutAttributeNotAnAttribute
                                                         multiplier:1.0
                                                           constant:80]];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:statusLabel
                                                          attribute:NSLayoutAttributeHeight
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:nil
                                                          attribute:NSLayoutAttributeNotAnAttribute
                                                         multiplier:1.0
                                                           constant:labelHeight * 1.4]];
    statusLabel.text = @"部分开通";
    
    //划线
    UIView *firstLine = [[UIView alloc]init];
    firstLine.translatesAutoresizingMaskIntoConstraints = NO;
    firstLine.backgroundColor = kColor(218, 218, 218, 1.0);
    [self.scrollView addSubview:firstLine];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:firstLine
                                                          attribute:NSLayoutAttributeTop
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:statusLabel
                                                          attribute:NSLayoutAttributeBottom
                                                         multiplier:1.0
                                                           constant:lineSpace]];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:firstLine
                                                          attribute:NSLayoutAttributeLeft
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:self.view
                                                          attribute:NSLayoutAttributeLeft
                                                         multiplier:1.0
                                                           constant:0]];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:firstLine
                                                          attribute:NSLayoutAttributeRight
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:self.view
                                                          attribute:NSLayoutAttributeRight
                                                         multiplier:1.0
                                                           constant:0]];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:firstLine
                                                          attribute:NSLayoutAttributeHeight
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:nil
                                                          attribute:NSLayoutAttributeNotAnAttribute
                                                         multiplier:1.0
                                                           constant:1.0]];
    
    //终端信息
    UILabel *terminalTitleLabel = [[UILabel alloc]init];
    terminalTitleLabel.text = @"终端信息";
    terminalTitleLabel.translatesAutoresizingMaskIntoConstraints = NO;
    terminalTitleLabel.backgroundColor = [UIColor clearColor];
    terminalTitleLabel.textColor = kColor(68, 68, 68, 1.0);
    terminalTitleLabel.font = [UIFont systemFontOfSize:18.f];
    [self.scrollView addSubview:terminalTitleLabel];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:terminalTitleLabel
                                                          attribute:NSLayoutAttributeTop
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:firstLine
                                                          attribute:NSLayoutAttributeBottom
                                                         multiplier:1.0
                                                           constant:lineSpace + 10]];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:terminalTitleLabel
                                                          attribute:NSLayoutAttributeLeft
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:self.view
                                                          attribute:NSLayoutAttributeLeft
                                                         multiplier:1.0
                                                           constant:leftSpace]];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:terminalTitleLabel
                                                          attribute:NSLayoutAttributeRight
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:self.view
                                                          attribute:NSLayoutAttributeRight
                                                         multiplier:1.0
                                                           constant:100.f]];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:terminalTitleLabel
                                                          attribute:NSLayoutAttributeHeight
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:nil
                                                          attribute:NSLayoutAttributeNotAnAttribute
                                                         multiplier:1.0
                                                           constant:labelHeight]];
    
    //划线 橙色
    UIView *secondLine = [[UIView alloc]init];
    secondLine.translatesAutoresizingMaskIntoConstraints = NO;
    secondLine.backgroundColor = kColor(254, 189, 147, 1.0);
    [self.scrollView addSubview:secondLine];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:secondLine
                                                          attribute:NSLayoutAttributeTop
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:terminalTitleLabel
                                                          attribute:NSLayoutAttributeBottom
                                                         multiplier:1.0
                                                           constant:space]];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:secondLine
                                                          attribute:NSLayoutAttributeLeft
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:self.view
                                                          attribute:NSLayoutAttributeLeft
                                                         multiplier:1.0
                                                           constant:leftSpace]];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:secondLine
                                                          attribute:NSLayoutAttributeRight
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:self.view
                                                          attribute:NSLayoutAttributeRight
                                                         multiplier:1.0
                                                           constant:-rightSpace]];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:secondLine
                                                          attribute:NSLayoutAttributeHeight
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:nil
                                                          attribute:NSLayoutAttributeNotAnAttribute
                                                         multiplier:1.0
                                                           constant:1.0]];
    
    
    //终端号136
    UILabel *terminalNumberLabel = [[UILabel alloc] init];
    [self setLabel:terminalNumberLabel withTopView:secondLine middleSpace:space titleName:@"终 端 号"];
    //POS品牌
    UILabel *brandLabel = [[UILabel alloc] init];
    [self setLabel:brandLabel withTopView:terminalNumberLabel middleSpace:space titleName:@"POS品牌"];
    //POS型号
    UILabel *modelLabel = [[UILabel alloc] init];
    [self setLabel:modelLabel withTopView:brandLabel middleSpace:space titleName:@"POS型号"];
    //支付平台
    UILabel *channelLabel = [[UILabel alloc] init];
    [self setLabel:channelLabel withTopView:modelLabel middleSpace:space titleName:@"支付平台"];
    //商户名
    UILabel *merchantNameLabel = [[UILabel alloc] init];
    [self setLabel:merchantNameLabel withTopView:channelLabel middleSpace:space titleName:@"商 户 名"];
    //商户电话 236
    UILabel *merchantPhoneLabel = [[UILabel alloc] init];
    [self setLabel:merchantPhoneLabel withTopView:merchantNameLabel middleSpace:space titleName:@"商户电话"];
    //订单号
    UILabel *orderLabel = [[UILabel alloc] init];
    [self setLabel:orderLabel withTopView:merchantPhoneLabel middleSpace:space titleName:@"订 单 号"];
    //订购时间
    UILabel *timeLabel = [[UILabel alloc] init];
    [self setLabel:timeLabel withTopView:orderLabel middleSpace:space titleName:@"订购时间"];

    //费率表
#pragma mark 改表格时记得改View里的宽度 传左右限制值
    CGFloat rateHeight = [FormView heightWithRowCount:[_ratesItems count] hasTitle:NO];
    FormView *formView = [[FormView alloc] init];
    formView.translatesAutoresizingMaskIntoConstraints = NO;
    [formView setRateData:_ratesItems];
    [_scrollView addSubview:formView];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:formView
                                                          attribute:NSLayoutAttributeTop
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:secondLine
                                                          attribute:NSLayoutAttributeBottom
                                                         multiplier:1.0
                                                           constant:space * 2]];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:formView
                                                          attribute:NSLayoutAttributeLeft
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:self.view
                                                          attribute:NSLayoutAttributeLeft
                                                         multiplier:1.0
                                                           constant:500.f]];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:formView
                                                          attribute:NSLayoutAttributeRight
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:self.view
                                                          attribute:NSLayoutAttributeRight
                                                         multiplier:1.0
                                                           constant:-50.f]];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:formView
                                                          attribute:NSLayoutAttributeHeight
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:nil
                                                          attribute:NSLayoutAttributeNotAnAttribute
                                                         multiplier:1.0
                                                           constant:rateHeight]];
    
    //开通信息
    UILabel *openTitleLabel = [[UILabel alloc] init];
    openTitleLabel.text = @"开通详情";
    openTitleLabel.translatesAutoresizingMaskIntoConstraints = NO;
    openTitleLabel.backgroundColor = [UIColor clearColor];
    openTitleLabel.textColor = kColor(68, 68, 68, 1.0);
    openTitleLabel.font = [UIFont systemFontOfSize:18.f];
    [self.scrollView addSubview:openTitleLabel];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:openTitleLabel
                                                          attribute:NSLayoutAttributeTop
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:timeLabel
                                                          attribute:NSLayoutAttributeBottom
                                                         multiplier:1.0
                                                           constant:lineSpace]];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:openTitleLabel
                                                          attribute:NSLayoutAttributeLeft
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:self.view
                                                          attribute:NSLayoutAttributeLeft
                                                         multiplier:1.0
                                                           constant:leftSpace]];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:openTitleLabel
                                                          attribute:NSLayoutAttributeRight
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:self.view
                                                          attribute:NSLayoutAttributeRight
                                                         multiplier:1.0
                                                           constant:0]];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:openTitleLabel
                                                          attribute:NSLayoutAttributeHeight
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:nil
                                                          attribute:NSLayoutAttributeNotAnAttribute
                                                         multiplier:1.0
                                                           constant:titleLabelHeight]];
    //划线
    UIView *thirdLine = [[UIView alloc] init];
    thirdLine.translatesAutoresizingMaskIntoConstraints = NO;
    thirdLine.backgroundColor = kColor(255, 102, 36, 1);
    [self.scrollView addSubview:thirdLine];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:thirdLine
                                                          attribute:NSLayoutAttributeTop
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:openTitleLabel
                                                          attribute:NSLayoutAttributeBottom
                                                         multiplier:1.0
                                                           constant:space]];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:thirdLine
                                                          attribute:NSLayoutAttributeLeft
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:self.view
                                                          attribute:NSLayoutAttributeLeft
                                                         multiplier:1.0
                                                           constant:leftSpace]];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:thirdLine
                                                          attribute:NSLayoutAttributeRight
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:self.view
                                                          attribute:NSLayoutAttributeRight
                                                         multiplier:1.0
                                                           constant:-leftSpace]];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:thirdLine
                                                          attribute:NSLayoutAttributeHeight
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:nil
                                                          attribute:NSLayoutAttributeNotAnAttribute
                                                         multiplier:1.0
                                                           constant:1.0]];
    //开通详情高度
    CGFloat openHeight = 0;
    //文字
    for (OpeningModel *model in _openItems) {
        if (model.type == ResourceText) {
            UILabel *openLabel = [[UILabel alloc] init];
            [self setLabel:openLabel withTopView:thirdLine middleSpace:openHeight + space titleName:model.resourceKey];
            openLabel.text = model.resourceValue;
            openHeight += titleLabelHeight;
        }
    }
    //图片
    int index = 0;
    for (OpeningModel *model in _openItems) {
        if (model.type == ResourceImage) {
            model.index = index;
            if (index % 2 == 0 && index != 0) {
                openHeight += labelHeight + lineSpace;
            }
            UILabel *imageLabel = [[UILabel alloc] init];
            [self setImageLabel:imageLabel withTopView:openTitleLabel middleSpace:openHeight + lineSpace data:model];
            index++;
        }
    }
    openHeight += labelHeight + lineSpace;
    //跟踪记录
    CGFloat recordHeight = 0.f;
    if ([self.records count] > 0) {
        UILabel *tipLabel = [[UILabel alloc] init];
        tipLabel.translatesAutoresizingMaskIntoConstraints = NO;
        tipLabel.backgroundColor = [UIColor clearColor];
        tipLabel.textColor = kColor(108, 108, 108, 1);
        tipLabel.font = [UIFont systemFontOfSize:14.f];
        tipLabel.text = @"追踪记录：";
        [_scrollView addSubview:tipLabel];
        [self.view addConstraint:[NSLayoutConstraint constraintWithItem:tipLabel
                                                              attribute:NSLayoutAttributeTop
                                                              relatedBy:NSLayoutRelationEqual
                                                                 toItem:openTitleLabel
                                                              attribute:NSLayoutAttributeBottom
                                                             multiplier:1.0
                                                               constant:openHeight + 30]];
        [self.view addConstraint:[NSLayoutConstraint constraintWithItem:tipLabel
                                                              attribute:NSLayoutAttributeLeft
                                                              relatedBy:NSLayoutRelationEqual
                                                                 toItem:self.view
                                                              attribute:NSLayoutAttributeLeft
                                                             multiplier:1.0
                                                               constant:leftSpace]];
        [self.view addConstraint:[NSLayoutConstraint constraintWithItem:tipLabel
                                                              attribute:NSLayoutAttributeRight
                                                              relatedBy:NSLayoutRelationEqual
                                                                 toItem:self.view
                                                              attribute:NSLayoutAttributeRight
                                                             multiplier:1.0
                                                               constant:-leftSpace]];
        [self.view addConstraint:[NSLayoutConstraint constraintWithItem:tipLabel
                                                              attribute:NSLayoutAttributeHeight
                                                              relatedBy:NSLayoutRelationEqual
                                                                 toItem:nil
                                                              attribute:NSLayoutAttributeNotAnAttribute
                                                             multiplier:1.0
                                                               constant:labelHeight * 2]];
        
        RecordView *recordView = [[RecordView alloc] initWithRecords:self.records
                                                               width:(kScreenWidth - leftSpace * 2)];
        recordView.translatesAutoresizingMaskIntoConstraints = NO;
        recordHeight = [recordView getHeight];
        [self.scrollView addSubview:recordView];
        [self.view addConstraint:[NSLayoutConstraint constraintWithItem:recordView
                                                              attribute:NSLayoutAttributeTop
                                                              relatedBy:NSLayoutRelationEqual
                                                                 toItem:tipLabel
                                                              attribute:NSLayoutAttributeBottom
                                                             multiplier:1.0
                                                               constant:4.f]];
        [self.view addConstraint:[NSLayoutConstraint constraintWithItem:recordView
                                                              attribute:NSLayoutAttributeLeft
                                                              relatedBy:NSLayoutRelationEqual
                                                                 toItem:self.view
                                                              attribute:NSLayoutAttributeLeft
                                                             multiplier:1.0
                                                               constant:leftSpace]];
        [self.view addConstraint:[NSLayoutConstraint constraintWithItem:recordView
                                                              attribute:NSLayoutAttributeRight
                                                              relatedBy:NSLayoutRelationEqual
                                                                 toItem:self.view
                                                              attribute:NSLayoutAttributeRight
                                                             multiplier:1.0
                                                               constant:-leftSpace]];
        [self.view addConstraint:[NSLayoutConstraint constraintWithItem:recordView
                                                              attribute:NSLayoutAttributeHeight
                                                              relatedBy:NSLayoutRelationEqual
                                                                 toItem:nil
                                                              attribute:NSLayoutAttributeNotAnAttribute
                                                             multiplier:1.0
                                                               constant:recordHeight]];
        [recordView initAndLayoutUI];
    }
    self.scrollView.contentSize = CGSizeMake(kScreenWidth, 400 + rateHeight + openHeight + recordHeight);
    terminalTitleLabel.text = @"终端信息";
    openTitleLabel.text = @"开通详情";
    statusLabel.text = [self getStatusString];
    terminalNumberLabel.text = _terminalNum;
    brandLabel.text = _brand;
    modelLabel.text = _model;
    channelLabel.text = _channel;
    merchantNameLabel.text = _merchantName;
    merchantPhoneLabel.text = _merchantPhone;
    orderLabel.text = _orderNumber;
    timeLabel.text = _createTime;
    
}

- (NSString *)getStatusString {
    NSString *statusString = nil;
    int index = [_dealStatus intValue];
    switch (index) {
        case TerminalStatusOpened:
            statusString = @"已开通";
            break;
        case TerminalStatusPartOpened:
            statusString = @"部分开通";
            break;
        case TerminalStatusUnOpened:
            statusString = @"未开通";
            break;
        case TerminalStatusCanceled:
            statusString = @"已注销";
            break;
        case TerminalStatusStopped:
            statusString = @"已停用";
            break;
        default:
            break;
    }
    return statusString;
}


#pragma mark - Layout

- (void)setLabel:(UILabel *)label
     withTopView:(UIView *)topView
     middleSpace:(CGFloat)space
       titleName:(NSString *)title {
    CGFloat leftSpace = 70.f;
    CGFloat rightSpce = 20.f;
    CGFloat labelHeight = 18.f;
    CGFloat vSpace = 4.f;
    CGFloat titleWidth = 100.f;
    
    //标题label
    UILabel *titleLabel = [[UILabel alloc] init];
    titleLabel.translatesAutoresizingMaskIntoConstraints = NO;
    titleLabel.backgroundColor = [UIColor clearColor];
    titleLabel.font = [UIFont systemFontOfSize:18.f];
    titleLabel.textColor = kColor(68, 68, 68, 1.0);
    titleLabel.text = title;
    [_scrollView addSubview:titleLabel];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:titleLabel
                                                          attribute:NSLayoutAttributeTop
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:topView
                                                          attribute:NSLayoutAttributeBottom
                                                         multiplier:1.0
                                                           constant:space]];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:titleLabel
                                                          attribute:NSLayoutAttributeLeft
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:self.view
                                                          attribute:NSLayoutAttributeLeft
                                                         multiplier:1.0
                                                           constant:leftSpace]];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:titleLabel
                                                          attribute:NSLayoutAttributeWidth
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:nil
                                                          attribute:NSLayoutAttributeNotAnAttribute
                                                         multiplier:0.0
                                                           constant:titleWidth]];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:titleLabel
                                                          attribute:NSLayoutAttributeHeight
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:nil
                                                          attribute:NSLayoutAttributeNotAnAttribute
                                                         multiplier:1.0
                                                           constant:labelHeight]];
    
    label.translatesAutoresizingMaskIntoConstraints = NO;
    label.backgroundColor = [UIColor clearColor];
    label.font = [UIFont systemFontOfSize:18.f];
    label.textColor = kColor(68, 68, 68, 1.0);
    [_scrollView addSubview:label];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:label
                                                          attribute:NSLayoutAttributeTop
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:topView
                                                          attribute:NSLayoutAttributeBottom
                                                         multiplier:1.0
                                                           constant:space]];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:label
                                                          attribute:NSLayoutAttributeLeft
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:titleLabel
                                                          attribute:NSLayoutAttributeRight
                                                         multiplier:1.0
                                                           constant:vSpace]];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:label
                                                          attribute:NSLayoutAttributeRight
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:self.view
                                                          attribute:NSLayoutAttributeRight
                                                         multiplier:1.0
                                                           constant:-rightSpce]];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:label
                                                          attribute:NSLayoutAttributeHeight
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:nil
                                                          attribute:NSLayoutAttributeNotAnAttribute
                                                         multiplier:1.0
                                                           constant:labelHeight]];
}


#pragma mark - Request

- (void)downloadDataWithPage:(int)page isMore:(BOOL)isMore {
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
    hud.labelText = @"加载中...";
    AppDelegate *delegate = [AppDelegate shareAppDelegate];
    [NetworkInterface getTerminalManagerListWithToken:delegate.token userID:delegate.userID page:page rows:kPageSize finished:^(BOOL success, NSData *response) {
        NSLog(@"%@",[[NSString alloc] initWithData:response encoding:NSUTF8StringEncoding]);
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
                    [self parseTerminalDetailDataWithDictionary:object];
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

- (void)parseTerminalDetailDataWithDictionary:(NSDictionary *)dict {
    if (![dict objectForKey:@"result"] || ![[dict objectForKey:@"result"] isKindOfClass:[NSDictionary class]]) {
        return;
    }
    NSDictionary *infoDict = [dict objectForKey:@"result"];
    if ([[infoDict objectForKey:@"applyDetails"] isKindOfClass:[NSDictionary class]]) {
        NSDictionary *applyDict = [infoDict objectForKey:@"applyDetails"];
        if ([applyDict objectForKey:@"status"]) {
            _status = [NSString stringWithFormat:@"%@",[applyDict objectForKey:@"status"]];
        }
        if ([applyDict objectForKey:@"serial_num"]) {
            _terminalNum = [NSString stringWithFormat:@"%@",[applyDict objectForKey:@"serial_num"]];
        }
        if ([applyDict objectForKey:@"brandName"]) {
            _brand = [NSString stringWithFormat:@"%@",[applyDict objectForKey:@"brandName"]];
        }
        if ([applyDict objectForKey:@"model_number"]) {
            _model = [NSString stringWithFormat:@"%@",[applyDict objectForKey:@"model_number"]];
        }
        if ([applyDict objectForKey:@"channelName"]) {
            _channel = [NSString stringWithFormat:@"%@",[applyDict objectForKey:@"channelName"]];
        }
        if ([applyDict objectForKey:@"title"]) {
            _merchantName = [NSString stringWithFormat:@"%@",[applyDict objectForKey:@"title"]];
        }
        if ([applyDict objectForKey:@"phone"]) {
            _merchantPhone = [NSString stringWithFormat:@"%@",[applyDict objectForKey:@"phone"]];
        }
        if ([applyDict objectForKey:@"order_number"]) {
            _orderNumber = [NSString stringWithFormat:@"%@",[applyDict objectForKey:@"order_number"]];
        }
        if ([applyDict objectForKey:@"createdAt"]) {
            _createTime = [NSString stringWithFormat:@"%@",[applyDict objectForKey:@"createdAt"]];
        }
    }
    //费率
    id rateObject = [infoDict objectForKey:@"rates"];
    if ([rateObject isKindOfClass:[NSArray class]]) {
        for (int i = 0; i < [rateObject count]; i++) {
            id dict = [rateObject objectAtIndex:i];
            if ([dict isKindOfClass:[NSDictionary class]]) {
                RateModel *model = [[RateModel alloc] initWithParseDictionary:dict];
                [self.ratesItems addObject:model];
            }
        }
    }
    //开通资料
    id openObject = [infoDict objectForKey:@"openingDetails"];
    if ([rateObject isKindOfClass:[NSArray class]]) {
        for (int i = 0; i < [openObject count]; i++) {
            id dict = [openObject objectAtIndex:i];
            if ([dict isKindOfClass:[NSDictionary class]]) {
                OpeningModel *model = [[OpeningModel alloc] initWithParseDictionary:dict];
                [self.openItems addObject:model];
            }
        }
    }
    //跟踪记录
    id recordObject = [infoDict objectForKey:@"trackRecord"];
    if ([recordObject isKindOfClass:[NSArray class]]) {
        for (int i = 0; i < [recordObject count]; i++) {
            id dict = [recordObject objectAtIndex:i];
            if ([dict isKindOfClass:[NSDictionary class]]) {
                RecordModel *model = [[RecordModel alloc] initWithParseTerminalDictionary:dict];
                [self.records addObject:model];
            }
        }
    }
    [self initSubViews];
}

- (void)setImageLabel:(UILabel *)label
          withTopView:(UIView *)topView
          middleSpace:(CGFloat)space
                 data:(OpeningModel *)dataModel {
    CGFloat leftSpace = 70.f;
    CGFloat labelHeight = 18.f;
    CGFloat vSpace = 0.f;
    label.translatesAutoresizingMaskIntoConstraints = NO;
    label.backgroundColor = [UIColor clearColor];
    label.font = [UIFont systemFontOfSize:18.f];
    label.textColor = kColor(42, 42, 42, 1);
    label.text = dataModel.resourceKey;
    [_scrollView addSubview:label];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:label
                                                          attribute:NSLayoutAttributeTop
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:topView
                                                          attribute:NSLayoutAttributeBottom
                                                         multiplier:1.0
                                                           constant:space]];
    if (dataModel.index % 2 == 0) {
        //左侧
        [self.view addConstraint:[NSLayoutConstraint constraintWithItem:label
                                                              attribute:NSLayoutAttributeLeft
                                                              relatedBy:NSLayoutRelationEqual
                                                                 toItem:self.view
                                                              attribute:NSLayoutAttributeLeft
                                                             multiplier:1.0
                                                               constant:leftSpace]];
    }
    else {
        //右侧
        [self.view addConstraint:[NSLayoutConstraint constraintWithItem:label
                                                              attribute:NSLayoutAttributeLeft
                                                              relatedBy:NSLayoutRelationEqual
                                                                 toItem:self.view
                                                              attribute:NSLayoutAttributeRight
                                                             multiplier:0.4
                                                               constant:0.f]];
    }
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:label
                                                          attribute:NSLayoutAttributeWidth
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:nil
                                                          attribute:NSLayoutAttributeWidth
                                                         multiplier:1.0
                                                           constant:150.f]];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:label
                                                          attribute:NSLayoutAttributeHeight
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:nil
                                                          attribute:NSLayoutAttributeNotAnAttribute
                                                         multiplier:1.0
                                                           constant:labelHeight]];
    if (!dataModel.resourceValue) {
        return;
    }
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.translatesAutoresizingMaskIntoConstraints = NO;
    btn.tag = dataModel.index + 1;
    [btn setBackgroundImage:kImageName(@"upload.png") forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(scanImage:) forControlEvents:UIControlEventTouchUpInside];
    [_scrollView addSubview:btn];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:btn
                                                          attribute:NSLayoutAttributeTop
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:topView
                                                          attribute:NSLayoutAttributeBottom
                                                         multiplier:1.0
                                                           constant:space]];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:btn
                                                          attribute:NSLayoutAttributeLeft
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:label
                                                          attribute:NSLayoutAttributeRight
                                                         multiplier:1.0
                                                           constant:vSpace]];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:btn
                                                          attribute:NSLayoutAttributeWidth
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:nil
                                                          attribute:NSLayoutAttributeNotAnAttribute
                                                         multiplier:0.0
                                                           constant:25.f]];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:btn
                                                          attribute:NSLayoutAttributeHeight
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:nil
                                                          attribute:NSLayoutAttributeNotAnAttribute
                                                         multiplier:1.0
                                                           constant:25.f]];
}


#pragma mark ---按钮点击时间

-(void)buttonClick:(UIButton *)button
{
    switch (button.tag) {
        case 3333:
            NSLog(@"点击了找回POS密码（已开通）");
            break;
        case 3334:
            NSLog(@"点击了视频认证（已开通）");
            break;
        case 4444:
            NSLog(@"点击了找回POS密码（部分开通）");
            break;
        case 4445:
            NSLog(@"点击了视频认证（部分开通）");
            break;
        case 4446:
            NSLog(@"点击了重新申请通（部分开通）");
            break;
        case 4447:
            NSLog(@"点击了同步（部分开通）");
            break;
        case 5555:
            NSLog(@"点击了视频认证（未开通）");
            break;
        case 5556:
            NSLog(@"点击了申请开通（未开通）");
            break;
        case 5557:
            NSLog(@"点击了同步（未开通）");
            break;
        case 6666:
            NSLog(@"点击了租凭退换（已注销）");
            break;
        case 7777:
            NSLog(@"点击了更新资料（已停用）");
            break;
        case 7778:
            NSLog(@"点击了同步（已停用）");
            break;
            
        default:
            break;
    }
}

#pragma mark - Action

- (IBAction)scanImage:(id)sender {
    NSLog(@"%ld",[(UIButton *)sender tag]);
    for (UIView *view in _scrollView.subviews) {
        NSLog(@"%@",view);
    }
}


@end
