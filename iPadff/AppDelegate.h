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
@property(nonatomic,strong) NSString *cityID;
@property(nonatomic,strong)NSString *userID;
@property(nonatomic,strong)NSString *token;

+ (AppDelegate *)shareAppDelegate;


@end

