//
//  DealRoadChildController.m
//  iPadff
//
//  Created by 黄含章 on 15/3/6.
//  Copyright (c) 2015年 LanTaiPro. All rights reserved.
//

#import "DealRoadChildController.h"
#import "AppDelegate.h"
#import "TradeModel.h"

@interface DealRoadChildController ()

@property (nonatomic, strong) UIScrollView *scrollView;

//解析字段
@property (nonatomic, strong) NSString *tradeStatus;    //状态
@property (nonatomic, strong) NSString *tradeAmount;    //交易金额
@property (nonatomic, strong) NSString *tradePoundage;  //手续费
@property (nonatomic, strong) NSString *tradeTime;      //交易时间
@property (nonatomic, strong) NSString *merchantNumber; //商户编号
@property (nonatomic, strong) NSString *agentID;        //代理商ID
@property (nonatomic, strong) NSString *merchantName;   //商户ID
@property (nonatomic, strong) NSString *terminalNumber; //终端号
@property (nonatomic, strong) NSString *payFromAccount; //付款账号
@property (nonatomic, strong) NSString *payToAccount;   //收款账号
@property (nonatomic, strong) NSString *channelName;    //支付通道
@property (nonatomic, strong) NSString *profitPrice;    //分润
@property (nonatomic, strong) NSString *batchNumber;    //交易批次号
@property (nonatomic, strong) NSString *tradeNumber;    //交易流水号

//消费
@property (nonatomic, strong) NSString *payedTime;
//生活充值
@property (nonatomic, strong) NSString *accountName;
@property (nonatomic, strong) NSString *accountNumber;
//话费充值
@property (nonatomic, strong) NSString *phoneNumber;

@end

@implementation DealRoadChildController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupNavBar];
    [self initAndLaoutUI];
    [self downloadTradeDetail];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark 创建导航栏
-(void)setupNavBar
{
    self.title = @"交易流水详情";
    self.view.backgroundColor = [UIColor whiteColor];
}
-(void)backHome
{
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark 创建UI
-(void)initAndLaoutUI
{
    _scrollView = [[UIScrollView alloc] init];
    _scrollView.translatesAutoresizingMaskIntoConstraints = NO;
    _scrollView.backgroundColor = kColor(244, 243, 243, 1);
    
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
}

-(void)initSubViews
{
    CGFloat topSpace = 20.f;
    CGFloat leftSpace = 50.f;
    CGFloat rightSpce = 20.f;
    CGFloat space = 1.f;       //label之间垂直间距
    CGFloat labelHeight = 18.f;
    CGFloat lineSpace = 20.f;  //划线前后间距
    CGFloat titleLabelHeight = 20.f;
    //交易状态
    UILabel *statusSLabel = [[UILabel alloc] init];
    statusSLabel.text = @"交易状态:";
    statusSLabel.font = [UIFont systemFontOfSize:17.f];
    statusSLabel.translatesAutoresizingMaskIntoConstraints = NO;
    statusSLabel.backgroundColor = [UIColor clearColor];
    [_scrollView addSubview:statusSLabel];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:statusSLabel
                                                          attribute:NSLayoutAttributeTop
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:_scrollView
                                                          attribute:NSLayoutAttributeTop
                                                         multiplier:1.0
                                                           constant:topSpace + 10]];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:statusSLabel
                                                          attribute:NSLayoutAttributeLeft
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:self.view
                                                          attribute:NSLayoutAttributeLeft
                                                         multiplier:1.0
                                                           constant:leftSpace]];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:statusSLabel
                                                          attribute:NSLayoutAttributeRight
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:self.view
                                                          attribute:NSLayoutAttributeRight
                                                         multiplier:1.0
                                                           constant:-rightSpce]];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:statusSLabel
                                                          attribute:NSLayoutAttributeHeight
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:nil
                                                          attribute:NSLayoutAttributeNotAnAttribute
                                                         multiplier:1.0
                                                           constant:20.f]];
    //状态
    UILabel *statusLabel = [[UILabel alloc] init];
    statusLabel.translatesAutoresizingMaskIntoConstraints = NO;
    statusLabel.backgroundColor = [UIColor clearColor];
    statusLabel.font = [UIFont systemFontOfSize:20.f];
    [_scrollView addSubview:statusLabel];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:statusLabel
                                                          attribute:NSLayoutAttributeTop
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:statusSLabel
                                                          attribute:NSLayoutAttributeTop
                                                         multiplier:1.0
                                                           constant:topSpace * 2]];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:statusLabel
                                                          attribute:NSLayoutAttributeLeft
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:self.view
                                                          attribute:NSLayoutAttributeLeft
                                                         multiplier:1.0
                                                           constant:leftSpace]];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:statusLabel
                                                          attribute:NSLayoutAttributeRight
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:self.view
                                                          attribute:NSLayoutAttributeRight
                                                         multiplier:1.0
                                                           constant:-rightSpce]];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:statusLabel
                                                          attribute:NSLayoutAttributeHeight
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:nil
                                                          attribute:NSLayoutAttributeNotAnAttribute
                                                         multiplier:1.0
                                                           constant:30.f]];
    //交易金额
    UILabel *moneyLabel = [[UILabel alloc] init];
    [self setLabel:moneyLabel withTopView:_scrollView middleSpace:space * 2 labelTag:1];
    moneyLabel.textColor = [UIColor blackColor];
    //手续费
    UILabel *poundageLabel = [[UILabel alloc] init];
    [self setLabel:poundageLabel withTopView:moneyLabel middleSpace:space labelTag:2];
    poundageLabel.textColor = [UIColor blackColor];
    //交易时间
    UILabel *tradeTimeLabel = [[UILabel alloc] init];
    [self setLabel:tradeTimeLabel withTopView:poundageLabel middleSpace:space labelTag:3];
    tradeTimeLabel.textColor = [UIColor blackColor];
    
    //划线
    UIView *firstLine = [[UIView alloc] init];
    firstLine.translatesAutoresizingMaskIntoConstraints = NO;
    firstLine.backgroundColor = kColor(222, 220, 220, 1);
    [_scrollView addSubview:firstLine];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:firstLine
                                                          attribute:NSLayoutAttributeTop
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:tradeTimeLabel
                                                          attribute:NSLayoutAttributeBottom
                                                         multiplier:1.0
                                                           constant:lineSpace]];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:firstLine
                                                          attribute:NSLayoutAttributeLeft
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:self.view
                                                          attribute:NSLayoutAttributeLeft
                                                         multiplier:1.0
                                                           constant:0.f]];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:firstLine
                                                          attribute:NSLayoutAttributeRight
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:self.view
                                                          attribute:NSLayoutAttributeRight
                                                         multiplier:1.0
                                                           constant:0.f]];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:firstLine
                                                          attribute:NSLayoutAttributeHeight
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:nil
                                                          attribute:NSLayoutAttributeNotAnAttribute
                                                         multiplier:1.0
                                                           constant:1.0]];
    //商户信息
    UILabel *merchantTitleLabel = [[UILabel alloc] init];
    merchantTitleLabel.translatesAutoresizingMaskIntoConstraints = NO;
    merchantTitleLabel.backgroundColor = [UIColor clearColor];
    merchantTitleLabel.textColor = kColor(56, 56, 56, 1);
    merchantTitleLabel.font = [UIFont systemFontOfSize:16.f];
    [_scrollView addSubview:merchantTitleLabel];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:merchantTitleLabel
                                                          attribute:NSLayoutAttributeTop
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:firstLine
                                                          attribute:NSLayoutAttributeBottom
                                                         multiplier:1.0
                                                           constant:lineSpace]];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:merchantTitleLabel
                                                          attribute:NSLayoutAttributeLeft
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:self.view
                                                          attribute:NSLayoutAttributeLeft
                                                         multiplier:1.0
                                                           constant:leftSpace]];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:merchantTitleLabel
                                                          attribute:NSLayoutAttributeRight
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:self.view
                                                          attribute:NSLayoutAttributeRight
                                                         multiplier:1.0
                                                           constant:-rightSpce]];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:merchantTitleLabel
                                                          attribute:NSLayoutAttributeHeight
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:nil
                                                          attribute:NSLayoutAttributeNotAnAttribute
                                                         multiplier:1.0
                                                           constant:titleLabelHeight]];
    //划线
    UIView *secondLine = [[UIView alloc] init];
    secondLine.translatesAutoresizingMaskIntoConstraints = NO;
    secondLine.backgroundColor = kColor(255, 102, 36, 1);
    [_scrollView addSubview:secondLine];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:secondLine
                                                          attribute:NSLayoutAttributeTop
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:merchantTitleLabel
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
                                                          attribute:NSLayoutAttributeWidth
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:nil
                                                          attribute:NSLayoutAttributeNotAnAttribute
                                                         multiplier:1.0
                                                           constant:900.f]];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:secondLine
                                                          attribute:NSLayoutAttributeHeight
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:nil
                                                          attribute:NSLayoutAttributeNotAnAttribute
                                                         multiplier:1.0
                                                           constant:1.0]];
    //商家编号
    UILabel *merchantNumberLabel = [[UILabel alloc] init];
    [self setLabel:merchantNumberLabel withTopView:secondLine middleSpace:space labelTag:0];
    //代理商ID
    UILabel *agentIDLabel = [[UILabel alloc] init];
    [self setLabel:agentIDLabel withTopView:merchantNumberLabel middleSpace:space labelTag:0];
    //商户ID
    UILabel *merchantIDLabel = [[UILabel alloc] init];
    [self setLabel:merchantIDLabel withTopView:agentIDLabel middleSpace:space labelTag:0];
    
    //银行信息
    UILabel *bankLabel = [[UILabel alloc] init];
    bankLabel.translatesAutoresizingMaskIntoConstraints = NO;
    bankLabel.backgroundColor = [UIColor clearColor];
    bankLabel.textColor = kColor(108, 108, 108, 1);
    bankLabel.font = [UIFont systemFontOfSize:16.f];
    [_scrollView addSubview:bankLabel];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:bankLabel
                                                          attribute:NSLayoutAttributeTop
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:merchantIDLabel
                                                          attribute:NSLayoutAttributeBottom
                                                         multiplier:1.0
                                                           constant:lineSpace]];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:bankLabel
                                                          attribute:NSLayoutAttributeLeft
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:self.view
                                                          attribute:NSLayoutAttributeLeft
                                                         multiplier:1.0
                                                           constant:leftSpace]];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:bankLabel
                                                          attribute:NSLayoutAttributeRight
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:self.view
                                                          attribute:NSLayoutAttributeRight
                                                         multiplier:1.0
                                                           constant:-rightSpce]];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:bankLabel
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
    [_scrollView addSubview:thirdLine];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:thirdLine
                                                          attribute:NSLayoutAttributeTop
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:bankLabel
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
                                                          attribute:NSLayoutAttributeWidth
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:nil
                                                          attribute:NSLayoutAttributeNotAnAttribute
                                                         multiplier:1.0
                                                           constant:900.f]];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:thirdLine
                                                          attribute:NSLayoutAttributeHeight
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:nil
                                                          attribute:NSLayoutAttributeNotAnAttribute
                                                         multiplier:1.0
                                                           constant:1.0]];
    //终端号
    UILabel *terminalLabel = [[UILabel alloc] init];
    [self setLabel:terminalLabel withTopView:thirdLine middleSpace:space labelTag:0];
    //付款账号
    UILabel *payFromLabel = [[UILabel alloc] init];
    [self setLabel:payFromLabel withTopView:terminalLabel middleSpace:space labelTag:0];
    
    //收款账号
    UILabel *payToLabel = [[UILabel alloc] init];
    //支付通道
    UILabel *channelLabel = [[UILabel alloc] init];
    if (_tradeType == TradeTypeTelephoneFare) {
        //若是话费充值 则不显示收款账号
        [self setLabel:channelLabel withTopView:payFromLabel middleSpace:space labelTag:0];
    }
    else {
        [self setLabel:payToLabel withTopView:payFromLabel middleSpace:space labelTag:0];
        [self setLabel:channelLabel withTopView:payToLabel middleSpace:space labelTag:0];
    }
    //分润金额
    UILabel *profitLabel = [[UILabel alloc] init];
    [self setLabel:profitLabel withTopView:channelLabel middleSpace:space labelTag:0];
    //交易金额
    UILabel *tradeMoneyLabel = [[UILabel alloc] init];
    [self setLabel:tradeMoneyLabel withTopView:profitLabel middleSpace:space labelTag:0];
    //交易时间
    UILabel *timeLabel = [[UILabel alloc] init];
    [self setLabel:timeLabel withTopView:tradeMoneyLabel middleSpace:space labelTag:0];
    //交易状态
    UILabel *tradeStatusLabel = [[UILabel alloc] init];
    [self setLabel:tradeStatusLabel withTopView:timeLabel middleSpace:space labelTag:0];
    //交易批次号
    UILabel *batchLabel = [[UILabel alloc] init];
    [self setLabel:batchLabel withTopView:tradeStatusLabel middleSpace:space labelTag:0];
    //交易流水号
    UILabel *tradeNumberLabel = [[UILabel alloc] init];
    [self setLabel:tradeNumberLabel withTopView:batchLabel middleSpace:space labelTag:0];
    //付款银行号
    UILabel *payBankLabel = [[UILabel alloc] init];
    [self setLabel:payBankLabel withTopView:tradeNumberLabel middleSpace:space labelTag:0];
    
    /*
     计算scrollview的contentSize
     顶部间距        topSpace
     状态label      30
     小label+间距    22 * (labelHeight + space)
     线上下间距       3 * lineSpace
     标题label       2 * titleLabelHeight
     线              3 * 1
     */
    CGFloat sizeY = topSpace + 30 + 17 * (labelHeight + space) + 5 * space + 3 * lineSpace + 2 * titleLabelHeight + 3 * 1;
    if (_tradeType == TradeTypeTelephoneFare) {
        sizeY -= labelHeight + space;
    }
    _scrollView.contentSize = CGSizeMake(kScreenWidth, sizeY);
    if (iOS7) {
    _scrollView.contentSize = CGSizeMake(kScreenHeight, sizeY);
    }
    
    statusLabel.text = [self statusForIndexString:_tradeStatus];
    moneyLabel.text = [NSString stringWithFormat:@"交易金额：%@",_tradeAmount];
    poundageLabel.text = [NSString stringWithFormat:@"手续费：￥%@",_tradePoundage];
    tradeTimeLabel.text = [NSString stringWithFormat:@"交易时间：%@",_tradeTime];
    merchantTitleLabel.text = @"商户信息";
    merchantNumberLabel.text = [NSString stringWithFormat:@"编       号   %@",_merchantNumber];
    agentIDLabel.text = [NSString stringWithFormat:@"代理商ID   %@",_agentID];
    merchantIDLabel.text = [NSString stringWithFormat:@"商 户  ID   %@",_merchantName];
    bankLabel.text = @"银行信息";
    terminalLabel.text = [NSString stringWithFormat:@"终   端   号   %@",_terminalNumber];
    switch (_tradeType) {
        case TradeTypeTransfer:
            payFromLabel.text = [NSString stringWithFormat:@"付 款 账 号   %@",_payFromAccount];
            payToLabel.text = [NSString stringWithFormat:@"收 款 账 号   %@",_payToAccount];
            break;
        case TradeTypeConsume:
            payFromLabel.text = [NSString stringWithFormat:@"结 算 时 间   %@",_payedTime];
            payToLabel.text = [NSString stringWithFormat:@"手   续   费   %@",_tradePoundage];
            break;
        case TradeTypeRepayment:
            payFromLabel.text = [NSString stringWithFormat:@"付 款 账 号   %@",_payFromAccount];
            payToLabel.text = [NSString stringWithFormat:@"转 入 账 号   %@",_payToAccount];
            break;
        case TradeTypeLife:
            payFromLabel.text = [NSString stringWithFormat:@"账   户   名   %@",_accountName];
            payToLabel.text = [NSString stringWithFormat:@"账 户 号 码   %@",_accountNumber];
            break;
        case TradeTypeTelephoneFare:
            payFromLabel.text = [NSString stringWithFormat:@"手 机 号 码   %@",_phoneNumber];
            break;
        default:
            break;
    }
    channelLabel.text = [NSString stringWithFormat:@"支 付 通 道   %@",_channelName];
    profitLabel.text = [NSString stringWithFormat:@"分 润 金 额   %@",_profitPrice];
    tradeMoneyLabel.text = [NSString stringWithFormat:@"交 易 金 额   %@",_tradeAmount];
    timeLabel.text = [NSString stringWithFormat:@"交 易 时 间   %@",_tradeTime];
    tradeStatusLabel.text = [NSString stringWithFormat:@"交 易 状 态   %@",[self statusForIndexString:_tradeStatus]];
    batchLabel.text = [NSString stringWithFormat:@"交易批次号   %@",_batchNumber];
    tradeNumberLabel.text = [NSString stringWithFormat:@"交易流水号   %@",_tradeNumber];
    payBankLabel.text = @"付款银行号";


}

#pragma mark - Layout

- (void)setLabel:(UILabel *)label
     withTopView:(UIView *)topView
     middleSpace:(CGFloat)space
        labelTag:(int)LabelTag{
    CGFloat leftSpace = 50.f;
    CGFloat rightSpce = 20.f;
    CGFloat labelHeight = 30.f;
    CGFloat leftSpace2 = 820.f;
    label.translatesAutoresizingMaskIntoConstraints = NO;
    label.backgroundColor = [UIColor clearColor];
    label.font = [UIFont systemFontOfSize:16.f];
    label.textColor = kColor(52, 52, 52, 1.0);
    [_scrollView addSubview:label];
    if (LabelTag == 1) {
        [self.view addConstraint:[NSLayoutConstraint constraintWithItem:label
                                                              attribute:NSLayoutAttributeTop
                                                              relatedBy:NSLayoutRelationEqual
                                                                 toItem:topView
                                                              attribute:NSLayoutAttributeBottom
                                                             multiplier:1.0
                                                               constant:space * 3]];
        [self.view addConstraint:[NSLayoutConstraint constraintWithItem:label
                                                              attribute:NSLayoutAttributeLeft
                                                              relatedBy:NSLayoutRelationEqual
                                                                 toItem:self.view
                                                              attribute:NSLayoutAttributeLeft
                                                             multiplier:1.0
                                                               constant:leftSpace2]];
        [self.view addConstraint:[NSLayoutConstraint constraintWithItem:label
                                                              attribute:NSLayoutAttributeRight
                                                              relatedBy:NSLayoutRelationEqual
                                                                 toItem:self.view
                                                              attribute:NSLayoutAttributeRight
                                                             multiplier:1.0
                                                               constant:rightSpce * 2]];
        [self.view addConstraint:[NSLayoutConstraint constraintWithItem:label
                                                              attribute:NSLayoutAttributeHeight
                                                              relatedBy:NSLayoutRelationEqual
                                                                 toItem:nil
                                                              attribute:NSLayoutAttributeNotAnAttribute
                                                             multiplier:1.0
                                                               constant:labelHeight]];

    }
    if (LabelTag == 2) {
        [self.view addConstraint:[NSLayoutConstraint constraintWithItem:label
                                                              attribute:NSLayoutAttributeTop
                                                              relatedBy:NSLayoutRelationEqual
                                                                 toItem:topView
                                                              attribute:NSLayoutAttributeBottom
                                                             multiplier:1.0
                                                               constant:space * 3]];
        [self.view addConstraint:[NSLayoutConstraint constraintWithItem:label
                                                              attribute:NSLayoutAttributeLeft
                                                              relatedBy:NSLayoutRelationEqual
                                                                 toItem:self.view
                                                              attribute:NSLayoutAttributeLeft
                                                             multiplier:1.0
                                                               constant:leftSpace2 + 20]];
        [self.view addConstraint:[NSLayoutConstraint constraintWithItem:label
                                                              attribute:NSLayoutAttributeRight
                                                              relatedBy:NSLayoutRelationEqual
                                                                 toItem:self.view
                                                              attribute:NSLayoutAttributeRight
                                                             multiplier:1.0
                                                               constant:rightSpce * 2]];
        [self.view addConstraint:[NSLayoutConstraint constraintWithItem:label
                                                              attribute:NSLayoutAttributeHeight
                                                              relatedBy:NSLayoutRelationEqual
                                                                 toItem:nil
                                                              attribute:NSLayoutAttributeNotAnAttribute
                                                             multiplier:1.0
                                                               constant:labelHeight]];
    }
    
    if (LabelTag == 3) {
        [self.view addConstraint:[NSLayoutConstraint constraintWithItem:label
                                                              attribute:NSLayoutAttributeTop
                                                              relatedBy:NSLayoutRelationEqual
                                                                 toItem:topView
                                                              attribute:NSLayoutAttributeBottom
                                                             multiplier:1.0
                                                               constant:space * 3]];
        [self.view addConstraint:[NSLayoutConstraint constraintWithItem:label
                                                              attribute:NSLayoutAttributeLeft
                                                              relatedBy:NSLayoutRelationEqual
                                                                 toItem:self.view
                                                              attribute:NSLayoutAttributeLeft
                                                             multiplier:1.0
                                                               constant:leftSpace2 - 100]];
        [self.view addConstraint:[NSLayoutConstraint constraintWithItem:label
                                                              attribute:NSLayoutAttributeRight
                                                              relatedBy:NSLayoutRelationEqual
                                                                 toItem:self.view
                                                              attribute:NSLayoutAttributeRight
                                                             multiplier:1.0
                                                               constant:rightSpce * 2]];
        [self.view addConstraint:[NSLayoutConstraint constraintWithItem:label
                                                              attribute:NSLayoutAttributeHeight
                                                              relatedBy:NSLayoutRelationEqual
                                                                 toItem:nil
                                                              attribute:NSLayoutAttributeNotAnAttribute
                                                             multiplier:1.0
                                                               constant:labelHeight]];
    }
    
    if (LabelTag==0){
        
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
                                                             toItem:self.view
                                                          attribute:NSLayoutAttributeLeft
                                                         multiplier:1.0
                                                           constant:leftSpace]];
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
    
}


#pragma mark - Request

- (void)downloadTradeDetail {
    AppDelegate *delegate = [AppDelegate shareAppDelegate];
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
    hud.labelText = @"加载中...";
 
    [NetworkInterface getTradeDetailWithToken:delegate.token tradeType:_tradeType  tradeID:_tradeID finished:^(BOOL success, NSData *response)
    {
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
                    [self parseDetailDataWithDictionary:object];
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

- (void)parseDetailDataWithDictionary:(NSDictionary *)dict {
    if (![dict objectForKey:@"result"] || ![[dict objectForKey:@"result"] isKindOfClass:[NSDictionary class]]) {
        return;
    }
    NSDictionary *infoDict = [dict objectForKey:@"result"];
    NSLog(@"%@",infoDict);
    if ([[infoDict allKeys] count] <= 0) {
        return;
    }
    _tradeStatus = [NSString stringWithFormat:@"%@",[infoDict objectForKey:@"tradedStatus"]];
    _tradeAmount = [NSString stringWithFormat:@"%@",[infoDict objectForKey:@"amount"]];
    _tradePoundage = [NSString stringWithFormat:@"%@",[infoDict objectForKey:@"poundage"]];
    _tradeTime = [NSString stringWithFormat:@"%@",[infoDict objectForKey:@"tradedTimeStr"]];
    _merchantNumber = [NSString stringWithFormat:@"%@",[infoDict objectForKey:@"merchantNumber"]];
    _merchantName = [NSString stringWithFormat:@"%@",[infoDict objectForKey:@"merchantName"]];
    _agentID = [NSString stringWithFormat:@"%@",[infoDict objectForKey:@"agentId"]];
    _terminalNumber = [NSString stringWithFormat:@"%@",[infoDict objectForKey:@"terminalNumber"]];
    _payFromAccount = [NSString stringWithFormat:@"%@",[infoDict objectForKey:@"payFromAccount"]];
    _payToAccount = [NSString stringWithFormat:@"%@",[infoDict objectForKey:@"payIntoAccount"]];
    _channelName = [NSString stringWithFormat:@"%@",[infoDict objectForKey:@"payChannelName"]];
    _profitPrice = [NSString stringWithFormat:@"%@",[infoDict objectForKey:@"profitPrice"]];
    _batchNumber = [NSString stringWithFormat:@"%@",[infoDict objectForKey:@"batchNumber"]];
    _tradeNumber = [NSString stringWithFormat:@"%@",[infoDict objectForKey:@"tradeNumber"]];
    _payedTime = [NSString stringWithFormat:@"%@",[infoDict objectForKey:@"payedTimeStr"]];
    _accountName = [NSString stringWithFormat:@"%@",[infoDict objectForKey:@"account_name"]];
    _accountNumber = [NSString stringWithFormat:@"%@",[infoDict objectForKey:@"account_number"]];
    _phoneNumber = [NSString stringWithFormat:@"%@",[infoDict objectForKey:@"phone"]];
    [self initSubViews];
}

- (NSString *)statusForIndexString:(NSString *)indexString {
    NSString *tradeStatus = nil;
    int index = [indexString intValue];
    switch (index) {
        case TradeStatusUnPaid:
            tradeStatus = @"未付款";
            break;
        case TradeStatusFinish:
            tradeStatus = @"交易完成";
            break;
        case TradeStatusFail:
            tradeStatus = @"交易失败";
            break;
        default:
            break;
    }
    return tradeStatus;
}


@end
