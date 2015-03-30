//
//  AppDelegate.h
//  iPadff
//
//  Created by comdosoft on 15/2/26.
//  Copyright (c) 2015年 LanTaiPro. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ZYCustomTabBarViewController.h"
@interface AppDelegate : UIResponder <UIApplicationDelegate>
@property (strong, nonatomic) ZYCustomTabBarViewController *tabBarViewController;

@property (strong, nonatomic) UIWindow *window;
@property (strong, nonatomic) UINavigationController *naviController;
@property (nonatomic, strong) NSString *cityID;
@property(nonatomic,strong)NSString *userID;
@property(nonatomic,strong)NSString *token;
@property(nonatomic,strong)NSArray *array5;

@property(nonatomic,assign)BOOL haveExit;

+ (AppDelegate *)shareAppDelegate;

//登录后返回
-(void)clearLoginInfo;
@end

