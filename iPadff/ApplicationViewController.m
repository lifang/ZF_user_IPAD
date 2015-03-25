//
//  ApplicationViewController.m
//  iPadff
//
//  Created by 黄含章 on 15/3/4.
//  Copyright (c) 2015年 LanTaiPro. All rights reserved.
//

#import "ApplicationViewController.h"
#import "NetworkInterface.h"
#import "AppDelegate.h"
#import "ApplyOpenModel.h"
#import "CityHandle.h"
@interface ApplicationViewController ()
@property (nonatomic, assign) OpenApplyType applyType;  //对公 对私

@property(nonatomic,strong)UIButton *publickBtn;
@property(nonatomic,strong)UIButton *privateBtn;
@property (nonatomic, strong) UIScrollView *scrollView;

@property(nonatomic,assign)BOOL isChecked;
@property(nonatomic,assign)CGFloat publicX;
@property(nonatomic,assign)CGFloat privateX;
@property(nonatomic,assign)CGFloat privateY;
@property (nonatomic, strong) UILabel *brandLabel;
@property (nonatomic, strong) UILabel *modelLabel;
@property (nonatomic, strong) UILabel *terminalLabel;
@property (nonatomic, strong) UILabel *channelLabel;



@end

@implementation ApplicationViewController

- (void)viewDidLoad {
    
    [super viewDidLoad];
    [self setupNavBar];
    [self setupHeaderView];
    [self initUIScrollView];
    
}

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

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
@end
