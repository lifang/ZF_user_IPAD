//
//  ContactusUsController.m
//  iPadff
//
//  Created by 黄含章 on 15/3/24.
//  Copyright (c) 2015年 LanTaiPro. All rights reserved.
//

#import "ContactusUsController.h"
#import "NetworkInterface.h"
#import "HHZTextView.h"
#import "RegularFormat.h"
#import "AccountTool.h"
#import "LoginViewController.h"

@interface ContactusUsController ()<UITextFieldDelegate,UITextViewDelegate,LoginSuccessDelegate>

@property(nonatomic,strong)UITextField *nameField;

@property(nonatomic,strong)UITextField *telField;

@property(nonatomic,strong)HHZTextView *contentTextView;

@property(nonatomic,strong)UILabel *limitLabel;

@end

@implementation ContactusUsController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupNavBar];
    [self initAndLayoutUI];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)setupNavBar
{
    self.title = @"联系我们";
    self.view.backgroundColor = [UIColor whiteColor];
    NSDictionary *attributes = [NSDictionary dictionaryWithObjectsAndKeys:[UIColor whiteColor],NSForegroundColorAttributeName,[UIFont boldSystemFontOfSize:22],NSFontAttributeName, nil];
    [self.navigationController.navigationBar setTitleTextAttributes:attributes];
    [self.navigationController.navigationBar setBackgroundImage:[UIImage resizedImage:@"orange"] forBarPosition:UIBarPositionTop barMetrics:UIBarMetricsDefault];
}

-(void)initAndLayoutUI
{
    UIColor *mainColor = kColor(45, 44, 44, 1.0);
    UIFont *mainFont = [UIFont systemFontOfSize:22];
    
    UILabel *hotlineLable = [[UILabel alloc]init];
    hotlineLable.translatesAutoresizingMaskIntoConstraints = NO;
    hotlineLable.text = @"客服热线：";
    hotlineLable.font = mainFont;
    hotlineLable.textColor = mainColor;
    [self.view addSubview:hotlineLable];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:hotlineLable
                                                          attribute:NSLayoutAttributeTop
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:self.view
                                                          attribute:NSLayoutAttributeTop
                                                         multiplier:1.0
                                                           constant:120.f]];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:hotlineLable
                                                          attribute:NSLayoutAttributeLeft
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:self.view
                                                          attribute:NSLayoutAttributeLeft
                                                         multiplier:1.0
                                                           constant:140.f]];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:hotlineLable
                                                          attribute:NSLayoutAttributeWidth
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:nil
                                                          attribute:NSLayoutAttributeNotAnAttribute
                                                         multiplier:1.0
                                                           constant:120.f]];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:hotlineLable
                                                          attribute:NSLayoutAttributeHeight
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:nil
                                                          attribute:NSLayoutAttributeNotAnAttribute
                                                         multiplier:0.0
                                                           constant:40.f]];
    UIImageView *imageView = [[UIImageView alloc]init];
    imageView.translatesAutoresizingMaskIntoConstraints = NO;
    imageView.image = [UIImage imageNamed:@"hotLine"];
    [self.view addSubview:imageView];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:imageView
                                                          attribute:NSLayoutAttributeTop
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:hotlineLable
                                                          attribute:NSLayoutAttributeBottom
                                                         multiplier:1.0
                                                           constant:0.f]];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:imageView
                                                          attribute:NSLayoutAttributeLeft
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:self.view
                                                          attribute:NSLayoutAttributeLeft
                                                         multiplier:1.0
                                                           constant:160.f]];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:imageView
                                                          attribute:NSLayoutAttributeWidth
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:nil
                                                          attribute:NSLayoutAttributeNotAnAttribute
                                                         multiplier:1.0
                                                           constant:61.f]];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:imageView
                                                          attribute:NSLayoutAttributeHeight
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:nil
                                                          attribute:NSLayoutAttributeNotAnAttribute
                                                         multiplier:0.0
                                                           constant:62.f]];
    
    UILabel *telLable = [[UILabel alloc]init];
    telLable.translatesAutoresizingMaskIntoConstraints = NO;
    telLable.text = @"400-880-9988";
    telLable.font = mainFont;
    telLable.textColor = mainColor;
    [self.view addSubview:telLable];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:telLable
                                                          attribute:NSLayoutAttributeTop
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:imageView
                                                          attribute:NSLayoutAttributeBottom
                                                         multiplier:1.0
                                                           constant:0.f]];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:telLable
                                                          attribute:NSLayoutAttributeLeft
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:self.view
                                                          attribute:NSLayoutAttributeLeft
                                                         multiplier:1.0
                                                           constant:120.f]];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:telLable
                                                          attribute:NSLayoutAttributeWidth
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:nil
                                                          attribute:NSLayoutAttributeNotAnAttribute
                                                         multiplier:1.0
                                                           constant:200.f]];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:telLable
                                                          attribute:NSLayoutAttributeHeight
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:nil
                                                          attribute:NSLayoutAttributeNotAnAttribute
                                                         multiplier:0.0
                                                           constant:40.f]];
    
    UIView *leftLine = [[UIView alloc]init];
    leftLine.translatesAutoresizingMaskIntoConstraints = NO;
    leftLine.backgroundColor = kColor(187, 187, 187, 1.0);
    [self .view addSubview:leftLine];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:leftLine
                                                          attribute:NSLayoutAttributeTop
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:telLable
                                                          attribute:NSLayoutAttributeBottom
                                                         multiplier:1.0
                                                           constant:50.f]];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:leftLine
                                                          attribute:NSLayoutAttributeLeft
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:self.view
                                                          attribute:NSLayoutAttributeLeft
                                                         multiplier:1.0
                                                           constant:100.f]];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:leftLine
                                                          attribute:NSLayoutAttributeWidth
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:nil
                                                          attribute:NSLayoutAttributeNotAnAttribute
                                                         multiplier:1.0
                                                           constant:180.f]];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:leftLine
                                                          attribute:NSLayoutAttributeHeight
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:nil
                                                          attribute:NSLayoutAttributeNotAnAttribute
                                                         multiplier:0.0
                                                           constant:1.f]];
    //微信公共平台
    UILabel *tinyMessageLabel = [[UILabel alloc]init];
    tinyMessageLabel.translatesAutoresizingMaskIntoConstraints = NO;
    tinyMessageLabel.textColor = mainColor;
    tinyMessageLabel.font = mainFont;
    tinyMessageLabel.text = @"微信公众平台：";
    [self.view addSubview:tinyMessageLabel];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:tinyMessageLabel
                                                          attribute:NSLayoutAttributeTop
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:leftLine
                                                          attribute:NSLayoutAttributeBottom
                                                         multiplier:1.0
                                                           constant:20.f]];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:tinyMessageLabel
                                                          attribute:NSLayoutAttributeLeft
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:self.view
                                                          attribute:NSLayoutAttributeLeft
                                                         multiplier:1.0
                                                           constant:120.f]];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:tinyMessageLabel
                                                          attribute:NSLayoutAttributeWidth
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:nil
                                                          attribute:NSLayoutAttributeNotAnAttribute
                                                         multiplier:1.0
                                                           constant:200.f]];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:tinyMessageLabel
                                                          attribute:NSLayoutAttributeHeight
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:nil
                                                          attribute:NSLayoutAttributeNotAnAttribute
                                                         multiplier:0.0
                                                           constant:40.f]];
    
    UIImageView *tinyImage = [[UIImageView alloc]init];
    tinyImage.translatesAutoresizingMaskIntoConstraints = NO;
    tinyImage.image = kImageName(@"erweima");
    [self.view addSubview:tinyImage];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:tinyImage
                                                          attribute:NSLayoutAttributeTop
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:tinyMessageLabel
                                                          attribute:NSLayoutAttributeBottom
                                                         multiplier:1.0
                                                           constant:10.f]];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:tinyImage
                                                          attribute:NSLayoutAttributeLeft
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:self.view
                                                          attribute:NSLayoutAttributeLeft
                                                         multiplier:1.0
                                                           constant:140.f]];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:tinyImage
                                                          attribute:NSLayoutAttributeWidth
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:nil
                                                          attribute:NSLayoutAttributeNotAnAttribute
                                                         multiplier:1.0
                                                           constant:100.f]];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:tinyImage
                                                          attribute:NSLayoutAttributeHeight
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:nil
                                                          attribute:NSLayoutAttributeNotAnAttribute
                                                         multiplier:0.0
                                                           constant:100.f]];
    
    UIView *middleLine = [[UIView alloc]init];
    middleLine.translatesAutoresizingMaskIntoConstraints = NO;
    middleLine.backgroundColor = kColor(220, 220, 221, 1.0);
    [self.view addSubview:middleLine];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:middleLine
                                                          attribute:NSLayoutAttributeTop
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:self.view
                                                          attribute:NSLayoutAttributeTop
                                                         multiplier:1.0
                                                           constant:120.f]];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:middleLine
                                                          attribute:NSLayoutAttributeLeft
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:leftLine
                                                          attribute:NSLayoutAttributeRight
                                                         multiplier:1.0
                                                           constant:20.f]];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:middleLine
                                                          attribute:NSLayoutAttributeWidth
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:nil
                                                          attribute:NSLayoutAttributeNotAnAttribute
                                                         multiplier:1.0
                                                           constant:1.f]];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:middleLine
                                                          attribute:NSLayoutAttributeHeight
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:nil
                                                          attribute:NSLayoutAttributeNotAnAttribute
                                                         multiplier:0.0
                                                           constant:380.f]];
    
    _nameField = [[UITextField alloc]init];
    _nameField.translatesAutoresizingMaskIntoConstraints = NO;
    _nameField.font = [UIFont systemFontOfSize:20];
    _nameField.borderStyle = UITextBorderStyleLine;
    _nameField.leftViewMode = UITextFieldViewModeAlways;
    UIView *v = [[UIView alloc]init];
    v.frame = CGRectMake(0, 0, 10, 40);
    _nameField.leftView = v;
    _nameField.clearButtonMode = UITextFieldViewModeWhileEditing;
    _nameField.placeholder = @"您的称呼";
    _nameField.delegate = self;
    CALayer *nameFieldLayer = [_nameField layer];
    [nameFieldLayer setMasksToBounds:YES];
    [nameFieldLayer setCornerRadius:2.0];
    [nameFieldLayer setBorderWidth:1.0];
    [nameFieldLayer setBorderColor:[kColor(163, 163, 163, 1.0) CGColor]];
    UIView *rightV = [[UIView alloc]init];
    rightV.frame = CGRectMake(0, 0, 110, 40);
    UILabel *sexLable = [[UILabel alloc]init];
    sexLable.text = @"先生/女士";
    sexLable.font = [UIFont systemFontOfSize:20];
    sexLable.textColor = kColor(194, 194, 200, 1.0);
    sexLable.frame = CGRectMake(0, 0, 100, 40);
    [rightV addSubview:sexLable];
    _nameField.rightViewMode = UITextFieldViewModeAlways;
    _nameField.rightView = rightV;
    [self.view addSubview:_nameField];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:_nameField
                                                          attribute:NSLayoutAttributeTop
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:self.view
                                                          attribute:NSLayoutAttributeTop
                                                         multiplier:1.0
                                                           constant:120.f]];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:_nameField
                                                          attribute:NSLayoutAttributeLeft
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:middleLine
                                                          attribute:NSLayoutAttributeRight
                                                         multiplier:1.0
                                                           constant:40.f]];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:_nameField
                                                          attribute:NSLayoutAttributeWidth
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:nil
                                                          attribute:NSLayoutAttributeNotAnAttribute
                                                         multiplier:1.0
                                                           constant:280.f]];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:_nameField
                                                          attribute:NSLayoutAttributeHeight
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:nil
                                                          attribute:NSLayoutAttributeNotAnAttribute
                                                         multiplier:0.0
                                                           constant:40.f]];
    
    _telField = [[UITextField alloc]init];
    _telField.translatesAutoresizingMaskIntoConstraints = NO;
    _telField.font = [UIFont systemFontOfSize:20];
    _telField.borderStyle = UITextBorderStyleLine;
    _telField.leftViewMode = UITextFieldViewModeAlways;
    UIView *v2 = [[UIView alloc]init];
    v2.frame = CGRectMake(0, 0, 10, 40);
    _telField.leftView = v2;
    _telField.clearButtonMode = UITextFieldViewModeWhileEditing;
    _telField.placeholder = @"您的联系方式";
    _telField.delegate = self;
    CALayer *nameFieldLayer2 = [_telField layer];
    [nameFieldLayer2 setMasksToBounds:YES];
    [nameFieldLayer2 setCornerRadius:2.0];
    [nameFieldLayer2 setBorderWidth:1.0];
    [nameFieldLayer2 setBorderColor:[kColor(163, 163, 163, 1.0) CGColor]];
    [self.view addSubview:_telField];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:_telField
                                                          attribute:NSLayoutAttributeTop
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:self.view
                                                          attribute:NSLayoutAttributeTop
                                                         multiplier:1.0
                                                           constant:120.f]];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:_telField
                                                          attribute:NSLayoutAttributeLeft
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:_nameField
                                                          attribute:NSLayoutAttributeRight
                                                         multiplier:1.0
                                                           constant:20.f]];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:_telField
                                                          attribute:NSLayoutAttributeWidth
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:nil
                                                          attribute:NSLayoutAttributeNotAnAttribute
                                                         multiplier:1.0
                                                           constant:280.f]];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:_telField
                                                          attribute:NSLayoutAttributeHeight
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:nil
                                                          attribute:NSLayoutAttributeNotAnAttribute
                                                         multiplier:0.0
                                                           constant:40.f]];

    _contentTextView = [[HHZTextView alloc]init];
    _contentTextView.translatesAutoresizingMaskIntoConstraints = NO;
    _contentTextView.placehoder = @"需要我们提供什么";
    _contentTextView.placehoderColor = kColor(194, 194, 200, 1.0);
    _contentTextView.delegate = self;
    CALayer *nameFieldLayer3 = [_contentTextView layer];
    [nameFieldLayer3 setMasksToBounds:YES];
    [nameFieldLayer3 setCornerRadius:2.0];
    [nameFieldLayer3 setBorderWidth:1.0];
    [nameFieldLayer3 setBorderColor:[kColor(163, 163, 163, 1.0) CGColor]];
    [self.view addSubview:_contentTextView];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:_contentTextView
                                                          attribute:NSLayoutAttributeTop
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:_nameField
                                                          attribute:NSLayoutAttributeBottom
                                                         multiplier:1.0
                                                           constant:10.f]];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:_contentTextView
                                                          attribute:NSLayoutAttributeLeft
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:middleLine
                                                          attribute:NSLayoutAttributeRight
                                                         multiplier:1.0
                                                           constant:40.f]];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:_contentTextView
                                                          attribute:NSLayoutAttributeWidth
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:nil
                                                          attribute:NSLayoutAttributeNotAnAttribute
                                                         multiplier:1.0
                                                           constant:580.f]];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:_contentTextView
                                                          attribute:NSLayoutAttributeHeight
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:nil
                                                          attribute:NSLayoutAttributeNotAnAttribute
                                                         multiplier:0.0
                                                           constant:330.f]];
    
    UILabel *limiteLabel = [[UILabel alloc]init];
    limiteLabel.translatesAutoresizingMaskIntoConstraints = NO;
    limiteLabel.text = @"最多填写200个汉字";
    limiteLabel.font = [UIFont systemFontOfSize:15];
    limiteLabel.textColor = kColor(64, 63, 63, 1.0);
    self.limitLabel = limiteLabel;
    [self.view addSubview:limiteLabel];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:limiteLabel
                                                          attribute:NSLayoutAttributeTop
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:self.view
                                                          attribute:NSLayoutAttributeTop
                                                         multiplier:1.0
                                                           constant:470.f]];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:limiteLabel
                                                          attribute:NSLayoutAttributeLeft
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:middleLine
                                                          attribute:NSLayoutAttributeRight
                                                         multiplier:1.0
                                                           constant:480.f]];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:limiteLabel
                                                          attribute:NSLayoutAttributeWidth
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:nil
                                                          attribute:NSLayoutAttributeNotAnAttribute
                                                         multiplier:1.0
                                                           constant:200.f]];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:limiteLabel
                                                          attribute:NSLayoutAttributeHeight
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:nil
                                                          attribute:NSLayoutAttributeNotAnAttribute
                                                         multiplier:0.0
                                                           constant:20.f]];
    
    UIButton *submitBtn = [[UIButton alloc]init];
    submitBtn.translatesAutoresizingMaskIntoConstraints = NO;
    [submitBtn addTarget:self action:@selector(submitClicked:) forControlEvents:UIControlEventTouchUpInside];
    [submitBtn setTitle:@"提交" forState:UIControlStateNormal];
    [submitBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [submitBtn setBackgroundColor:kColor(251, 83, 7, 1.0)];
    [self.view addSubview:submitBtn];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:submitBtn
                                                          attribute:NSLayoutAttributeTop
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:_contentTextView
                                                          attribute:NSLayoutAttributeBottom
                                                         multiplier:1.0
                                                           constant:10.f]];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:submitBtn
                                                          attribute:NSLayoutAttributeRight
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:self.view
                                                          attribute:NSLayoutAttributeRight
                                                         multiplier:1.0
                                                           constant:-100.f]];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:submitBtn
                                                          attribute:NSLayoutAttributeWidth
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:nil
                                                          attribute:NSLayoutAttributeNotAnAttribute
                                                         multiplier:1.0
                                                           constant:110.f]];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:submitBtn
                                                          attribute:NSLayoutAttributeHeight
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:nil
                                                          attribute:NSLayoutAttributeNotAnAttribute
                                                         multiplier:0.0
                                                           constant:40.f]];
    
}

-(void)ShowLoginVC
{
    AccountModel *account = [AccountTool userModel];
    NSLog(@"%@",account);
    if (account.password) {
        [self submitQuestion];
    }
    else
    {
        LoginViewController *loginC = [[LoginViewController alloc]init];
        loginC.LoginSuccessDelegate = self;
        loginC.view.frame = CGRectMake(0, 0, 320, 320);
        UINavigationController *nav = [[UINavigationController alloc]initWithRootViewController:loginC];
        nav.navigationBarHidden = YES;
        nav.modalPresentationStyle = UIModalPresentationCustom;
        nav.modalTransitionStyle = UIModalTransitionStyleCoverVertical;
        [self presentViewController:nav animated:YES completion:nil];
    }
}

-(void)LoginSuccess
{
    [self submitQuestion];
}


#pragma mark - Action
-(IBAction)submitClicked:(id)sender
{
    if (!_nameField.text || [_nameField.text isEqualToString:@""]) {
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
        hud.customView = [[UIImageView alloc] init];
        hud.mode = MBProgressHUDModeCustomView;
        [hud hide:YES afterDelay:1.f];
        hud.labelText = @"请填写姓名";
        return;
    }
    if (!_telField.text || [_telField.text isEqualToString:@""]) {
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
        hud.customView = [[UIImageView alloc] init];
        hud.mode = MBProgressHUDModeCustomView;
        [hud hide:YES afterDelay:1.f];
        hud.labelText = @"请填写联系方式";
        return;
    }
    if (!([RegularFormat isMobileNumber:_telField.text] || [RegularFormat isTelephoneNumber:_telField.text])) {
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
        hud.customView = [[UIImageView alloc] init];
        hud.mode = MBProgressHUDModeCustomView;
        [hud hide:YES afterDelay:1.f];
        hud.labelText = @"请填写正确的联系方式";
        return;
    }
    if (!_contentTextView.text || [_contentTextView.text isEqualToString:@""]) {
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
        hud.customView = [[UIImageView alloc] init];
        hud.mode = MBProgressHUDModeCustomView;
        [hud hide:YES afterDelay:1.f];
        hud.labelText = @"请输入内容";
        return;
    }
    if ([_contentTextView.text length] > 200) {
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
        hud.customView = [[UIImageView alloc] init];
        hud.mode = MBProgressHUDModeCustomView;
        [hud hide:YES afterDelay:1.f];
        hud.labelText = @"输入内容超过限制";
        return;
    }

    [self ShowLoginVC];
}

#pragma mark - Request
-(void)submitQuestion
{
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
    hud.labelText = @"加载中...";
    [NetworkInterface sendBuyIntentionWithName:_nameField.text phoneNumber:_telField.text content:_contentTextView.text finished:^(BOOL success, NSData *response) {
        NSLog(@"%@",[[NSString alloc] initWithData:response encoding:NSUTF8StringEncoding]);
        hud.customView = [[UIImageView alloc] init];
        hud.mode = MBProgressHUDModeCustomView;
        [hud hide:YES afterDelay:0.5f];
        if (success) {
            id object = [NSJSONSerialization JSONObjectWithData:response options:NSJSONReadingMutableLeaves error:nil];
            if ([object isKindOfClass:[NSDictionary class]]) {
                NSString *errorCode = [NSString stringWithFormat:@"%@",[object objectForKey:@"code"]];
                if ([errorCode intValue] == RequestFail) {
                    //返回错误代码
                    hud.labelText = [NSString stringWithFormat:@"%@",[object objectForKey:@"message"]];
                }
                else if ([errorCode intValue] == RequestSuccess) {
                    hud.labelText = @"提交成功";
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

#pragma mark - UITextView
- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
    if ([text isEqualToString:@"\n"]) {
        [textView resignFirstResponder];
        return NO;
    }
    else if ([textView.text length] + [text length] > 200 && ![text isEqualToString:@""]) {
        return NO;
    }
    return YES;
}

- (void)textViewDidChange:(UITextView *)textView {
    
    NSInteger number = 200 - [textView.text length];
    if (number < 0) {
        number = 0;
    }
    _limitLabel.text = [NSString stringWithFormat:@"最多填写%ld个汉字", number];
}


//处理键盘
-(void)textViewDidBeginEditing:(UITextView *)textView
{
    NSRange range;
    range.location = 10;
    range.length = 0;
    textView.selectedRange = range;
    
    CGRect frame = CGRectMake(textView.frame.origin.x, textView.frame.origin.y + 350, textView.frame.size.width, textView.frame.size.height);
    NSLog(@"%@",NSStringFromCGRect(frame));
    int offset = frame.origin.y + 32 - (self.view.frame.size.height - 216.0);
    NSTimeInterval animationDuration = 0.30f;
    [UIView beginAnimations:@"ResizeForKeyboard" context:nil];
    [UIView setAnimationDuration:animationDuration];
    
    if (offset > 0) {
        self.view.frame = CGRectMake(0.0f, -offset, self.view.frame.size.width, self.view.frame.size.height);
        [UIView commitAnimations];
    }
}

-(void)textViewDidEndEditing:(UITextView *)textView
{
    self.view.frame =CGRectMake(0, 64, self.view.frame.size.width, self.view.frame.size.height);
}

@end
