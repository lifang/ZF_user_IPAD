//
//  FindPasswordViewController.m
//  iPadff
//
//  Created by 黄含章 on 15/3/2.
//  Copyright (c) 2015年 LanTaiPro. All rights reserved.
//

#import "RegisterViewController.h"

@interface RegisterViewController ()<UITextFieldDelegate>

@property(nonatomic,strong)UITextField *phoneField;
@property(nonatomic,strong)UITextField *authField;
@property(nonatomic,strong)UITextField *newsPassword;
@property(nonatomic,strong)UITextField *makeSurePassword;
@property(nonatomic,strong)UITextField *locationField;

@end

@implementation RegisterViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initUI];
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
    [self.view addSubview:_phoneField];
    
    UIButton *authGetBtn = [[UIButton alloc]initWithFrame:CGRectMake(CGRectGetMaxX(_phoneField.frame)+10, _phoneField.frame.origin.y, _phoneField.frame.size.width * 0.43, _phoneField.frame.size.height)];
    [authGetBtn addTarget:self action:@selector(authClick:) forControlEvents:UIControlEventTouchUpInside];
    [authGetBtn setBackgroundColor:mainColor];
    [authGetBtn setTitle:@"获取验证码" forState:UIControlStateNormal];
    [self.view addSubview:authGetBtn];
    
    UILabel *authCode = [[UILabel alloc]init];
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
    [self.view addSubview:_authField];
    
    UIButton *makeSureBtn = [[UIButton alloc]initWithFrame:CGRectMake(CGRectGetMaxX(_phoneField.frame)+10, _authField.frame.origin.y, _phoneField.frame.size.width * 0.43, _phoneField.frame.size.height)];
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
    [self.view addSubview:_makeSurePassword];
    
    UILabel *location = [[UILabel alloc]init];
    location.font = [UIFont systemFontOfSize:20];
    location.text = @"所 在 地";
    location.frame = CGRectMake(280, CGRectGetMaxY(makeSurepassword.frame)+ 10, 140, 40);
    [self.view addSubview:location];
    
    _locationField = [[UITextField alloc]init];
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
    rightBtn.frame = CGRectMake(0, 0, 50, 40);
    [rightBtn setBackgroundImage:kImageName(@"location_right") forState:UIControlStateNormal];
    _locationField.rightView = rightBtn;
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

-(void)presentClick:(UIButton *)sender
{
    NSLog(@"点击了提交！");
}

-(void)backHome
{
    self.navigationController.navigationBarHidden = YES;
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)authClick:(UIButton *)sender
{
    NSLog(@"点击了验证码！");
}

-(void)makeSureClick:(UIButton *)sender
{
    NSLog(@"点击了检查！");
    UIView *rightBigV = [[UIView alloc]init];
    rightBigV.frame = CGRectMake(0, 0, 60, 40);
    UIImageView *rightV = [[UIImageView alloc]init];
    rightV.frame = CGRectMake(20, 8, 23, 23);
    rightV.image = kImageName(@"check_right");
    [rightBigV addSubview:rightV];
    _authField.rightView = rightBigV;
}


@end

