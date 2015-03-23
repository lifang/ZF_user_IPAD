//
//  ApplicationViewController.m
//  iPadff
//
//  Created by 黄含章 on 15/3/4.
//  Copyright (c) 2015年 LanTaiPro. All rights reserved.
//

#import "ApplicationViewController.h"

@interface ApplicationViewController ()

@property(nonatomic,strong)UIButton *publickBtn;
@property(nonatomic,strong)UIButton *privateBtn;

@property(nonatomic,assign)BOOL isChecked;
@property(nonatomic,assign)CGFloat publicX;
@property(nonatomic,assign)CGFloat privateX;
@property(nonatomic,assign)CGFloat privateY;


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
    UIScrollView *scrollView = [[UIScrollView alloc]init];
    
    scrollView.frame = CGRectMake(0, 80, SCREEN_WIDTH, 1000);
    if (iOS7) {
        scrollView.frame = CGRectMake(0, 80, SCREEN_HEIGHT, 1000);
    }
    [self.view addSubview:scrollView];
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
