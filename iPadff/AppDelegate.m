//
//  AppDelegate.m
//  iPadff
//
//  Created by comdosoft on 15/2/26.
//  Copyright (c) 2015年 LanTaiPro. All rights reserved.
//

#import "AppDelegate.h"
#import "ZYCustomTabBarViewController.h"
#define SCREEN_HEIGHT [[UIScreen mainScreen] bounds].size.height
#define SCREEN_WIDTH [[UIScreen mainScreen] bounds].size.width
#import "ZYHomeViewController.h"
#import "MessageViewController.h"
#import "MyViewController.h"
#import "ShoppingViewController.h"
#import "BasicNagigationController.h"
@interface AppDelegate ()

@end

@implementation AppDelegate


+(AppDelegate *)shareAppDelegate
{
    return [UIApplication sharedApplication].delegate;
}


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
  
//    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;

    ZYHomeViewController *viewController1 = [[ZYHomeViewController alloc] init];
    ShoppingViewController *viewController2 = [[ShoppingViewController alloc] init];
    MessageViewController *viewController3 = [[MessageViewController alloc] init];
    MyViewController *viewController4 = [[MyViewController alloc] init];
    
    
    //创建一个导航，以第一个视图控制器为根视图
    BasicNagigationController *navController = [[BasicNagigationController alloc] initWithRootViewController:viewController2];
    BasicNagigationController *navController2 = [[BasicNagigationController alloc] initWithRootViewController:viewController4];
    BasicNagigationController *navController3 = [[BasicNagigationController alloc] initWithRootViewController:viewController1];
    BasicNagigationController *navController4 = [[BasicNagigationController alloc] initWithRootViewController:viewController3];
    
    //创建一个数组保存导航和另外四个视图控制器
    NSArray *array = [NSArray arrayWithObjects:navController3,navController,navController4,navController2,nil];
    //释放

    
    //创建一个自定义的TabBar
    self.tabBarViewController = [[ZYCustomTabBarViewController alloc] init];
    //给TabBar的视图数组赋值
    self.tabBarViewController.viewControllers = array;
    //设置TabBar默认选中的是哪一个
    //用 对象. 赋值默认会调set方法
    [self.tabBarViewController setSeletedIndex:0];

    //设置window的根视图
    self.naviController = [[UINavigationController alloc] initWithRootViewController:self.tabBarViewController];
    self.naviController.navigationBarHidden = YES;
        [self.window setRootViewController:self.naviController];
    _cityID = @"1";
    _userID = @"8";
    _token = @"123";

    // Override point for customization after application launch.
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
