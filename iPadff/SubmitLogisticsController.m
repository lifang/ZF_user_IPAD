//
//  SubmitLogisticsController.m
//  iPadff
//
//  Created by 黄含章 on 15/3/16.
//  Copyright (c) 2015年 LanTaiPro. All rights reserved.
//

#import "SubmitLogisticsController.h"

@interface SubmitLogisticsController ()<UITextFieldDelegate>

@property(nonatomic,strong)UITextField *logisticsCompanyField;
@property(nonatomic,strong)UITextField *logisticsNumField;

@end

@implementation SubmitLogisticsController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = kColor(144, 144, 144, 0.7);
    [self initUI];
}

-(void)initUI
{
    //添加其它终端View
    UIView *submitLogisticsView = [[UIView alloc]init];
    submitLogisticsView.frame = CGRectMake(300, 140, 450, 320);
    submitLogisticsView.backgroundColor = [UIColor whiteColor];
    
    UIButton *exitBtn = [[UIButton alloc]init];
    [exitBtn setBackgroundImage:[UIImage imageNamed:@"X_black"] forState:UIControlStateNormal];
    [exitBtn addTarget:self action:@selector(exitClick) forControlEvents:UIControlEventTouchUpInside];
    exitBtn.frame = CGRectMake(10, 15, 25, 25);
    [submitLogisticsView addSubview:exitBtn];
    
    UILabel *addLabel = [[UILabel alloc]init];
    addLabel.text = @"提交物流信息";
    addLabel.font = [UIFont boldSystemFontOfSize:22];
    addLabel.tintColor = [UIColor blackColor];
    addLabel.frame = CGRectMake(submitLogisticsView.frame.origin.x - 140, 15, 200, 25);
    [submitLogisticsView addSubview:addLabel];
    
    UIView *line = [[UIView alloc]init];
    line.backgroundColor = [UIColor blackColor];
    line.frame = CGRectMake(0, CGRectGetMaxY(addLabel.frame) + 10,submitLogisticsView.frame.size.width , 0.7);
    [submitLogisticsView addSubview:line];
    
    UILabel *firstLabel = [[UILabel alloc]init];
    firstLabel.text = @"物流公司";
    firstLabel.font = [UIFont boldSystemFontOfSize:20];
    firstLabel.frame = CGRectMake(40, CGRectGetMaxY(line.frame) + 30, 80, 40);
    [submitLogisticsView addSubview:firstLabel];
    
    UILabel *secondLabel = [[UILabel alloc]init];
    secondLabel.text = @"物流单号";
    secondLabel.font = [UIFont boldSystemFontOfSize:20];
    secondLabel.frame = CGRectMake(40, CGRectGetMaxY(firstLabel.frame) + 20, 80, 40);
    [submitLogisticsView addSubview:secondLabel];
    
    _logisticsCompanyField = [[UITextField alloc]init];
    _logisticsCompanyField.userInteractionEnabled = YES;
    _logisticsCompanyField.placeholder = @"";
    [_logisticsCompanyField setValue:[UIFont systemFontOfSize:20] forKeyPath:@"_placeholderLabel.font"];
    _logisticsCompanyField.leftViewMode = UITextFieldViewModeAlways;
    UIView *v = [[UIView alloc]init];
    v.frame = CGRectMake(0, 0, 10, 40);
    _logisticsCompanyField.leftView = v;
    _logisticsCompanyField.frame = CGRectMake(CGRectGetMaxX(firstLabel.frame) + 20, firstLabel.frame.origin.y, 240, 40);
    _logisticsCompanyField.borderStyle = UITextBorderStyleLine;
    CALayer *readBtnLayer = [_logisticsCompanyField layer];
    [readBtnLayer setMasksToBounds:YES];
    [readBtnLayer setCornerRadius:2.0];
    [readBtnLayer setBorderWidth:1.0];
    [readBtnLayer setBorderColor:[kColor(163, 163, 163, 1.0) CGColor]];
    [submitLogisticsView addSubview:_logisticsCompanyField];
    
    _logisticsNumField = [[UITextField alloc]init];
    _logisticsNumField.leftViewMode = UITextFieldViewModeAlways;
    UIView *v1 = [[UIView alloc]init];
    v1.frame = CGRectMake(0, 0, 10, 40);
    _logisticsNumField.leftView = v1;
    _logisticsNumField.frame = CGRectMake(CGRectGetMaxX(firstLabel.frame) + 20, secondLabel.frame.origin.y, 240, 40);
    _logisticsNumField.borderStyle = UITextBorderStyleLine;
    CALayer *readBtnLayer1 = [_logisticsNumField layer];
    [readBtnLayer1 setMasksToBounds:YES];
    [readBtnLayer1 setCornerRadius:2.0];
    [readBtnLayer1 setBorderWidth:1.0];
    [readBtnLayer1 setBorderColor:[kColor(163, 163, 163, 1.0) CGColor]];
    [submitLogisticsView addSubview:_logisticsNumField];
    
    UIButton *submitBtn = [[UIButton alloc]init];
    [submitBtn setBackgroundColor:kColor(241, 81, 8, 1.0)];
    [submitBtn setTitle:@"保存" forState:UIControlStateNormal];
    [submitBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [submitBtn addTarget:self action:@selector(submitClick) forControlEvents:UIControlEventTouchUpInside];
    submitBtn.frame = CGRectMake(_logisticsNumField.frame.origin.x + 30, CGRectGetMaxY(_logisticsNumField.frame) + 50, 120, 40);
    [submitLogisticsView addSubview:submitBtn];
    
    [self.view addSubview:submitLogisticsView];

}

-(void)exitClick
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

-(void)submitClick
{
    //保存
    if (!_logisticsCompanyField.text || [_logisticsCompanyField.text isEqualToString:@""]) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示信息"
                                                        message:@"请填写物流公司"
                                                       delegate:nil
                                              cancelButtonTitle:@"确定"
                                              otherButtonTitles:nil];
        [alert show];
        return;
    }
    if (!_logisticsNumField.text || [_logisticsNumField.text isEqualToString:@""]) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示信息"
                                                        message:@"请填写物流单号"
                                                       delegate:nil
                                              cancelButtonTitle:@"确定"
                                              otherButtonTitles:nil];
        [alert show];
        return;
    }
    
    [self dismissViewControllerAnimated:YES completion:^{
        [self.SubmitLogisticsClickWithDataDelegate SubmitLogisticsClickedWithName:_logisticsCompanyField.text AndNum:_logisticsNumField.text];
    }];
}


@end
