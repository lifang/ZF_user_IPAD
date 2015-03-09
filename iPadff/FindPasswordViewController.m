//
//  FindPasswordViewController.m
//  iPadff
//
//  Created by 黄含章 on 15/3/2.
//  Copyright (c) 2015年 LanTaiPro. All rights reserved.
//

#import "FindPasswordViewController.h"

@interface FindPasswordViewController ()<UITextFieldDelegate>

@property(nonatomic,strong)UITextField *phoneField;
@property(nonatomic,strong)UITextField *authField;
@property(nonatomic,strong)UITextField *newsPassword;
@property(nonatomic,strong)UITextField *makeSurePassword;

@property(nonatomic,assign) BOOL isMobile;
@property(nonatomic,strong)UIButton *sendButton;
@property(nonatomic,strong)UILabel *authLabel;
@property(nonatomic,strong)UILabel *newpassworLabel;
@property(nonatomic,strong)UILabel *makesurepasswordLabel;
@property(nonatomic,strong)UIButton *makeSureBtn;
@property(nonatomic,strong)UIView *line;

@property(nonatomic,strong)UIButton *presentBtn;

@end

@implementation FindPasswordViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initUI];
}

-(void)initUI
{
    self.title = @"找回密码";
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
    CALayer *readBtnLayer1 = [_authField layer];
    [readBtnLayer1 setMasksToBounds:YES];
    [readBtnLayer1 setCornerRadius:2.0];
    [readBtnLayer1 setBorderWidth:1.0];
    [readBtnLayer1 setBorderColor:[kColor(163, 163, 163, 1.0) CGColor]];
    [self.view addSubview:_authField];
    
    UIButton *makeSureBtn = [[UIButton alloc]initWithFrame:CGRectMake(CGRectGetMaxX(_phoneField.frame)+10, _authField.frame.origin.y, _phoneField.frame.size.width * 0.43, _phoneField.frame.size.height)];
    _makeSureBtn = makeSureBtn;
    [makeSureBtn addTarget:self action:@selector(makeSureClick:) forControlEvents:UIControlEventTouchUpInside];
    [makeSureBtn setBackgroundColor:mainColor];
    [makeSureBtn setTitle:@"检查" forState:UIControlStateNormal];
    [self.view addSubview:makeSureBtn];
    
    UILabel *password = [[UILabel alloc]init];
    _newpassworLabel = password;
    password.font = [UIFont systemFontOfSize:20];
    password.text = @"输入新密码";
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
    CALayer *readBtnLayer2 = [_newsPassword layer];
    [readBtnLayer2 setMasksToBounds:YES];
    [readBtnLayer2 setCornerRadius:2.0];
    [readBtnLayer2 setBorderWidth:1.0];
    [readBtnLayer2 setBorderColor:[kColor(163, 163, 163, 1.0) CGColor]];
    [self.view addSubview:_newsPassword];
    
    UILabel *makeSurepassword = [[UILabel alloc]init];
    _makesurepasswordLabel = makeSurepassword;
    makeSurepassword.font = [UIFont systemFontOfSize:20];
    makeSurepassword.text = @"确认新密码";
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
    CALayer *readBtnLayer3 = [_makeSurePassword layer];
    [readBtnLayer3 setMasksToBounds:YES];
    [readBtnLayer3 setCornerRadius:2.0];
    [readBtnLayer3 setBorderWidth:1.0];
    [readBtnLayer3 setBorderColor:[kColor(163, 163, 163, 1.0) CGColor]];
    [self.view addSubview:_makeSurePassword];
    
    UIView *line = [[UIView alloc]init];
    _line = line;
    line.frame = CGRectMake(40, CGRectGetMaxY(_makeSurePassword.frame) + 50, self.view.frame.size.width * 0.9, 1);
    line.backgroundColor = kColor(225, 224, 224, 1.0);
    [self.view addSubview:line];
    
    UIButton *presentBtn = [[UIButton alloc]init];
    _presentBtn = presentBtn;
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
    if (!_isMobile) {
        
    }
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


- (void)setIsMobile:(BOOL)isMobile {
    _isMobile = isMobile;
    if (_isMobile) {
        [_sendButton setTitle:@"发送验证码" forState:UIControlStateNormal];
        _authLabel.hidden = NO;
        _makeSureBtn.hidden = NO;
        _authField.hidden = NO;
        _newpassworLabel.hidden = NO;
        _newsPassword.hidden = NO;
        _makesurepasswordLabel.hidden = NO;
        _makeSurePassword.hidden = NO;
        _presentBtn.hidden = NO;
        _line.hidden = NO;
    }
    else {
        [_sendButton setTitle:@"发送重置邮箱" forState:UIControlStateNormal];
        _authLabel.hidden = YES;
        _makeSureBtn.hidden = YES;
        _authField.hidden = YES;
        _newpassworLabel.hidden = YES;
        _newsPassword.hidden = YES;
        _makesurepasswordLabel.hidden = YES;
        _makeSurePassword.hidden = YES;
        _presentBtn.hidden = YES;
        _line.hidden = YES;
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


@end
