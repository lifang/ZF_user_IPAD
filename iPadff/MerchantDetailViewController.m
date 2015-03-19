//
//  MerchantDetailViewController.m
//  iPadff
//
//  Created by wufei on 15/3/13.
//  Copyright (c) 2015年 LanTaiPro. All rights reserved.
//

#import "MerchantDetailViewController.h"
#import "MerchantDetailModel.h"
#import "CityHandle.h"
#import "AppDelegate.h"
#import "NetworkInterface.h"
#import "EditMerchantViewController.h"


#define kImageTag   20

@interface MerchantDetailViewController ()<UITextViewDelegate>


@property (nonatomic, strong) MerchantDetailModel *merchantDetail;

@property (nonatomic, strong) UIScrollView *scrollView;

@property (nonatomic, strong) UITextView *merchantTV;
@property (nonatomic, strong) UITextView *personTV;
@property (nonatomic, strong) UITextView *person_IDTV;
@property (nonatomic, strong) UITextView *licenceTV;
@property (nonatomic, strong) UITextView *taxTV;
@property (nonatomic, strong) UITextView *organzationTV;
@property (nonatomic, strong) UITextView *locationTV;
@property (nonatomic, strong) UITextView *bankTV;
@property (nonatomic, strong) UITextView *bank_IDTV;
@property(strong,nonatomic) UIImageView * frontImgv;
@property(strong,nonatomic) UIImageView * backImgv;
@property(strong,nonatomic) UIImageView * bodyImgv;
@property(strong,nonatomic) UIImageView * licenseImgv;
@property(strong,nonatomic) UIImageView * taxImgv;
@property(strong,nonatomic) UIImageView * organzationImgv;
@property(strong,nonatomic) UIImageView * bankImgv;


@end

@implementation MerchantDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = _merchant.merchantLegal;
     self.view.backgroundColor = [UIColor whiteColor];
    
    UIButton *modifyBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    //modifyBtn.frame = CGRectMake(0, 0, 20, 44);
    modifyBtn.frame = CGRectMake(0, 0, 60, 44);
    modifyBtn.titleLabel.font = IconFontWithSize(22);
    [modifyBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
   // [modifyBtn setTitle:@"\U0000E62f" forState:UIControlStateNormal];
    [modifyBtn setTitle:@"修改" forState:UIControlStateNormal];
    [modifyBtn addTarget:self action:@selector(modifyBtnPressed:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *rightBarBtn = [[UIBarButtonItem alloc] initWithCustomView:modifyBtn];
    self.navigationItem.rightBarButtonItem = rightBarBtn;

    
    
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
    
    
    _merchantTV = [[UITextView alloc] init];
    _merchantTV.delegate = self;
    _merchantTV.clipsToBounds = YES;
    _merchantTV.layer.borderColor = [UIColor colorWithHexString:@"a8a8a8"].CGColor;
    _merchantTV.layer.borderWidth = 1.0f;
    _merchantTV.layer.cornerRadius = 3.0f;
    _merchantTV.font = FONT20;
    _merchantTV.editable=NO;
    _merchantTV.textColor = [UIColor colorWithHexString:@"6c6c6c"];
    _merchantTV.textAlignment=NSTextAlignmentCenter;
    _merchantTV.backgroundColor = [UIColor whiteColor];
    [_scrollView addSubview:_merchantTV];
    [_merchantTV makeConstraints:^(MASConstraintMaker *make) {
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
        make.top.equalTo(_scrollView.top).offset(48);
        make.left.equalTo(self.view.centerX).offset(-20);
        make.width.equalTo(@180);
        make.height.equalTo(@42);
    }];
    
    
    
    _personTV = [[UITextView alloc] init];
    _personTV.delegate = self;
    _personTV.clipsToBounds = YES;
    _personTV.layer.borderColor = [UIColor colorWithHexString:@"a8a8a8"].CGColor;
    _personTV.layer.borderWidth = 1.0f;
    _personTV.layer.cornerRadius = 3.0f;
    _personTV.font = FONT20;
    _personTV.editable=NO;
    _personTV.textColor = [UIColor colorWithHexString:@"6c6c6c"];
    _personTV.textAlignment=NSTextAlignmentCenter;
    _personTV.backgroundColor = [UIColor whiteColor];
    [_scrollView addSubview:_personTV];
    [_personTV makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(personLB.right).offset(24);
        make.right.equalTo(self.view.right).offset(-24);
        make.top.equalTo(_scrollView.top).offset(48);
        make.height.equalTo(@42);
    }];
    
    
    //*****
    
    UILabel *personIDLB=[[UILabel alloc ] init];
    personIDLB.font = FONT20;
    personIDLB.text=@"法人身份证号";
    personIDLB.textColor = [UIColor colorWithHexString:@"292929"];
    personIDLB.textAlignment=NSTextAlignmentCenter;
    [_scrollView addSubview:personIDLB];
    [personIDLB makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view.mas_left).offset(24);
        make.top.equalTo(_merchantTV.bottom).offset(48);
        make.width.equalTo(@120);
        make.height.equalTo(@42);
    }];
    
    
    _person_IDTV = [[UITextView alloc] init];
    _person_IDTV.delegate = self;
    _person_IDTV.clipsToBounds = YES;
    _person_IDTV.layer.borderColor = [UIColor colorWithHexString:@"a8a8a8"].CGColor;
    _person_IDTV.layer.borderWidth = 1.0f;
    _person_IDTV.layer.cornerRadius = 3.0f;
    _person_IDTV.font = FONT20;
    _person_IDTV.editable=NO;
    _person_IDTV.textColor = [UIColor colorWithHexString:@"6c6c6c"];
    _person_IDTV.textAlignment=NSTextAlignmentCenter;
    _person_IDTV.backgroundColor = [UIColor whiteColor];
    [_scrollView addSubview:_person_IDTV];
    [_person_IDTV makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(personIDLB.mas_right).offset(24);
        make.top.equalTo(_merchantTV.bottom).offset(48);
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
        make.left.equalTo(self.view.centerX).offset(-20);
        make.top.equalTo(_merchantTV.bottom).offset(48);
        make.width.equalTo(@180);
        make.height.equalTo(@42);
    }];
    
    _licenceTV = [[UITextView alloc] init];
    _licenceTV.delegate = self;
    _licenceTV.clipsToBounds = YES;
    _licenceTV.layer.borderColor = [UIColor colorWithHexString:@"a8a8a8"].CGColor;
    _licenceTV.layer.borderWidth = 1.0f;
    _licenceTV.layer.cornerRadius = 3.0f;
    _licenceTV.font = FONT20;
    _licenceTV.editable=NO;
    _licenceTV.textColor = [UIColor colorWithHexString:@"6c6c6c"];
    _licenceTV.textAlignment=NSTextAlignmentCenter;
    _licenceTV.backgroundColor = [UIColor whiteColor];
    [_scrollView addSubview:_licenceTV];
    [_licenceTV makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.view.right).offset(-24);
        make.top.equalTo(_merchantTV.bottom).offset(48);
        make.left.equalTo(licenceLB.right).offset(24);
        make.height.equalTo(@42);
    }];
    
    
    
    //****
    
    UILabel *taxLB=[[UILabel alloc ] init];
    taxLB.font = FONT20;
    taxLB.text=@"税务证号";
    taxLB.textColor = [UIColor colorWithHexString:@"292929"];
    taxLB.textAlignment=NSTextAlignmentCenter;
    [_scrollView addSubview:taxLB];
    [taxLB makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view.mas_left).offset(24);
        make.top.equalTo(_person_IDTV.bottom).offset(48);
        make.width.equalTo(@120);
        make.height.equalTo(@42);
    }];
    
    
    _taxTV = [[UITextView alloc] init];
    _taxTV.delegate = self;
    _taxTV.clipsToBounds = YES;
    _taxTV.layer.borderColor = [UIColor colorWithHexString:@"a8a8a8"].CGColor;
    _taxTV.layer.borderWidth = 1.0f;
    _taxTV.layer.cornerRadius = 3.0f;
    _taxTV.font = FONT20;
    _taxTV.editable=NO;
    _taxTV.textColor = [UIColor colorWithHexString:@"6c6c6c"];
    _taxTV.textAlignment=NSTextAlignmentCenter;
    _taxTV.backgroundColor = [UIColor whiteColor];
    [_scrollView addSubview:_taxTV];
    [_taxTV makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(taxLB.mas_right).offset(24);
        make.top.equalTo(_person_IDTV.bottom).offset(48);
        make.right.equalTo(self.view.centerX).offset(-44);
        make.height.equalTo(@42);
    }];
    
    
    UILabel *organzationLB=[[UILabel alloc ] init];
    organzationLB.font = FONT20;
    organzationLB.text=@"组织机构代码证书";
    organzationLB.textColor = [UIColor colorWithHexString:@"292929"];
    organzationLB.textAlignment=NSTextAlignmentCenter;
    [_scrollView addSubview:organzationLB];
    [organzationLB makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view.centerX).offset(-20);
        make.top.equalTo(_person_IDTV.bottom).offset(48);
        make.width.equalTo(@180);
        make.height.equalTo(@42);
    }];
    
    
    _organzationTV = [[UITextView alloc] init];
    _organzationTV.delegate = self;
    _organzationTV.clipsToBounds = YES;
    _organzationTV.layer.borderColor = [UIColor colorWithHexString:@"a8a8a8"].CGColor;
    _organzationTV.layer.borderWidth = 1.0f;
    _organzationTV.layer.cornerRadius = 3.0f;
    _organzationTV.font = FONT20;
    _organzationTV.editable=NO;
    _organzationTV.textColor = [UIColor colorWithHexString:@"6c6c6c"];
    _organzationTV.textAlignment=NSTextAlignmentCenter;
    _organzationTV.backgroundColor = [UIColor whiteColor];
    [_scrollView addSubview:_organzationTV];
    [_organzationTV makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.view.right).offset(-24);
        make.top.equalTo(_person_IDTV.bottom).offset(48);
        make.left.equalTo(organzationLB.right).offset(24);
        make.height.equalTo(@42);
    }];
    
    //******
    
    UILabel *locationLB=[[UILabel alloc ] init];
    locationLB.font = FONT20;
    locationLB.text=@"商户所在地";
    locationLB.textColor = [UIColor colorWithHexString:@"292929"];
    locationLB.textAlignment=NSTextAlignmentCenter;
    [_scrollView addSubview:locationLB];
    [locationLB makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view.mas_left).offset(24);
        make.top.equalTo(_taxTV.bottom).offset(48);
        make.width.equalTo(@120);
        make.height.equalTo(@42);
    }];
    
    
    _locationTV = [[UITextView alloc] init];
    _locationTV.delegate = self;
    _locationTV.clipsToBounds = YES;
    _locationTV.layer.borderColor = [UIColor colorWithHexString:@"a8a8a8"].CGColor;
    _locationTV.layer.borderWidth = 1.0f;
    _locationTV.layer.cornerRadius = 3.0f;
    _locationTV.font = FONT20;
    _locationTV.editable=NO;
    _locationTV.textColor = [UIColor colorWithHexString:@"6c6c6c"];
    _locationTV.textAlignment=NSTextAlignmentCenter;
    _locationTV.backgroundColor = [UIColor whiteColor];
    [_scrollView addSubview:_locationTV];
    [_locationTV makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(locationLB.mas_right).offset(24);
        make.top.equalTo(_taxTV.bottom).offset(48);
        make.right.equalTo(self.view.centerX).offset(-44);
        make.height.equalTo(@42);
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
        make.top.equalTo(_locationTV.bottom).offset(48);
        make.width.equalTo(@120);
        make.height.equalTo(@42);
    }];
    
    
    _bankTV = [[UITextView alloc] init];
    _bankTV.delegate = self;
    _bankTV.clipsToBounds = YES;
    _bankTV.layer.borderColor = [UIColor colorWithHexString:@"a8a8a8"].CGColor;
    _bankTV.layer.borderWidth = 1.0f;
    _bankTV.layer.cornerRadius = 3.0f;
    _bankTV.font = FONT20;
    _bankTV.editable=NO;
    _bankTV.textColor = [UIColor colorWithHexString:@"6c6c6c"];
    _bankTV.textAlignment=NSTextAlignmentCenter;
    _bankTV.backgroundColor = [UIColor whiteColor];
    [_scrollView addSubview:_bankTV];
    [_bankTV makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(bankLB.mas_right).offset(24);
        make.top.equalTo(_locationTV.bottom).offset(48);
        make.right.equalTo(self.view.centerX).offset(-44);
        make.height.equalTo(@42);
    }];
    
    UILabel *bank_IDLB=[[UILabel alloc ] init];
    bank_IDLB.font = FONT20;
    bank_IDLB.text=@"银行开户许可证号";
    bank_IDLB.textColor = [UIColor colorWithHexString:@"292929"];
    bank_IDLB.textAlignment=NSTextAlignmentCenter;
    [_scrollView addSubview:bank_IDLB];
    [bank_IDLB makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view.centerX).offset(-20);
        make.top.equalTo(_locationTV.bottom).offset(48);
        make.width.equalTo(@180);
        make.height.equalTo(@42);
    }];
    
    
    _bank_IDTV = [[UITextView alloc] init];
    _bank_IDTV.delegate = self;
    _bank_IDTV.clipsToBounds = YES;
    _bank_IDTV.layer.borderColor = [UIColor colorWithHexString:@"a8a8a8"].CGColor;
    _bank_IDTV.layer.borderWidth = 1.0f;
    _bank_IDTV.layer.cornerRadius = 3.0f;
    _bank_IDTV.font = FONT20;
    _bankTV.editable=NO;
    _bank_IDTV.textColor = [UIColor colorWithHexString:@"6c6c6c"];
    _bank_IDTV.textAlignment=NSTextAlignmentCenter;
    _bank_IDTV.backgroundColor = [UIColor whiteColor];
    [_scrollView addSubview:_bank_IDTV];
    [_bank_IDTV makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.view.right).offset(-24);
        make.top.equalTo(_locationTV.bottom).offset(48);
        make.left.equalTo(bank_IDLB.right).offset(24);
        make.height.equalTo(@42);
    }];
    
    //***
    
    UILabel *frontImageLB=[[UILabel alloc ] init];
    frontImageLB.font = FONT20;
    frontImageLB.text=@"商户法人身份证照正面";
    frontImageLB.textColor = [UIColor colorWithHexString:@"292929"];
    frontImageLB.textAlignment=NSTextAlignmentCenter;
    [_scrollView addSubview:frontImageLB];
    [frontImageLB makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view.mas_left).offset(24);
        make.top.equalTo(_bankTV.bottom).offset(48);
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
        make.top.equalTo(_bankTV.bottom).offset(48);
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
        make.top.equalTo(_bankTV.bottom).offset(48);
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
        make.top.equalTo(_bankTV.bottom).offset(48);
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
    
    
    
    //******
    
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
    
    
    //****
    
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
    
    
    
    [_scrollView layoutSubviews];
    [_scrollView setContentSize:CGSizeMake(self.view.frame.size.width, _bankImgv.frame.size.height + _bankImgv.frame.origin.y + 100)];
    
    
    
}

-(void)modifyBtnPressed:(id)sender
{
    EditMerchantViewController *editMerchantVC=[[EditMerchantViewController alloc] init];
    MerchantDetailModel *model =_merchantDetail;
    editMerchantVC.editmerchant = model;
    editMerchantVC.hidesBottomBarWhenPushed=YES;
    [self.navigationController pushViewController:editMerchantVC animated:YES];
    //[self presentViewController:editMerchantVC animated:YES completion:nil];

}


#pragma mark - Request

- (void)downloadDetail {
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
    hud.labelText = @"加载中...";
    AppDelegate *delegate = [AppDelegate shareAppDelegate];
    [NetworkInterface getMerchantDetailWithToken:delegate.token merchantID:_merchant.merchantID finished:^(BOOL success, NSData *response) {
        NSLog(@"%@",[[NSString alloc] initWithData:response encoding:NSUTF8StringEncoding]);
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
                    [hud hide:YES];
                    [self parsemerchantDetaiDataWithDictionary:object];
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



#pragma mark - Data

- (void)parsemerchantDetaiDataWithDictionary:(NSDictionary *)dict {
    if (![dict objectForKey:@"result"] || ![[dict objectForKey:@"result"] isKindOfClass:[NSDictionary class]]) {
        return;
    }
    NSDictionary *infoDict = [dict objectForKey:@"result"];
    _merchantDetail = [[MerchantDetailModel alloc] initWithParseDictionary:infoDict];
    [self.pickerView selectRow:[CityHandle getProvinceIndexWithCityID:_merchantDetail.merchantCityID] inComponent:0 animated:NO];
    [self.pickerView reloadAllComponents];
    [self.pickerView selectRow:[CityHandle getCityIndexWithCityID:_merchantDetail.merchantCityID] inComponent:1 animated:NO];
    [self get];
    
}

-(void)get
{
    _merchantTV.text = _merchantDetail.merchantName;
    _personTV.text = _merchantDetail.merchantPersonName;
    _person_IDTV.text = _merchantDetail.merchantPersonID;
    _licenceTV.text=_merchantDetail.merchantBusinessID;
    _taxTV.text = _merchantDetail.merchantTaxID;
    _organzationTV.text = _merchantDetail.merchantOrganizationID;
    _locationTV.text = [CityHandle getCityNameWithCityID:_merchantDetail.merchantCityID];
    _bankTV.text = _merchantDetail.merchantBank;
    _bank_IDTV.text= _merchantDetail.merchantBankID;
   
    /*
    [_frontImgv sd_setImageWithURL:[NSURL URLWithString:_merchantDetail.frontPath]];
    [_backImgv sd_setImageWithURL:[NSURL URLWithString:_merchantDetail.frontPath]];
    [_bodyImgv sd_setImageWithURL:[NSURL URLWithString:_merchantDetail.frontPath]];
    [_licenseImgv sd_setImageWithURL:[NSURL URLWithString:_merchantDetail.frontPath]];
    [_taxImgv sd_setImageWithURL:[NSURL URLWithString:_merchantDetail.frontPath]];
    [_organzationImgv sd_setImageWithURL:[NSURL URLWithString:_merchantDetail.frontPath]];
    [_bankImgv sd_setImageWithURL:[NSURL URLWithString:_merchantDetail.frontPath]];
     */
    
    [_frontImgv sd_setImageWithURL:[NSURL URLWithString:@"http://g.hiphotos.baidu.com/image/w%3D2048/sign=b7641b0f6509c93d07f209f7ab05f9dc/d50735fae6cd7b89e0226b820d2442a7d9330e60.jpg"]];
     [_backImgv sd_setImageWithURL:[NSURL URLWithString:@"http://g.hiphotos.baidu.com/image/w%3D2048/sign=b7641b0f6509c93d07f209f7ab05f9dc/d50735fae6cd7b89e0226b820d2442a7d9330e60.jpg"]];
     [_bodyImgv sd_setImageWithURL:[NSURL URLWithString:@"http://g.hiphotos.baidu.com/image/w%3D2048/sign=b7641b0f6509c93d07f209f7ab05f9dc/d50735fae6cd7b89e0226b820d2442a7d9330e60.jpg"]];
     [_licenseImgv sd_setImageWithURL:[NSURL URLWithString:@"http://g.hiphotos.baidu.com/image/w%3D2048/sign=b7641b0f6509c93d07f209f7ab05f9dc/d50735fae6cd7b89e0226b820d2442a7d9330e60.jpg"]];
    [_taxImgv sd_setImageWithURL:[NSURL URLWithString:@"http://g.hiphotos.baidu.com/image/w%3D2048/sign=b7641b0f6509c93d07f209f7ab05f9dc/d50735fae6cd7b89e0226b820d2442a7d9330e60.jpg"]];
     [_organzationImgv sd_setImageWithURL:[NSURL URLWithString:@"http://g.hiphotos.baidu.com/image/w%3D2048/sign=b7641b0f6509c93d07f209f7ab05f9dc/d50735fae6cd7b89e0226b820d2442a7d9330e60.jpg"]];
     [_bankImgv sd_setImageWithURL:[NSURL URLWithString:@"http://g.hiphotos.baidu.com/image/w%3D2048/sign=b7641b0f6509c93d07f209f7ab05f9dc/d50735fae6cd7b89e0226b820d2442a7d9330e60.jpg"]];
    
    
}


-(void) viewWillAppear:(BOOL)animated
{
    [self downloadDetail];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
