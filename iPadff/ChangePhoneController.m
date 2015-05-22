//
//  ChangePhoneController.m
//  iPadff
//
//  Created by 黄含章 on 15/3/17.
//  Copyright (c) 2015年 LanTaiPro. All rights reserved.
//

#import "ChangePhoneController.h"
#import "ChangePhoneSuccessViewController.h"
#import "NetworkInterface.h"
#import "RegularFormat.h"
#import "ChangePhoneNextController.h"

@interface ChangePhoneController ()<UITextFieldDelegate>

@property(nonatomic,strong)UITextField *newsPhoneField;

@property(nonatomic,strong)UITextField *authCodeField;

@property(nonatomic,strong)UITextField *oldPhoneField;

@property(nonatomic,strong)UITextField *newsAuthCodeField;

@property(nonatomic,strong)UIButton *getAuthCode;

@property(nonatomic,assign)BOOL isOldAuth;
@property(nonatomic,assign)BOOL isNewAuth;

@property(nonatomic,strong)NSString *authCode;


@property(nonatomic,strong)UILabel *makeSureWrongLabel;

@property(nonatomic,strong)UIButton *makeSureBtn;

@property(nonatomic,assign)BOOL isChecked;

@end

@implementation ChangePhoneController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.edgesForExtendedLayout = UIRectEdgeAll;
    NSDictionary *attributes = [NSDictionary dictionaryWithObjectsAndKeys:[UIColor whiteColor],NSForegroundColorAttributeName,[UIFont boldSystemFontOfSize:22],NSFontAttributeName, nil];
    [self.navigationController.navigationBar setTitleTextAttributes:attributes];
    [self sendMobileValidate];
    [self initAndLayoutUI];
    
//    [self getAuthCodeClicked];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)initAndLayoutUI
{
    self.view.backgroundColor = [UIColor whiteColor];
    self.title = @"修改手机";
    
    CGFloat mainWidth = 280.f;
    CGFloat mainHeight = 40.f;
    
    UILabel *oldPhoneLabel = [[UILabel alloc]init];
    oldPhoneLabel.hidden = YES;
    oldPhoneLabel.text = @"原 手 机 号";
    [self setLabel:oldPhoneLabel withTopView:self.view middleSpace:120.f labelTag:1];
    
    UILabel *authCodeLabel = [[UILabel alloc]init];
    authCodeLabel.hidden = YES;
    authCodeLabel.text = @"原 验 证 码";
    [self setLabel:authCodeLabel withTopView:oldPhoneLabel middleSpace:30.f labelTag:2];
    
    UILabel *newPhoneLabel = [[UILabel alloc]init];
    newPhoneLabel.text = @"原 手 机 号";
    [self setLabel:newPhoneLabel withTopView:self.view middleSpace:120.f labelTag:1];
    
    UILabel *newCodeLabel = [[UILabel alloc]init];
    newCodeLabel.text = @"原 验 证 码";
    [self setLabel:newCodeLabel withTopView:newPhoneLabel middleSpace:30.f labelTag:2];
    
    _oldPhoneField = [[UITextField alloc]init];
    _oldPhoneField.userInteractionEnabled = NO;
    _oldPhoneField.translatesAutoresizingMaskIntoConstraints = NO;
    _oldPhoneField.borderStyle = UITextBorderStyleNone;
    _oldPhoneField.clearButtonMode = UITextFieldViewModeWhileEditing;
    _oldPhoneField.text = _oldPhoneNum;
    _oldPhoneField.font = [UIFont systemFontOfSize:20];
    //    _newsPhoneField.placeholder = @"13919022222";
    //    [_oldPhoneField setValue:[UIFont systemFontOfSize:20] forKeyPath:@"_placeholderLabel.font"];
    _oldPhoneField.delegate = self;
    _oldPhoneField.leftViewMode = UITextFieldViewModeAlways;
    UIView *placeholderV2 = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 15, 10)];
    _oldPhoneField.leftView = placeholderV2;
    [self.view addSubview:_oldPhoneField];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:_oldPhoneField
                                                          attribute:NSLayoutAttributeTop
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:self.view
                                                          attribute:NSLayoutAttributeTop
                                                         multiplier:1.0
                                                           constant:115.f]];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:_oldPhoneField
                                                          attribute:NSLayoutAttributeLeft
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:oldPhoneLabel
                                                          attribute:NSLayoutAttributeLeft
                                                         multiplier:1.0
                                                           constant:120.f]];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:_oldPhoneField
                                                          attribute:NSLayoutAttributeWidth
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:nil
                                                          attribute:NSLayoutAttributeNotAnAttribute
                                                         multiplier:1.0
                                                           constant:mainWidth * 0.6]];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:_oldPhoneField
                                                          attribute:NSLayoutAttributeHeight
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:nil
                                                          attribute:NSLayoutAttributeNotAnAttribute
                                                         multiplier:1.0
                                                           constant:mainHeight]];

    
    _authCodeField = [[UITextField alloc]init];
    _authCodeField.hidden = YES;
    _authCodeField.translatesAutoresizingMaskIntoConstraints = NO;
    _authCodeField.borderStyle = UITextBorderStyleLine;
    _authCodeField.clearButtonMode = UITextFieldViewModeWhileEditing;
    _authCodeField.placeholder = @"请输入旧验证码";
    [_authCodeField setValue:[UIFont systemFontOfSize:20] forKeyPath:@"_placeholderLabel.font"];
    _authCodeField.delegate = self;
    _authCodeField.leftViewMode = UITextFieldViewModeAlways;
    UIView *placeholderV3 = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 15, 10)];
    _authCodeField.leftView = placeholderV3;
    _authCodeField.rightViewMode = UITextFieldViewModeAlways;
    CALayer *readBtnLayer3 = [_authCodeField layer];
    [readBtnLayer3 setMasksToBounds:YES];
    [readBtnLayer3 setCornerRadius:2.0];
    [readBtnLayer3 setBorderWidth:1.0];
    [readBtnLayer3 setBorderColor:[kColor(163, 163, 163, 1.0) CGColor]];
    [self.view addSubview:_authCodeField];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:_authCodeField
                                                          attribute:NSLayoutAttributeTop
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:_oldPhoneField
                                                          attribute:NSLayoutAttributeBottom
                                                         multiplier:1.0
                                                           constant:20.f]];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:_authCodeField
                                                          attribute:NSLayoutAttributeLeft
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:newPhoneLabel
                                                          attribute:NSLayoutAttributeLeft
                                                         multiplier:1.0
                                                           constant:120.f]];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:_authCodeField
                                                          attribute:NSLayoutAttributeWidth
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:nil
                                                          attribute:NSLayoutAttributeNotAnAttribute
                                                         multiplier:1.0
                                                           constant:mainWidth]];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:_authCodeField
                                                          attribute:NSLayoutAttributeHeight
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:nil
                                                          attribute:NSLayoutAttributeNotAnAttribute
                                                         multiplier:1.0
                                                           constant:mainHeight]];
    
    _newsPhoneField = [[UITextField alloc]init];
    _newsPhoneField.hidden = YES;
    _newsPhoneField.translatesAutoresizingMaskIntoConstraints = NO;
    _newsPhoneField.borderStyle = UITextBorderStyleLine;
    _newsPhoneField.clearButtonMode = UITextFieldViewModeWhileEditing;
    _newsPhoneField.placeholder = @"请输入新手机号";
    [_newsPhoneField setValue:[UIFont systemFontOfSize:20] forKeyPath:@"_placeholderLabel.font"];
    _newsPhoneField.delegate = self;
    _newsPhoneField.leftViewMode = UITextFieldViewModeAlways;
    UIView *placeholderV4 = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 15, 10)];
    _newsPhoneField.leftView = placeholderV4;
    _newsPhoneField.rightViewMode = UITextFieldViewModeAlways;
    CALayer *readBtnLayer4 = [_newsPhoneField layer];
    [readBtnLayer4 setMasksToBounds:YES];
    [readBtnLayer4 setCornerRadius:2.0];
    [readBtnLayer4 setBorderWidth:1.0];
    [readBtnLayer4 setBorderColor:[kColor(163, 163, 163, 1.0) CGColor]];
    [self.view addSubview:_newsPhoneField];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:_newsPhoneField
                                                          attribute:NSLayoutAttributeTop
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:self.view
                                                          attribute:NSLayoutAttributeTop
                                                         multiplier:1.0
                                                           constant:115.f]];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:_newsPhoneField
                                                          attribute:NSLayoutAttributeLeft
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:newPhoneLabel
                                                          attribute:NSLayoutAttributeLeft
                                                         multiplier:1.0
                                                           constant:120.f]];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:_newsPhoneField
                                                          attribute:NSLayoutAttributeWidth
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:nil
                                                          attribute:NSLayoutAttributeNotAnAttribute
                                                         multiplier:1.0
                                                           constant:mainWidth]];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:_newsPhoneField
                                                          attribute:NSLayoutAttributeHeight
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:nil
                                                          attribute:NSLayoutAttributeNotAnAttribute
                                                         multiplier:1.0
                                                           constant:mainHeight]];

    
    UIButton *makeSureBtn = [[UIButton alloc]init];
    makeSureBtn.hidden = YES;
    [makeSureBtn addTarget:self action:@selector(makeSureClieked) forControlEvents:UIControlEventTouchUpInside];
    makeSureBtn.translatesAutoresizingMaskIntoConstraints = NO;
    [makeSureBtn setBackgroundColor:kMainColor];
    [makeSureBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [makeSureBtn setTitle:@"检查" forState:UIControlStateNormal];
    [self.view addSubview:makeSureBtn];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:makeSureBtn
                                                          attribute:NSLayoutAttributeTop
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:_oldPhoneField
                                                          attribute:NSLayoutAttributeBottom
                                                         multiplier:1.0
                                                           constant:20.f]];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:makeSureBtn
                                                          attribute:NSLayoutAttributeLeft
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:_authCodeField
                                                          attribute:NSLayoutAttributeLeft
                                                         multiplier:1.0
                                                           constant:mainWidth + 20]];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:makeSureBtn
                                                          attribute:NSLayoutAttributeWidth
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:nil
                                                          attribute:NSLayoutAttributeNotAnAttribute
                                                         multiplier:1.0
                                                           constant:mainWidth * 0.4]];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:makeSureBtn
                                                          attribute:NSLayoutAttributeHeight
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:nil
                                                          attribute:NSLayoutAttributeNotAnAttribute
                                                         multiplier:1.0
                                                           constant:mainHeight]];
    
    _getAuthCode = [[UIButton alloc]init];
    [_getAuthCode addTarget:self action:@selector(getAuthCodeClicked) forControlEvents:UIControlEventTouchUpInside];
    _getAuthCode.translatesAutoresizingMaskIntoConstraints = NO;
    _getAuthCode.titleLabel.textAlignment = NSTextAlignmentLeft;
    [_getAuthCode setTitle:@"获取验证码" forState:UIControlStateNormal];
    [_getAuthCode setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [_getAuthCode setBackgroundColor:kMainColor];
    [self.view addSubview:_getAuthCode];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:_getAuthCode
                                                          attribute:NSLayoutAttributeTop
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:self.view
                                                          attribute:NSLayoutAttributeTop
                                                         multiplier:1.0
                                                           constant:115.f]];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:_getAuthCode
                                                          attribute:NSLayoutAttributeLeft
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:_newsPhoneField
                                                          attribute:NSLayoutAttributeRight
                                                         multiplier:1.0
                                                           constant:10.f]];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:_getAuthCode
                                                          attribute:NSLayoutAttributeWidth
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:nil
                                                          attribute:NSLayoutAttributeNotAnAttribute
                                                         multiplier:1.0
                                                           constant:mainWidth * 0.6]];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:_getAuthCode
                                                          attribute:NSLayoutAttributeHeight
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:nil
                                                          attribute:NSLayoutAttributeNotAnAttribute
                                                         multiplier:1.0
                                                           constant:mainHeight]];
    
    _newsAuthCodeField = [[UITextField alloc]init];
    _newsAuthCodeField.translatesAutoresizingMaskIntoConstraints = NO;
    _newsAuthCodeField.borderStyle = UITextBorderStyleLine;
    _newsAuthCodeField.clearButtonMode = UITextFieldViewModeWhileEditing;
    _newsAuthCodeField.placeholder = @"请输入原验证码";
    [_newsAuthCodeField setValue:[UIFont systemFontOfSize:20] forKeyPath:@"_placeholderLabel.font"];
    _newsAuthCodeField.delegate = self;
    _newsAuthCodeField.leftViewMode = UITextFieldViewModeAlways;
    UIView *placeholderV5 = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 15, 10)];
    _newsAuthCodeField.leftView = placeholderV5;
    _newsAuthCodeField.rightViewMode = UITextFieldViewModeAlways;
    CALayer *readBtnLayer5 = [_newsAuthCodeField layer];
    [readBtnLayer5 setMasksToBounds:YES];
    [readBtnLayer5 setCornerRadius:2.0];
    [readBtnLayer5 setBorderWidth:1.0];
    [readBtnLayer5 setBorderColor:[kColor(163, 163, 163, 1.0) CGColor]];
    [self.view addSubview:_newsAuthCodeField];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:_newsAuthCodeField
                                                          attribute:NSLayoutAttributeTop
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:_newsPhoneField
                                                          attribute:NSLayoutAttributeBottom
                                                         multiplier:1.0
                                                           constant:20.f]];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:_newsAuthCodeField
                                                          attribute:NSLayoutAttributeLeft
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:newPhoneLabel
                                                          attribute:NSLayoutAttributeLeft
                                                         multiplier:1.0
                                                           constant:120.f]];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:_newsAuthCodeField
                                                          attribute:NSLayoutAttributeWidth
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:nil
                                                          attribute:NSLayoutAttributeNotAnAttribute
                                                         multiplier:1.0
                                                           constant:mainWidth]];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:_newsAuthCodeField
                                                          attribute:NSLayoutAttributeHeight
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:nil
                                                          attribute:NSLayoutAttributeNotAnAttribute
                                                         multiplier:1.0
                                                           constant:mainHeight]];
    _makeSureBtn = [[UIButton alloc]init];
    _makeSureBtn.hidden = YES;
    [_makeSureBtn addTarget:self action:@selector(makeSureNewClieked) forControlEvents:UIControlEventTouchUpInside];
    _makeSureBtn.translatesAutoresizingMaskIntoConstraints = NO;
    [_makeSureBtn setBackgroundColor:kMainColor];
    [_makeSureBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [_makeSureBtn setTitle:@"检查" forState:UIControlStateNormal];
    [self.view addSubview:_makeSureBtn];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:_makeSureBtn
                                                          attribute:NSLayoutAttributeTop
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:_newsPhoneField
                                                          attribute:NSLayoutAttributeBottom
                                                         multiplier:1.0
                                                           constant:20.f]];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:_makeSureBtn
                                                          attribute:NSLayoutAttributeLeft
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:_authCodeField
                                                          attribute:NSLayoutAttributeLeft
                                                         multiplier:1.0
                                                           constant:mainWidth + 20]];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:_makeSureBtn
                                                          attribute:NSLayoutAttributeWidth
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:nil
                                                          attribute:NSLayoutAttributeNotAnAttribute
                                                         multiplier:1.0
                                                           constant:mainWidth * 0.4]];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:_makeSureBtn
                                                          attribute:NSLayoutAttributeHeight
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:nil
                                                          attribute:NSLayoutAttributeNotAnAttribute
                                                         multiplier:1.0
                                                           constant:mainHeight]];
    

    
    UIView *lineV = [[UIView alloc]init];
    lineV.translatesAutoresizingMaskIntoConstraints = NO;
    lineV.backgroundColor = kColor(220, 220, 220, 1.0);
    [self.view addSubview:lineV];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:lineV
                                                          attribute:NSLayoutAttributeTop
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:newCodeLabel
                                                          attribute:NSLayoutAttributeBottom
                                                         multiplier:1.0
                                                           constant:70.f]];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:lineV
                                                          attribute:NSLayoutAttributeLeft
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:self.view
                                                          attribute:NSLayoutAttributeLeft
                                                         multiplier:1.0
                                                           constant:40.f]];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:lineV
                                                          attribute:NSLayoutAttributeRight
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:self.view
                                                          attribute:NSLayoutAttributeRight
                                                         multiplier:1.0
                                                           constant:-40.f]];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:lineV
                                                          attribute:NSLayoutAttributeHeight
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:nil
                                                          attribute:NSLayoutAttributeNotAnAttribute
                                                         multiplier:1.0
                                                           constant:1.f]];
    UIButton *submitBtn = [[UIButton alloc]init];
    [submitBtn addTarget:self action:@selector(submitClicked) forControlEvents:UIControlEventTouchUpInside];
    submitBtn.translatesAutoresizingMaskIntoConstraints = NO;
    [submitBtn setBackgroundColor:kMainColor];
    [submitBtn setTitle:@"下一步" forState:UIControlStateNormal];
    [submitBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.view addSubview:submitBtn];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:submitBtn
                                                          attribute:NSLayoutAttributeTop
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:lineV
                                                          attribute:NSLayoutAttributeBottom
                                                         multiplier:1.0
                                                           constant:50.f]];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:submitBtn
                                                          attribute:NSLayoutAttributeLeft
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:authCodeLabel
                                                          attribute:NSLayoutAttributeRight
                                                         multiplier:1.0
                                                           constant:- 50.f]];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:submitBtn
                                                          attribute:NSLayoutAttributeWidth
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:nil
                                                          attribute:NSLayoutAttributeNotAnAttribute
                                                         multiplier:1.0
                                                           constant:mainWidth * 0.9]];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:submitBtn
                                                          attribute:NSLayoutAttributeHeight
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:nil
                                                          attribute:NSLayoutAttributeNotAnAttribute
                                                         multiplier:1.0
                                                           constant:mainHeight]];
}

- (void)setLabel:(UILabel *)label
     withTopView:(UIView *)topView
     middleSpace:(CGFloat)space
        labelTag:(int)LabelTag{
    CGFloat labelHeight = 30.f;
    CGFloat labelWidth = 200.f;
    CGFloat leftSpace = 260.f;
    label.translatesAutoresizingMaskIntoConstraints = NO;
    label.backgroundColor = [UIColor clearColor];
    label.font = [UIFont boldSystemFontOfSize:20.f];
    label.textColor = kColor(38, 38, 38, 1.0);
    [self.view addSubview:label];
    if (LabelTag == 2)
    {
        [self.view addConstraint:[NSLayoutConstraint constraintWithItem:label
                                                              attribute:NSLayoutAttributeTop
                                                              relatedBy:NSLayoutRelationEqual
                                                                 toItem:topView
                                                              attribute:NSLayoutAttributeBottom
                                                             multiplier:1.0
                                                               constant:space]];
    }else{
        [self.view addConstraint:[NSLayoutConstraint constraintWithItem:label
                                                              attribute:NSLayoutAttributeTop
                                                              relatedBy:NSLayoutRelationEqual
                                                                 toItem:topView
                                                              attribute:NSLayoutAttributeTop
                                                             multiplier:1.0
                                                               constant:space]];
    }
        [self.view addConstraint:[NSLayoutConstraint constraintWithItem:label
                                                              attribute:NSLayoutAttributeLeft
                                                              relatedBy:NSLayoutRelationEqual
                                                                 toItem:self.view
                                                              attribute:NSLayoutAttributeLeft
                                                             multiplier:1.0
                                                               constant:leftSpace]];
        [self.view addConstraint:[NSLayoutConstraint constraintWithItem:label
                                                              attribute:NSLayoutAttributeWidth
                                                              relatedBy:NSLayoutRelationEqual
                                                                 toItem:nil
                                                              attribute:NSLayoutAttributeNotAnAttribute
                                                             multiplier:1.0
                                                               constant:labelWidth]];
        [self.view addConstraint:[NSLayoutConstraint constraintWithItem:label
                                                              attribute:NSLayoutAttributeHeight
                                                              relatedBy:NSLayoutRelationEqual
                                                                 toItem:nil
                                                              attribute:NSLayoutAttributeNotAnAttribute
                                                             multiplier:1.0
                                                               constant:labelHeight]];
    
}

-(void)getAuthCodeClicked
{
    [self sendMobileValidate];
}

- (void)resetStatus {
    [self countDownStart];
}

-(void)makeSureNewClieked
{
    if (!_newsAuthCodeField.text || [_newsAuthCodeField.text isEqualToString:@""]) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示信息"
                                                        message:@"验证码不能为空!"
                                                       delegate:nil
                                              cancelButtonTitle:@"确定"
                                              otherButtonTitles:nil];
        [alert show];
        return;
    }
    if (![_newsAuthCodeField.text isEqualToString:_authCode]) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示信息"
                                                        message:@"验证码错误!"
                                                       delegate:nil
                                              cancelButtonTitle:@"确定"
                                              otherButtonTitles:nil];
        [alert show];
        
        UIView *rightBigV = [[UIView alloc]init];
        rightBigV.frame = CGRectMake(0, 0, 60, 40);
        UIImageView *rightV = [[UIImageView alloc]init];
        rightV.frame = CGRectMake(20, 8, 23, 23);
        rightV.image = kImageName(@"check_wrong");
        [rightBigV addSubview:rightV];
        _newsAuthCodeField.rightView = rightBigV;
        _isNewAuth = NO;
        return;
    }
    
    UIView *rightBigV = [[UIView alloc]init];
    rightBigV.frame = CGRectMake(0, 0, 60, 40);
    UIImageView *rightV = [[UIImageView alloc]init];
    rightV.frame = CGRectMake(20, 8, 23, 23);
    rightV.image = kImageName(@"check_right");
    [rightBigV addSubview:rightV];
    _newsAuthCodeField.rightView = rightBigV;
    _isNewAuth = YES;

}

-(void)makeSureClieked
{
    if (!_authCodeField.text || [_authCodeField.text isEqualToString:@""]) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示信息"
                                                        message:@"验证码不能为空!"
                                                       delegate:nil
                                              cancelButtonTitle:@"确定"
                                              otherButtonTitles:nil];
        [alert show];
        return;
    }
    if (![_authCodeField.text isEqualToString:_oldAuthCode]) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示信息"
                                                        message:@"验证码错误!"
                                                       delegate:nil
                                              cancelButtonTitle:@"确定"
                                              otherButtonTitles:nil];
        [alert show];
        
        UIView *rightBigV = [[UIView alloc]init];
        rightBigV.frame = CGRectMake(0, 0, 60, 40);
        UIImageView *rightV = [[UIImageView alloc]init];
        rightV.frame = CGRectMake(20, 8, 23, 23);
        rightV.image = kImageName(@"check_wrong");
        [rightBigV addSubview:rightV];
        _authCodeField.rightView = rightBigV;
        _isOldAuth = NO;
        return;
    }
    
    UIView *rightBigV = [[UIView alloc]init];
    rightBigV.frame = CGRectMake(0, 0, 60, 40);
    UIImageView *rightV = [[UIImageView alloc]init];
    rightV.frame = CGRectMake(20, 8, 23, 23);
    rightV.image = kImageName(@"check_right");
    [rightBigV addSubview:rightV];
    _authCodeField.rightView = rightBigV;
    _isOldAuth = YES;

}

-(void)submitClicked
{
    [_newsAuthCodeField resignFirstResponder];
    if (!_newsAuthCodeField.text || [_newsAuthCodeField.text isEqualToString:@""]) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示信息"
                                                        message:@"验证码不能为空!"
                                                       delegate:nil
                                              cancelButtonTitle:@"确定"
                                              otherButtonTitles:nil];
        [alert show];
        return;
    }
    if (![_newsAuthCodeField.text isEqualToString:_authCode]) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示信息"
                                                        message:@"验证码错误!"
                                                       delegate:nil
                                              cancelButtonTitle:@"确定"
                                              otherButtonTitles:nil];
        [alert show];
        return;
        
    }
    [self saveDate];
    
}

#pragma mark - Request
-(void)saveDate
{
    ChangePhoneNextController *changeNext = [[ChangePhoneNextController alloc]init];
    changeNext.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:changeNext animated:YES];
    
//    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
//    hud.labelText = @"提交中...";
//    AppDelegate *delegate = [AppDelegate shareAppDelegate];
//    [NetworkInterface modifyUserInfoWithToken:delegate.token userID:delegate.userID username:nil mobilePhone:_newsPhoneField.text email:nil cityID:nil finished:^(BOOL success, NSData *response) {
//        hud.customView = [[UIImageView alloc] init];
//        hud.mode = MBProgressHUDModeCustomView;
//        [hud hide:YES afterDelay:0.5f];
//        if (success) {
//            id object = [NSJSONSerialization JSONObjectWithData:response options:NSJSONReadingMutableLeaves error:nil];
//            if ([object isKindOfClass:[NSDictionary class]]) {
//                NSString *errorCode = [object objectForKey:@"code"];
//                if ([errorCode intValue] == RequestFail) {
//                    //返回错误代码
//                    hud.labelText = [NSString stringWithFormat:@"%@",[object objectForKey:@"message"]];
//                }
//                else if ([errorCode intValue] == RequestSuccess) {
//                [self.ChangePhoneSuccessDelegate ChangePhoneNumSuccessWithNewPhoneNum:_newsPhoneField.text];
//                //点击了提交
//                ChangePhoneSuccessViewController *changeSuccessVC = [[ChangePhoneSuccessViewController alloc]init];
//                changeSuccessVC.hidesBottomBarWhenPushed = YES;
//                [self.navigationController pushViewController:changeSuccessVC animated:YES];
//                }
//            }
//            else {
//                //返回错误数据
//                hud.labelText = kServiceReturnWrong;
//            }
//        }
//        else {
//            hud.labelText = kNetworkFailed;
//        }
//    }];
    
}


//倒计时
- (void)countDownStart {
    __block int timeout = 60; //倒计时时间
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_source_t _timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, queue);
    dispatch_source_set_timer(_timer,dispatch_walltime(NULL, 0),1.0 * NSEC_PER_SEC, 0); //每秒执行
    dispatch_source_set_event_handler(_timer, ^{
        if(timeout <= 0){
            //倒计时结束，关闭
            dispatch_source_cancel(_timer);
            dispatch_async(dispatch_get_main_queue(), ^{
                //UI更新
                _getAuthCode.userInteractionEnabled = YES;
                [_getAuthCode setTitle:@"获取验证码" forState:UIControlStateNormal];
                [_getAuthCode setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
                [_getAuthCode setBackgroundColor:kMainColor];
            });
        }
        else {
            dispatch_async(dispatch_get_main_queue(), ^{
                _getAuthCode.userInteractionEnabled = NO;
                NSString *title = [NSString stringWithFormat:@"%d秒后重新获取",timeout];
                [_getAuthCode setBackgroundColor:[UIColor lightGrayColor]];
                [_getAuthCode setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
                [_getAuthCode setTitle:title forState:UIControlStateNormal];
                
            });
            timeout--;
            
        }
    });
    dispatch_resume(_timer);
}

#pragma mark - Request

-(void)sendOldMobileValidate
{
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
    hud.labelText = @"正在获取旧手机验证码...";
    [NetworkInterface getModifyMobileValidateWithPhoneNumber:_oldPhoneNum finished:^(BOOL success, NSData *response) {
        NSLog(@"%@",[[NSString alloc] initWithData:response encoding:NSUTF8StringEncoding]);
        hud.customView = [[UIImageView alloc] init];
        hud.mode = MBProgressHUDModeCustomView;
        [hud hide:YES afterDelay:0.3f];
        if (success) {
            id object = [NSJSONSerialization JSONObjectWithData:response options:NSJSONReadingMutableLeaves error:nil];
            if ([object isKindOfClass:[NSDictionary class]]) {
                if ([[object objectForKey:@"code"] intValue] == RequestSuccess) {
                    [hud setHidden:YES];
                    NSString *authcode = [object objectForKey:@"result"];
                    self.oldAuthCode = authcode;
                }
                else {
                    hud.labelText = [NSString stringWithFormat:@"%@",[object objectForKey:@"message"]];
                }
            }
            else {
                hud.labelText = kServiceReturnWrong;
            }
        }
        else {
            hud.labelText = kNetworkFailed;
        }
    }];

}
//发送手机验证码
-(void)sendMobileValidate
{
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
    hud.labelText = @"正在发送...";
    [NetworkInterface getModifyMobileValidateWithPhoneNumber:_oldPhoneNum finished:^(BOOL success, NSData *response) {
        NSLog(@"%@",[[NSString alloc] initWithData:response encoding:NSUTF8StringEncoding]);
        hud.customView = [[UIImageView alloc] init];
        hud.mode = MBProgressHUDModeCustomView;
        [hud hide:YES afterDelay:0.3f];
        if (success) {
            id object = [NSJSONSerialization JSONObjectWithData:response options:NSJSONReadingMutableLeaves error:nil];
            if ([object isKindOfClass:[NSDictionary class]]) {
                if ([[object objectForKey:@"code"] intValue] == RequestSuccess) {
                    [hud setHidden:YES];
                    NSString *authcode = [object objectForKey:@"result"];
                    self.authCode = authcode;
                    [self resetStatus];
                }
                else {
                    hud.labelText = [NSString stringWithFormat:@"%@",[object objectForKey:@"message"]];
                }
            }
            else {
                hud.labelText = kServiceReturnWrong;
            }
        }
        else {
            hud.labelText = kNetworkFailed;
        }
    }];
    
}
-(void)textFieldDidEndEditing:(UITextField *)textField
{
    if (textField == _newsAuthCodeField) {
        if ([_newsAuthCodeField.text isEqualToString:_authCode]) {
            UIView *rightBigV = [[UIView alloc]init];
            rightBigV.frame = CGRectMake(0, 0, 60, 40);
            UIImageView *rightV = [[UIImageView alloc]init];
            rightV.frame = CGRectMake(20, 8, 23, 23);
            rightV.image = kImageName(@"check_right");
            [rightBigV addSubview:rightV];
            _newsAuthCodeField.rightView = rightBigV;
            [_makeSureWrongLabel removeFromSuperview];
            _isChecked = YES;
        }else
        {
            UIView *rightBigV = [[UIView alloc]init];
            rightBigV.frame = CGRectMake(0, 0, 60, 40);
            UIImageView *rightV = [[UIImageView alloc]init];
            rightV.frame = CGRectMake(20, 8, 23, 23);
            rightV.image = kImageName(@"check_wrong");
            [rightBigV addSubview:rightV];
            _newsAuthCodeField.rightView = rightBigV;
            _isChecked = NO;
            
            _makeSureWrongLabel = [[UILabel alloc]init];
            _makeSureWrongLabel.font = [UIFont systemFontOfSize:10];
            _makeSureWrongLabel.textColor = kColor(230, 68, 67, 1.0);
            _makeSureWrongLabel.text = @"验证码不正确，请重新填写";
            _makeSureWrongLabel.translatesAutoresizingMaskIntoConstraints = NO;
            [self.view addSubview:_makeSureWrongLabel];
            [self.view addConstraint:[NSLayoutConstraint constraintWithItem:_makeSureWrongLabel
                                                                  attribute:NSLayoutAttributeTop
                                                                  relatedBy:NSLayoutRelationEqual
                                                                     toItem:_newsAuthCodeField
                                                                  attribute:NSLayoutAttributeBottom
                                                                 multiplier:1.0
                                                                   constant:2.f]];
            [self.view addConstraint:[NSLayoutConstraint constraintWithItem:_makeSureWrongLabel
                                                                  attribute:NSLayoutAttributeLeft
                                                                  relatedBy:NSLayoutRelationEqual
                                                                     toItem:_makeSureBtn
                                                                  attribute:NSLayoutAttributeLeft
                                                                 multiplier:1.0
                                                                   constant:- 140.f]];
            [self.view addConstraint:[NSLayoutConstraint constraintWithItem:_makeSureWrongLabel
                                                                  attribute:NSLayoutAttributeWidth
                                                                  relatedBy:NSLayoutRelationEqual
                                                                     toItem:nil
                                                                  attribute:NSLayoutAttributeNotAnAttribute
                                                                 multiplier:1.0
                                                                   constant:140.f]];
            [self.view addConstraint:[NSLayoutConstraint constraintWithItem:_makeSureWrongLabel
                                                                  attribute:NSLayoutAttributeHeight
                                                                  relatedBy:NSLayoutRelationEqual
                                                                     toItem:nil
                                                                  attribute:NSLayoutAttributeNotAnAttribute
                                                                 multiplier:1.0
                                                                   constant:15.f]];
            return;
        }
    }
}

@end
