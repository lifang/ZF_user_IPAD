//
//  AppDelegate.h
//  iPadff
//
//  Created by comdosoft on 15/2/26.
//  Copyright (c) 2015年 LanTaiPro. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ZYCustomTabBarViewController.h"

#define UMENG_APPKEY @"553def3e67e58ed8e700015b"
static NSString *s_messageTab = @"s_messageTab";
#define kDefaultCityID  @"0"
@interface AppDelegate : UIResponder <UIApplicationDelegate>
@property (strong, nonatomic) ZYCustomTabBarViewController *tabBarViewController;

@property (strong, nonatomic) UIWindow *window;
@property (strong, nonatomic) UINavigationController *naviController;
@property (nonatomic, strong) NSString *cityID;
@property(nonatomic,strong)NSString *userID;
@property(nonatomic,strong)NSString *token;
@property(nonatomic,strong)NSArray *array5;

@property(nonatomic,assign)BOOL haveExit;
@property (nonatomic, assign) int shopcartCount;
+ (AppDelegate *)shareAppDelegate;

//登录后返回
-(void)clearLoginInfo;

@property(nonatomic,assign)BOOL isFirst;
//消息数量
@property (nonatomic, assign) int messageCount;
@end

