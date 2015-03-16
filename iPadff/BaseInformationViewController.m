//
//  BaseInformationViewController.m
//  iPadff
//
//  Created by 黄含章 on 15/3/13.
//  Copyright (c) 2015年 LanTaiPro. All rights reserved.
//

#import "BaseInformationViewController.h"

@interface BaseInformationViewController ()<UITextFieldDelegate>

@property(nonatomic,strong)UITextField *nameField;

@property(nonatomic,strong)UITextField *locatonField;

@property(nonatomic,strong)UITextField *particularLocatonField;

@property(nonatomic,strong)UITextField *phoneField;

@property(nonatomic,strong)UITextField *emailField;

@end

@implementation BaseInformationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.swithView setSelectedBtnAtIndex:1];
    NSLog(@"当前是~~~~~~~~~~~~%d",self.Index);
    self.view.backgroundColor = kColor(251, 251, 251, 1.0);
    [self initAndLayoutUI];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)initAndLayoutUI
{
    UILabel *nameLabel = [[UILabel alloc]init];
    nameLabel.text = @"姓       名";
    [self setLabel:nameLabel withTopView:self.swithView middleSpace:20 labelTag:1];
    
    UILabel *phoneLabel = [[UILabel alloc]init];
    phoneLabel.text = @"手       机";
    [self setLabel:phoneLabel withTopView:nameLabel middleSpace:12 labelTag:1];
    
    UILabel *emailLabel = [[UILabel alloc]init];
    emailLabel.text = @"邮       箱";
    [self setLabel:emailLabel withTopView:phoneLabel middleSpace:12 labelTag:1];
    
    UILabel *locationLabel = [[UILabel alloc]init];
    locationLabel.text = @"所  在  地";
    [self setLabel:locationLabel withTopView:emailLabel middleSpace:12 labelTag:1];
    
    UILabel *particularLocationLabel = [[UILabel alloc]init];
    particularLocationLabel.text = @"详细地址";
    [self setLabel:particularLocationLabel withTopView:locationLabel middleSpace:12 labelTag:1];
    
    CGFloat btnWidth = 280.f;
    CGFloat btnHeight = 40.f;
    CGFloat leftSpace = 310.f;
    
    _nameField = [[UITextField alloc]init];
    _nameField.translatesAutoresizingMaskIntoConstraints = NO;
    _nameField.borderStyle = UITextBorderStyleLine;
    _nameField.clearButtonMode = UITextFieldViewModeWhileEditing;
    _nameField.placeholder = @"王小小";
    [_nameField setValue:[UIFont systemFontOfSize:20] forKeyPath:@"_placeholderLabel.font"];
    [_nameField setValue:kColor(111, 111, 111, 1.0) forKeyPath:@"_placeholderLabel.color"];
    _nameField.delegate = self;
    _nameField.leftViewMode = UITextFieldViewModeAlways;
    UIView *placeholderV = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 15, 10)];
    _nameField.leftView = placeholderV;
    CALayer *readBtnLayer = [_nameField layer];
    [readBtnLayer setMasksToBounds:YES];
    [readBtnLayer setCornerRadius:2.0];
    [readBtnLayer setBorderWidth:1.0];
    [readBtnLayer setBorderColor:[kColor(163, 163, 163, 1.0) CGColor]];
    [self.view addSubview:_nameField];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:_nameField
                                                          attribute:NSLayoutAttributeTop
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:self.swithView
                                                          attribute:NSLayoutAttributeBottom
                                                         multiplier:1.0
                                                           constant:46.f]];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:_nameField
                                                          attribute:NSLayoutAttributeLeft
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:self.view
                                                          attribute:NSLayoutAttributeLeft
                                                         multiplier:1.0
                                                           constant:leftSpace]];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:_nameField
                                                          attribute:NSLayoutAttributeWidth
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:nil
                                                          attribute:NSLayoutAttributeNotAnAttribute
                                                         multiplier:1.0
                                                           constant:btnWidth]];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:_nameField
                                                          attribute:NSLayoutAttributeHeight
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:nil
                                                          attribute:NSLayoutAttributeNotAnAttribute
                                                         multiplier:1.0
                                                           constant:btnHeight]];
    
    _phoneField = [[UITextField alloc]init];
    _phoneField.translatesAutoresizingMaskIntoConstraints = NO;
    _phoneField.borderStyle = UITextBorderStyleNone;
    _phoneField.clearButtonMode = UITextFieldViewModeWhileEditing;
    _phoneField.placeholder = @"123456789876";
    [_phoneField setValue:[UIFont systemFontOfSize:18] forKeyPath:@"_placeholderLabel.font"];
    [_phoneField setValue:kColor(111, 111, 111, 1.0) forKeyPath:@"_placeholderLabel.color"];
    _phoneField.delegate = self;
    _phoneField.leftViewMode = UITextFieldViewModeAlways;
    UIView *placeholderV1 = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 15, 10)];
    _phoneField.leftView = placeholderV1;
    CALayer *readBtnLayer1 = [_phoneField layer];
    [readBtnLayer1 setMasksToBounds:YES];
    [readBtnLayer1 setCornerRadius:2.0];
    [readBtnLayer1 setBorderWidth:1.0];
    [readBtnLayer1 setBorderColor:[[UIColor clearColor] CGColor]];
    [self.view addSubview:_phoneField];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:_phoneField
                                                          attribute:NSLayoutAttributeTop
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:_nameField
                                                          attribute:NSLayoutAttributeBottom
                                                         multiplier:1.0
                                                           constant:18.f]];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:_phoneField
                                                          attribute:NSLayoutAttributeLeft
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:self.view
                                                          attribute:NSLayoutAttributeLeft
                                                         multiplier:1.0
                                                           constant:leftSpace]];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:_phoneField
                                                          attribute:NSLayoutAttributeWidth
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:nil
                                                          attribute:NSLayoutAttributeNotAnAttribute
                                                         multiplier:1.0
                                                           constant:btnWidth - 40.f]];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:_phoneField
                                                          attribute:NSLayoutAttributeHeight
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:nil
                                                          attribute:NSLayoutAttributeNotAnAttribute
                                                         multiplier:1.0
                                                           constant:btnHeight]];
    
    
    UIButton *changePasswordBtn = [[UIButton alloc]init];
    changePasswordBtn.translatesAutoresizingMaskIntoConstraints = NO;
    [changePasswordBtn setTitle:@"修改" forState:UIControlStateNormal];
    [changePasswordBtn setTitleColor:kColor(251, 93, 46, 1.0) forState:UIControlStateNormal];
    changePasswordBtn.titleLabel.font = [UIFont systemFontOfSize:18];
    [changePasswordBtn addTarget:self action:@selector(changePassWord) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:changePasswordBtn];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:changePasswordBtn
                                                          attribute:NSLayoutAttributeTop
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:_nameField
                                                          attribute:NSLayoutAttributeBottom
                                                         multiplier:1.0
                                                           constant:18.f]];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:changePasswordBtn
                                                          attribute:NSLayoutAttributeLeft
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:_phoneField
                                                          attribute:NSLayoutAttributeLeft
                                                         multiplier:1.0
                                                           constant:220.f]];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:changePasswordBtn
                                                          attribute:NSLayoutAttributeWidth
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:nil
                                                          attribute:NSLayoutAttributeNotAnAttribute
                                                         multiplier:1.0
                                                           constant:btnWidth/6]];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:changePasswordBtn
                                                          attribute:NSLayoutAttributeHeight
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:nil
                                                          attribute:NSLayoutAttributeNotAnAttribute
                                                         multiplier:1.0
                                                           constant:btnHeight]];
    
    _emailField = [[UITextField alloc]init];
    _emailField.translatesAutoresizingMaskIntoConstraints = NO;
    _emailField.borderStyle = UITextBorderStyleNone;
    _emailField.clearButtonMode = UITextFieldViewModeWhileEditing;
    _emailField.placeholder = @"1234567898@qq.com";
    [_emailField setValue:[UIFont systemFontOfSize:18] forKeyPath:@"_placeholderLabel.font"];
    [_emailField setValue:kColor(111, 111, 111, 1.0) forKeyPath:@"_placeholderLabel.color"];
    _emailField.delegate = self;
    _emailField.leftViewMode = UITextFieldViewModeAlways;
    UIView *placeholderV2 = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 15, 10)];
    _emailField.leftView = placeholderV2;
    CALayer *readBtnLayer2 = [_emailField layer];
    [readBtnLayer2 setMasksToBounds:YES];
    [readBtnLayer2 setCornerRadius:2.0];
    [readBtnLayer2 setBorderWidth:1.0];
    [readBtnLayer2 setBorderColor:[[UIColor clearColor] CGColor]];
    [self.view addSubview:_emailField];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:_emailField
                                                          attribute:NSLayoutAttributeTop
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:_phoneField
                                                          attribute:NSLayoutAttributeBottom
                                                         multiplier:1.0
                                                           constant:20.f]];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:_emailField
                                                          attribute:NSLayoutAttributeLeft
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:self.view
                                                          attribute:NSLayoutAttributeLeft
                                                         multiplier:1.0
                                                           constant:leftSpace]];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:_emailField
                                                          attribute:NSLayoutAttributeWidth
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:nil
                                                          attribute:NSLayoutAttributeNotAnAttribute
                                                         multiplier:1.0
                                                           constant:btnWidth - 40.f]];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:_emailField
                                                          attribute:NSLayoutAttributeHeight
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:nil
                                                          attribute:NSLayoutAttributeNotAnAttribute
                                                         multiplier:1.0
                                                           constant:btnHeight]];
    
    
    UIButton *changeEmailBtn = [[UIButton alloc]init];
    changeEmailBtn.translatesAutoresizingMaskIntoConstraints = NO;
    [changeEmailBtn setTitle:@"修改" forState:UIControlStateNormal];
    [changeEmailBtn setTitleColor:kColor(251, 93, 46, 1.0) forState:UIControlStateNormal];
    changeEmailBtn.titleLabel.font = [UIFont systemFontOfSize:18];
    [changeEmailBtn addTarget:self action:@selector(changeEmail) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:changeEmailBtn];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:changeEmailBtn
                                                          attribute:NSLayoutAttributeTop
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:_phoneField
                                                          attribute:NSLayoutAttributeBottom
                                                         multiplier:1.0
                                                           constant:20.f]];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:changeEmailBtn
                                                          attribute:NSLayoutAttributeLeft
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:_emailField
                                                          attribute:NSLayoutAttributeLeft
                                                         multiplier:1.0
                                                           constant:220.f]];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:changeEmailBtn
                                                          attribute:NSLayoutAttributeWidth
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:nil
                                                          attribute:NSLayoutAttributeNotAnAttribute
                                                         multiplier:1.0
                                                           constant:btnWidth/6]];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:changeEmailBtn
                                                          attribute:NSLayoutAttributeHeight
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:nil
                                                          attribute:NSLayoutAttributeNotAnAttribute
                                                         multiplier:1.0
                                                           constant:btnHeight]];
    
    _locatonField = [[UITextField alloc]init];
    _locatonField.translatesAutoresizingMaskIntoConstraints = NO;
    _locatonField.borderStyle = UITextBorderStyleLine;
    _locatonField.clearButtonMode = UITextFieldViewModeWhileEditing;
    _locatonField.placeholder = @"上海市";
    [_locatonField setValue:[UIFont systemFontOfSize:20] forKeyPath:@"_placeholderLabel.font"];
    [_locatonField setValue:kColor(111, 111, 111, 1.0) forKeyPath:@"_placeholderLabel.color"];
    _locatonField.delegate = self;
    _locatonField.leftViewMode = UITextFieldViewModeAlways;
    UIView *placeholderV3 = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 15, 10)];
    _locatonField.leftView = placeholderV3;
    CALayer *readBtnLayer3 = [_locatonField layer];
    [readBtnLayer3 setMasksToBounds:YES];
    [readBtnLayer3 setCornerRadius:2.0];
    [readBtnLayer3 setBorderWidth:1.0];
    [readBtnLayer3 setBorderColor:[kColor(163, 163, 163, 1.0) CGColor]];
    [self.view addSubview:_locatonField];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:_locatonField
                                                          attribute:NSLayoutAttributeTop
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:_emailField
                                                          attribute:NSLayoutAttributeBottom
                                                         multiplier:1.0
                                                           constant:20.f]];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:_locatonField
                                                          attribute:NSLayoutAttributeLeft
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:self.view
                                                          attribute:NSLayoutAttributeLeft
                                                         multiplier:1.0
                                                           constant:leftSpace]];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:_locatonField
                                                          attribute:NSLayoutAttributeWidth
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:nil
                                                          attribute:NSLayoutAttributeNotAnAttribute
                                                         multiplier:1.0
                                                           constant:btnWidth]];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:_locatonField
                                                          attribute:NSLayoutAttributeHeight
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:nil
                                                          attribute:NSLayoutAttributeNotAnAttribute
                                                         multiplier:1.0
                                                           constant:btnHeight]];
    
    UIButton *locationBtn = [[UIButton alloc]init];
    locationBtn.translatesAutoresizingMaskIntoConstraints = NO;
    [locationBtn setBackgroundImage:[UIImage imageNamed:@"arrow_line"] forState:UIControlStateNormal];
    [locationBtn addTarget:self action:@selector(locationClicked) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:locationBtn];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:locationBtn
                                                          attribute:NSLayoutAttributeTop
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:_emailField
                                                          attribute:NSLayoutAttributeBottom
                                                         multiplier:1.0
                                                           constant:20.f]];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:locationBtn
                                                          attribute:NSLayoutAttributeLeft
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:_locatonField
                                                          attribute:NSLayoutAttributeLeft
                                                         multiplier:1.0
                                                           constant:230.f]];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:locationBtn
                                                          attribute:NSLayoutAttributeWidth
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:nil
                                                          attribute:NSLayoutAttributeNotAnAttribute
                                                         multiplier:1.0
                                                           constant:btnWidth/6]];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:locationBtn
                                                          attribute:NSLayoutAttributeHeight
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:nil
                                                          attribute:NSLayoutAttributeNotAnAttribute
                                                         multiplier:1.0
                                                           constant:btnHeight]];
    
    _particularLocatonField = [[UITextField alloc]init];
    _particularLocatonField.translatesAutoresizingMaskIntoConstraints = NO;
    _particularLocatonField.borderStyle = UITextBorderStyleLine;
    _particularLocatonField.clearButtonMode = UITextFieldViewModeWhileEditing;
    _particularLocatonField.placeholder = @"上海市";
    [_particularLocatonField setValue:[UIFont systemFontOfSize:20] forKeyPath:@"_placeholderLabel.font"];
    [_particularLocatonField setValue:kColor(111, 111, 111, 1.0) forKeyPath:@"_placeholderLabel.color"];
    _particularLocatonField.delegate = self;
    _particularLocatonField.leftViewMode = UITextFieldViewModeAlways;
    UIView *placeholderV4 = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 15, 10)];
    _particularLocatonField.leftView = placeholderV4;
    CALayer *readBtnLayer4 = [_particularLocatonField layer];
    [readBtnLayer4 setMasksToBounds:YES];
    [readBtnLayer4 setCornerRadius:2.0];
    [readBtnLayer4 setBorderWidth:1.0];
    [readBtnLayer4 setBorderColor:[kColor(163, 163, 163, 1.0) CGColor]];
    [self.view addSubview:_particularLocatonField];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:_particularLocatonField
                                                          attribute:NSLayoutAttributeTop
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:_locatonField
                                                          attribute:NSLayoutAttributeBottom
                                                         multiplier:1.0
                                                           constant:20.f]];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:_particularLocatonField
                                                          attribute:NSLayoutAttributeLeft
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:self.view
                                                          attribute:NSLayoutAttributeLeft
                                                         multiplier:1.0
                                                           constant:leftSpace]];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:_particularLocatonField
                                                          attribute:NSLayoutAttributeWidth
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:nil
                                                          attribute:NSLayoutAttributeNotAnAttribute
                                                         multiplier:1.0
                                                           constant:btnWidth]];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:_particularLocatonField
                                                          attribute:NSLayoutAttributeHeight
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:nil
                                                          attribute:NSLayoutAttributeNotAnAttribute
                                                         multiplier:1.0
                                                           constant:btnHeight]];
    
    UIButton *saveBtn = [[UIButton alloc]init];
    [saveBtn addTarget:self action:@selector(saveClicked) forControlEvents:UIControlEventTouchUpInside];
    saveBtn.translatesAutoresizingMaskIntoConstraints = NO;
    [saveBtn setBackgroundColor:kColor(254, 79, 29, 1.0)];
    [saveBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [saveBtn setTitle:@"保存" forState:UIControlStateNormal];
    saveBtn.titleLabel.font = [UIFont systemFontOfSize:18];
    [self.view addSubview:saveBtn];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:saveBtn
                                                          attribute:NSLayoutAttributeTop
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:_particularLocatonField
                                                          attribute:NSLayoutAttributeBottom
                                                         multiplier:1.0
                                                           constant:60.f]];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:saveBtn
                                                          attribute:NSLayoutAttributeLeft
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:self.view
                                                          attribute:NSLayoutAttributeLeft
                                                         multiplier:1.0
                                                           constant:leftSpace]];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:saveBtn
                                                          attribute:NSLayoutAttributeWidth
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:nil
                                                          attribute:NSLayoutAttributeNotAnAttribute
                                                         multiplier:1.0
                                                           constant:btnWidth]];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:saveBtn
                                                          attribute:NSLayoutAttributeHeight
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:nil
                                                          attribute:NSLayoutAttributeNotAnAttribute
                                                         multiplier:1.0
                                                           constant:btnHeight]];
    
    UIView *lineV = [[UIView alloc]init];
    lineV.translatesAutoresizingMaskIntoConstraints = NO;
    lineV.backgroundColor = kColor(232, 231, 231, 1.0);
    [self.view addSubview:lineV];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:lineV
                                                          attribute:NSLayoutAttributeTop
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:saveBtn
                                                          attribute:NSLayoutAttributeBottom
                                                         multiplier:1.0
                                                           constant:100.f]];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:lineV
                                                          attribute:NSLayoutAttributeLeft
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:self.view
                                                          attribute:NSLayoutAttributeLeft
                                                         multiplier:1.0
                                                           constant:200.f]];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:lineV
                                                          attribute:NSLayoutAttributeWidth
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:nil
                                                          attribute:NSLayoutAttributeNotAnAttribute
                                                         multiplier:1.0
                                                           constant:740.f]];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:lineV
                                                          attribute:NSLayoutAttributeHeight
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:nil
                                                          attribute:NSLayoutAttributeNotAnAttribute
                                                         multiplier:1.0
                                                           constant:1.0]];
    
    UIButton *exitBtn = [[UIButton alloc]init];
    [exitBtn addTarget:self action:@selector(exitClicke) forControlEvents:UIControlEventTouchUpInside];
    exitBtn.translatesAutoresizingMaskIntoConstraints = NO;
    [exitBtn setBackgroundColor:kColor(254, 79, 29, 1.0)];
    [exitBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [exitBtn setTitle:@"退出" forState:UIControlStateNormal];
    exitBtn.titleLabel.font = [UIFont systemFontOfSize:18];
    [self.view addSubview:exitBtn];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:exitBtn
                                                          attribute:NSLayoutAttributeTop
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:lineV
                                                          attribute:NSLayoutAttributeBottom
                                                         multiplier:1.0
                                                           constant:40.f]];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:exitBtn
                                                          attribute:NSLayoutAttributeLeft
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:self.view
                                                          attribute:NSLayoutAttributeLeft
                                                         multiplier:1.0
                                                           constant:leftSpace]];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:exitBtn
                                                          attribute:NSLayoutAttributeWidth
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:nil
                                                          attribute:NSLayoutAttributeNotAnAttribute
                                                         multiplier:1.0
                                                           constant:btnWidth]];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:exitBtn
                                                          attribute:NSLayoutAttributeHeight
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:nil
                                                          attribute:NSLayoutAttributeNotAnAttribute
                                                         multiplier:1.0
                                                           constant:btnHeight]];
    
}

- (void)setLabel:(UILabel *)label
     withTopView:(UIView *)topView
     middleSpace:(CGFloat)space
        labelTag:(int)LabelTag{
    CGFloat labelHeight = 30.f;
    CGFloat labelWidth = 100.f;
    CGFloat leftSpace = 200.f;
    label.translatesAutoresizingMaskIntoConstraints = NO;
    label.backgroundColor = [UIColor clearColor];
    label.font = [UIFont boldSystemFontOfSize:22.f];
    label.textColor = kColor(38, 38, 38, 1.0);
    [self.view addSubview:label];
    if (LabelTag == 1) {
        [self.view addConstraint:[NSLayoutConstraint constraintWithItem:label
                                                              attribute:NSLayoutAttributeTop
                                                              relatedBy:NSLayoutRelationEqual
                                                                 toItem:topView
                                                              attribute:NSLayoutAttributeBottom
                                                             multiplier:1.0
                                                               constant:space * 2.5]];
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
}

//选择城市
-(void)locationClicked
{
    
}

//修改密码
-(void)changePassWord
{
    
}
//修改邮箱
-(void)changeEmail
{
    
}
//点击了保存
-(void)saveClicked
{
    
}
//点击了退出
-(void)exitClicke
{
    
}

@end
