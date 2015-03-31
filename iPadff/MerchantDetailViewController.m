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
@property(strong,nonatomic) UIButton * editBtn;
@property(strong,nonatomic) UIActivityIndicatorView *indicatorView;


@property(strong,nonatomic) UIButton * frontIMGBtn;
@property(strong,nonatomic) UIButton * backIMGBtn;
@property(strong,nonatomic) UIButton * bodyIMGBtn;
@property(strong,nonatomic) UIButton * licenseIMGBtn;
@property(strong,nonatomic) UIButton * taxIMGBtn;
@property(strong,nonatomic) UIButton * organzationIMGBtn;
@property(strong,nonatomic) UIButton * bankIMGBtn;

@end

@implementation MerchantDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = _merchant.merchantLegal;
     self.view.backgroundColor = [UIColor whiteColor];
    
    /*
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
     */
    
    
    _scrollView = [[UIScrollView alloc] init];
    [self.view addSubview:_scrollView];
    if (iOS8) {

    [_scrollView makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view.mas_top);
        make.bottom.equalTo(self.view.mas_bottom);
        make.left.equalTo(self.view.mas_left);
        make.right.equalTo(self.view.mas_right);
    }];
    }
    else
    {
  
        _scrollView.frame=CGRectMake(0, 0, SCREEN_HEIGHT, SCREEN_WIDTH);
    
    
    }
    UILabel *merchantLB=[[UILabel alloc ] init];
    merchantLB.font = FONT20;
    merchantLB.text=@"店  铺  名  称";
    merchantLB.textColor = [UIColor colorWithHexString:@"292929"];
    merchantLB.textAlignment=NSTextAlignmentCenter;
    [_scrollView addSubview:merchantLB];
    [merchantLB makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view.mas_left).offset(64);
        make.top.equalTo(_scrollView.top).offset(48);
        make.width.equalTo(@120);
        make.height.equalTo(@42);
    }];
    
    
    _merchantTV = [[UITextView alloc] init];
    _merchantTV.delegate = self;
    //_merchantTV.clipsToBounds = YES;
    //_merchantTV.layer.borderColor = [UIColor colorWithHexString:@"a8a8a8"].CGColor;
    //_merchantTV.layer.borderWidth = 1.0f;
    //_merchantTV.layer.cornerRadius = 3.0f;
    _merchantTV.font = FONT21;
    _merchantTV.editable=NO;
    _merchantTV.textColor = [UIColor colorWithHexString:@"6c6c6c"];
    _merchantTV.textAlignment=NSTextAlignmentLeft;
    _merchantTV.backgroundColor = [UIColor whiteColor];
    [_scrollView addSubview:_merchantTV];
    [_merchantTV makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(merchantLB.right).offset(24);
        make.top.equalTo(_scrollView.top).offset(48);
        make.right.equalTo(self.view.centerX).offset(-44);
        make.height.equalTo(@42);
    }];
    
    UILabel *personLB=[[UILabel alloc ] init];
    personLB.font = FONT20;
    personLB.text=@"商 户 法 人 姓 名";
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
    _personTV.font = FONT21;
    _personTV.editable=NO;
    _personTV.textColor = [UIColor colorWithHexString:@"6c6c6c"];
    _personTV.textAlignment=NSTextAlignmentLeft;
    _personTV.backgroundColor = [UIColor whiteColor];
    [_scrollView addSubview:_personTV];
    [_personTV makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(personLB.right).offset(24);
        make.right.equalTo(self.view.right).offset(-64);
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
        make.left.equalTo(self.view.mas_left).offset(64);
        make.top.equalTo(_merchantTV.bottom).offset(48);
        make.width.equalTo(@120);
        make.height.equalTo(@42);
    }];
    
    
    _person_IDTV = [[UITextView alloc] init];
    _person_IDTV.delegate = self;
    _person_IDTV.clipsToBounds = YES;
    _person_IDTV.font = FONT21;
    _person_IDTV.editable=NO;
    _person_IDTV.textColor = [UIColor colorWithHexString:@"6c6c6c"];
    _person_IDTV.textAlignment=NSTextAlignmentLeft;
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
    licenceLB.text=@"营业 执照登记 号";
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
    _licenceTV.font = FONT21;
    _licenceTV.editable=NO;
    _licenceTV.textColor = [UIColor colorWithHexString:@"6c6c6c"];
    _licenceTV.textAlignment=NSTextAlignmentLeft;
    _licenceTV.backgroundColor = [UIColor whiteColor];
    [_scrollView addSubview:_licenceTV];
    [_licenceTV makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.view.right).offset(-64);
        make.top.equalTo(_merchantTV.bottom).offset(48);
        make.left.equalTo(licenceLB.right).offset(24);
        make.height.equalTo(@42);
    }];
    
    
    
    //****
    
    UILabel *taxLB=[[UILabel alloc ] init];
    taxLB.font = FONT20;
    taxLB.text=@"税  务  证  号";
    taxLB.textColor = [UIColor colorWithHexString:@"292929"];
    taxLB.textAlignment=NSTextAlignmentCenter;
    [_scrollView addSubview:taxLB];
    [taxLB makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view.mas_left).offset(64);
        make.top.equalTo(_person_IDTV.bottom).offset(48);
        make.width.equalTo(@120);
        make.height.equalTo(@42);
    }];
    
    
    _taxTV = [[UITextView alloc] init];
    _taxTV.delegate = self;
    _taxTV.clipsToBounds = YES;
    _taxTV.font = FONT21;
    _taxTV.editable=NO;
    _taxTV.textColor = [UIColor colorWithHexString:@"6c6c6c"];
    _taxTV.textAlignment=NSTextAlignmentLeft;
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
    organzationLB.text=@"组织机构代码证号";
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
    _organzationTV.font = FONT21;
    _organzationTV.editable=NO;
    _organzationTV.textColor = [UIColor colorWithHexString:@"6c6c6c"];
    _organzationTV.textAlignment=NSTextAlignmentLeft;
    _organzationTV.backgroundColor = [UIColor whiteColor];
    [_scrollView addSubview:_organzationTV];
    [_organzationTV makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.view.right).offset(-64);
        make.top.equalTo(_person_IDTV.bottom).offset(48);
        make.left.equalTo(organzationLB.right).offset(24);
        make.height.equalTo(@42);
    }];
    
    //******
    
    UILabel *locationLB=[[UILabel alloc ] init];
    locationLB.font = FONT20;
    locationLB.text=@"商 户 所在 地";
    locationLB.textColor = [UIColor colorWithHexString:@"292929"];
    locationLB.textAlignment=NSTextAlignmentCenter;
    [_scrollView addSubview:locationLB];
    [locationLB makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view.mas_left).offset(64);
        make.top.equalTo(_taxTV.bottom).offset(48);
        make.width.equalTo(@120);
        make.height.equalTo(@42);
    }];
    
    
    _locationTV = [[UITextView alloc] init];
    _locationTV.delegate = self;
    _locationTV.font = FONT21;
    _locationTV.editable=NO;
    _locationTV.textColor = [UIColor colorWithHexString:@"6c6c6c"];
    _locationTV.textAlignment=NSTextAlignmentLeft;
    _locationTV.backgroundColor = [UIColor whiteColor];
    [_scrollView addSubview:_locationTV];
    [_locationTV makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(locationLB.mas_right).offset(24);
        make.top.equalTo(_taxTV.bottom).offset(48);
        make.right.equalTo(self.view.centerX).offset(-44);
        make.height.equalTo(@42);
    }];
    
    UILabel *line1=[[UILabel alloc ] init];
    [line1 setBackgroundColor:[UIColor colorWithHexString:LineColor]];
    [_scrollView  addSubview:line1];
    [line1 makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(locationLB.bottom).offset(48);
        make.left.equalTo(locationLB.left);
        make.right.equalTo(_organzationTV.right);
        make.height.equalTo(@1);
    }];

    
    //***
    
    UILabel *bankLB=[[UILabel alloc ] init];
    bankLB.font = FONT20;
    bankLB.text=@"开  户  银  行";
    bankLB.textColor = [UIColor colorWithHexString:@"292929"];
    bankLB.textAlignment=NSTextAlignmentCenter;
    [_scrollView addSubview:bankLB];
    [bankLB makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view.mas_left).offset(64);
        make.top.equalTo(line1.bottom).offset(48);
        make.width.equalTo(@120);
        make.height.equalTo(@42);
    }];
    
    
    _bankTV = [[UITextView alloc] init];
    _bankTV.delegate = self;
    _bankTV.font = FONT21;
    _bankTV.editable=NO;
    _bankTV.textColor = [UIColor colorWithHexString:@"6c6c6c"];
    _bankTV.textAlignment=NSTextAlignmentLeft;
    _bankTV.backgroundColor = [UIColor whiteColor];
    [_scrollView addSubview:_bankTV];
    [_bankTV makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(bankLB.mas_right).offset(24);
        make.top.equalTo(line1.bottom).offset(48);
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
        make.top.equalTo(line1.bottom).offset(48);
        make.width.equalTo(@180);
        make.height.equalTo(@42);
    }];
    
    
    _bank_IDTV = [[UITextView alloc] init];
    _bank_IDTV.delegate = self;
    _bank_IDTV.font = FONT21;
    _bankTV.editable=NO;
    _bank_IDTV.textColor = [UIColor colorWithHexString:@"6c6c6c"];
    _bank_IDTV.textAlignment=NSTextAlignmentLeft;
    _bank_IDTV.backgroundColor = [UIColor whiteColor];
    [_scrollView addSubview:_bank_IDTV];
    [_bank_IDTV makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.view.right).offset(-64);
        make.top.equalTo(line1.bottom).offset(48);
        make.left.equalTo(bank_IDLB.right).offset(24);
        make.height.equalTo(@42);
    }];
    
    UILabel *line2=[[UILabel alloc ] init];
    [line2 setBackgroundColor:[UIColor colorWithHexString:LineColor]];
    [_scrollView  addSubview:line2];
    [line2 makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(bankLB.bottom).offset(48);
        make.left.equalTo(bankLB.left);
        make.right.equalTo(_bank_IDTV.right);
        make.height.equalTo(@1);
    }];

    
    //*****
    
    UILabel *frontImageLB=[[UILabel alloc ] init];
    frontImageLB.font = FONT20;
    frontImageLB.text=@"商户法人身份证照正面";
    frontImageLB.textColor = [UIColor colorWithHexString:@"292929"];
    frontImageLB.textAlignment=NSTextAlignmentLeft;
    [_scrollView addSubview:frontImageLB];
    [frontImageLB makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view.mas_left).offset(64);
        make.top.equalTo(line2.bottom).offset(48);
        make.width.equalTo(@200);
        make.height.equalTo(@42);
    }];
    
    
    /*
    _frontImgv=[[UIImageView alloc] init];
    //_frontImgv.layer.masksToBounds = YES;
    // _frontImgv.layer.cornerRadius = 3.0f;
    // _frontImgv.layer.borderWidth = 1.0f;
    //  _frontImgv.layer.borderColor = [UIColor colorWithHexString:LineColor].CGColor;
    [_frontImgv setImage:[UIImage imageNamed:@"hasimage"]];
    [_scrollView addSubview:_frontImgv];
    [_frontImgv setHidden:YES];
    [_frontImgv makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(frontImageLB.top);
        make.left.equalTo(frontImageLB.right).offset(24);
        make.width.equalTo(@42);
        make.height.equalTo(@42);
        
    }];
     */
    
    _frontIMGBtn=[[UIButton alloc] init];
    [_frontIMGBtn setBackgroundImage:[UIImage imageNamed:@"hasimage"] forState:UIControlStateNormal];
    [_frontIMGBtn addTarget:self action:@selector(BtnImagePressed:) forControlEvents:UIControlEventTouchUpInside];
    [_frontIMGBtn setHidden:YES];
    [_scrollView addSubview:_frontIMGBtn];
    [_frontIMGBtn makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(frontImageLB.top);
        make.left.equalTo(frontImageLB.right).offset(24);
        make.height.equalTo(@42);
        make.width.equalTo(@(42));
        
    }];

    
    
    
    
    UILabel *backImageLB=[[UILabel alloc ] init];
    backImageLB.font = FONT20;
    backImageLB.text=@"商户法人身份证照背面";
    backImageLB.textColor = [UIColor colorWithHexString:@"292929"];
    backImageLB.textAlignment=NSTextAlignmentLeft;
    [_scrollView addSubview:backImageLB];
    [backImageLB makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view.mas_left).offset(64);
        make.top.equalTo(frontImageLB.bottom).offset(48);
        make.width.equalTo(@200);
        make.height.equalTo(@42);
    }];
    
    
    /*
    _backImgv=[[UIImageView alloc] init];
    [_backImgv setImage:[UIImage imageNamed:@"hasimage"]];
    [_scrollView addSubview:_backImgv];
    [_backImgv setHidden:YES];
    [_backImgv makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(backImageLB.top);
        make.left.equalTo(backImageLB.right).offset(24);
        make.width.equalTo(@42);
        make.height.equalTo(@42);
        
    }];
     */
    
    
    _backIMGBtn=[[UIButton alloc] init];
    [_backIMGBtn setBackgroundImage:[UIImage imageNamed:@"hasimage"] forState:UIControlStateNormal];
    [_backIMGBtn addTarget:self action:@selector(BtnImagePressed:) forControlEvents:UIControlEventTouchUpInside];
    [_backIMGBtn setHidden:YES];
    [_scrollView addSubview:_backIMGBtn];
    [_backIMGBtn makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(backImageLB.top);
        make.left.equalTo(backImageLB.right).offset(24);
        make.height.equalTo(@42);
        make.width.equalTo(@(42));
        
    }];

    
    
    //////
    
    UILabel *bodyImageLB=[[UILabel alloc ] init];
    bodyImageLB.font = FONT20;
    bodyImageLB.text=@"商户法人上半身照片";
    bodyImageLB.textColor = [UIColor colorWithHexString:@"292929"];
    bodyImageLB.textAlignment=NSTextAlignmentLeft;
    [_scrollView addSubview:bodyImageLB];
    [bodyImageLB makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view.mas_left).offset(64);
        make.top.equalTo(backImageLB.bottom).offset(48);
        make.width.equalTo(@200);
        make.height.equalTo(@42);
    }];
    
    
    /*
    _bodyImgv=[[UIImageView alloc] init];
    [_bodyImgv setImage:[UIImage imageNamed:@"hasimage"]];
    [_scrollView addSubview:_bodyImgv];
    [_bodyImgv setHidden:YES];
    [_bodyImgv makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(bodyImageLB.top);
        make.left.equalTo(bodyImageLB.right).offset(24);
        make.width.equalTo(@42);
        make.height.equalTo(@42);
        
    }];
     */
    
    
    _bodyIMGBtn=[[UIButton alloc] init];
    [_bodyIMGBtn setBackgroundImage:[UIImage imageNamed:@"hasimage"] forState:UIControlStateNormal];
    [_bodyIMGBtn addTarget:self action:@selector(BtnImagePressed:) forControlEvents:UIControlEventTouchUpInside];
    [_bodyIMGBtn setHidden:YES];
    [_scrollView addSubview:_bodyIMGBtn];
    [_bodyIMGBtn makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(bodyImageLB.top);
        make.left.equalTo(bodyImageLB.right).offset(24);
        make.height.equalTo(@42);
        make.width.equalTo(@(42));
        
    }];

    
    ///银行开户许可证照片
    
    UILabel *bankImageLB=[[UILabel alloc ] init];
    bankImageLB.font = FONT20;
    bankImageLB.text=@"银行开户许可证照片";
    bankImageLB.textColor = [UIColor colorWithHexString:@"292929"];
    bankImageLB.textAlignment=NSTextAlignmentLeft;
    [_scrollView addSubview:bankImageLB];
    [bankImageLB makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view.mas_left).offset(64);
        make.top.equalTo(bodyImageLB.bottom).offset(48);
        make.width.equalTo(@200);
        make.height.equalTo(@42);
    }];
    
    /*
    _bankImgv=[[UIImageView alloc] init];
    [_bankImgv setImage:[UIImage imageNamed:@"hasimage"]];
    [_scrollView addSubview:_bankImgv];
    [_bankImgv setHidden:YES];
    [_bankImgv makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(bankImageLB.top);
        make.left.equalTo(bankImageLB.right).offset(24);
        make.width.equalTo(@42);
        make.height.equalTo(@42);
        
    }];
     */
    
    
    _bankIMGBtn=[[UIButton alloc] init];
    [_bankIMGBtn setBackgroundImage:[UIImage imageNamed:@"hasimage"] forState:UIControlStateNormal];
    [_bankIMGBtn addTarget:self action:@selector(BtnImagePressed:) forControlEvents:UIControlEventTouchUpInside];
    [_bankIMGBtn setHidden:YES];
    [_scrollView addSubview:_bankIMGBtn];
    [_bankIMGBtn makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(bankImageLB.top);
        make.left.equalTo(bankImageLB.right).offset(24);
        make.height.equalTo(@42);
        make.width.equalTo(@(42));
        
    }];

    
    
    //营业执照
    UILabel *licenseImageLB=[[UILabel alloc ] init];
    licenseImageLB.font = FONT20;
    licenseImageLB.text=@"营业执照照片";
    licenseImageLB.textColor = [UIColor colorWithHexString:@"292929"];
    licenseImageLB.textAlignment=NSTextAlignmentLeft;
    [_scrollView addSubview:licenseImageLB];
    [licenseImageLB makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.view.right).offset(-205);
        make.top.equalTo(line2.bottom).offset(48);
        make.width.equalTo(@200);
        make.height.equalTo(@42);
    }];
    
    /*
    _licenseImgv=[[UIImageView alloc] init];
    [_licenseImgv setImage:[UIImage imageNamed:@"hasimage"]];
    [_scrollView addSubview:_licenseImgv];
    [_licenseImgv setHidden:YES];
    [_licenseImgv makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(licenseImageLB.top);
        make.left.equalTo(licenseImageLB.right).offset(24);
        make.width.equalTo(@42);
        make.height.equalTo(@42);
        
    }];
     */
    
    
    _licenseIMGBtn=[[UIButton alloc] init];
    [_licenseIMGBtn setBackgroundImage:[UIImage imageNamed:@"hasimage"] forState:UIControlStateNormal];
    [_licenseIMGBtn addTarget:self action:@selector(BtnImagePressed:) forControlEvents:UIControlEventTouchUpInside];
    [_licenseIMGBtn setHidden:YES];
    [_scrollView addSubview:_licenseIMGBtn];
    [_licenseIMGBtn makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(licenseImageLB.top);
        make.left.equalTo(licenseImageLB.right).offset(24);
        make.height.equalTo(@42);
        make.width.equalTo(@(42));
        
    }];
    
    
    
    //
    UILabel *taxImageLB=[[UILabel alloc ] init];
    taxImageLB.font = FONT20;
    taxImageLB.text=@"税务登记证照片";
    taxImageLB.textColor = [UIColor colorWithHexString:@"292929"];
    taxImageLB.textAlignment=NSTextAlignmentLeft;
    [_scrollView addSubview:taxImageLB];
    [taxImageLB makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.view.right).offset(-205);
        make.top.equalTo(licenseImageLB.bottom).offset(48);
        make.width.equalTo(@200);
        make.height.equalTo(@42);
    }];
    
    /*
    _taxImgv=[[UIImageView alloc] init];
    [_taxImgv setImage:[UIImage imageNamed:@"hasimage"]];
    [_scrollView addSubview:_taxImgv];
    [_taxImgv setHidden:YES];
    [_taxImgv makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(taxImageLB.top);
        make.left.equalTo(taxImageLB.right).offset(24);
        make.width.equalTo(@42);
        make.height.equalTo(@42);
        
    }];
     */
    
    _taxIMGBtn=[[UIButton alloc] init];
    [_taxIMGBtn setBackgroundImage:[UIImage imageNamed:@"hasimage"] forState:UIControlStateNormal];
    [_taxIMGBtn addTarget:self action:@selector(BtnImagePressed:) forControlEvents:UIControlEventTouchUpInside];
    [_taxIMGBtn setHidden:YES];
    [_scrollView addSubview:_taxIMGBtn];
    [_taxIMGBtn makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(taxImageLB.top);
        make.left.equalTo(taxImageLB.right).offset(24);
        make.height.equalTo(@42);
        make.width.equalTo(@(42));
        
    }];

    
    //
    
    UILabel *organzationImageLB=[[UILabel alloc ] init];
    organzationImageLB.font = FONT20;
    organzationImageLB.text=@"组织机构代码证照片";
    organzationImageLB.textColor = [UIColor colorWithHexString:@"292929"];
    organzationImageLB.textAlignment=NSTextAlignmentLeft;
    [_scrollView addSubview:organzationImageLB];
    [organzationImageLB makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.view.right).offset(-205);
        make.top.equalTo(taxImageLB.bottom).offset(48);
        make.width.equalTo(@200);
        make.height.equalTo(@42);
    }];
    
    

    /*
    _organzationImgv=[[UIImageView alloc] init];
    [_organzationImgv setImage:[UIImage imageNamed:@"hasimage"]];
    [_scrollView addSubview:_organzationImgv];
    [_organzationImgv setHidden:YES];
    [_organzationImgv makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(organzationImageLB.top);
        make.left.equalTo(organzationImageLB.right).offset(24);
        make.width.equalTo(@42);
        make.height.equalTo(@42);
        
    }];
     */
    
    _organzationIMGBtn=[[UIButton alloc] init];
    [_organzationIMGBtn setBackgroundImage:[UIImage imageNamed:@"hasimage"] forState:UIControlStateNormal];
    [_organzationIMGBtn addTarget:self action:@selector(BtnImagePressed:) forControlEvents:UIControlEventTouchUpInside];
    [_organzationIMGBtn setHidden:YES];
    [_scrollView addSubview:_organzationIMGBtn];
    [_organzationIMGBtn makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(organzationImageLB.top);
        make.left.equalTo(organzationImageLB.right).offset(24);
        make.height.equalTo(@42);
        make.width.equalTo(@(42));
        
    }];
    
    
 
    
    UILabel *line3=[[UILabel alloc ] init];
    [line3 setBackgroundColor:[UIColor colorWithHexString:LineColor]];
    [_scrollView  addSubview:line3];
    [line3 makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(bankImageLB.bottom).offset(48);
        make.left.equalTo(line2.left);
        make.right.equalTo(line2.right);
        make.height.equalTo(@1);
    }];
    

    
    
    _editBtn = [[UIButton alloc] init];
    [_editBtn setTitle:@"编辑" forState:UIControlStateNormal];
    _editBtn.backgroundColor=[UIColor orangeColor];
    [ _editBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    //_editBtn.clipsToBounds = YES;
   // CALayer *readBtnLayer = [_editBtn layer];
   // [readBtnLayer setMasksToBounds:YES];
   // [readBtnLayer setCornerRadius:2.0];
   // [readBtnLayer setBorderWidth:1.0];
   // [readBtnLayer setBorderColor:[[UIColor orangeColor] CGColor]];
    [_editBtn addTarget:self action:@selector(editPressed:) forControlEvents:UIControlEventTouchUpInside];
    [_scrollView  addSubview:_editBtn];
    [_editBtn makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(line3.bottom).offset(48);
        make.centerX.equalTo(self.view.centerX);
        make.width.equalTo(@117);
        make.height.equalTo(@40);
    }];

    
    _indicatorView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    [_editBtn addSubview:_indicatorView];
    
    [_scrollView layoutSubviews];
    if (iOS8) {

    [_scrollView setContentSize:CGSizeMake(self.view.frame.size.width, _editBtn.frame.size.height + _editBtn.frame.origin.y + 50)];
    }
   
    [_indicatorView makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(_editBtn.centerY);
        make.left.equalTo(_editBtn.left).offset(_editBtn.frame.size.width/2 -80);
    }];

}

/*
-(void)modifyBtnPressed:(id)sender
{
    EditMerchantViewController *editMerchantVC=[[EditMerchantViewController alloc] init];
    MerchantDetailModel *model =_merchantDetail;
    editMerchantVC.editmerchant = model;
    editMerchantVC.hidesBottomBarWhenPushed=YES;
    [self.navigationController pushViewController:editMerchantVC animated:YES];
    //[self presentViewController:editMerchantVC animated:YES completion:nil];

}
 */

-(void)editPressed:(id)sender
{
    EditMerchantViewController *editMerchantVC=[[EditMerchantViewController alloc] init];
    MerchantDetailModel *model =_merchantDetail;
    editMerchantVC.editmerchant = model;
    editMerchantVC.hidesBottomBarWhenPushed=YES;
    [self.navigationController pushViewController:editMerchantVC animated:YES];


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
    if (_merchantDetail.frontPath) {
        [_frontIMGBtn setHidden:NO];
    }
    if (_merchantDetail.backPath) {
        [_backIMGBtn setHidden:NO];
    }
    if (_merchantDetail.bodyPath) {
        [_bodyIMGBtn setHidden:NO];
    }
    if (_merchantDetail.licensePath) {
        [_licenseIMGBtn setHidden:NO];
    }
    if (_merchantDetail.taxPath) {
        [_taxIMGBtn setHidden:NO];
    }
    if (_merchantDetail.bankPath) {
        [_bankIMGBtn setHidden:NO];
    }
    if (_merchantDetail.organizationPath) {
        [_organzationIMGBtn setHidden:NO];
    }

   
    /*
    [_frontImgv sd_setImageWithURL:[NSURL URLWithString:_merchantDetail.frontPath]];
    
    [_frontImgv sd_setImageWithURL:[NSURL URLWithString:@"http://g.hiphotos.baidu.com/image/w%3D2048/sign=b7641b0f6509c93d07f209f7ab05f9dc/d50735fae6cd7b89e0226b820d2442a7d9330e60.jpg"]];
    */
    
}

-(void)BtnImagePressed:(id)sender
{
    //[self scanBigImage];
    NSString *urlString = nil;
   
    if(sender==_frontIMGBtn)
    {
        urlString = _merchantDetail.frontPath;
        
    }
    else if(sender==_backIMGBtn)
    {
        urlString = _merchantDetail.bankPath;
        
    }
    else if(sender==_bodyIMGBtn)
    {
       
        urlString = _merchantDetail.bodyPath;
        
    }
    else if(sender==_licenseIMGBtn)
    {
         urlString = _merchantDetail.licensePath;
    }
    else if(sender==_taxIMGBtn)
    {
      
        urlString = _merchantDetail.taxPath;

    }
    else if(sender==_bankIMGBtn)
    {
         urlString = _merchantDetail.organizationPath;
        
    }
    else if(sender==_organzationIMGBtn)
    {
       
         urlString = _merchantDetail.bankPath;
    }
    [self showDetailImageWithURL:urlString imageRect:self.imageRect];

}







-(void) viewWillAppear:(BOOL)animated
{
    [self downloadDetail];
    
}

- (void)viewDidAppear:(BOOL)animated
 {
     if (iOS7) {
    
     [_scrollView setContentSize:CGSizeMake(self.view.frame.size.height, _editBtn.frame.size.height + _editBtn.frame.origin.y + 100)];
     }
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
