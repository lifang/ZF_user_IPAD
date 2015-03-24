//
//  SystemNoticeChildController.m
//  iPadff
//
//  Created by 黄含章 on 15/3/24.
//  Copyright (c) 2015年 LanTaiPro. All rights reserved.
//

#import "SystemNoticeChildController.h"
#import "NetworkInterface.h"
#import "AppDelegate.h"

@interface SystemNoticeChildController ()

@property (nonatomic, strong) UIScrollView *scrollView;

@property (nonatomic, strong) MessageModel *detail;

@end

@implementation SystemNoticeChildController

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
    self.title = @"系统公告";
    self.view.backgroundColor = [UIColor whiteColor];
}

-(void)initAndLayoutUI
{
    _scrollView = [[UIScrollView alloc]init];
    _scrollView.translatesAutoresizingMaskIntoConstraints = NO;
    _scrollView.backgroundColor = kColor(243, 243, 243, 1.0);
    [self.view addSubview:_scrollView];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:_scrollView
                                                          attribute:NSLayoutAttributeTop
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:self.view
                                                          attribute:NSLayoutAttributeTop
                                                         multiplier:1.0
                                                           constant:0]];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:_scrollView
                                                          attribute:NSLayoutAttributeLeft
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:self.view
                                                          attribute:NSLayoutAttributeLeft
                                                         multiplier:1.0
                                                           constant:0]];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:_scrollView
                                                          attribute:NSLayoutAttributeRight
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:self.view
                                                          attribute:NSLayoutAttributeRight
                                                         multiplier:1.0
                                                           constant:0]];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:_scrollView
                                                          attribute:NSLayoutAttributeBottom
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:self.view
                                                          attribute:NSLayoutAttributeBottom
                                                         multiplier:1.0
                                                           constant:0]];

}

-(void)initSubViews
{
    CGFloat topSpace = 40.f;
    CGFloat leftSpace = 180.f;
    CGFloat rightSpace = 180.f;
    UILabel *titleLabel = [[UILabel alloc]init];
    titleLabel.translatesAutoresizingMaskIntoConstraints = NO;
    titleLabel.backgroundColor = [UIColor clearColor];
    
}


@end
