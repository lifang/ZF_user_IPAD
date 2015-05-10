//
//  BaseInformationViewController.m
//  iPadff
//
//  Created by 黄含章 on 15/3/13.
//  Copyright (c) 2015年 LanTaiPro. All rights reserved.
//

#import "BaseInformationViewController.h"
#import "ChangePhoneController.h"
#import "ChangeEmailController.h"
#import "NetworkInterface.h"
#import "AppDelegate.h"
#import "UserModel.h"
#import "CityHandle.h"
#import "LoginViewController.h"
#import "AccountTool.h"
#import "RegularFormat.h"
#import "ZYHomeViewController.h"

@interface BaseInformationViewController ()<UITextFieldDelegate,UIPickerViewDelegate,UIPickerViewDataSource,ChangePhoneSuccessDelegate,ChangeEmailSuccessDelegate,LoginSuccessDelegate,UIAlertViewDelegate,UIGestureRecognizerDelegate>

@property(nonatomic,strong)UIButton *exitBtn;

@property(nonatomic,strong)UITextField *nameField;

@property(nonatomic,strong)UITextField *locatonField;

@property(nonatomic,strong)UITextField *particularLocatonField;

@property(nonatomic,strong)UITextField *phoneField;

@property(nonatomic,strong)UITextField *emailField;

@property (nonatomic, strong) UserModel *userInfo;

@property (nonatomic, strong) UIToolbar *toolbar;

@property (nonatomic, strong) UIPickerView *pickerView;

@property (nonatomic, strong) NSArray *cityArray;  //pickerView 第二列

@property(nonatomic,strong)UIButton *changeEmailBtn;

@property(nonatomic,strong)UIButton *changePhoneBtn;

@property(nonatomic,strong)UIButton *makeSureEmailBtn;
@property(nonatomic,strong)NSString *authCode;


@end

@implementation BaseInformationViewController
-(void)ShowLoginVC
{
    AccountModel *account = [AccountTool userModel];
    NSLog(@"%@",account);
    if (account.password) {
        [self getUserInfo];
        self.swithView.hidden = NO;
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
    [self getUserInfo];
    self.swithView.hidden = NO;
}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [self ShowLoginVC];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self.swithView setSelectedBtnAtIndex:1];
    NSLog(@"当前是~~~~~~~~~~~~%d",self.Index);
    self.view.backgroundColor = kColor(251, 251, 251, 1.0);
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:22],NSForegroundColorAttributeName:[UIColor whiteColor]}];
    [self initAndLayoutUI];
    [self initPickerView];
}
//选择城市
- (void)initPickerView {
    //pickerView
    _toolbar = [[UIToolbar alloc] initWithFrame:CGRectMake(0, kScreenHeight, kScreenWidth, 44)];
    UIBarButtonItem *cancelItem = [[UIBarButtonItem alloc] initWithTitle:@"取消"
                                                                   style:UIBarButtonItemStyleDone
                                                                  target:self
                                                                  action:@selector(pickerScrollOut)];
    UIBarButtonItem *finishItem = [[UIBarButtonItem alloc] initWithTitle:@"完成"
                                                                   style:UIBarButtonItemStyleDone
                                                                  target:self
                                                                  action:@selector(modifyLocation:)];
    UIBarButtonItem *spaceItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace
                                                                               target:nil
                                                                               action:nil];
    spaceItem.width = 830.f;
    [_toolbar setItems:[NSArray arrayWithObjects:cancelItem,spaceItem,finishItem, nil]];
    [self.view addSubview:_toolbar];
    _pickerView = [[UIPickerView alloc] initWithFrame:CGRectMake(0, kScreenHeight, kScreenWidth, 216)];
    _pickerView.backgroundColor = kColor(244, 243, 243, 1);
    _pickerView.delegate = self;
    _pickerView.dataSource = self;
    
    [self.view addSubview:_pickerView];
}

- (IBAction)modifyLocation:(id)sender {
    [self pickerScrollOut];
    NSInteger index = [_pickerView selectedRowInComponent:1];
    NSString *cityID = [NSString stringWithFormat:@"%@",[[_cityArray objectAtIndex:index] objectForKey:@"id"]];
    NSString *cityName = [[_cityArray objectAtIndex:index] objectForKey:@"name"];
    [self modifyLocationWithCityID:cityID cityName:cityName];
}


#pragma mark - Request

//获得个人信息
- (void)getUserInfo {
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
    hud.labelText = @"加载中...";
    AppDelegate *delegate = [AppDelegate shareAppDelegate];
    [NetworkInterface getUserInfoWithToken:delegate.token userID:delegate.userID finished:^(BOOL success, NSData *response) {
        hud.customView = [[UIImageView alloc] init];
        hud.mode = MBProgressHUDModeCustomView;
        [hud hide:YES afterDelay:0.5f];
        if (success) {
            id object = [NSJSONSerialization JSONObjectWithData:response options:NSJSONReadingMutableLeaves error:nil];
            NSLog(@"!!!!!!!!!!!!!!!!!!%@",[[NSString alloc]initWithData:response encoding:NSUTF8StringEncoding]);
            if ([object isKindOfClass:[NSDictionary class]]) {
                NSString *errorCode = [object objectForKey:@"code"];
                if ([errorCode intValue] == RequestFail) {
                    //返回错误代码
                    hud.labelText = [NSString stringWithFormat:@"%@",[object objectForKey:@"message"]];
                }
                else if ([errorCode intValue] == RequestSuccess) {
                    [hud hide:YES];
                    [self parseUserDataWithDictionary:object];
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

//修改所在地
- (void)modifyLocationWithCityID:(NSString *)cityID
                        cityName:(NSString *)cityName {
//    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
//    hud.labelText = @"提交中...";
//    AppDelegate *delegate = [AppDelegate shareAppDelegate];
//    [NetworkInterface modifyUserInfoWithToken:delegate.token userID:delegate.userID username:nil mobilePhone:nil email:nil cityID:cityID finished:^(BOOL success, NSData *response) {
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
//                    
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
    _userInfo.cityID = cityID;
    _locatonField.text = [CityHandle getCityNameWithCityID:cityID];
}


- (void)parseUserDataWithDictionary:(NSDictionary *)dict {
    if (![dict objectForKey:@"result"] || ![[dict objectForKey:@"result"] isKindOfClass:[NSDictionary class]]) {
        return;
    }
    NSDictionary *infoDict = [dict objectForKey:@"result"];
    _userInfo = [[UserModel alloc] initWithParseDictionary:infoDict];
    self.IntegralNum = _userInfo.userScore;
    _nameField.text = _userInfo.userName;
    _phoneField.text = _userInfo.phoneNumber;
    _emailField.text = _userInfo.email;
    if (_userInfo.email == nil || [_userInfo.email isEqualToString:@""]) {
        CALayer *readBtnLayer2 = [_emailField layer];
        [readBtnLayer2 setMasksToBounds:YES];
        [readBtnLayer2 setCornerRadius:2.0];
        [readBtnLayer2 setBorderWidth:1.0];
        [readBtnLayer2 setBorderColor:[kColor(163, 163, 163, 1.0) CGColor]];
        _emailField.placeholder = @"请添加邮箱";
        _changeEmailBtn.hidden = YES;
        _emailField.userInteractionEnabled = YES;
        
        UIButton *makeSureEmailBtn = [[UIButton alloc]init];
        makeSureEmailBtn.translatesAutoresizingMaskIntoConstraints = NO;
        [makeSureEmailBtn setTitle:@"去验证" forState:UIControlStateNormal];
        [makeSureEmailBtn setTitleColor:kColor(251, 93, 46, 1.0) forState:UIControlStateNormal];
        [makeSureEmailBtn addTarget:self action:@selector(makeSureClicked) forControlEvents:UIControlEventTouchUpInside];
        self.makeSureEmailBtn = makeSureEmailBtn;
        [self.view addSubview:makeSureEmailBtn];
        [self.view addConstraint:[NSLayoutConstraint constraintWithItem:makeSureEmailBtn
                                                              attribute:NSLayoutAttributeTop
                                                              relatedBy:NSLayoutRelationEqual
                                                                 toItem:_phoneField
                                                              attribute:NSLayoutAttributeBottom
                                                             multiplier:1.0
                                                               constant:20.f]];
        [self.view addConstraint:[NSLayoutConstraint constraintWithItem:makeSureEmailBtn
                                                              attribute:NSLayoutAttributeLeft
                                                              relatedBy:NSLayoutRelationEqual
                                                                 toItem:self.view
                                                              attribute:NSLayoutAttributeLeft
                                                             multiplier:1.0
                                                               constant:590.f]];
        [self.view addConstraint:[NSLayoutConstraint constraintWithItem:makeSureEmailBtn
                                                              attribute:NSLayoutAttributeWidth
                                                              relatedBy:NSLayoutRelationEqual
                                                                 toItem:nil
                                                              attribute:NSLayoutAttributeNotAnAttribute
                                                             multiplier:1.0
                                                               constant:100.f]];
        [self.view addConstraint:[NSLayoutConstraint constraintWithItem:makeSureEmailBtn
                                                              attribute:NSLayoutAttributeHeight
                                                              relatedBy:NSLayoutRelationEqual
                                                                 toItem:nil
                                                              attribute:NSLayoutAttributeNotAnAttribute
                                                             multiplier:1.0
                                                               constant:40.f]];
    }
    if (_userInfo.phoneNumber == nil || [_userInfo.phoneNumber isEqualToString:@""]) {
        _phoneField.placeholder = @"请添加手机";
        _phoneField.userInteractionEnabled = YES;
        CALayer *readBtnLayer1 = [_phoneField layer];
        [readBtnLayer1 setMasksToBounds:YES];
        [readBtnLayer1 setCornerRadius:2.0];
        [readBtnLayer1 setBorderWidth:1.0];
        [readBtnLayer1 setBorderColor:[kColor(163, 163, 163, 1.0) CGColor]];
        _changePhoneBtn.hidden = YES;
    }
    _locatonField.text = [CityHandle getCityNameWithCityID: _userInfo.cityID];
    [_pickerView selectRow:[CityHandle getProvinceIndexWithCityID:_userInfo.cityID] inComponent:0 animated:NO];
    [_pickerView reloadAllComponents];
    [_pickerView selectRow:[CityHandle getCityIndexWithCityID:_userInfo.cityID] inComponent:1 animated:NO];
}

//点击了去验证邮箱
-(void)makeSureClicked
{
    if (!_emailField.text || [_emailField.text isEqualToString:@""]) {
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
        hud.customView = [[UIImageView alloc] init];
        hud.mode = MBProgressHUDModeCustomView;
        [hud hide:YES afterDelay:1.f];
        hud.labelText = @"邮箱不能为空";
        return;
    }
    if (![RegularFormat isCorrectEmail:_emailField.text]) {
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
        hud.customView = [[UIImageView alloc] init];
        hud.mode = MBProgressHUDModeCustomView;
        [hud hide:YES afterDelay:1.f];
        hud.labelText = @"邮箱格式不正确";
        return;
    }
    [self addEmail];
   
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
    particularLocationLabel.hidden = YES;
    particularLocationLabel.text = @"详细地址";
    [self setLabel:particularLocationLabel withTopView:locationLabel middleSpace:12 labelTag:1];
    
    CGFloat btnWidth = 280.f;
    CGFloat btnHeight = 40.f;
    CGFloat leftSpace = 310.f;
    
    _nameField = [[UITextField alloc]init];
    _nameField.translatesAutoresizingMaskIntoConstraints = NO;
    _nameField.borderStyle = UITextBorderStyleLine;
    _nameField.clearButtonMode = UITextFieldViewModeWhileEditing;
    _nameField.textColor = kColor(111, 111, 111, 1.0);
    _nameField.placeholder = @"请输入昵称";
    [_nameField setValue:[UIFont systemFontOfSize:18] forKeyPath:@"_placeholderLabel.font"];
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
    _phoneField.userInteractionEnabled = NO;
    _phoneField.translatesAutoresizingMaskIntoConstraints = NO;
    _phoneField.textColor = kColor(111, 111, 111, 1.0);
    _phoneField.borderStyle = UITextBorderStyleNone;
    _phoneField.clearButtonMode = UITextFieldViewModeWhileEditing;
    [_phoneField setValue:[UIFont systemFontOfSize:18] forKeyPath:@"_placeholderLabel.font"];
    [_phoneField setValue:kColor(111, 111, 111, 1.0) forKeyPath:@"_placeholderLabel.color"];
    _phoneField.delegate = self;
    _phoneField.leftViewMode = UITextFieldViewModeAlways;
    UIView *placeholderV1 = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 15, 10)];
    _phoneField.leftView = placeholderV1;
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
                                                           constant:btnWidth]];
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
    self.changePhoneBtn = changePasswordBtn;
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
    _emailField.userInteractionEnabled = NO;
    _emailField.textColor = kColor(111, 111, 111, 1.0);
    _emailField.translatesAutoresizingMaskIntoConstraints = NO;
    _emailField.borderStyle = UITextBorderStyleNone;
    _emailField.clearButtonMode = UITextFieldViewModeWhileEditing;
    [_emailField setValue:[UIFont systemFontOfSize:18] forKeyPath:@"_placeholderLabel.font"];
    [_emailField setValue:kColor(111, 111, 111, 1.0) forKeyPath:@"_placeholderLabel.color"];
    _emailField.delegate = self;
    _emailField.leftViewMode = UITextFieldViewModeAlways;
    UIView *placeholderV2 = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 15, 10)];
    _emailField.leftView = placeholderV2;
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
                                                           constant:btnWidth]];
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
    self.changeEmailBtn = changeEmailBtn;
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
    _locatonField.textColor = kColor(111, 111, 111, 1.0);
    _locatonField.userInteractionEnabled = NO;
    _locatonField.translatesAutoresizingMaskIntoConstraints = NO;
    _locatonField.borderStyle = UITextBorderStyleLine;
    _locatonField.clearButtonMode = UITextFieldViewModeWhileEditing;
    _locatonField.placeholder = @"请输入城市";
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
    _particularLocatonField.hidden = YES;
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
    self.exitBtn = exitBtn;
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
    
    UITapGestureRecognizer *tapRecognizer = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapClicked)];
    tapRecognizer.numberOfTapsRequired = 1;
    tapRecognizer.numberOfTapsRequired = 1;
    tapRecognizer.delegate = self;
    [self.view addGestureRecognizer:tapRecognizer];
    
}

-(void)tapClicked
{
    [_nameField resignFirstResponder];
    [_phoneField resignFirstResponder];
    [_emailField resignFirstResponder];
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
    [self pickerScrollIn];
}

//修改手机
-(void)changePassWord
{
    ChangePhoneController *changePhoneVC = [[ChangePhoneController alloc]init];
    changePhoneVC.ChangePhoneSuccessDelegate = self;
    changePhoneVC.oldPhoneNum = _phoneField.text;
    changePhoneVC.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:changePhoneVC animated:YES];
}

-(void)ChangePhoneNumSuccessWithNewPhoneNum:(NSString *)newPhoneNum
{
    _phoneField.text = newPhoneNum;
}
//添加邮箱
-(void)addEmail
{
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
    hud.labelText = @"提交中...";
    [NetworkInterface sendEmailChangeWithName:_nameField.text email:_emailField.text finished:^(BOOL success, NSData *response) {
        hud.customView = [[UIImageView alloc] init];
        hud.mode = MBProgressHUDModeCustomView;
        [hud hide:YES afterDelay:0.5f];
        if (success) {
            id object = [NSJSONSerialization JSONObjectWithData:response options:NSJSONReadingMutableLeaves error:nil];
            NSLog(@"~~~~~~~~~~~~~~~~~~~~~~~~~~%@",[[NSString alloc] initWithData:response encoding:NSUTF8StringEncoding]);
            if ([object isKindOfClass:[NSDictionary class]]) {
                NSString *errorCode = [object objectForKey:@"code"];
                
                if ([errorCode intValue] == RequestFail) {
                    //返回错误代码
                    hud.labelText = [NSString stringWithFormat:@"%@",[object objectForKey:@"message"]];
                }
                else if ([errorCode intValue] == RequestSuccess) {
                    ChangeEmailController *changgeEmailVC = [[ChangeEmailController alloc]init];
                    changgeEmailVC.oldEmail = _emailField.text;
                    changgeEmailVC.isAdd = NO;
                    changgeEmailVC.authCode = [object objectForKey:@"result"];
                    [self.navigationController pushViewController:changgeEmailVC animated:YES];
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
//修改邮箱
-(void)changeEmail
{
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
    hud.labelText = @"提交中...";
    [NetworkInterface sendEmailChangeWithName:_nameField.text email:_emailField.text finished:^(BOOL success, NSData *response) {
        hud.customView = [[UIImageView alloc] init];
        hud.mode = MBProgressHUDModeCustomView;
        [hud hide:YES afterDelay:0.5f];
        if (success) {
            id object = [NSJSONSerialization JSONObjectWithData:response options:NSJSONReadingMutableLeaves error:nil];
            NSLog(@"~~~~~~~~~~~~~~~~~~~~~~~~~~%@",[[NSString alloc] initWithData:response encoding:NSUTF8StringEncoding]);
            if ([object isKindOfClass:[NSDictionary class]]) {
                NSString *errorCode = [object objectForKey:@"code"];
                
                if ([errorCode intValue] == RequestFail) {
                    //返回错误代码
                    hud.labelText = [NSString stringWithFormat:@"%@",[object objectForKey:@"message"]];
                }
                else if ([errorCode intValue] == RequestSuccess) {
                    [self changeAlready:object];
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

-(void)changeAlready:(NSDictionary *)dict
{
    if (![dict objectForKey:@"result"]) {
        return;
    }
    ChangeEmailController *changeEmailVC =[[ChangeEmailController alloc]init];
    changeEmailVC.authCode = [dict objectForKey:@"result"];
    NSLog(@"$$$$$$%@",[dict objectForKey:@"result"]);
    changeEmailVC.ChangeEmailSuccessDelegate = self;
    changeEmailVC.oldEmail = _emailField.text;
    changeEmailVC.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:changeEmailVC animated:YES];

}

-(void)ChangeEmailSuccessWithEmail:(NSString *)newEmail
{
    _emailField.text = newEmail;
}
//点击了保存
-(void)saveClicked
{
    if (!_nameField.text || [_nameField.text isEqualToString:@""]) {
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
        hud.customView = [[UIImageView alloc] init];
        hud.mode = MBProgressHUDModeCustomView;
        [hud hide:YES afterDelay:1.f];
        hud.labelText = @"姓名不能为空";
        return;
    }
    if (!_locatonField.text || [_locatonField.text isEqualToString:@""]) {
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
        hud.customView = [[UIImageView alloc] init];
        hud.mode = MBProgressHUDModeCustomView;
        [hud hide:YES afterDelay:1.f];
        hud.labelText = @"所在地不能为空";
        return;
    }
    [self saveDate];
}

-(void)saveDate
{
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
    hud.labelText = @"提交中...";
    AppDelegate *delegate = [AppDelegate shareAppDelegate];
    [NetworkInterface modifyUserInfoWithToken:delegate.token userID:delegate.userID username:_nameField.text mobilePhone:nil email:nil cityID:_userInfo.cityID finished:^(BOOL success, NSData *response) {
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
                    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示信息"
                                                                    message:@"用户信息修改成功"
                                                                   delegate:self
                                                          cancelButtonTitle:@"确定"
                                                          otherButtonTitles:nil];
                    [alert show];
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
//点击了退出
-(void)exitClicke
{
    UIAlertView *alertV = [[UIAlertView alloc]initWithTitle:nil message:@"您确定要退出吗？" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:@"取消", nil];
    alertV.tag = 9090;
    [alertV show];
}

#pragma mark - uialertView Delegate
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 0 && alertView.tag == 9090) {
        AppDelegate *delegate = [AppDelegate shareAppDelegate];
        [delegate clearLoginInfo];
        [delegate.tabBarViewController setSeletedIndex:0];
//        [self.navigationController popToRootViewControllerAnimated:YES];
        _nameField.text = nil;
        _phoneField.text = nil;
        _emailField.text = nil;
        _locatonField.text = nil;
    }
}

#pragma mark - UIPickerView

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return 2;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    if (component == 0) {
        return [[CityHandle shareProvinceList] count];
    }
    else {
        NSInteger provinceIndex = [pickerView selectedRowInComponent:0];
        NSDictionary *provinceDict = [[CityHandle shareProvinceList] objectAtIndex:provinceIndex];
        _cityArray = [provinceDict objectForKey:@"cities"];
        return [_cityArray count];
    }
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    if (component == 0) {
        //省
        NSDictionary *provinceDict = [[CityHandle shareProvinceList] objectAtIndex:row];
        return [provinceDict objectForKey:@"name"];
    }
    else {
        //市
        return [[_cityArray objectAtIndex:row] objectForKey:@"name"];
    }
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    if (component == 0) {
        //省
        [_pickerView reloadComponent:1];
    }
}


#pragma mark - UIPickerView

- (void)pickerScrollIn {
    _exitBtn.hidden = YES;
    CGFloat wide;
    CGFloat height;
    if(iOS7)
    {
        wide=SCREEN_HEIGHT;
        height=SCREEN_WIDTH;
    }
    else
    {  wide=SCREEN_WIDTH;
        height=SCREEN_HEIGHT;
    }
    [UIView animateWithDuration:.3f animations:^{
        _toolbar.frame = CGRectMake(0, height - 260, wide, 44);
        _pickerView.frame = CGRectMake(0, height - 216, wide, 216);
    }];
}

- (void)pickerScrollOut {
    self.exitBtn.hidden = NO;
    CGFloat wide;
    CGFloat height;
    if(iOS7)
    {
        wide=SCREEN_HEIGHT;
        height=SCREEN_WIDTH;
    }
    else
    {  wide=SCREEN_WIDTH;
        height=SCREEN_HEIGHT;
    }
    
    [UIView animateWithDuration:.3f animations:^{
        _toolbar.frame = CGRectMake(0, height, wide, 44);
        _pickerView.frame = CGRectMake(0, height, wide, 216);
    }];
}


@end
