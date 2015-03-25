//
//  ApplyDetailController.m
//  ZFUB
//
//  Created by 徐宝桥 on 15/3/9.
//  Copyright (c) 2015年 ___MyCompanyName___. All rights reserved.
//

#import "ApplyDetailController.h"
#import "NetworkInterface.h"
#import "AppDelegate.h"
#import "ApplyOpenModel.h"
#import "CityHandle.h"

#define kTextViewTag   111

@interface ApplyInfoCell : UITableViewCell

@property (nonatomic, strong) NSString *key;
@property (nonatomic, assign) MaterialType type;

@end

@implementation ApplyInfoCell

@end

@interface InputTextField : UITextField

@property (nonatomic, strong) NSString *key;

@end

@implementation InputTextField


@end

@interface ApplyDetailController ()<UITableViewDataSource,UITableViewDelegate,UITextFieldDelegate,UIActionSheetDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate,UIPickerViewDataSource,UIPickerViewDelegate>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) UISegmentedControl *segmentControl;

@property (nonatomic, assign) OpenApplyType applyType;  //对公 对私

@property (nonatomic, strong) ApplyOpenModel *applyData;

@property (nonatomic, strong) NSMutableDictionary *infoDict;

@property (nonatomic, strong) UILabel *brandLabel;
@property (nonatomic, strong) UILabel *modelLabel;
@property (nonatomic, strong) UILabel *terminalLabel;
@property (nonatomic, strong) UILabel *channelLabel;
@property(nonatomic,strong)UIButton *publickBtn;
@property(nonatomic,strong)UIButton *privateBtn;
@property (nonatomic, strong) UIScrollView *scrollView;

@property(nonatomic,assign)BOOL isChecked;
@property(nonatomic,assign)CGFloat publicX;
@property(nonatomic,assign)CGFloat privateX;
@property(nonatomic,assign)CGFloat privateY;

//用于记录点击的是哪一行
@property (nonatomic, strong) NSString *selectedKey;

@property (nonatomic, strong) UIPickerView *pickerView;

@property (nonatomic, strong) UIDatePicker *datePicker;

@property (nonatomic, strong) UIToolbar *toolbar;

@property (nonatomic, strong) NSArray *cityArray;  //pickerView 第二列

@property (nonatomic, strong) NSString *merchantID;
@property (nonatomic, strong) NSString *bankID;  //银行代码
@property (nonatomic, strong) NSString *channelID; //支付通道ID
@property (nonatomic, strong) NSString *billID;    //结算日期ID

//无作用 就是用来去掉cell中输入框的输入状态
@property (nonatomic, strong) UITextField *tempField;

@end

@implementation ApplyDetailController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"开通申请";
    _applyType = OpenApplyPublic;
    _infoDict = [[NSMutableDictionary alloc] init];
    _tempField = [[UITextField alloc] init];
    _tempField.hidden = YES;
    [self.view addSubview:_tempField];
    [self initAndLayoutUI];
    [self beginApply];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UI
-(void)initUIScrollView
{
    _scrollView = [[UIScrollView alloc]init];
    
    _scrollView.frame = CGRectMake(0, 80, SCREEN_WIDTH, 1000);
    if (iOS7) {
        _scrollView.frame = CGRectMake(0, 80, SCREEN_HEIGHT, 1000);
    }
    [self.view addSubview:_scrollView];
    NSArray*namesarry=[NSArray arrayWithObjects:@"姓              名",@"店   铺  名   称",@"性              别",@"选   择   生  日",@"身  份  证  号",@"联   系  电  话",@"邮              箱",@"所      在     地",@"结算银行名称",@"结算银行代码",@"结算银行账户",@"税务登记证号",@"组 织 机 构 号",@"支  付   通  道", nil];
    
    CGFloat borderSpace = 40.f;
    CGFloat topSpace = 10.f;
    CGFloat labelHeight = 20.f;
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
    
    
    _brandLabel = [[UILabel alloc] initWithFrame:CGRectMake(borderSpace+18, topSpace+20, wide/2 - borderSpace , labelHeight)];
    _brandLabel.backgroundColor = [UIColor clearColor];
    //    _brandLabel.textColor = kColor(142, 141, 141, 1);
    _brandLabel.font = [UIFont systemFontOfSize:18.f];
    [_scrollView addSubview:_brandLabel];
    _brandLabel.text=@"选择已有商户";
    
    _modelLabel = [[UILabel alloc] initWithFrame:CGRectMake(borderSpace+18, topSpace + labelHeight+20, wide/2 - borderSpace, labelHeight)];
    _modelLabel.backgroundColor = [UIColor clearColor];
    //    _modelLabel.textColor = kColor(142, 141, 141, 1);
    _modelLabel.font = [UIFont systemFontOfSize:18.f];
    [_scrollView addSubview:_modelLabel];
    _modelLabel.text=@"选择已有商户";
    
    _terminalLabel = [[UILabel alloc] initWithFrame:CGRectMake(borderSpace+18, topSpace + labelHeight * 2+20, wide/2 - borderSpace, labelHeight)];
    _terminalLabel.backgroundColor = [UIColor clearColor];
    //    _terminalLabel.textColor = kColor(142, 141, 141, 1);
    _terminalLabel.font = [UIFont systemFontOfSize:18.f];
    [_scrollView addSubview:_terminalLabel];
    _terminalLabel.text=@"选择已有商户";
    
    UILabel*accountnamelable=[[UILabel alloc]initWithFrame:CGRectMake(wide/2,topSpace + labelHeight * 2,140, 40)];
    [_scrollView addSubview:accountnamelable];
    accountnamelable.textAlignment = NSTextAlignmentCenter;
    accountnamelable.font=[UIFont systemFontOfSize:19];
    
    accountnamelable.text=@"选择已有商户";
    
    UIButton* accountnamebutton= [UIButton buttonWithType:UIButtonTypeCustom];
    accountnamebutton.frame = CGRectMake(150+wide/2,  topSpace + labelHeight * 2,280, 40);
    
    //            [_cityField setTitle:@"123" forState:UIControlStateNormal];
    [accountnamebutton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    accountnamebutton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    [accountnamebutton setImage:kImageName(@"arrow_line1") forState:UIControlStateNormal];
    CALayer *layer=[accountnamebutton  layer];
    //是否设置边框以及是否可见
    [layer setMasksToBounds:YES];
    //设置边框圆角的弧度
    
    //设置边框线的宽
    //
    [layer setBorderWidth:1];
    //设置边框线的颜色
    [layer setBorderColor:[[UIColor grayColor] CGColor]];
    accountnamebutton.contentEdgeInsets = UIEdgeInsetsMake(0,10, 0, 0);
    accountnamebutton.imageEdgeInsets = UIEdgeInsetsMake(0,220,0,0);//设置image在button上的位置（上top，左left，下bottom，右right）这里可以写负值，对上写－5，那么image就象上移动5个像素
    
    
    [accountnamebutton addTarget:self action:@selector(cityclick) forControlEvents:UIControlEventTouchUpInside];
    [_scrollView addSubview:accountnamebutton];
    
    
    
    UILabel*firestline = [[UILabel alloc] initWithFrame:CGRectMake(borderSpace+18, topSpace + labelHeight * 4+30, wide - 138, 1)];
    firestline.backgroundColor = [UIColor grayColor];
    [_scrollView addSubview:firestline];
    
    
    for(int i=0;i<namesarry.count;i++)
    {
        NSInteger row;
        row=i%2;
        NSInteger height;
        
        height=i/2;
        if(i>7)
        {
            topSpace=40;
            
            
        }
        UILabel*newaddress=[[UILabel alloc]initWithFrame:CGRectMake(40+(wide/2-40)*row, height*70+topSpace + labelHeight * 7,140, 40)];
        [_scrollView addSubview:newaddress];
        newaddress.textAlignment = NSTextAlignmentCenter;
        newaddress.font=[UIFont systemFontOfSize:18];
        
        newaddress.text=[namesarry objectAtIndex:i];
        
        if(i==2)
        {
            UIButton* _cityField = [UIButton buttonWithType:UIButtonTypeCustom];
            _cityField.frame = CGRectMake(190,  height*70+topSpace + labelHeight * 7,280, 40);
            
            //            [_cityField setTitle:@"123" forState:UIControlStateNormal];
            [_cityField setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            _cityField.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
            [_cityField setImage:kImageName(@"arrow_line1") forState:UIControlStateNormal];
            CALayer *layer=[_cityField  layer];
            //是否设置边框以及是否可见
            [layer setMasksToBounds:YES];
            //设置边框圆角的弧度
            
            //设置边框线的宽
            //
            [layer setBorderWidth:1];
            //设置边框线的颜色
            [layer setBorderColor:[[UIColor grayColor] CGColor]];
            _cityField.contentEdgeInsets = UIEdgeInsetsMake(0,10, 0, 0);
            _cityField.imageEdgeInsets = UIEdgeInsetsMake(0,220,0,0);//设置image在button上的位置（上top，左left，下bottom，右right）这里可以写负值，对上写－5，那么image就象上移动5个像素
            
            
            [_cityField addTarget:self action:@selector(cityclick) forControlEvents:UIControlEventTouchUpInside];
            [_scrollView addSubview:_cityField];
        }
        else
        {
            UITextField*neworiginaltextfield=[[UITextField alloc]initWithFrame:CGRectMake(190+(wide/2-40)*row,  height*70+topSpace + labelHeight * 7,280, 40)];
            neworiginaltextfield.tag=i+1056;
            
            [_scrollView addSubview:neworiginaltextfield];
            //        neworiginaltextfield.delegate=self;
            
            CALayer *layer=[neworiginaltextfield layer];
            //是否设置边框以及是否可见
            [layer setMasksToBounds:YES];
            //设置边框圆角的弧度
            
            //设置边框线的宽
            //
            [layer setBorderWidth:1];
            //设置边框线的颜色
            [layer setBorderColor:[[UIColor grayColor] CGColor]];
            
        }
        
        
    }
    
    UILabel*twoline = [[UILabel alloc] initWithFrame:CGRectMake(borderSpace+18,  4*70+topSpace + labelHeight *5+10, wide - 138, 1)];
    twoline.backgroundColor = [UIColor grayColor];
    [_scrollView addSubview:twoline];
    
    _scrollView.contentSize=CGSizeMake(wide, 1600);
    
}



-(void)setupHeaderView
{
    //创建头部View
    UIView *headerView = [[UIView alloc]init];
    headerView.backgroundColor = kColor(226, 226, 226, 1.0);
    headerView.frame = CGRectMake(0, 0, SCREEN_WIDTH, 80);
    if (iOS7) {
        headerView.frame = CGRectMake(0, 0, SCREEN_HEIGHT, 80);
    }
    //创建头部按钮
    UIButton *publicBtn = [[UIButton alloc]init];
    self.isChecked = YES;
    self.publickBtn = publicBtn;
    [publicBtn addTarget:self action:@selector(publicClicked) forControlEvents:UIControlEventTouchUpInside];
    publicBtn.backgroundColor = [UIColor clearColor];
    [publicBtn setBackgroundImage:[UIImage imageNamed:@"chose_Btn"] forState:UIControlStateNormal];
    publicBtn.titleLabel.font = [UIFont systemFontOfSize:22];
    [publicBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [publicBtn setTitle:@"对公" forState:UIControlStateNormal];
    publicBtn.frame = CGRectMake(headerView.frame.size.width * 0.4 , 40, 140, 40);
    self.privateY = 40;
    self.publicX = headerView.frame.size.width * 0.4;
    [headerView addSubview:publicBtn];
    
    UIButton *privateBtn = [[UIButton alloc]init];
    self.privateBtn = privateBtn;
    [privateBtn addTarget:self action:@selector(privateClicked) forControlEvents:UIControlEventTouchUpInside];
    privateBtn.backgroundColor = [UIColor clearColor];
    privateBtn.titleLabel.font = [UIFont systemFontOfSize:20];
    [privateBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [privateBtn setTitle:@"对私" forState:UIControlStateNormal];
    privateBtn.frame = CGRectMake(CGRectGetMaxX(publicBtn.frame), 44, 120, 36);
    self.privateX = CGRectGetMaxX(publicBtn.frame);
    [headerView addSubview:privateBtn];
    
    [self.view addSubview:headerView];
}
#pragma mark - Request


-(void)publicClicked
{
    if (_isChecked == YES) {
        
    }else{
        
        [_publickBtn setBackgroundImage:[UIImage imageNamed:@"chose_Btn"] forState:UIControlStateNormal];
        _publickBtn.titleLabel.font = [UIFont systemFontOfSize:22];
        _publickBtn.frame = CGRectMake(_publicX, _privateY, 140, 40);
        
        [_privateBtn setBackgroundImage:nil forState:UIControlStateNormal];
        _privateBtn.titleLabel.font = [UIFont systemFontOfSize:20];
        _privateBtn.frame = CGRectMake(_privateX + 10, _privateY, 120, 36);
        
        _isChecked = YES;
    }
}

-(void)privateClicked
{
    _isChecked = NO;
    
    [_privateBtn setBackgroundImage:[UIImage imageNamed:@"chose_Btn"] forState:UIControlStateNormal];
    _privateBtn.titleLabel.font = [UIFont systemFontOfSize:22];
    _privateBtn.frame = CGRectMake(_privateX, _privateY, 140, 40);
    
    [_publickBtn setBackgroundImage:nil forState:UIControlStateNormal];
    _publickBtn.titleLabel.font = [UIFont systemFontOfSize:20];
    _publickBtn.frame = CGRectMake(_publicX + 10, _privateY, 120, 36);
}

-(void)setupNavBar
{
    self.title = @"申请开通";
    self.view.backgroundColor = [UIColor whiteColor];
}

-(void)backHome
{
    [self.navigationController popViewControllerAnimated:YES];
}


- (void)initAndLayoutUI {
    [self setupNavBar];
    [self setupHeaderView];
    [self initUIScrollView];

    [self initPickerView];
}

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
    UIBarButtonItem *spaceItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace
                                                                               target:nil
                                                                               action:nil];
    [_toolbar setItems:[NSArray arrayWithObjects:cancelItem,spaceItem,finishItem, nil]];
    [self.view addSubview:_toolbar];
    _pickerView = [[UIPickerView alloc] initWithFrame:CGRectMake(0, kScreenHeight, kScreenWidth, 216)];
    _pickerView.backgroundColor = kColor(244, 243, 243, 1);
    _pickerView.delegate = self;
    _pickerView.dataSource = self;
    [self.view addSubview:_pickerView];
    
    _datePicker = [[UIDatePicker alloc] initWithFrame:CGRectMake(0, kScreenHeight, kScreenWidth, 216)];
    _datePicker.backgroundColor = kColor(244, 243, 243, 1);
    [_datePicker addTarget:self action:@selector(timeChanged:) forControlEvents:UIControlEventValueChanged];
    _datePicker.datePickerMode = UIDatePickerModeDate;
    [self.view addSubview:self.datePicker];
}

- (void)setTextFieldAttr:(InputTextField *)textField {
    textField.borderStyle = UITextBorderStyleNone;
    textField.textAlignment = NSTextAlignmentRight;
    textField.font = [UIFont systemFontOfSize:14.f];
    textField.tag = kTextViewTag;
    textField.delegate = self;
    textField.textColor = kColor(108, 108, 108, 1);
    textField.clearButtonMode = UITextFieldViewModeWhileEditing;
    textField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
}

#pragma mark - Request

- (void)beginApply {
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
    hud.labelText = @"加载中...";
    AppDelegate *delegate = [AppDelegate shareAppDelegate];
    [NetworkInterface beginToApplyWithToken:delegate.token userID:delegate.userID applyStatus:_applyType terminalID:_terminalID finished:^(BOOL success, NSData *response) {
        NSLog(@"!!!!%@",[[NSString alloc] initWithData:response encoding:NSUTF8StringEncoding]);
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
                    [hud hide:YES];
                    [self parseApplyDataWithDictionary:object];
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

- (void)submitApplyInfoWithArray:(NSArray *)params {
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
    hud.labelText = @"提交中...";
    AppDelegate *delegate = [AppDelegate shareAppDelegate];
    [NetworkInterface submitApplyWithToken:delegate.token params:params finished:^(BOOL success, NSData *response) {
        NSLog(@"!!!!%@",[[NSString alloc] initWithData:response encoding:NSUTF8StringEncoding]);
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
                    hud.labelText = @"添加成功";
                    [self.navigationController popViewControllerAnimated:YES];
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

- (void)parseApplyDataWithDictionary:(NSDictionary *)dict {
    if (![dict objectForKey:@"result"] || ![[dict objectForKey:@"result"] isKindOfClass:[NSDictionary class]]) {
        return;
    }
    NSDictionary *applyDict = [dict objectForKey:@"result"];
    ApplyOpenModel *model = [[ApplyOpenModel alloc] initWithParseDictionary:applyDict];
    _applyData = model;
    _brandLabel.text = [NSString stringWithFormat:@"POS品牌   %@",_applyData.brandName];
    _modelLabel.text = [NSString stringWithFormat:@"POS型号   %@",_applyData.modelNumber];
    _terminalLabel.text = [NSString stringWithFormat:@"终  端  号   %@",_applyData.terminalNumber];
    _channelLabel.text = [NSString stringWithFormat:@"支付通道   %@",_applyData.channelName];
    [self setPrimaryData];
    [_tableView reloadData];
}

//保存获取的内容
- (void)setPrimaryData {
    if (_applyData.personName) {
        [_infoDict setObject:_applyData.personName forKey:key_name];
    }
    if (_applyData.merchantName) {
        [_infoDict setObject:_applyData.merchantName forKey:key_merchantName];
    }
    if (_applyData.birthday) {
        [_infoDict setObject:_applyData.birthday forKey:key_birth];
    }
    if (_applyData.cardID) {
        [_infoDict setObject:_applyData.cardID forKey:key_cardID];
    }
    if (_applyData.phoneNumber) {
        [_infoDict setObject:_applyData.phoneNumber forKey:key_phone];
    }
    if (_applyData.email) {
        [_infoDict setObject:_applyData.email forKey:key_email];
    }
    if (_applyData.cityID) {
        [_infoDict setObject:_applyData.cityID forKey:key_location];
    }
    if (_applyData.bankName) {
        [_infoDict setObject:_applyData.bankName forKey:key_bank];
    }
    if (_applyData.bankNumber) {
        [_infoDict setObject:_applyData.bankNumber forKey:key_bankID];
    }
    if (_applyData.bankAccount) {
        [_infoDict setObject:_applyData.bankAccount forKey:key_bankAccount];
    }
    if (_applyData.taxID) {
        [_infoDict setObject:_applyData.taxID forKey:key_taxID];
    }
    if (_applyData.organID) {
        [_infoDict setObject:_applyData.organID forKey:key_organID];
    }
    if (_applyData.channelID) {
        [_infoDict setObject:_applyData.channelID forKey:key_channel];
    }
    [_infoDict setObject:[NSNumber numberWithInt:_applyData.sex] forKey:key_sex];
    _merchantID = _applyData.merchantID;
}

//根据对公对私材料的id找到是否已经提交过材料
- (NSString *)getApplyValueForKey:(NSString *)key {
    NSLog(@"!!%@,key = %@",[_infoDict objectForKey:key],key);
    if ([_infoDict objectForKey:key] && ![[_infoDict objectForKey:@""] isEqualToString:@""]) {
        //若修改过值 返回保存的值
        return [_infoDict objectForKey:key];
    }
    else {
        //是否之前提交过
        if ([_applyData.applyList count] <= 0) {
            return nil;
        }
        for (ApplyInfoModel *model in _applyData.applyList) {
            if ([model.targetID isEqualToString:key]) {
                if (model.value && ![model.value isEqualToString:@""]) {
                    [_infoDict setObject:model.value forKey:key];
                }
                return model.value;
            }
        }
    }
    return nil;
}

- (void)parseImageUploadInfo:(NSDictionary *)dict {
    if (![dict objectForKey:@"result"] || ![[dict objectForKey:@"result"] isKindOfClass:[NSString class]]) {
        return;
    }
    NSString *urlString = [dict objectForKey:@"result"];
    if (urlString && ![urlString isEqualToString:@""]) {
        [_infoDict setObject:urlString forKey:_selectedKey];
    }
    [_tableView reloadData];
}

#pragma mark - 上传图片

- (void)uploadPictureWithImage:(UIImage *)image {
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
    hud.labelText = @"上传中...";
    [NetworkInterface uploadImageWithImage:image finished:^(BOOL success, NSData *response) {
        NSLog(@"!!!!%@",[[NSString alloc] initWithData:response encoding:NSUTF8StringEncoding]);
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
                    hud.labelText = @"上传成功";
                    [self parseImageUploadInfo:object];
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

//点击图片行调用
- (void)showImageOption {
    UIActionSheet *sheet = nil;
    NSString *value = [_infoDict objectForKey:_selectedKey];
    if (value && ![value isEqualToString:@""]) {
        sheet = [[UIActionSheet alloc] initWithTitle:@""
                                            delegate:self
                                   cancelButtonTitle:@"取消"
                              destructiveButtonTitle:nil
                                   otherButtonTitles:@"查看照片",@"相册上传",@"拍照上传",nil];
    }
    else {
        sheet = [[UIActionSheet alloc] initWithTitle:@""
                                            delegate:self
                                   cancelButtonTitle:@"取消"
                              destructiveButtonTitle:nil
                                   otherButtonTitles:@"相册上传",@"拍照上传",nil];
    }
    [sheet showInView:self.view];
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    NSInteger sourceType = UIImagePickerControllerSourceTypeCamera;
    NSString *value = [_infoDict objectForKey:_selectedKey];
    if (value && ![value isEqualToString:@""]) {
        if (buttonIndex == 0) {
            //查看大图
            return;
        }
        else if (buttonIndex == 1) {
            //相册
            sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        }
        else if (buttonIndex == 2) {
            //拍照
            sourceType = UIImagePickerControllerSourceTypeCamera;
        }
    }
    else {
        if (buttonIndex == 0) {
            //相册
            sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        }
        else if (buttonIndex == 1) {
            //拍照
            sourceType = UIImagePickerControllerSourceTypeCamera;
        }
    }
    if ([UIImagePickerController isSourceTypeAvailable:sourceType] &&
        buttonIndex != actionSheet.cancelButtonIndex) {
        UIImagePickerController *imagePickerController = [[UIImagePickerController alloc] init];
        imagePickerController.delegate = self;
        imagePickerController.allowsEditing = YES;
        imagePickerController.sourceType = sourceType;
        [self presentViewController:imagePickerController animated:YES completion:nil];
    }
}

#pragma mark - UIImagePickerDelegate

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    [picker dismissViewControllerAnimated:YES completion:nil];
    UIImage *editImage = [info objectForKey:UIImagePickerControllerEditedImage];
    [self uploadPictureWithImage:editImage];
}

#pragma mark - UITableView


#pragma mark - UIPickerView

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    if (_selectedKey == key_location) {
        return 2;
    }
    else if (_selectedKey == key_sex) {
        return 1;
    }
    return 0;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    if (_selectedKey == key_location) {
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
    else if (_selectedKey == key_sex) {
        return 2;
    }
    return 0;
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    if (_selectedKey == key_location) {
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
    else if (_selectedKey == key_sex) {
        NSString *title = @"";
        switch (row) {
            case 0:
                title = @"女";
                break;
            case 1:
                title = @"男";
                break;
            default:
                break;
        }
        return title;
    }
    return @"";
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    if (_selectedKey == key_location) {
        if (component == 0) {
            //省
            [_pickerView reloadComponent:1];
        }
    }
}

#pragma mark - UIPickerView

- (void)pickerScrollIn {
    if ([_selectedKey isEqualToString:key_location]) {
        [_pickerView reloadAllComponents];
        NSString *cityID = [_infoDict objectForKey:key_location];
        [_pickerView selectRow:[CityHandle getProvinceIndexWithCityID:cityID] inComponent:0 animated:NO];
        [_pickerView reloadAllComponents];
        [_pickerView selectRow:[CityHandle getCityIndexWithCityID:cityID] inComponent:1 animated:NO];
        [UIView animateWithDuration:.3f animations:^{
            _toolbar.frame = CGRectMake(0, kScreenHeight - 260, kScreenWidth, 44);
            _pickerView.frame = CGRectMake(0, kScreenHeight - 216, kScreenWidth, 216);
            _datePicker.frame = CGRectMake(0, kScreenHeight, kScreenWidth, 216);
        }];
    }
    else if ([_selectedKey isEqualToString:key_sex]) {
        [_pickerView reloadAllComponents];
        [UIView animateWithDuration:.3f animations:^{
            _toolbar.frame = CGRectMake(0, kScreenHeight - 260, kScreenWidth, 44);
            _pickerView.frame = CGRectMake(0, kScreenHeight - 216, kScreenWidth, 216);
            _datePicker.frame = CGRectMake(0, kScreenHeight, kScreenWidth, 216);
        }];
    }
    else if ([_selectedKey isEqualToString:key_birth]) {
        NSString *birth = [_infoDict objectForKey:key_birth];
        NSDateFormatter *format = [[NSDateFormatter alloc] init];
        [format setDateFormat:@"yyyy-MM-dd"];
        if (birth) {
            NSDate *birthDate = [format dateFromString:birth];
            _datePicker.date = birthDate;
        }
        else {
            [self timeChanged:nil];
        }
        [UIView animateWithDuration:.3f animations:^{
            _toolbar.frame = CGRectMake(0, kScreenHeight - 260, kScreenWidth, 44);
            _datePicker.frame = CGRectMake(0, kScreenHeight - 216, kScreenWidth, 216);
            _pickerView.frame = CGRectMake(0, kScreenHeight, kScreenWidth, 216);
        }];
    }
}

- (void)pickerScrollOut {
    [UIView animateWithDuration:.3f animations:^{
        _toolbar.frame = CGRectMake(0, kScreenHeight, kScreenWidth, 44);
        _pickerView.frame = CGRectMake(0, kScreenHeight, kScreenWidth, 216);
        _datePicker.frame = CGRectMake(0, kScreenHeight, kScreenWidth, 216);
    }];
}

#pragma mark - Action

- (IBAction)typeChanged:(id)sender {
    if (_segmentControl.selectedSegmentIndex == 1) {
        _applyType = OpenApplyPrivate;
    }
    else {
        _applyType = OpenApplyPublic;
    }
    [self beginApply];
    NSLog(@"%d",_applyType);
}

- (IBAction)modifyLocation:(id)sender {
    [self pickerScrollOut];
    if ([_selectedKey isEqualToString:key_location]) {
        NSInteger index = [_pickerView selectedRowInComponent:1];
        NSString *cityID = [NSString stringWithFormat:@"%@",[[_cityArray objectAtIndex:index] objectForKey:@"id"]];
        [_infoDict setObject:cityID forKey:key_location];
    }
    else if ([_selectedKey isEqualToString:key_birth]) {
        
    }
    else if ([_selectedKey isEqualToString:key_sex]) {
        NSInteger index = [_pickerView selectedRowInComponent:0];
        [_infoDict setObject:[NSNumber numberWithInteger:index] forKey:key_sex];
    }
    [_tableView reloadData];
}

//datePicker滚动时调用方法
- (IBAction)timeChanged:(id)sender {
    NSDateFormatter *format = [[NSDateFormatter alloc] init];
    [format setDateFormat:@"yyyy-MM-dd"];
    NSString *dateString = [format stringFromDate:_datePicker.date];
    NSString *str_date = dateString;
    if ([dateString length] >= 10) {
        str_date = [dateString substringToIndex:10];
    }
    [_infoDict setObject:str_date forKey:key_birth];
}

- (IBAction)submitApply:(id)sender {
    [_tempField becomeFirstResponder];
    [_tempField resignFirstResponder];
    if (![_infoDict objectForKey:key_name]) {
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
        hud.customView = [[UIImageView alloc] init];
        hud.mode = MBProgressHUDModeCustomView;
        [hud hide:YES afterDelay:1.f];
        hud.labelText = @"请填写姓名";
        return;
    }
    if (![_infoDict objectForKey:key_merchantName]) {
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
        hud.customView = [[UIImageView alloc] init];
        hud.mode = MBProgressHUDModeCustomView;
        [hud hide:YES afterDelay:1.f];
        hud.labelText = @"请填写店铺名称";
        return;
    }
    if (![_infoDict objectForKey:key_sex]) {
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
        hud.customView = [[UIImageView alloc] init];
        hud.mode = MBProgressHUDModeCustomView;
        [hud hide:YES afterDelay:1.f];
        hud.labelText = @"请选择性别";
        return;
    }
    if (![_infoDict objectForKey:key_birth]) {
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
        hud.customView = [[UIImageView alloc] init];
        hud.mode = MBProgressHUDModeCustomView;
        [hud hide:YES afterDelay:1.f];
        hud.labelText = @"请选择生日";
        return;
    }
    if (![_infoDict objectForKey:key_cardID]) {
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
        hud.customView = [[UIImageView alloc] init];
        hud.mode = MBProgressHUDModeCustomView;
        [hud hide:YES afterDelay:1.f];
        hud.labelText = @"请填写身份证号";
        return;
    }
    if (![_infoDict objectForKey:key_phone]) {
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
        hud.customView = [[UIImageView alloc] init];
        hud.mode = MBProgressHUDModeCustomView;
        [hud hide:YES afterDelay:1.f];
        hud.labelText = @"请填写电话";
        return;
    }
    if (![_infoDict objectForKey:key_email]) {
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
        hud.customView = [[UIImageView alloc] init];
        hud.mode = MBProgressHUDModeCustomView;
        [hud hide:YES afterDelay:1.f];
        hud.labelText = @"请填写邮箱";
        return;
    }
    if (![_infoDict objectForKey:key_location]) {
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
        hud.customView = [[UIImageView alloc] init];
        hud.mode = MBProgressHUDModeCustomView;
        [hud hide:YES afterDelay:1.f];
        hud.labelText = @"请选择所在地";
        return;
    }
    if (![_infoDict objectForKey:key_bank]) {
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
        hud.customView = [[UIImageView alloc] init];
        hud.mode = MBProgressHUDModeCustomView;
        [hud hide:YES afterDelay:1.f];
        hud.labelText = @"请填写结算银行名称";
        return;
    }
    if (![_infoDict objectForKey:key_bankID]) {
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
        hud.customView = [[UIImageView alloc] init];
        hud.mode = MBProgressHUDModeCustomView;
        [hud hide:YES afterDelay:1.f];
        hud.labelText = @"请填写结算银行代码";
        return;
    }
    if (![_infoDict objectForKey:key_bankAccount]) {
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
        hud.customView = [[UIImageView alloc] init];
        hud.mode = MBProgressHUDModeCustomView;
        [hud hide:YES afterDelay:1.f];
        hud.labelText = @"请填写结算银行账户";
        return;
    }
    if (![_infoDict objectForKey:key_taxID]) {
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
        hud.customView = [[UIImageView alloc] init];
        hud.mode = MBProgressHUDModeCustomView;
        [hud hide:YES afterDelay:1.f];
        hud.labelText = @"请填写税务登记证号";
        return;
    }
    if (![_infoDict objectForKey:key_organID]) {
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
        hud.customView = [[UIImageView alloc] init];
        hud.mode = MBProgressHUDModeCustomView;
        [hud hide:YES afterDelay:1.f];
        hud.labelText = @"请填写组织机构号";
        return;
    }
    if (!_channelID || !_billID) {
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
        hud.customView = [[UIImageView alloc] init];
        hud.mode = MBProgressHUDModeCustomView;
        [hud hide:YES afterDelay:1.f];
        hud.labelText = @"请选择支付通道";
        return;
    }
    for (MaterialModel *model in _applyData.materialList) {
        if (![_infoDict objectForKey:model.materialID]) {
            NSString *infoString = nil;
            if (model.materialType == MaterialText) {
                infoString = [NSString stringWithFormat:@"请填写%@",model.materialName];
            }
            else if (model.materialType == MaterialList) {
                infoString = [NSString stringWithFormat:@"请选择%@",model.materialName];
            }
            else if (model.materialType == MaterialImage) {
                infoString = [NSString stringWithFormat:@"请上传%@",model.materialName];
            }
            MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
            hud.customView = [[UIImageView alloc] init];
            hud.mode = MBProgressHUDModeCustomView;
            [hud hide:YES afterDelay:1.f];
            hud.labelText = infoString;
            return;
        }
    }
    NSMutableArray *paramList = [[NSMutableArray alloc] init];
    AppDelegate *delegate = [AppDelegate shareAppDelegate];
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    [params setObject:[NSNumber numberWithInt:[_terminalID intValue]] forKey:@"terminalId"];
    [params setObject:[NSNumber numberWithInt:_openStatus] forKey:@"status"];
    [params setObject:[NSNumber numberWithInt:[delegate.userID intValue]] forKey:@"applyCustomerId"];
    [params setObject:[NSNumber numberWithInt:_applyType] forKey:@"publicPrivateStatus"];
    [params setObject:[NSNumber numberWithInt:[_merchantID intValue]] forKey:@"merchantId"];
    [params setObject:[_infoDict objectForKey:key_merchantName] forKey:@"merchantName"];
    [params setObject:[_infoDict objectForKey:key_sex] forKey:@"sex"];
    [params setObject:[_infoDict objectForKey:key_birth] forKey:@"birthday"];
    [params setObject:[_infoDict objectForKey:key_cardID] forKey:@"cardId"];
    [params setObject:[_infoDict objectForKey:key_phone] forKey:@"phone"];
    [params setObject:[_infoDict objectForKey:key_name] forKey:@"name"];
    [params setObject:[_infoDict objectForKey:key_email] forKey:@"email"];
    [params setObject:[NSNumber numberWithInt:[[_infoDict objectForKey:key_location] intValue]] forKey:@"cityId"];
    [params setObject:[NSNumber numberWithInt:[_channelID intValue]] forKey:@"channel"];
    [params setObject:[NSNumber numberWithInt:[_billID intValue]] forKey:@"billingId"];
    [params setObject:[_infoDict objectForKey:key_bankAccount] forKey:@"bankNum"];
    [params setObject:[_infoDict objectForKey:key_bank] forKey:@"bankName"];
    [params setObject:[_infoDict objectForKey:key_bankID] forKey:@"bankCode"];
    [params setObject:[_infoDict objectForKey:key_organID] forKey:@"organizationNo"];
    [params setObject:[_infoDict objectForKey:key_taxID] forKey:@"registeredNo"];
    
    [paramList addObject:params];
    for (MaterialModel *model in _applyData.materialList) {
        NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
        NSString *value = nil;
        if (model.materialType == MaterialList) {
            value = _bankID;
        }
        else {
            value = [_infoDict objectForKey:model.materialID];
        }
        [dict setObject:model.materialName forKey:@"Key"];
        if (value) {
            [dict setObject:value forKey:@"Value"];
        }
        [dict setObject:[NSNumber numberWithInt:model.materialType] forKey:@"types"];
        [dict setObject:[NSNumber numberWithInt:[model.materialID intValue]] forKey:@"targetId"];
        [dict setObject:[NSNumber numberWithInt:[model.levelID intValue]] forKey:@"openingRequirementId"];
        [paramList addObject:dict];
    }
    [self submitApplyInfoWithArray:paramList];
}

#pragma mark - UITextFieldDelegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return YES;
}

- (void)textFieldDidBeginEditing:(UITextField *)textField {
    [self pickerScrollOut];
}

- (void)textFieldDidEndEditing:(InputTextField *)textField {
    if (textField.text && ![textField.text isEqualToString:@""]) {
        [_infoDict setObject:textField.text forKey:textField.key];
    }
}

@end
