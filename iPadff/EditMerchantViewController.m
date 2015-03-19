//
//  EditMerchantViewController.m
//  iPadff
//
//  Created by wufei on 15/3/13.
//  Copyright (c) 2015年 LanTaiPro. All rights reserved.
//

#import "EditMerchantViewController.h"
#import "NetworkInterface.h"
#import "AppDelegate.h"


@interface EditMerchantViewController ()<UITextFieldDelegate,UIAlertViewDelegate>


@property (nonatomic, strong) UIScrollView *scrollView;

@property (nonatomic, strong) UITextField *merchantTF;
@property (nonatomic, strong) UITextField *personTF;
@property (nonatomic, strong) UITextField *person_IDTF;
@property (nonatomic, strong) UITextField *licenceTF;
@property (nonatomic, strong) UITextField *taxTF;
@property (nonatomic, strong) UITextField *organzationTF;
@property (nonatomic, strong) UITextField *locationTF;
@property (nonatomic, strong) UITextField *bankTF;
@property (nonatomic, strong) UITextField *bank_IDTF;
@property(strong,nonatomic) UIButton * locationBtn;

@property(strong,nonatomic) UIImageView * frontImgv;
@property(strong,nonatomic) UIImageView * backImgv;
@property(strong,nonatomic) UIImageView * bodyImgv;
@property(strong,nonatomic) UIImageView * licenseImgv;
@property(strong,nonatomic) UIImageView * taxImgv;
@property(strong,nonatomic) UIImageView * organzationImgv;
@property(strong,nonatomic) UIImageView * bankImgv;
@property(strong,nonatomic) UIButton * saveBtn;

@property (nonatomic, strong) NSMutableDictionary *imageDict; //保存上传的图片地址
@property (nonatomic, strong) NSString *cityID;

@property(strong,nonatomic) UITapGestureRecognizer * TAP;
@property(strong,nonatomic) UIActivityIndicatorView * indicatorView;


@end

@implementation EditMerchantViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"修改商户信息";
    // self.navigationController.hidesBottomBarWhenPushed=YES;
     self.view.backgroundColor = [UIColor whiteColor];
    
    _scrollView = [[UIScrollView alloc] init];
    [self.view addSubview:_scrollView];
    [_scrollView makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view.mas_top);
        make.bottom.equalTo(self.view.mas_bottom);
        make.left.equalTo(self.view.mas_left);
        make.right.equalTo(self.view.mas_right);
    }];
    
    UILabel *merchantLB=[[UILabel alloc ] init];
    merchantLB.font = FONT20;
    merchantLB.text=@"店铺名称";
    merchantLB.textColor = [UIColor colorWithHexString:@"292929"];
    merchantLB.textAlignment=NSTextAlignmentCenter;
    [_scrollView addSubview:merchantLB];
    [merchantLB makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view.mas_left).offset(24);
        make.top.equalTo(_scrollView.top).offset(48);
        make.width.equalTo(@120);
        make.height.equalTo(@42);
    }];
    
    
    _merchantTF = [[UITextField alloc] init];
    _merchantTF.delegate = self;
    _merchantTF.clipsToBounds = YES;
    _merchantTF.layer.borderColor = [UIColor colorWithHexString:@"a8a8a8"].CGColor;
    _merchantTF.layer.borderWidth = 1.0f;
    _merchantTF.layer.cornerRadius = 3.0f;
    _merchantTF.font = FONT20;
    _merchantTF.placeholder = @"地域+经营商铺名+行业";
    _merchantTF.textAlignment=NSTextAlignmentCenter;
    _merchantTF.textColor = [UIColor colorWithHexString:@"6c6c6c"];
    _merchantTF.backgroundColor = [UIColor whiteColor];
    [_scrollView addSubview:_merchantTF];
    [_merchantTF makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(merchantLB.mas_right).offset(24);
        make.top.equalTo(_scrollView.top).offset(48);
        make.right.equalTo(self.view.centerX).offset(-44);
        make.height.equalTo(@42);
    }];
    
    
    UILabel *personLB=[[UILabel alloc ] init];
    personLB.font = FONT20;
    personLB.text=@"商户法人姓名";
    personLB.textColor = [UIColor colorWithHexString:@"292929"];
    personLB.textAlignment=NSTextAlignmentCenter;
    [_scrollView addSubview:personLB];
    [personLB makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view.centerX).offset(-20);
        make.top.equalTo(_scrollView.top).offset(48);
        make.width.equalTo(@180);
        make.height.equalTo(@42);
    }];
    
    _personTF = [[UITextField alloc] init];
    _personTF.delegate = self;
    _personTF.clipsToBounds = YES;
    _personTF.layer.borderColor = [UIColor colorWithHexString:@"a8a8a8"].CGColor;
    _personTF.layer.borderWidth = 1.0f;
    _personTF.layer.cornerRadius = 3.0f;
    _personTF.font = FONT20;
    _personTF.placeholder = @"请输入法人姓名";
    _personTF.textAlignment=NSTextAlignmentCenter;
    _personTF.textColor = [UIColor colorWithHexString:@"6c6c6c"];
    _personTF.backgroundColor = [UIColor whiteColor];
    [_scrollView addSubview:_personTF];
    [_personTF makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.view.right).offset(-24);
        make.top.equalTo(_scrollView.top).offset(48);
        make.left.equalTo(personLB.right).offset(24);
        make.height.equalTo(@42);
    }];
    
    
    
    //****
    UILabel *personIDLB=[[UILabel alloc ] init];
    personIDLB.font = FONT20;
    personIDLB.text=@"法人身份证号";
    personIDLB.textColor = [UIColor colorWithHexString:@"292929"];
    personIDLB.textAlignment=NSTextAlignmentCenter;
    [_scrollView addSubview:personIDLB];
    [personIDLB makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view.mas_left).offset(24);
        make.top.equalTo(_merchantTF.bottom).offset(48);
        make.width.equalTo(@120);
        make.height.equalTo(@42);
    }];
    
    
    _person_IDTF = [[UITextField alloc] init];
    _person_IDTF.delegate = self;
    _person_IDTF.clipsToBounds = YES;
    _person_IDTF.layer.borderColor = [UIColor colorWithHexString:@"a8a8a8"].CGColor;
    _person_IDTF.layer.borderWidth = 1.0f;
    _person_IDTF.layer.cornerRadius = 3.0f;
    _person_IDTF.font = FONT20;
    _person_IDTF.placeholder = @"请输入法人身份证号";
    _person_IDTF.textAlignment=NSTextAlignmentCenter;
    _person_IDTF.textColor = [UIColor colorWithHexString:@"6c6c6c"];
    _person_IDTF.backgroundColor = [UIColor whiteColor];
    [_scrollView addSubview:_person_IDTF];
    [_person_IDTF makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(personIDLB.mas_right).offset(24);
        make.top.equalTo(_merchantTF.bottom).offset(48);
        make.right.equalTo(self.view.centerX).offset(-44);
        make.height.equalTo(@42);
    }];
    
    UILabel *licenceLB=[[UILabel alloc ] init];
    licenceLB.font = FONT20;
    licenceLB.text=@"营业执照登记号";
    licenceLB.textColor = [UIColor colorWithHexString:@"292929"];
    licenceLB.textAlignment=NSTextAlignmentCenter;
    [_scrollView addSubview:licenceLB];
    [licenceLB makeConstraints:^(MASConstraintMaker *make) {
        // make.right.equalTo(_licenceTF.left).offset(-24);
        make.left.equalTo(self.view.centerX).offset(-20);
        make.top.equalTo(_merchantTF.bottom).offset(48);
        make.width.equalTo(@180);
        make.height.equalTo(@42);
    }];
    
    _licenceTF = [[UITextField alloc] init];
    _licenceTF.delegate = self;
    _licenceTF.clipsToBounds = YES;
    _licenceTF.layer.borderColor = [UIColor colorWithHexString:@"a8a8a8"].CGColor;
    _licenceTF.layer.borderWidth = 1.0f;
    _licenceTF.layer.cornerRadius = 3.0f;
    _licenceTF.font = FONT20;
    _licenceTF.placeholder = @"请输入营业执照号";
    _licenceTF.textAlignment=NSTextAlignmentCenter;
    _licenceTF.textColor = [UIColor colorWithHexString:@"6c6c6c"];
    _licenceTF.backgroundColor = [UIColor whiteColor];
    [_scrollView addSubview:_licenceTF];
    [_licenceTF makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.view.right).offset(-24);
        make.top.equalTo(_merchantTF.bottom).offset(48);
        make.left.equalTo(licenceLB.right).offset(24);
        // make.width.equalTo(@278);
        make.height.equalTo(@42);
    }];
    
    
    
    //******
    
    UILabel *taxLB=[[UILabel alloc ] init];
    taxLB.font = FONT20;
    taxLB.text=@"税务证号";
    taxLB.textColor = [UIColor colorWithHexString:@"292929"];
    taxLB.textAlignment=NSTextAlignmentCenter;
    [_scrollView addSubview:taxLB];
    [taxLB makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view.mas_left).offset(24);
        make.top.equalTo(_person_IDTF.bottom).offset(48);
        make.width.equalTo(@120);
        make.height.equalTo(@42);
    }];
    
    
    _taxTF = [[UITextField alloc] init];
    _taxTF.delegate = self;
    _taxTF.clipsToBounds = YES;
    _taxTF.layer.borderColor = [UIColor colorWithHexString:@"a8a8a8"].CGColor;
    _taxTF.layer.borderWidth = 1.0f;
    _taxTF.layer.cornerRadius = 3.0f;
    _taxTF.font = FONT20;
    _taxTF.placeholder = @"请输入税务证号";
    _taxTF.textAlignment=NSTextAlignmentCenter;
    _taxTF.textColor = [UIColor colorWithHexString:@"6c6c6c"];
    _taxTF.backgroundColor = [UIColor whiteColor];
    [_scrollView addSubview:_taxTF];
    [_taxTF makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(taxLB.mas_right).offset(24);
        make.top.equalTo(_person_IDTF.bottom).offset(48);
        make.right.equalTo(self.view.centerX).offset(-44);
        // make.width.equalTo(@278);
        make.height.equalTo(@42);
    }];
    
    UILabel *organzationLB=[[UILabel alloc ] init];
    organzationLB.font = FONT20;
    organzationLB.text=@"组织机构代码证书";
    organzationLB.textColor = [UIColor colorWithHexString:@"292929"];
    organzationLB.textAlignment=NSTextAlignmentCenter;
    [_scrollView addSubview:organzationLB];
    [organzationLB makeConstraints:^(MASConstraintMaker *make) {
        // make.right.equalTo(_organzationTF.left).offset(-24);
        make.left.equalTo(self.view.centerX).offset(-20);
        make.top.equalTo(_person_IDTF.bottom).offset(48);
        make.width.equalTo(@180);
        make.height.equalTo(@42);
    }];
    
    
    _organzationTF = [[UITextField alloc] init];
    _organzationTF.delegate = self;
    _organzationTF.clipsToBounds = YES;
    _organzationTF.layer.borderColor = [UIColor colorWithHexString:@"a8a8a8"].CGColor;
    _organzationTF.layer.borderWidth = 1.0f;
    _organzationTF.layer.cornerRadius = 3.0f;
    _organzationTF.font = FONT20;
    _organzationTF.placeholder = @"请输入机构代码号";
    _organzationTF.textAlignment=NSTextAlignmentCenter;
    _organzationTF.textColor = [UIColor colorWithHexString:@"6c6c6c"];
    _organzationTF.backgroundColor = [UIColor whiteColor];
    [_scrollView addSubview:_organzationTF];
    [_organzationTF makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.view.right).offset(-24);
        make.top.equalTo(_person_IDTF.bottom).offset(48);
        // make.width.equalTo(@278);
        make.left.equalTo(organzationLB.right).offset(24);
        make.height.equalTo(@42);
    }];
    
    
    
    //****
    
    UILabel *locationLB=[[UILabel alloc ] init];
    locationLB.font = FONT20;
    locationLB.text=@"商户所在地";
    locationLB.textColor = [UIColor colorWithHexString:@"292929"];
    locationLB.textAlignment=NSTextAlignmentCenter;
    [_scrollView addSubview:locationLB];
    [locationLB makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view.mas_left).offset(24);
        make.top.equalTo(_taxTF.bottom).offset(48);
        make.width.equalTo(@120);
        make.height.equalTo(@42);
    }];
    
    
    _locationTF = [[UITextField alloc] init];
    _locationTF.delegate = self;
    _locationTF.clipsToBounds = YES;
    _locationTF.layer.borderColor = [UIColor colorWithHexString:@"a8a8a8"].CGColor;
    _locationTF.layer.borderWidth = 1.0f;
    _locationTF.layer.cornerRadius = 3.0f;
    _locationTF.font = FONT20;
    _locationTF.placeholder = @"请选择商户所在地";
    _locationTF.textAlignment=NSTextAlignmentCenter;
    _locationTF.textColor = [UIColor colorWithHexString:@"6c6c6c"];
    _locationTF.backgroundColor = [UIColor whiteColor];
    [_scrollView addSubview:_locationTF];
    [_locationTF makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(locationLB.mas_right).offset(24);
        make.top.equalTo(_taxTF.bottom).offset(48);
        // make.width.equalTo(@278);
        make.right.equalTo(self.view.centerX).offset(-44);
        make.height.equalTo(@42);
    }];
    
    _locationBtn = [[UIButton alloc] init];
    _locationBtn.clipsToBounds = YES;
    _locationBtn.layer.cornerRadius = 3.0f;
    [ _locationBtn setImage:[UIImage imageNamed:@"city.png"] forState:UIControlStateNormal];
    [_locationBtn addTarget:self action:@selector(locationBtnPressed:) forControlEvents:UIControlEventTouchUpInside];
    [_scrollView addSubview:_locationBtn];
    [_locationBtn makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_locationTF.left);
        make.top.equalTo(_locationTF.top);
        make.height.equalTo(@42);
        make.right.equalTo(self.view.centerX).offset(-44);
        // make.width.equalTo(@278);
    }];
    
    //***
    
    UILabel *bankLB=[[UILabel alloc ] init];
    bankLB.font = FONT20;
    bankLB.text=@"开户银行";
    bankLB.textColor = [UIColor colorWithHexString:@"292929"];
    bankLB.textAlignment=NSTextAlignmentCenter;
    [_scrollView addSubview:bankLB];
    [bankLB makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view.mas_left).offset(24);
        make.top.equalTo(_locationTF.bottom).offset(48);
        make.width.equalTo(@120);
        make.height.equalTo(@42);
    }];
    
    
    _bankTF = [[UITextField alloc] init];
    _bankTF.delegate = self;
    _bankTF.clipsToBounds = YES;
    _bankTF.layer.borderColor = [UIColor colorWithHexString:@"a8a8a8"].CGColor;
    _bankTF.layer.borderWidth = 1.0f;
    _bankTF.layer.cornerRadius = 3.0f;
    _bankTF.font = FONT20;
    _bankTF.placeholder = @"请输入开户银行";
    _bankTF.textAlignment=NSTextAlignmentCenter;
    _bankTF.textColor = [UIColor colorWithHexString:@"6c6c6c"];
    _bankTF.backgroundColor = [UIColor whiteColor];
    [_scrollView addSubview:_bankTF];
    [_bankTF makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(bankLB.mas_right).offset(24);
        make.top.equalTo(_locationTF.bottom).offset(48);
        make.right.equalTo(self.view.centerX).offset(-44);
        // make.width.equalTo(@278);
        make.height.equalTo(@42);
    }];
    
    UILabel *bank_IDLB=[[UILabel alloc ] init];
    bank_IDLB.font = FONT20;
    bank_IDLB.text=@"银行开户许可证号";
    bank_IDLB.textColor = [UIColor colorWithHexString:@"292929"];
    bank_IDLB.textAlignment=NSTextAlignmentCenter;
    [_scrollView addSubview:bank_IDLB];
    [bank_IDLB makeConstraints:^(MASConstraintMaker *make) {
        //make.right.equalTo(_bank_IDTF.left).offset(-24);
        make.top.equalTo(_locationTF.bottom).offset(48);
        make.left.equalTo(self.view.centerX).offset(-20);
        make.width.equalTo(@180);
        make.height.equalTo(@42);
    }];
    
    
    _bank_IDTF = [[UITextField alloc] init];
    _bank_IDTF.delegate = self;
    _bank_IDTF.clipsToBounds = YES;
    _bank_IDTF.layer.borderColor = [UIColor colorWithHexString:@"a8a8a8"].CGColor;
    _bank_IDTF.layer.borderWidth = 1.0f;
    _bank_IDTF.layer.cornerRadius = 3.0f;
    _bank_IDTF.font = FONT20;
    _bank_IDTF.placeholder = @"请输入银行许可证号";
    _bank_IDTF.textAlignment=NSTextAlignmentCenter;
    _bank_IDTF.textColor = [UIColor colorWithHexString:@"6c6c6c"];
    _bank_IDTF.backgroundColor = [UIColor whiteColor];
    [_scrollView addSubview:_bank_IDTF];
    [_bank_IDTF makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.view.right).offset(-24);
        make.top.equalTo(_locationTF.bottom).offset(48);
        make.left.equalTo(bank_IDLB.right).offset(24);
        make.height.equalTo(@42);
    }];
    
    
    //*****
    
    UILabel *frontImageLB=[[UILabel alloc ] init];
    frontImageLB.font = FONT20;
    frontImageLB.text=@"商户法人身份证照正面";
    frontImageLB.textColor = [UIColor colorWithHexString:@"292929"];
    frontImageLB.textAlignment=NSTextAlignmentCenter;
    [_scrollView addSubview:frontImageLB];
    [frontImageLB makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view.mas_left).offset(24);
        make.top.equalTo(_bankTF.bottom).offset(48);
        make.width.equalTo(@200);
        make.height.equalTo(@42);
    }];
    
    _frontImgv=[[UIImageView alloc] init];
    _frontImgv.layer.masksToBounds = YES;
    _frontImgv.layer.cornerRadius = 3.0f;
    _frontImgv.layer.borderWidth = 1.0f;
    _frontImgv.layer.borderColor = [UIColor colorWithHexString:LineColor].CGColor;
    [_scrollView addSubview:_frontImgv];
    [_frontImgv makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_bankTF.bottom).offset(48);
        make.left.equalTo(frontImageLB.right).offset(24);
        make.width.equalTo(@80);
        make.height.equalTo(@80);
        
    }];
    
    
    UILabel *backImageLB=[[UILabel alloc ] init];
    backImageLB.font = FONT20;
    backImageLB.text=@"商户法人身份证照背面";
    backImageLB.textColor = [UIColor colorWithHexString:@"292929"];
    backImageLB.textAlignment=NSTextAlignmentCenter;
    [_scrollView addSubview:backImageLB];
    [backImageLB makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view.centerX).offset(-20);
        make.top.equalTo(_bankTF.bottom).offset(48);
        make.width.equalTo(@200);
        make.height.equalTo(@42);
    }];
    
    _backImgv=[[UIImageView alloc] init];
    _backImgv.layer.masksToBounds = YES;
    _backImgv.layer.cornerRadius = 3.0f;
    _backImgv.layer.borderWidth = 1.0f;
    _backImgv.layer.borderColor = [UIColor colorWithHexString:LineColor].CGColor;
    [_scrollView addSubview:_backImgv];
    [_backImgv makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_bankTF.bottom).offset(48);
        make.left.equalTo(backImageLB.right).offset(24);
        make.width.equalTo(@80);
        make.height.equalTo(@80);
        
    }];
    
    
    //////
    
    UILabel *bodyImageLB=[[UILabel alloc ] init];
    bodyImageLB.font = FONT20;
    bodyImageLB.text=@"商户法人上半身照片";
    bodyImageLB.textColor = [UIColor colorWithHexString:@"292929"];
    bodyImageLB.textAlignment=NSTextAlignmentCenter;
    [_scrollView addSubview:bodyImageLB];
    [bodyImageLB makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view.mas_left).offset(24);
        make.top.equalTo(_frontImgv.bottom).offset(48);
        make.width.equalTo(@200);
        make.height.equalTo(@42);
    }];
    
    _bodyImgv=[[UIImageView alloc] init];
    _bodyImgv.layer.masksToBounds = YES;
    _bodyImgv.layer.cornerRadius = 3.0f;
    _bodyImgv.layer.borderWidth = 1.0f;
    _bodyImgv.layer.borderColor = [UIColor colorWithHexString:LineColor].CGColor;
    [_scrollView addSubview:_bodyImgv];
    [_bodyImgv makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_frontImgv.bottom).offset(48);
        make.left.equalTo(bodyImageLB.right).offset(24);
        make.width.equalTo(@80);
        make.height.equalTo(@80);
        
    }];
    
    
    UILabel *licenseImageLB=[[UILabel alloc ] init];
    licenseImageLB.font = FONT20;
    licenseImageLB.text=@"营业执照";
    licenseImageLB.textColor = [UIColor colorWithHexString:@"292929"];
    licenseImageLB.textAlignment=NSTextAlignmentCenter;
    [_scrollView addSubview:licenseImageLB];
    [licenseImageLB makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view.centerX).offset(-20);
        make.top.equalTo(_frontImgv.bottom).offset(48);
        make.width.equalTo(@200);
        make.height.equalTo(@42);
    }];
    
    _licenseImgv=[[UIImageView alloc] init];
    _licenseImgv.layer.masksToBounds = YES;
    _licenseImgv.layer.cornerRadius = 3.0f;
    _licenseImgv.layer.borderWidth = 1.0f;
    _licenseImgv.layer.borderColor = [UIColor colorWithHexString:LineColor].CGColor;
    [_scrollView addSubview:_licenseImgv];
    [_licenseImgv makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_frontImgv.bottom).offset(48);
        make.left.equalTo(licenseImageLB.right).offset(24);
        make.width.equalTo(@80);
        make.height.equalTo(@80);
        
    }];
    
    
    //
    
    UILabel *taxImageLB=[[UILabel alloc ] init];
    taxImageLB.font = FONT20;
    taxImageLB.text=@"税务照片";
    taxImageLB.textColor = [UIColor colorWithHexString:@"292929"];
    taxImageLB.textAlignment=NSTextAlignmentCenter;
    [_scrollView addSubview:taxImageLB];
    [taxImageLB makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view.mas_left).offset(24);
        make.top.equalTo(_bodyImgv.bottom).offset(48);
        make.width.equalTo(@200);
        make.height.equalTo(@42);
    }];
    
    _taxImgv=[[UIImageView alloc] init];
    _taxImgv.layer.masksToBounds = YES;
    _taxImgv.layer.cornerRadius = 3.0f;
    _taxImgv.layer.borderWidth = 1.0f;
    _taxImgv.layer.borderColor = [UIColor colorWithHexString:LineColor].CGColor;
    [_scrollView addSubview:_taxImgv];
    [_taxImgv makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_bodyImgv.bottom).offset(48);
        make.left.equalTo(taxImageLB.right).offset(24);
        make.width.equalTo(@80);
        make.height.equalTo(@80);
        
    }];
    
    UILabel *organzationImageLB=[[UILabel alloc ] init];
    organzationImageLB.font = FONT20;
    organzationImageLB.text=@"组织机构代码证照片";
    organzationImageLB.textColor = [UIColor colorWithHexString:@"292929"];
    organzationImageLB.textAlignment=NSTextAlignmentCenter;
    [_scrollView addSubview:organzationImageLB];
    [organzationImageLB makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view.centerX).offset(-20);
        make.top.equalTo(_bodyImgv.bottom).offset(48);
        make.width.equalTo(@200);
        make.height.equalTo(@42);
    }];
    
    _organzationImgv=[[UIImageView alloc] init];
    _organzationImgv.layer.masksToBounds = YES;
    _organzationImgv.layer.cornerRadius = 3.0f;
    _organzationImgv.layer.borderWidth = 1.0f;
    _organzationImgv.layer.borderColor = [UIColor colorWithHexString:LineColor].CGColor;
    [_scrollView addSubview:_organzationImgv];
    [_organzationImgv makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_bodyImgv.bottom).offset(48);
        make.left.equalTo(organzationImageLB.right).offset(24);
        make.width.equalTo(@80);
        make.height.equalTo(@80);
        
    }];
    
    
    //
    
    UILabel *bankImageLB=[[UILabel alloc ] init];
    bankImageLB.font = FONT20;
    bankImageLB.text=@"银行开户许可证照片";
    bankImageLB.textColor = [UIColor colorWithHexString:@"292929"];
    bankImageLB.textAlignment=NSTextAlignmentCenter;
    [_scrollView addSubview:bankImageLB];
    [bankImageLB makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view.mas_left).offset(24);
        make.top.equalTo(_taxImgv.bottom).offset(48);
        make.width.equalTo(@200);
        make.height.equalTo(@42);
    }];
    
    _bankImgv=[[UIImageView alloc] init];
    _bankImgv.layer.masksToBounds = YES;
    _bankImgv.layer.cornerRadius = 3.0f;
    _bankImgv.layer.borderWidth = 1.0f;
    _bankImgv.layer.borderColor = [UIColor colorWithHexString:LineColor].CGColor;
    [_scrollView addSubview:_bankImgv];
    [_bankImgv makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_taxImgv.bottom).offset(48);
        make.left.equalTo(bankImageLB.right).offset(24);
        make.width.equalTo(@80);
        make.height.equalTo(@80);
        
    }];
    
    _saveBtn = [[UIButton alloc] init];
    [_saveBtn setTitle:@"修改" forState:UIControlStateNormal];
    _saveBtn.backgroundColor=[UIColor orangeColor];
    [ _saveBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    _saveBtn.clipsToBounds = YES;
    CALayer *readBtnLayer = [_saveBtn layer];
    [readBtnLayer setMasksToBounds:YES];
    [readBtnLayer setCornerRadius:2.0];
    [readBtnLayer setBorderWidth:1.0];
    [readBtnLayer setBorderColor:[[UIColor orangeColor] CGColor]];
    [_saveBtn addTarget:self action:@selector(savePressed:) forControlEvents:UIControlEventTouchUpInside];
    [_scrollView  addSubview:_saveBtn];
    [_saveBtn makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_bankImgv.bottom).offset(48);
        make.centerX.equalTo(self.view.centerX);
        make.width.equalTo(@117);
        make.height.equalTo(@40);
    }];
    
    
    _indicatorView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    [_saveBtn addSubview:_indicatorView];
    
    [_scrollView layoutSubviews];
    [_scrollView setContentSize:CGSizeMake(self.view.frame.size.width, _saveBtn.frame.size.height + _saveBtn.frame.origin.y + 50)];
    [_indicatorView makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(_saveBtn.centerY);
        make.left.equalTo(_saveBtn.left).offset(_saveBtn.frame.size.width/2 -80);
    }];
    
    
    
    _TAP = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(touchPressed:)];
    [_scrollView setUserInteractionEnabled:YES];
    [_scrollView addGestureRecognizer:_TAP];
    
    
}

-(void)locationBtnPressed:(id)sender
{
    [self pickerDisplay];
    NSLog(@"11111222222");
}

- (void)modifyLocation:(id)sender {
    [self pickerHide];
    NSInteger index = [self.pickerView selectedRowInComponent:1];
    _cityID = [NSString stringWithFormat:@"%@",[[self.cityArray objectAtIndex:index] objectForKey:@"id"]];
    NSString *cityName = [[self.cityArray objectAtIndex:index] objectForKey:@"name"];
    _locationTF.text = cityName;
    NSLog(@"cityname:%@",cityName);
    
}



-(void) touchPressed:(UITapGestureRecognizer *)t
{
    //上传图片
    NSString *key = nil;
    BOOL hasImage = NO;
    CGPoint point  = [t locationInView:self.view];
    if(CGRectContainsPoint(_frontImgv.frame, point))
    {
        
        key = key_frontImage;
        hasImage = ([_imageDict objectForKey:key] && ![[_imageDict objectForKey:key] isEqualToString:@""]);
        [self selectedKey:key hasImage:hasImage];
        
    }
    else if(CGRectContainsPoint(_backImgv.frame, point))
    {
        key = key_backImage;
        hasImage = ([_imageDict objectForKey:key] && ![[_imageDict objectForKey:key] isEqualToString:@""]);
        [self selectedKey:key hasImage:hasImage];

        
    }
    else if(CGRectContainsPoint(_bodyImgv.frame, point))
    {
        key = key_bodyImage;
        hasImage = ([_imageDict objectForKey:key] && ![[_imageDict objectForKey:key] isEqualToString:@""]);
        [self selectedKey:key hasImage:hasImage];

    }
    else if(CGRectContainsPoint(_licenseImgv.frame, point))
    {
        key = key_licenseImage;
        hasImage = ([_imageDict objectForKey:key] && ![[_imageDict objectForKey:key] isEqualToString:@""]);
        [self selectedKey:key hasImage:hasImage];

    }
    else if(CGRectContainsPoint(_taxImgv.frame, point))
    {
        key = key_taxImage;
        hasImage = ([_imageDict objectForKey:key] && ![[_imageDict objectForKey:key] isEqualToString:@""]);
        [self selectedKey:key hasImage:hasImage];

    }
    else if(CGRectContainsPoint(_organzationImgv.frame, point))
    {
        key = key_organizationImage;
        hasImage = ([_imageDict objectForKey:key] && ![[_imageDict objectForKey:key] isEqualToString:@""]);
        [self selectedKey:key hasImage:hasImage];

        
    }
    else if(CGRectContainsPoint(_bankImgv.frame, point))
    {
        key = key_bankImage;
        hasImage = ([_imageDict objectForKey:key] && ![[_imageDict objectForKey:key] isEqualToString:@""]);
        [self selectedKey:key hasImage:hasImage];

        
    }
   // hasImage = ([_imageDict objectForKey:key] && ![[_imageDict objectForKey:key] isEqualToString:@""]);
   // [self selectedKey:key hasImage:hasImage];
    
}



-(void)savePressed:(id)sender
{
    
    
    [_merchantTF becomeFirstResponder];
    [_merchantTF resignFirstResponder];
    
    /*
    if (!_merchantTF.text || [_merchantTF.text isEqualToString:@""]) {
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
        hud.customView = [[UIImageView alloc] init];
        hud.mode = MBProgressHUDModeCustomView;
        [hud hide:YES afterDelay:1.f];
        hud.labelText = @"请输入商户名";
        return;
    }
    if (!_personTF.text || [_personTF.text isEqualToString:@""]) {
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
        hud.customView = [[UIImageView alloc] init];
        hud.mode = MBProgressHUDModeCustomView;
        [hud hide:YES afterDelay:1.f];
        hud.labelText = @"请输入法人姓名";
        return;
    }
    if (!_person_IDTF.text || [_person_IDTF.text isEqualToString:@""]) {
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
        hud.customView = [[UIImageView alloc] init];
        hud.mode = MBProgressHUDModeCustomView;
        [hud hide:YES afterDelay:1.f];
        hud.labelText = @"请输入法人身份证号";
        return;
    }
    if (!_licenceTF.text || [_licenceTF.text isEqualToString:@""]) {
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
        hud.customView = [[UIImageView alloc] init];
        hud.mode = MBProgressHUDModeCustomView;
        [hud hide:YES afterDelay:1.f];
        hud.labelText = @"请输入营业执照号";
        return;
    }
    if (!_taxTF.text || [_taxTF.text isEqualToString:@""]) {
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
        hud.customView = [[UIImageView alloc] init];
        hud.mode = MBProgressHUDModeCustomView;
        [hud hide:YES afterDelay:1.f];
        hud.labelText = @"请输入税务证号";
        return;
    }
    if (!_organzationTF.text || [_organzationTF.text isEqualToString:@""]) {
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
        hud.customView = [[UIImageView alloc] init];
        hud.mode = MBProgressHUDModeCustomView;
        [hud hide:YES afterDelay:1.f];
        hud.labelText = @"请输入组织机构代码证号";
        return;
    }
    if (!_cityID || [_cityID isEqualToString:@""]) {
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
        hud.customView = [[UIImageView alloc] init];
        hud.mode = MBProgressHUDModeCustomView;
        [hud hide:YES afterDelay:1.f];
        hud.labelText = @"请选择商户所在地";
        return;
    }
    if (!_bankTF.text || [_bankTF.text isEqualToString:@""]) {
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
        hud.customView = [[UIImageView alloc] init];
        hud.mode = MBProgressHUDModeCustomView;
        [hud hide:YES afterDelay:1.f];
        hud.labelText = @"请输入开户银行";
        return;
    }
    if (!_bank_IDTF.text || [_bank_IDTF.text isEqualToString:@""]) {
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
        hud.customView = [[UIImageView alloc] init];
        hud.mode = MBProgressHUDModeCustomView;
        [hud hide:YES afterDelay:1.f];
        hud.labelText = @"请输入银行许可证号";
        return;
    }
    if (![_imageDict objectForKey:key_frontImage] || [[_imageDict objectForKey:key_frontImage] isEqualToString:@""]) {
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
        hud.customView = [[UIImageView alloc] init];
        hud.mode = MBProgressHUDModeCustomView;
        [hud hide:YES afterDelay:1.f];
        hud.labelText = @"请上传身份证照片正面";
        return;
    }
    if (![_imageDict objectForKey:key_backImage] || [[_imageDict objectForKey:key_backImage] isEqualToString:@""]) {
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
        hud.customView = [[UIImageView alloc] init];
        hud.mode = MBProgressHUDModeCustomView;
        [hud hide:YES afterDelay:1.f];
        hud.labelText = @"请上传身份证照片背面";
        return;
    }
    if (![_imageDict objectForKey:key_bodyImage] || [[_imageDict objectForKey:key_bodyImage] isEqualToString:@""]) {
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
        hud.customView = [[UIImageView alloc] init];
        hud.mode = MBProgressHUDModeCustomView;
        [hud hide:YES afterDelay:1.f];
        hud.labelText = @"请上传法人上半身照片";
        return;
    }
    if (![_imageDict objectForKey:key_licenseImage] || [[_imageDict objectForKey:key_licenseImage] isEqualToString:@""]) {
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
        hud.customView = [[UIImageView alloc] init];
        hud.mode = MBProgressHUDModeCustomView;
        [hud hide:YES afterDelay:1.f];
        hud.labelText = @"请上传营业执照照片";
        return;
    }
    if (![_imageDict objectForKey:key_taxImage] || [[_imageDict objectForKey:key_taxImage] isEqualToString:@""]) {
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
        hud.customView = [[UIImageView alloc] init];
        hud.mode = MBProgressHUDModeCustomView;
        [hud hide:YES afterDelay:1.f];
        hud.labelText = @"请上传税务证照片";
        return;
    }
    if (![_imageDict objectForKey:key_organizationImage] || [[_imageDict objectForKey:key_organizationImage] isEqualToString:@""]) {
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
        hud.customView = [[UIImageView alloc] init];
        hud.mode = MBProgressHUDModeCustomView;
        [hud hide:YES afterDelay:1.f];
        hud.labelText = @"请上传组织机构代码证照片";
        return;
    }
    if (![_imageDict objectForKey:key_bankImage] || [[_imageDict objectForKey:key_bankImage] isEqualToString:@""]) {
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
        hud.customView = [[UIImageView alloc] init];
        hud.mode = MBProgressHUDModeCustomView;
        [hud hide:YES afterDelay:1.f];
        hud.labelText = @"请上传银行开户许可证照片";
        return;
    }
    */
    
    [self modifyUserInfo];
    
}


- (MerchantDetailModel *)newMerchantInfo {
           MerchantDetailModel *model = [[MerchantDetailModel alloc] init];
            model.merchantID = _editmerchant.merchantID;
    
            model.merchantName = _merchantTF.text;
            model.merchantPersonName = _personTF.text;
            model.merchantPersonID = _person_IDTF.text;
            model.merchantBusinessID = _licenceTF.text;
            model.merchantTaxID = _taxTF.text;
            model.merchantOrganizationID = _organzationTF.text;
            model.merchantCityID=_cityID;
            model.merchantBank = _bankTF.text;
            model.merchantBankID = _bank_IDTF.text;

    return model;
}


#pragma mark - Request

- (void)modifyUserInfo {
    MerchantDetailModel *modifyModel = [self newMerchantInfo];
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
    hud.labelText = @"提交中...";
    AppDelegate *delegate = [AppDelegate shareAppDelegate];
    [NetworkInterface modifyMerchantWithToken:delegate.token merchantDetail:modifyModel finished:^(BOOL success, NSData *response) {
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
                    hud.labelText = @"修改商户成功";
                  //  [self updateMerchant:modifyModel];
                    [self.navigationController popViewControllerAnimated:YES];
                    [[NSNotificationCenter defaultCenter] postNotificationName:EditMerchantInfoNotification object:nil];
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

-(void)viewWillAppear:(BOOL)animated
{
    _merchantTF.text=_editmerchant.merchantName ;
    _personTF.text=_editmerchant.merchantPersonName;
    _person_IDTF.text=_editmerchant.merchantPersonID;
    _licenceTF.text=_editmerchant.merchantBusinessID;
    _taxTF.text=_editmerchant.merchantTaxID;
    _organzationTF.text=_editmerchant.merchantOrganizationID;
    _locationTF.text = [CityHandle getCityNameWithCityID:_editmerchant.merchantCityID];
    _bankTF.text=_editmerchant.merchantBank;
    _bank_IDTF.text=_editmerchant.merchantBankID;
    
    /*
     [_frontImgv sd_setImageWithURL:[NSURL URLWithString:_editmerchant.frontPath]];
     [_backImgv sd_setImageWithURL:[NSURL URLWithString:_editmerchant.frontPath]];
     [_bodyImgv sd_setImageWithURL:[NSURL URLWithString:_editmerchant.frontPath]];
     [_licenseImgv sd_setImageWithURL:[NSURL URLWithString:_editmerchant.frontPath]];
     [_taxImgv sd_setImageWithURL:[NSURL URLWithString:_editmerchant.frontPath]];
     [_organzationImgv sd_setImageWithURL:[NSURL URLWithString:_editmerchant.frontPath]];
     [_bankImgv sd_setImageWithURL:[NSURL URLWithString:_editmerchant.frontPath]];
    */
    
    [_frontImgv sd_setImageWithURL:[NSURL URLWithString:@"http://g.hiphotos.baidu.com/image/w%3D2048/sign=b7641b0f6509c93d07f209f7ab05f9dc/d50735fae6cd7b89e0226b820d2442a7d9330e60.jpg"]];
    [_backImgv sd_setImageWithURL:[NSURL URLWithString:@"http://g.hiphotos.baidu.com/image/w%3D2048/sign=b7641b0f6509c93d07f209f7ab05f9dc/d50735fae6cd7b89e0226b820d2442a7d9330e60.jpg"]];
    [_bodyImgv sd_setImageWithURL:[NSURL URLWithString:@"http://g.hiphotos.baidu.com/image/w%3D2048/sign=b7641b0f6509c93d07f209f7ab05f9dc/d50735fae6cd7b89e0226b820d2442a7d9330e60.jpg"]];
    [_licenseImgv sd_setImageWithURL:[NSURL URLWithString:@"http://g.hiphotos.baidu.com/image/w%3D2048/sign=b7641b0f6509c93d07f209f7ab05f9dc/d50735fae6cd7b89e0226b820d2442a7d9330e60.jpg"]];
    [_taxImgv sd_setImageWithURL:[NSURL URLWithString:@"http://g.hiphotos.baidu.com/image/w%3D2048/sign=b7641b0f6509c93d07f209f7ab05f9dc/d50735fae6cd7b89e0226b820d2442a7d9330e60.jpg"]];
    [_organzationImgv sd_setImageWithURL:[NSURL URLWithString:@"http://g.hiphotos.baidu.com/image/w%3D2048/sign=b7641b0f6509c93d07f209f7ab05f9dc/d50735fae6cd7b89e0226b820d2442a7d9330e60.jpg"]];
    [_bankImgv sd_setImageWithURL:[NSURL URLWithString:@"http://g.hiphotos.baidu.com/image/w%3D2048/sign=b7641b0f6509c93d07f209f7ab05f9dc/d50735fae6cd7b89e0226b820d2442a7d9330e60.jpg"]];


}



#pragma mark - UITextField

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return YES;
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
