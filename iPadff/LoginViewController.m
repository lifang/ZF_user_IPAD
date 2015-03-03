//
//  LoginViewController.m
//  iPadff
//
//  Created by 黄含章 on 15/3/2.
//  Copyright (c) 2015年 LanTaiPro. All rights reserved.
//

#import "LoginViewController.h"
#import "FindPasswordViewController.h"
#import "RegisterViewController.h"

@interface LoginViewController ()<UITextFieldDelegate>
@property(nonatomic,strong)UITextField *userField;
@property(nonatomic,strong)UITextField *passwordField;
@end

@implementation LoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = kColor(144, 144, 144, 0.7);
    [self setLoginView];
}

-(void)setLoginView
{
    UIView *loginView = [[UIView alloc]init];
    loginView.frame = CGRectMake(300, 140, 430, 380);
    loginView.backgroundColor = [UIColor whiteColor];
    UIImageView *exitImage = [[UIImageView alloc]init];
    exitImage.userInteractionEnabled = YES;
    UIButton *btnClick = [[UIButton alloc]init];
    btnClick.frame = CGRectMake(0, 0, 30, 30);
    [btnClick addTarget:self action:@selector(exitClick) forControlEvents:UIControlEventTouchUpInside];
    [exitImage addSubview:btnClick];
    exitImage.image = kImageName(@"X");
    exitImage.frame = CGRectMake(15, 15, 30, 30);
    [loginView addSubview:exitImage];
    UILabel *loginLabel = [[UILabel alloc]initWithFrame:CGRectMake(loginView.frame.size.width * 0.5 - 20, 10, 50, 40)];
    loginLabel.font = [UIFont boldSystemFontOfSize:22];
    loginLabel.text = @"登陆";
    [loginView addSubview:loginLabel];
    UIView *line = [[UIView alloc]init];
    line.frame = CGRectMake(0, CGRectGetMaxY(loginLabel.frame)+ 10, loginView.frame.size.width, 1);
    line.backgroundColor = kColor(147, 147, 147, 1.0);
    [loginView addSubview:line];
    UIImageView *userImage = [[UIImageView alloc]initWithFrame:CGRectMake(40, CGRectGetMaxY(line.frame)+ 30, 40, 40)];
    userImage.image = kImageName(@"user");
    [loginView addSubview:userImage];
    UIImageView *passwordImage = [[UIImageView alloc]initWithFrame:CGRectMake(40, CGRectGetMaxY(userImage.frame)+ 30, 40, 40)];
    passwordImage.image = kImageName(@"password");
    [loginView addSubview:passwordImage];
    
    _userField = [[UITextField alloc]init];
    _userField.borderStyle = UITextBorderStyleLine;
    _userField.clearButtonMode = UITextFieldViewModeWhileEditing;
    _userField.frame = CGRectMake(CGRectGetMaxX(userImage.frame) + 10, userImage.frame.origin.y, loginView.frame.size.width * 0.65, userImage.frame.size.height);
    _userField.placeholder = @"请输入手机号/邮箱";
    [_userField setValue:[UIFont systemFontOfSize:20] forKeyPath:@"_placeholderLabel.font"];
    _userField.delegate = self;
    _userField.leftViewMode = UITextFieldViewModeAlways;
    UIView *placeholderV = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 15, 10)];
    _userField.leftView = placeholderV;
    [loginView addSubview:_userField];
    
    _passwordField = [[UITextField alloc]init];
    _passwordField.borderStyle = UITextBorderStyleLine;
    _passwordField.clearButtonMode = UITextFieldViewModeWhileEditing;
    _passwordField.frame = CGRectMake(CGRectGetMaxX(userImage.frame) + 10, passwordImage.frame.origin.y, loginView.frame.size.width * 0.65, userImage.frame.size.height);
    _passwordField.placeholder = @"请输入密码";
    [_passwordField setValue:[UIFont systemFontOfSize:20] forKeyPath:@"_placeholderLabel.font"];
    _passwordField.delegate = self;
    _passwordField.leftViewMode = UITextFieldViewModeAlways;
    UIView *placeholderV1 = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 15, 10)];
    _passwordField.leftView = placeholderV1;
    [loginView addSubview:_passwordField];
    
    UIButton *loginBtn = [[UIButton alloc]init];
    [loginBtn addTarget:self action:@selector(loginClick:) forControlEvents:UIControlEventTouchUpInside];
    [loginBtn setBackgroundColor:[UIColor orangeColor]];
    [loginBtn setTitle:@"登陆" forState:UIControlStateNormal];
    loginBtn.titleLabel.tintColor = [UIColor whiteColor];
    loginBtn.frame = CGRectMake(_userField.frame.origin.x, CGRectGetMaxY(_passwordField.frame) + 30, _userField.frame.size.width, userImage.frame.size.height);
    [loginView addSubview:loginBtn];
    
    UIButton *findPasswordBtn = [[UIButton alloc]init];
    [findPasswordBtn setTitle:@"找回密码" forState:UIControlStateNormal];
    [findPasswordBtn setTitleColor:[UIColor orangeColor] forState:UIControlStateNormal];
    [findPasswordBtn addTarget:self action:@selector(findClick:) forControlEvents:UIControlEventTouchUpInside];
    findPasswordBtn.frame = CGRectMake(20, loginView.frame.size.height - 40, 80, 20);
    [loginView addSubview:findPasswordBtn];
    
    UIButton *registerBtn = [[UIButton alloc]init];
    [registerBtn setTitleColor:[UIColor orangeColor] forState:UIControlStateNormal];
    [registerBtn setTitle:@"注册" forState:UIControlStateNormal];
    [registerBtn addTarget:self action:@selector(registe:) forControlEvents:UIControlEventTouchUpInside];
    registerBtn.frame = CGRectMake(loginView.frame.size.width - 60, findPasswordBtn.frame.origin.y, 40, 20);
    [loginView addSubview:registerBtn];
    
    [self.view addSubview:loginView];
}

-(void)loginClick:(UIButton *)sender
{
    NSLog(@"点击了登陆！");
    [self dismissViewControllerAnimated:YES completion:nil];
}

-(void)exitClick
{
    [self dismissViewControllerAnimated:YES completion:nil];

}

-(void)findClick:(UIButton *)sender
{
    NSLog(@"点击了找回密码！");
    FindPasswordViewController *findV = [[FindPasswordViewController alloc]init];
    self.navigationController.navigationBarHidden = NO;
    [self.navigationController pushViewController:findV animated:YES];
}

-(void)registe:(UIButton *)sender
{
    NSLog(@"点击了注册！");
    RegisterViewController *registeVC = [[RegisterViewController alloc]init];
    self.navigationController.navigationBarHidden = NO;
    [self.navigationController pushViewController:registeVC animated:YES];
}

@end
