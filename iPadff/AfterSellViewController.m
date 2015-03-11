//
//  AfterSellViewController.m
//  iPadff
//
//  Created by 黄含章 on 15/3/11.
//  Copyright (c) 2015年 LanTaiPro. All rights reserved.
//

#import "AfterSellViewController.h"

@interface AfterSellViewController ()

@property(nonatomic,strong)UIButton *serviceBtn;

@property(nonatomic,strong)UIButton *cancelBtn;

@property(nonatomic,strong)UIButton *salesReturnBtn;

@property(nonatomic,strong)UIButton *changeBtn;

@property(nonatomic,strong)UIButton *updateDataBtn;

@property(nonatomic,strong)UIButton *alterationBtn;

@property(nonatomic,assign)BOOL isChecked;

@property(nonatomic,assign)CGFloat serviceBtnX;
@property(nonatomic,assign)CGFloat serviceBtnY;
@property(nonatomic,assign)CGFloat cancelBtnX;
@property(nonatomic,assign)CGFloat salesReturnBtnX;
@property(nonatomic,assign)CGFloat changeBtnX;
@property(nonatomic,assign)CGFloat updateDataBtnX;
@property(nonatomic,assign)CGFloat alterationBtnX;

@property(nonatomic,assign)int buttonIndex;

@end

@implementation AfterSellViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = kColor(251, 251, 251, 1.0);
    self.buttonIndex = 1;
    [self setLeftViewWith:ChooseViewAfterSell];
    [self setupHeaderView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark 创建顶部5个BTN View
-(void)setupHeaderView
{
    //创建头部View
    UIView *headerView = [[UIView alloc]init];
    headerView.backgroundColor = kColor(226, 226, 226, 1.0);
    headerView.frame = CGRectMake(160, 0, SCREEN_WIDTH - 160.f, 80);
    if (iOS7) {
        headerView.frame = CGRectMake(160, 0, SCREEN_HEIGHT - 160.f, 80);
    }
    //创建头部按钮
    UIButton *serviceBtn = [[UIButton alloc]init];
    self.isChecked = YES;
    self.serviceBtn = serviceBtn;
    serviceBtn.tag = 20001;
    [serviceBtn addTarget:self action:@selector(btnClicked:) forControlEvents:UIControlEventTouchUpInside];
    serviceBtn.backgroundColor = [UIColor clearColor];
    [serviceBtn setBackgroundImage:[UIImage imageNamed:@"chose_Btn"] forState:UIControlStateNormal];
    serviceBtn.titleLabel.font = [UIFont systemFontOfSize:20];
    [serviceBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [serviceBtn setTitle:@"维修" forState:UIControlStateNormal];
    serviceBtn.frame = CGRectMake(headerView.frame.size.width * 0.05 , 40, 110, 40);
    self.serviceBtnX = serviceBtn.frame.origin.x;
    self.serviceBtnY = serviceBtn.frame.origin.y;
    [headerView addSubview:serviceBtn];
    
    UIButton *cancelBtn = [[UIButton alloc]init];
    self.cancelBtn = cancelBtn;
    cancelBtn.tag = 20002;
    [cancelBtn addTarget:self action:@selector(btnClicked:) forControlEvents:UIControlEventTouchUpInside];
    cancelBtn.backgroundColor = [UIColor clearColor];
    cancelBtn.titleLabel.font = [UIFont systemFontOfSize:18];
    [cancelBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [cancelBtn setTitle:@"注销" forState:UIControlStateNormal];
    cancelBtn.frame = CGRectMake(CGRectGetMaxX(serviceBtn.frame), 45, 90, 36);
    self.cancelBtnX = cancelBtn.frame.origin.x;
    [headerView addSubview:cancelBtn];
    
    UIButton *salesReturnBtn = [[UIButton alloc]init];
    self.salesReturnBtn = salesReturnBtn;
    salesReturnBtn.tag = 20003;
    [salesReturnBtn addTarget:self action:@selector(btnClicked:) forControlEvents:UIControlEventTouchUpInside];
    salesReturnBtn.backgroundColor = [UIColor clearColor];
    salesReturnBtn.titleLabel.font = [UIFont systemFontOfSize:18];
    [salesReturnBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [salesReturnBtn setTitle:@"退货" forState:UIControlStateNormal];
    salesReturnBtn.frame = CGRectMake(CGRectGetMaxX(cancelBtn.frame), 45, 90, 36);
    self.salesReturnBtnX = salesReturnBtn.frame.origin.x;
    [headerView addSubview:salesReturnBtn];
    
    UIButton *changeBtn = [[UIButton alloc]init];
    self.changeBtn = changeBtn;
    changeBtn.tag = 20004;
    [changeBtn addTarget:self action:@selector(btnClicked:) forControlEvents:UIControlEventTouchUpInside];
    changeBtn.backgroundColor = [UIColor clearColor];
    changeBtn.titleLabel.font = [UIFont systemFontOfSize:18];
    [changeBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [changeBtn setTitle:@"换货" forState:UIControlStateNormal];
    changeBtn.frame = CGRectMake(CGRectGetMaxX(salesReturnBtn.frame), 45, 90, 36);
    self.changeBtnX = changeBtn.frame.origin.x;
    [headerView addSubview:changeBtn];
    
    UIButton *updateDataBtn = [[UIButton alloc]init];
    self.updateDataBtn = updateDataBtn;
    updateDataBtn.tag = 20005;
    [updateDataBtn addTarget:self action:@selector(btnClicked:) forControlEvents:UIControlEventTouchUpInside];
    updateDataBtn.backgroundColor = [UIColor clearColor];
    updateDataBtn.titleLabel.font = [UIFont systemFontOfSize:18];
    [updateDataBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [updateDataBtn setTitle:@"更新资料" forState:UIControlStateNormal];
    updateDataBtn.frame = CGRectMake(CGRectGetMaxX(changeBtn.frame), 45, 90, 36);
    self.updateDataBtnX = updateDataBtn.frame.origin.x;
    [headerView addSubview:updateDataBtn];
    
    UIButton *alterationBtn = [[UIButton alloc]init];
    self.alterationBtn = alterationBtn;
    alterationBtn.tag = 20006;
    [alterationBtn addTarget:self action:@selector(btnClicked:) forControlEvents:UIControlEventTouchUpInside];
    alterationBtn.backgroundColor = [UIColor clearColor];
    alterationBtn.titleLabel.font = [UIFont systemFontOfSize:18];
    [alterationBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [alterationBtn setTitle:@"租凭退还" forState:UIControlStateNormal];
    alterationBtn.frame = CGRectMake(CGRectGetMaxX(updateDataBtn.frame) + 18, 45, 90, 36);
    self.alterationBtnX = alterationBtn.frame.origin.x;
    [headerView addSubview:alterationBtn];
    
    [self.view addSubview:headerView];
}

#pragma mark 顶部BTN的点击切换
-(void)btnClicked:(UIButton *)button
{
    //维修
    if (button.tag == 20001) {
        if (_isChecked == YES) {
            //什么都不做
        }
        else{
            _buttonIndex = 1;
//            [self tradeTypeFromIndex:1];
//            [self downloadDataWithPage:1 isMore:NO];
            [_serviceBtn setBackgroundImage:[UIImage imageNamed:@"chose_Btn"] forState:UIControlStateNormal];
            _serviceBtn.titleLabel.font = [UIFont systemFontOfSize:20];
            _serviceBtn.frame = CGRectMake(_serviceBtnX, _serviceBtnY, 110, 40);
            
            [_cancelBtn setBackgroundImage:nil forState:UIControlStateNormal];
            _cancelBtn.titleLabel.font = [UIFont systemFontOfSize:18];
            _cancelBtn.frame = CGRectMake(_cancelBtnX + 4, _serviceBtnY + 5, 90, 36);
            
            [_salesReturnBtn setBackgroundImage:nil forState:UIControlStateNormal];
            _salesReturnBtn.titleLabel.font = [UIFont systemFontOfSize:18];
            _salesReturnBtn.frame = CGRectMake(_salesReturnBtnX + 4, _serviceBtnY + 5, 90, 36);
            
            [_changeBtn setBackgroundImage:nil forState:UIControlStateNormal];
            _changeBtn.titleLabel.font = [UIFont systemFontOfSize:18];
            _changeBtn.frame = CGRectMake(_changeBtnX + 4, _serviceBtnY + 5, 90, 36);
            
            [_updateDataBtn setBackgroundImage:nil forState:UIControlStateNormal];
            _updateDataBtn.titleLabel.font = [UIFont systemFontOfSize:18];
            _updateDataBtn.frame = CGRectMake(_updateDataBtnX + 4, _serviceBtnY + 5, 90, 36);
            
            [_alterationBtn setBackgroundImage:nil forState:UIControlStateNormal];
            _alterationBtn.titleLabel.font = [UIFont systemFontOfSize:18];
            _alterationBtn.frame = CGRectMake(_alterationBtnX + 4, _serviceBtnY + 5, 90, 36);
            
            _isChecked = YES;
        }
    }
    //注销
    if (button.tag == 20002) {
        _buttonIndex = 2;
        [_cancelBtn setBackgroundImage:[UIImage imageNamed:@"chose_Btn"] forState:UIControlStateNormal];
        _cancelBtn.titleLabel.font = [UIFont systemFontOfSize:20];
        _cancelBtn.frame = CGRectMake(_cancelBtnX - 10, _serviceBtnY, 110, 40);
        
        [_serviceBtn setBackgroundImage:nil forState:UIControlStateNormal];
        _serviceBtn.titleLabel.font = [UIFont systemFontOfSize:18];
        _serviceBtn.frame = CGRectMake(_serviceBtnX + 4, _serviceBtnY + 5, 90, 36);
        
        [_salesReturnBtn setBackgroundImage:nil forState:UIControlStateNormal];
        _salesReturnBtn.titleLabel.font = [UIFont systemFontOfSize:18];
        _salesReturnBtn.frame = CGRectMake(_salesReturnBtnX + 4, _serviceBtnY + 5, 90, 36);
        
        [_changeBtn setBackgroundImage:nil forState:UIControlStateNormal];
        _changeBtn.titleLabel.font = [UIFont systemFontOfSize:18];
        _changeBtn.frame = CGRectMake(_changeBtnX + 4, _serviceBtnY + 5, 90, 36);
        
        [_updateDataBtn setBackgroundImage:nil forState:UIControlStateNormal];
        _updateDataBtn.titleLabel.font = [UIFont systemFontOfSize:18];
        _updateDataBtn.frame = CGRectMake(_updateDataBtnX + 4, _serviceBtnY + 5, 90, 36);
        
        [_alterationBtn setBackgroundImage:nil forState:UIControlStateNormal];
        _alterationBtn.titleLabel.font = [UIFont systemFontOfSize:18];
        _alterationBtn.frame = CGRectMake(_alterationBtnX + 4, _serviceBtnY + 5, 90, 36);
        
        _isChecked = NO;
    }
    //退货
    if (button.tag == 20003) {
        _buttonIndex = 3;
        
        [_salesReturnBtn setBackgroundImage:[UIImage imageNamed:@"chose_Btn"] forState:UIControlStateNormal];
        _salesReturnBtn.titleLabel.font = [UIFont systemFontOfSize:20];
        _salesReturnBtn.frame = CGRectMake(_salesReturnBtnX - 10, _serviceBtnY, 110, 40);
        
        [_serviceBtn setBackgroundImage:nil forState:UIControlStateNormal];
        _serviceBtn.titleLabel.font = [UIFont systemFontOfSize:18];
        _serviceBtn.frame = CGRectMake(_serviceBtnX + 4, _serviceBtnY + 5, 90, 36);
        
        [_cancelBtn setBackgroundImage:nil forState:UIControlStateNormal];
        _cancelBtn.titleLabel.font = [UIFont systemFontOfSize:18];
        _cancelBtn.frame = CGRectMake(_cancelBtnX + 4, _serviceBtnY + 5, 90, 36);
        
        [_changeBtn setBackgroundImage:nil forState:UIControlStateNormal];
        _changeBtn.titleLabel.font = [UIFont systemFontOfSize:18];
        _changeBtn.frame = CGRectMake(_changeBtnX + 4, _serviceBtnY + 5, 90, 36);
        
        [_updateDataBtn setBackgroundImage:nil forState:UIControlStateNormal];
        _updateDataBtn.titleLabel.font = [UIFont systemFontOfSize:18];
        _updateDataBtn.frame = CGRectMake(_updateDataBtnX + 4, _serviceBtnY + 5, 90, 36);
        
        [_alterationBtn setBackgroundImage:nil forState:UIControlStateNormal];
        _alterationBtn.titleLabel.font = [UIFont systemFontOfSize:18];
        _alterationBtn.frame = CGRectMake(_alterationBtnX + 4, _serviceBtnY + 5, 90, 36);
        
        _isChecked = NO;
    }
    //换货
    if (button.tag == 20004) {
        _buttonIndex = 4;
        
        [_changeBtn setBackgroundImage:[UIImage imageNamed:@"chose_Btn"] forState:UIControlStateNormal];
        _changeBtn.titleLabel.font = [UIFont systemFontOfSize:20];
        _changeBtn.frame = CGRectMake(_changeBtnX - 10, _serviceBtnY, 110, 40);
        
        [_serviceBtn setBackgroundImage:nil forState:UIControlStateNormal];
        _serviceBtn.titleLabel.font = [UIFont systemFontOfSize:18];
        _serviceBtn.frame = CGRectMake(_serviceBtnX + 4, _serviceBtnY + 5, 90, 36);
        
        [_cancelBtn setBackgroundImage:nil forState:UIControlStateNormal];
        _cancelBtn.titleLabel.font = [UIFont systemFontOfSize:18];
        _cancelBtn.frame = CGRectMake(_cancelBtnX + 4, _serviceBtnY + 5, 90, 36);
        
        [_salesReturnBtn setBackgroundImage:nil forState:UIControlStateNormal];
        _salesReturnBtn.titleLabel.font = [UIFont systemFontOfSize:18];
        _salesReturnBtn.frame = CGRectMake(_salesReturnBtnX + 4, _serviceBtnY + 5, 90, 36);
        
        [_updateDataBtn setBackgroundImage:nil forState:UIControlStateNormal];
        _updateDataBtn.titleLabel.font = [UIFont systemFontOfSize:18];
        _updateDataBtn.frame = CGRectMake(_updateDataBtnX + 4, _serviceBtnY + 5, 90, 36);
        
        [_alterationBtn setBackgroundImage:nil forState:UIControlStateNormal];
        _alterationBtn.titleLabel.font = [UIFont systemFontOfSize:18];
        _alterationBtn.frame = CGRectMake(_alterationBtnX + 4, _serviceBtnY + 5, 90, 36);
        
        _isChecked = NO;
    }
    
    //换货
    if (button.tag == 20004) {
        _buttonIndex = 4;
        
        [_changeBtn setBackgroundImage:[UIImage imageNamed:@"chose_Btn"] forState:UIControlStateNormal];
        _changeBtn.titleLabel.font = [UIFont systemFontOfSize:20];
        _changeBtn.frame = CGRectMake(_changeBtnX - 10, _serviceBtnY, 110, 40);
        
        [_serviceBtn setBackgroundImage:nil forState:UIControlStateNormal];
        _serviceBtn.titleLabel.font = [UIFont systemFontOfSize:18];
        _serviceBtn.frame = CGRectMake(_serviceBtnX + 4, _serviceBtnY + 5, 90, 36);
        
        [_cancelBtn setBackgroundImage:nil forState:UIControlStateNormal];
        _cancelBtn.titleLabel.font = [UIFont systemFontOfSize:18];
        _cancelBtn.frame = CGRectMake(_cancelBtnX + 4, _serviceBtnY + 5, 90, 36);
        
        [_salesReturnBtn setBackgroundImage:nil forState:UIControlStateNormal];
        _salesReturnBtn.titleLabel.font = [UIFont systemFontOfSize:18];
        _salesReturnBtn.frame = CGRectMake(_salesReturnBtnX - 10, _serviceBtnY + 5, 90, 36);
        
        [_updateDataBtn setBackgroundImage:nil forState:UIControlStateNormal];
        _updateDataBtn.titleLabel.font = [UIFont systemFontOfSize:18];
        _updateDataBtn.frame = CGRectMake(_updateDataBtnX + 4, _serviceBtnY + 5, 90, 36);
        
        [_alterationBtn setBackgroundImage:nil forState:UIControlStateNormal];
        _alterationBtn.titleLabel.font = [UIFont systemFontOfSize:18];
        _alterationBtn.frame = CGRectMake(_alterationBtnX + 4, _serviceBtnY + 5, 90, 36);
        
        _isChecked = NO;
    }
    //更新资料
    if (button.tag == 20005) {
        _buttonIndex = 5;
        _isChecked = NO;
        [_updateDataBtn setBackgroundImage:[UIImage imageNamed:@"chose_Btn"] forState:UIControlStateNormal];
        _updateDataBtn.titleLabel.font = [UIFont systemFontOfSize:20];
        _updateDataBtn.frame = CGRectMake(_updateDataBtnX - 10, _serviceBtnY, 110, 40);
        
        [_serviceBtn setBackgroundImage:nil forState:UIControlStateNormal];
        _serviceBtn.titleLabel.font = [UIFont systemFontOfSize:18];
        _serviceBtn.frame = CGRectMake(_serviceBtnX + 4, _serviceBtnY + 5, 90, 36);
        
        [_cancelBtn setBackgroundImage:nil forState:UIControlStateNormal];
        _cancelBtn.titleLabel.font = [UIFont systemFontOfSize:18];
        _cancelBtn.frame = CGRectMake(_cancelBtnX + 4, _serviceBtnY + 5, 90, 36);
        
        [_salesReturnBtn setBackgroundImage:nil forState:UIControlStateNormal];
        _salesReturnBtn.titleLabel.font = [UIFont systemFontOfSize:18];
        _salesReturnBtn.frame = CGRectMake(_salesReturnBtnX + 4, _serviceBtnY + 5, 90, 36);
        
        [_changeBtn setBackgroundImage:nil forState:UIControlStateNormal];
        _changeBtn.titleLabel.font = [UIFont systemFontOfSize:18];
        _changeBtn.frame = CGRectMake(_changeBtnX + 4, _serviceBtnY + 5, 90, 36);
        
        [_alterationBtn setBackgroundImage:nil forState:UIControlStateNormal];
        _alterationBtn.titleLabel.font = [UIFont systemFontOfSize:18];
        _alterationBtn.frame = CGRectMake(_alterationBtnX + 4, _serviceBtnY + 5, 90, 36);
    }
    
    //租凭退还
    if (button.tag == 20006) {
        _buttonIndex = 6;
        _isChecked = NO;
        [_alterationBtn setBackgroundImage:[UIImage imageNamed:@"chose_Btn"] forState:UIControlStateNormal];
        _alterationBtn.titleLabel.font = [UIFont systemFontOfSize:20];
        _alterationBtn.frame = CGRectMake(_alterationBtnX - 10, _serviceBtnY, 110, 40);
        
        [_serviceBtn setBackgroundImage:nil forState:UIControlStateNormal];
        _serviceBtn.titleLabel.font = [UIFont systemFontOfSize:18];
        _serviceBtn.frame = CGRectMake(_serviceBtnX + 4, _serviceBtnY + 5, 90, 36);
        
        [_cancelBtn setBackgroundImage:nil forState:UIControlStateNormal];
        _cancelBtn.titleLabel.font = [UIFont systemFontOfSize:18];
        _cancelBtn.frame = CGRectMake(_cancelBtnX + 4, _serviceBtnY + 5, 90, 36);
        
        [_salesReturnBtn setBackgroundImage:nil forState:UIControlStateNormal];
        _salesReturnBtn.titleLabel.font = [UIFont systemFontOfSize:18];
        _salesReturnBtn.frame = CGRectMake(_salesReturnBtnX + 4, _serviceBtnY + 5, 90, 36);
        
        [_changeBtn setBackgroundImage:nil forState:UIControlStateNormal];
        _changeBtn.titleLabel.font = [UIFont systemFontOfSize:18];
        _changeBtn.frame = CGRectMake(_changeBtnX + 4, _serviceBtnY + 5, 90, 36);
        
        [_updateDataBtn setBackgroundImage:nil forState:UIControlStateNormal];
        _updateDataBtn.titleLabel.font = [UIFont systemFontOfSize:18];
        _updateDataBtn.frame = CGRectMake(_updateDataBtnX + 4, _serviceBtnY + 5, 90, 36);
    }
    
}



@end
