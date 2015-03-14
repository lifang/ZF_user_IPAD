//
//  FindPasswordViewController.m
//  iPadff
//
//  Created by 黄含章 on 15/3/2.
//  Copyright (c) 2015年 LanTaiPro. All rights reserved.
//

#import "RegisterViewController.h"
#import "RegularFormat.h"
#import "NetworkInterface.h"
#import "PhoneSuccessViewController.h"
#import "EmailSuccessViewController.h"
#import "LocationViewController.h"

@interface RegisterViewController ()<UITextFieldDelegate,UIAlertViewDelegate,sendCity>

@property(nonatomic,strong)UITextField *phoneField;
@property(nonatomic,strong)UITextField *authField;
@property(nonatomic,strong)UITextField *newsPassword;
@property(nonatomic,strong)UITextField *makeSurePassword;
@property(nonatomic,strong)UITextField *locationField;

@property(nonatomic,assign) BOOL isMobile;
@property(nonatomic,assign) BOOL isChecked;
@property(nonatomic,strong)UIButton *sendButton;
@property(nonatomic,strong)UILabel *authLabel;
@property(nonatomic,strong)UIButton *makeSureBtn;
@property(nonatomic,strong)LocationViewController *locationVC;
@property(nonatomic,strong)NSString *cityName;
@property(nonatomic,strong)NSString *cityId;
@end

@implementation RegisterViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    LocationViewController *locationVC = [[LocationViewController alloc]init];
    locationVC.delegate = self;
    self.locationVC = locationVC;
    [self initUI];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    _locationField.text = _cityName;
}


-(void)sendCity:(NSString *)city WithCity_id:(NSString *)city_id
{
    self.cityName = city;
    self.cityId = city_id;
    _locationField.placeholder = nil;
    _locationField.text = nil;
}

-(void)initUI
{
    self.title = @"注册";
    self.view.backgroundColor = [UIColor whiteColor];
    UIColor *mainColor = kColor(231, 88, 8, 1.0);
    NSDictionary *attributes = [NSDictionary dictionaryWithObjectsAndKeys:[UIColor whiteColor],NSForegroundColorAttributeName,[UIFont boldSystemFontOfSize:22],NSFontAttributeName, nil];
    [self.navigationController.navigationBar setTitleTextAttributes:attributes];
    [self.navigationController.navigationBar setBackgroundImage:[UIImage resizedImage:@"orange"] forBarPosition:UIBarPositionTop barMetrics:UIBarMetricsDefault];
    
    UIButton *leftBtn = [[UIButton alloc]init];
    [leftBtn addTarget:self action:@selector(backHome) forControlEvents:UIControlEventTouchUpInside];
    leftBtn.frame = CGRectMake(0, 0, 50, 50);
    [leftBtn setImage:[UIImage imageNamed:@"back_btn_white"] forState:UIControlStateNormal];
    UIBarButtonItem *leftBar = [[UIBarButtonItem alloc]initWithCustomView:leftBtn];
    self.navigationItem.leftBarButtonItem = leftBar;
    
    UILabel *phoneOrEmail = [[UILabel alloc]init];
    phoneOrEmail.font = [UIFont systemFontOfSize:20];
    phoneOrEmail.text = @"手机号/邮箱";
    phoneOrEmail.frame = CGRectMake(280, 60, 140, 40);
    [self.view addSubview:phoneOrEmail];
    
    _isChecked = NO;
    _phoneField = [[UITextField alloc]init];
    _phoneField.borderStyle = UITextBorderStyleLine;
    _phoneField.clearButtonMode = UITextFieldViewModeWhileEditing;
    _phoneField.frame = CGRectMake(CGRectGetMaxX(phoneOrEmail.frame) , phoneOrEmail.frame.origin.y, self.view.frame.size.width * 0.25, phoneOrEmail.frame.size.height);
    _phoneField.placeholder = @"请输入手机号/邮箱";
    [_phoneField setValue:[UIFont systemFontOfSize:20] forKeyPath:@"_placeholderLabel.font"];
    _phoneField.delegate = self;
    _phoneField.leftViewMode = UITextFieldViewModeAlways;
    UIView *placeholderV = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 15, 10)];
    _phoneField.leftView = placeholderV;
    CALayer *readBtnLayer = [_phoneField layer];
    [readBtnLayer setMasksToBounds:YES];
    [readBtnLayer setCornerRadius:2.0];
    [readBtnLayer setBorderWidth:1.0];
    [readBtnLayer setBorderColor:[kColor(163, 163, 163, 1.0) CGColor]];
    [self.view addSubview:_phoneField];
    
    UIButton *authGetBtn = [[UIButton alloc]initWithFrame:CGRectMake(CGRectGetMaxX(_phoneField.frame)+10, _phoneField.frame.origin.y, _phoneField.frame.size.width * 0.43, _phoneField.frame.size.height)];
    _sendButton = authGetBtn;
    [authGetBtn addTarget:self action:@selector(authClick:) forControlEvents:UIControlEventTouchUpInside];
    [authGetBtn setBackgroundColor:mainColor];
    [authGetBtn setTitle:@"获取验证码" forState:UIControlStateNormal];
    [self.view addSubview:authGetBtn];
    
    UILabel *authCode = [[UILabel alloc]init];
    _authLabel = authCode;
    authCode.font = [UIFont systemFontOfSize:20];
    authCode.text = @"输入验证码";
    authCode.frame = CGRectMake(280, CGRectGetMaxY(phoneOrEmail.frame) + 20, 140, 40);
    [self.view addSubview:authCode];
    
    _authField = [[UITextField alloc]init];
    _authField.borderStyle = UITextBorderStyleLine;
    _authField.clearButtonMode = UITextFieldViewModeWhileEditing;
    _authField.frame = CGRectMake(CGRectGetMaxX(phoneOrEmail.frame) , authCode.frame.origin.y, self.view.frame.size.width * 0.25, phoneOrEmail.frame.size.height);
    _authField.placeholder = @"请输入验证码";
    [_authField setValue:[UIFont systemFontOfSize:20] forKeyPath:@"_placeholderLabel.font"];
    _authField.delegate = self;
    _authField.leftViewMode = UITextFieldViewModeAlways;
    UIView *placeholderV1 = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 15, 10)];
    _authField.leftView = placeholderV1;
    _authField.rightViewMode = UITextFieldViewModeAlways;
    CALayer *readBtnLayer2 = [_authField layer];
    [readBtnLayer2 setMasksToBounds:YES];
    [readBtnLayer2 setCornerRadius:2.0];
    [readBtnLayer2 setBorderWidth:1.0];
    [readBtnLayer2 setBorderColor:[kColor(163, 163, 163, 1.0) CGColor]];
    [self.view addSubview:_authField];
    
    UIButton *makeSureBtn = [[UIButton alloc]initWithFrame:CGRectMake(CGRectGetMaxX(_phoneField.frame)+10, _authField.frame.origin.y, _phoneField.frame.size.width * 0.43, _phoneField.frame.size.height)];
    _makeSureBtn = makeSureBtn;
    [makeSureBtn addTarget:self action:@selector(makeSureClick:) forControlEvents:UIControlEventTouchUpInside];
    [makeSureBtn setBackgroundColor:mainColor];
    [makeSureBtn setTitle:@"检查" forState:UIControlStateNormal];
    [self.view addSubview:makeSureBtn];
    
    UILabel *password = [[UILabel alloc]init];
    password.font = [UIFont systemFontOfSize:20];
    password.text = @"输 入 密 码";
    password.frame = CGRectMake(280, CGRectGetMaxY(authCode.frame)+ 40, 140, 40);
    [self.view addSubview:password];
    
    _newsPassword = [[UITextField alloc]init];
    _newsPassword.borderStyle = UITextBorderStyleLine;
    _newsPassword.clearButtonMode = UITextFieldViewModeWhileEditing;
    _newsPassword.frame = CGRectMake(CGRectGetMaxX(password.frame) , password.frame.origin.y, self.view.frame.size.width * 0.25, password.frame.size.height);
    _newsPassword.placeholder = @"请输入新密码";
    [_newsPassword setValue:[UIFont systemFontOfSize:20] forKeyPath:@"_placeholderLabel.font"];
    _newsPassword.delegate = self;
    _newsPassword.leftViewMode = UITextFieldViewModeAlways;
    UIView *placeholderV2 = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 15, 10)];
    _newsPassword.leftView = placeholderV2;
    CALayer *readBtnLayer3 = [_newsPassword layer];
    [readBtnLayer3 setMasksToBounds:YES];
    [readBtnLayer3 setCornerRadius:2.0];
    [readBtnLayer3 setBorderWidth:1.0];
    [readBtnLayer3 setBorderColor:[kColor(163, 163, 163, 1.0) CGColor]];
    [self.view addSubview:_newsPassword];
    
    UILabel *makeSurepassword = [[UILabel alloc]init];
    makeSurepassword.font = [UIFont systemFontOfSize:20];
    makeSurepassword.text = @"确 认 密 码";
    makeSurepassword.frame = CGRectMake(280, CGRectGetMaxY(password.frame)+ 10, 140, 40);
    [self.view addSubview:makeSurepassword];
    
    _makeSurePassword = [[UITextField alloc]init];
    _makeSurePassword.borderStyle = UITextBorderStyleLine;
    _makeSurePassword.clearButtonMode = UITextFieldViewModeWhileEditing;
    _makeSurePassword.frame = CGRectMake(CGRectGetMaxX(makeSurepassword.frame) , makeSurepassword.frame.origin.y, self.view.frame.size.width * 0.25, makeSurepassword.frame.size.height);
    _makeSurePassword.placeholder = @"请确认新密码";
    [_makeSurePassword setValue:[UIFont systemFontOfSize:20] forKeyPath:@"_placeholderLabel.font"];
    _makeSurePassword.delegate = self;
    _makeSurePassword.leftViewMode = UITextFieldViewModeAlways;
    UIView *placeholderV3 = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 15, 10)];
    _makeSurePassword.leftView = placeholderV3;
    CALayer *readBtnLayer4 = [_makeSurePassword layer];
    [readBtnLayer4 setMasksToBounds:YES];
    [readBtnLayer4 setCornerRadius:2.0];
    [readBtnLayer4 setBorderWidth:1.0];
    [readBtnLayer4 setBorderColor:[kColor(163, 163, 163, 1.0) CGColor]];
    [self.view addSubview:_makeSurePassword];
    
    UILabel *location = [[UILabel alloc]init];
    location.font = [UIFont systemFontOfSize:20];
    location.text = @"所 在 地";
    location.frame = CGRectMake(280, CGRectGetMaxY(makeSurepassword.frame)+ 10, 140, 40);
    [self.view addSubview:location];
    
    _locationField = [[UITextField alloc]init];
    _locationField.userInteractionEnabled = NO;
    _locationField.borderStyle = UITextBorderStyleLine;
    _locationField.clearButtonMode = UITextFieldViewModeWhileEditing;
    _locationField.frame = CGRectMake(CGRectGetMaxX(makeSurepassword.frame) , location.frame.origin.y, self.view.frame.size.width * 0.25, makeSurepassword.frame.size.height);
    _locationField.placeholder = @"请选择城市";
    [_locationField setValue:[UIFont systemFontOfSize:20] forKeyPath:@"_placeholderLabel.font"];
    _locationField.delegate = self;
    _locationField.leftViewMode = UITextFieldViewModeAlways;
    UIView *placeholderV4 = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 15, 10)];
    _locationField.leftView = placeholderV4;
    _locationField.rightViewMode = UITextFieldViewModeAlways;
    UIButton *rightBtn = [[UIButton alloc]init];
    [rightBtn addTarget:self action:@selector(locationCity) forControlEvents:UIControlEventTouchUpInside];
    rightBtn.frame = CGRectMake(CGRectGetMaxX(_locationField.frame) - 50, _locationField.frame.origin.y, 50, 40);
    [rightBtn setBackgroundImage:kImageName(@"arrow_line") forState:UIControlStateNormal];
    [self.view addSubview:rightBtn];
    CALayer *readBtnLayer5 = [_locationField layer];
    [readBtnLayer5 setMasksToBounds:YES];
    [readBtnLayer5 setCornerRadius:2.0];
    [readBtnLayer5 setBorderWidth:1.0];
    [readBtnLayer5 setBorderColor:[kColor(163, 163, 163, 1.0) CGColor]];
    [self.view addSubview:_locationField];
    
    UIView *line = [[UIView alloc]init];
    line.frame = CGRectMake(40, CGRectGetMaxY(_locationField.frame) + 50, self.view.frame.size.width * 0.9, 1);
    line.backgroundColor = kColor(225, 224, 224, 1.0);
    [self.view addSubview:line];
    
    UIButton *presentBtn = [[UIButton alloc]init];
    [presentBtn addTarget:self action:@selector(presentClick:) forControlEvents:UIControlEventTouchUpInside];
    [presentBtn setTitle:@"提交" forState:UIControlStateNormal];
    [presentBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [presentBtn setBackgroundColor:mainColor];
    presentBtn.frame = CGRectMake(CGRectGetMaxX(password.frame) + 20, CGRectGetMaxY(line.frame) + 40, 240, 40);
    [self.view addSubview:presentBtn];
}

-(void)locationCity
{
    [self.navigationController pushViewController:_locationVC animated:YES];
    
}

-(void)setIsChecked:(BOOL)isChecked
{
    _isChecked = isChecked;
    if (_isChecked) {
        _authField.userInteractionEnabled = NO;
        
    }
}

-(void)presentClick:(UIButton *)sender
{
    
    if (!_isMobile) {
        if (!_newsPassword.text || [_newsPassword.text isEqualToString:@""]) {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示信息"
                                                            message:@"密码不能为空!"
                                                           delegate:nil
                                                  cancelButtonTitle:@"确定"
                                                  otherButtonTitles:nil];
            [alert show];
            return;
        }
        if ([_newsPassword.text length] < 6) {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示信息"
                                                            message:@"密码不能少于6位!"
                                                           delegate:nil
                                                  cancelButtonTitle:@"确定"
                                                  otherButtonTitles:nil];
            [alert show];
            return;
        }
        if (![_newsPassword.text isEqualToString:_makeSurePassword.text]) {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示信息"
                                                            message:@"两次密码不一致!"
                                                           delegate:nil
                                                  cancelButtonTitle:@"确定"
                                                  otherButtonTitles:nil];
            [alert show];
            return;
        }
        if (!_locationField.text || [_locationField.text isEqualToString:@""]) {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示信息"
                                                            message:@"请选择所在地!"
                                                           delegate:nil
                                                  cancelButtonTitle:@"确定"
                                                  otherButtonTitles:nil];
            [alert show];
            return;
        }
        [self registerWithEmail];
    }
    else{
        if (!_newsPassword.text || [_newsPassword.text isEqualToString:@""]) {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示信息"
                                                            message:@"密码不能为空!"
                                                           delegate:nil
                                                  cancelButtonTitle:@"确定"
                                                  otherButtonTitles:nil];
            [alert show];
            return;
        }
        if ([_newsPassword.text length] < 6) {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示信息"
                                                            message:@"密码不能少于6位!"
                                                           delegate:nil
                                                  cancelButtonTitle:@"确定"
                                                  otherButtonTitles:nil];
            [alert show];
            return;
        }
        if (![_newsPassword.text isEqualToString:_makeSurePassword.text]) {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示信息"
                                                            message:@"两次密码不一致!"
                                                           delegate:nil
                                                  cancelButtonTitle:@"确定"
                                                  otherButtonTitles:nil];
            [alert show];
            return;
        }
        if (!_locationField.text || [_locationField.text isEqualToString:@""]) {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示信息"
                                                            message:@"请选择所在地!"
                                                           delegate:nil
                                                  cancelButtonTitle:@"确定"
                                                  otherButtonTitles:nil];
            [alert show];
            return;
        }
        if (_isChecked == NO) {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示信息"
                                                            message:@"请先验证验证码!"
                                                           delegate:nil
                                                  cancelButtonTitle:@"确定"
                                                  otherButtonTitles:nil];
            [alert show];
            return;

        }
        [self registerWithPhone];

    }
}

-(void)registerWithPhone
{
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
    hud.labelText = @"正在提交...";
    [NetworkInterface registerWithActivation:_authField.text username:_phoneField.text userPassword:_newsPassword.text cityID:@"1" isEmailRegister:NO finished:^(BOOL success, NSData *response) {
        hud.customView = [[UIImageView alloc] init];
        hud.mode = MBProgressHUDModeCustomView;
        [hud hide:YES afterDelay:0.3f];
        if (success) {
            id object = [NSJSONSerialization JSONObjectWithData:response options:NSJSONReadingMutableLeaves error:nil];
            if ([object isKindOfClass:[NSDictionary class]]) {
                [hud hide:YES];
                int errorCode = [[object objectForKey:@"code"] intValue];
                if (errorCode == RequestFail) {
                    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示信息"
                                                                    message:[object objectForKey:@"message"]
                                                                   delegate:nil
                                                          cancelButtonTitle:@"确定"
                                                          otherButtonTitles:nil];
                    [alert show];
                }
                else if (errorCode == RequestSuccess) {
                    NSLog(@"success = %@",[object objectForKey:@"message"]);
                    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示信息"
                                                                    message:@"注册成功"
                                                                   delegate:self
                                                          cancelButtonTitle:@"确定"
                                                          otherButtonTitles:nil];
                    alert.tag=1001;
                    [alert show];
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

-(void)registerWithEmail
{
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
    hud.labelText = @"正在提交...";
    [NetworkInterface registerWithActivation:nil username:_phoneField.text userPassword:_newsPassword.text cityID:@"1" isEmailRegister:YES finished:^(BOOL success, NSData *response) {
        hud.customView = [[UIImageView alloc] init];
        hud.mode = MBProgressHUDModeCustomView;
        [hud hide:YES afterDelay:0.3f];
        if (success) {
            id object = [NSJSONSerialization JSONObjectWithData:response options:NSJSONReadingMutableLeaves error:nil];
            if ([object isKindOfClass:[NSDictionary class]]) {
                [hud hide:YES];
                int errorCode = [[object objectForKey:@"code"] intValue];
                if (errorCode == RequestFail) {
                    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示信息"
                                                                    message:[object objectForKey:@"message"]
                                                                   delegate:nil
                                                          cancelButtonTitle:@"确定"
                                                          otherButtonTitles:nil];
                    [alert show];
                }
                else if (errorCode == RequestSuccess) {
                    NSLog(@"success = %@",[object objectForKey:@"message"]);
                    EmailSuccessViewController *emailVC = [[EmailSuccessViewController alloc]init];
                    emailVC.email = _phoneField.text;
                    [self.navigationController pushViewController:emailVC animated:YES];
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

-(void)backHome
{
    self.navigationController.navigationBarHidden = YES;
    _phoneField.text = nil;
    _authField.text = nil;
    _newsPassword.text = nil;
    _makeSurePassword.text = nil;
    _locationField.text = nil;
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)authClick:(UIButton *)sender
{
    NSLog(@"点击了验证码！");
    if (!_phoneField.text || [_phoneField.text isEqualToString:@""]) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示信息"
                                                        message:@"手机号不能为空!"
                                                       delegate:nil
                                              cancelButtonTitle:@"确定"
                                              otherButtonTitles:nil];
        [alert show];
         return;
    }
    if (![RegularFormat isMobileNumber:_phoneField.text]) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示信息"
                                                        message:@"手机号格式不正确!"
                                                       delegate:nil
                                              cancelButtonTitle:@"确定"
                                              otherButtonTitles:nil];
        [alert show];
        return;
    }
    [self sendMobileValidate];
}

-(void)sendMobileValidate
{
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
    hud.labelText = @"正在获取...";
    NSLog(@"%@",_phoneField.text);
    [NetworkInterface getRegisterValidateCodeWithMobileNumber:_phoneField.text finished:^(BOOL success, NSData *response) {
        hud.customView = [[UIImageView alloc] init];
        hud.mode = MBProgressHUDModeCustomView;
        [hud hide:YES afterDelay:0.3f];
        if (success) {
            id object = [NSJSONSerialization JSONObjectWithData:response options:NSJSONReadingMutableLeaves error:nil];
            if ([object isKindOfClass:[NSDictionary class]]) {
                if ([[object objectForKey:@"code"] intValue] == RequestSuccess) {
                    [hud setHidden:YES];
                    _validate = [object objectForKey:@"result"];
                    [self resetStatus];
                    NSLog(@"验证码为~~~~~~%@",_validate);
                }
                else {
                    hud.labelText = [NSString stringWithFormat:@"错误代码:%@",[object objectForKey:@"code"]];
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

-(void)makeSureClick:(UIButton *)sender
{
    NSLog(@"点击了检查！");
    if (!_authField.text || [_authField.text isEqualToString:@""]) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示信息"
                                                        message:@"验证码不能为空!"
                                                       delegate:nil
                                              cancelButtonTitle:@"确定"
                                              otherButtonTitles:nil];
        [alert show];
        return;
    }
    if (![_authField.text isEqualToString:_validate]) {
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
        _authField.rightView = rightBigV;
        _isChecked = NO;
        return;
    }

    UIView *rightBigV = [[UIView alloc]init];
    rightBigV.frame = CGRectMake(0, 0, 60, 40);
    UIImageView *rightV = [[UIImageView alloc]init];
    rightV.frame = CGRectMake(20, 8, 23, 23);
    rightV.image = kImageName(@"check_right");
    [rightBigV addSubview:rightV];
    _authField.rightView = rightBigV;
    _isChecked = YES;
}

- (void)setIsMobile:(BOOL)isMobile {
    _isMobile = isMobile;
    if (_isMobile) {
        _sendButton.hidden = NO;
        _authLabel.hidden = NO;
        _makeSureBtn.hidden = NO;
        _authField.hidden = NO;
    }
    else {
        _sendButton.hidden = YES;
        _authLabel.hidden = YES;
        _makeSureBtn.hidden = YES;
        _authField.hidden = YES;
    }
}

#pragma mark - UITextField

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    if (textField == _phoneField) {
    if ([string isEqualToString:@""]) {
        //删除
        if ([textField.text length] > 0 && [[textField.text substringToIndex:[textField.text length] - 1] containsString:@"@"]) {
            self.isMobile = NO;
        }
        else {
            self.isMobile = YES;
        }
    }
    else if ([textField.text containsString:@"@"] || [string containsString:@"@"]) {
        self.isMobile = NO;
    }
    else {
        self.isMobile = YES;
    }
    }
    return YES;
}

- (BOOL)textFieldShouldClear:(UITextField *)textField {
    if (textField==_phoneField) {
    self.isMobile = YES;
    }
    return YES;
}

#pragma mark - UIAlertView

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (buttonIndex == alertView.cancelButtonIndex) {
        if (alertView.tag == 1001) {
            PhoneSuccessViewController *phoneSuccessV = [[PhoneSuccessViewController alloc]init];
            phoneSuccessV.phoneNum = _phoneField.text;
            [self.navigationController pushViewController:phoneSuccessV animated:YES];
        }
    }
}

- (void)resetStatus {
    self.isChecked = NO;
    [self countDownStart];
}

//倒计时
- (void)countDownStart {
    __block int timeout = 10; //倒计时时间
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_source_t _timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, queue);
    dispatch_source_set_timer(_timer,dispatch_walltime(NULL, 0),1.0 * NSEC_PER_SEC, 0); //每秒执行
    dispatch_source_set_event_handler(_timer, ^{
        if(timeout <= 0){
            //倒计时结束，关闭
            dispatch_source_cancel(_timer);
            dispatch_async(dispatch_get_main_queue(), ^{
                //UI更新
                _sendButton.userInteractionEnabled = YES;
                _sendButton.frame = CGRectMake(CGRectGetMaxX(_phoneField.frame)+10, _phoneField.frame.origin.y, _phoneField.frame.size.width * 0.43, _phoneField.frame.size.height);
                [_sendButton setBackgroundImage:kImageName(@"orange.png") forState:UIControlStateNormal];
                [_sendButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
                [_sendButton setTitle:@"发送验证码" forState:UIControlStateNormal];
            });
        }
        else {
            dispatch_async(dispatch_get_main_queue(), ^{
                _sendButton.userInteractionEnabled = NO;
                _sendButton.frame = CGRectMake(CGRectGetMaxX(_phoneField.frame)+10, _phoneField.frame.origin.y, _phoneField.frame.size.width * 0.6, _phoneField.frame.size.height);
                [_sendButton setBackgroundColor:[UIColor lightGrayColor]];
                NSString *title = [NSString stringWithFormat:@"%d秒后重新获取",timeout];
                [_sendButton setBackgroundImage:nil forState:UIControlStateNormal];
                [_sendButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
                [_sendButton setTitle:title forState:UIControlStateNormal];
                
            });
            timeout--;
            
        }
    });
    dispatch_resume(_timer);
}


@end

