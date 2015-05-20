//
//  AppDelegate.m
//  iPadff
//
//  Created by comdosoft on 15/2/26.
//  Copyright (c) 2015年 LanTaiPro. All rights reserved.
//

#import "AppDelegate.h"
#import "NetworkInterface.h"
#import "ZYCustomTabBarViewController.h"
#import "MyOrderViewController.h"
#import "ZYHomeViewController.h"
#import "MessageViewController.h"
#import "ShoppingCartController.h"
#import "BasicNagigationController.h"
#import "MyMessageViewController.h"
#import "SwitchView.h"
#import "AddressViewController.h"
#import "AccountTool.h"
#import "SwitchView.h"
#import "MyMessageViewController.h"
#import "LoginViewController.h"
#import <AlipaySDK/AlipaySDK.h>
#import "MessageChildViewController.h"
#import "BPush.h"
@interface AppDelegate ()<BPushDelegate>

@property (nonatomic, strong) UIScrollView *scrollView;
@end

@implementation AppDelegate


+(AppDelegate *)shareAppDelegate
{
    return (AppDelegate *)[UIApplication sharedApplication].delegate;
}


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    self.isFirst = NO;
    self.tabBarViewController.AG=78;
    
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(viewcontrollew) name:@"addressmanger" object:nil];

    ZYHomeViewController *viewController1 = [[ZYHomeViewController alloc] init];
    ShoppingCartController *viewController2 = [[ShoppingCartController alloc] init];
    MessageViewController *viewController3 = [[MessageViewController alloc] init];
    MyOrderViewController *viewController4 = [[MyOrderViewController alloc] init];
    MyMessageViewController *viewController5 = [[MyMessageViewController alloc] init];
    
    //创建一个导航，以第一个视图控制器为根视图
    BasicNagigationController *navController = [[BasicNagigationController alloc] initWithRootViewController:viewController2];
    BasicNagigationController *navController2 = [[BasicNagigationController alloc] initWithRootViewController:viewController4];
    BasicNagigationController *navController3 = [[BasicNagigationController alloc] initWithRootViewController:viewController1];
    BasicNagigationController *navController4 = [[BasicNagigationController alloc] initWithRootViewController:viewController3];
    BasicNagigationController *navController5 = [[BasicNagigationController alloc] initWithRootViewController:viewController5];

    //创建一个数组保存导航和另外四个视图控制器
    NSArray *array = [NSArray arrayWithObjects:navController3,navController,navController4,navController2,nil];
   
     self.array5 = [NSArray arrayWithObjects:navController3,navController,navController4,navController5,nil];

    //释放

//    [[UIApplication sharedApplication] setApplicationIconBadgeNumber:0];
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
    self.haveExit = NO;
    _cityID = @"1";
    AccountModel *account = [AccountTool userModel];
    if (account.password) {
        _userID = account.userID;
        _token = account.token;
    }
    
    // iOS8 下需要使⽤用新的 API
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0) {
        UIUserNotificationType myTypes = UIUserNotificationTypeBadge | UIUserNotificationTypeSound
        | UIUserNotificationTypeAlert;
        UIUserNotificationSettings *settings = [UIUserNotificationSettings settingsForTypes:myTypes
                                                                                 categories:nil];
        [[UIApplication sharedApplication] registerUserNotificationSettings:settings];
    }
    else {
        UIRemoteNotificationType myTypes = UIRemoteNotificationTypeBadge | UIRemoteNotificationTypeAlert | UIRemoteNotificationTypeSound;
        [[UIApplication sharedApplication] registerForRemoteNotificationTypes:myTypes];
    }
    // 在 App 启动时注册百度云推送服务,需要提供 Apikey
    [BPush registerChannel:launchOptions apiKey:@"0CansN8lRSdGU58HX4INwhq4" pushMode:BPushModeDevelopment isDebug:NO];
    // 设置 BPush 的回调
    [BPush setDelegate:self];
    
    // App 是⽤用户点击推送消息启动
    NSDictionary *userInfo = [launchOptions objectForKey:UIApplicationLaunchOptionsRemoteNotificationKey];
    if (userInfo) {
        NSLog(@"!!!!%@",userInfo);
        [BPush handleNotification:userInfo];
        [self showNotificationViewWithInfo:userInfo pushLaunch:YES];
    }

    return YES;
}

-(void)viewcontrollew
{
//    SwitchView*switchv=[[SwitchView alloc]init];
//    [switchv setSelectedBtnAtIndex:3];
    

    self.tabBarViewController.viewControllers = self.array5;
    [self.tabBarViewController setSeletedIndex:3];

    self.naviController = [[UINavigationController alloc] initWithRootViewController:self.tabBarViewController];
    self.naviController.navigationBarHidden = YES;
    
    [self.window setRootViewController:self.naviController];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"addressmangers" object:self userInfo:nil];

//    AddressViewController*add=[[AddressViewController alloc]init];
//    add.hidesBottomBarWhenPushed=YES;
//    

//    [[NSNotificationCenter defaultCenter] postNotificationName:@"address" object:nil];

//    [viewController5 SwitchViewClickedAtIndex:3];
   // AddressViewController*add=[[AddressViewController alloc]init];
   // add.hidesBottomBarWhenPushed=YES;
    
   // [[NSNotificationCenter defaultCenter] postNotificationName:@"address" object:nil];
   // [viewController5 SwitchViewClickedAtIndex:3];

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
- (BOOL)application:(UIApplication *)application
            openURL:(NSURL *)url
  sourceApplication:(NSString *)sourceApplication
         annotation:(id)annotation {
    NSLog(@"%@",url);
    if ([url.host isEqualToString:@"safepay"]) {
        NSLog(@"!!!");
        [[AlipaySDK defaultService] processOrderWithPaymentResult:url standbyCallback:^(NSDictionary *resultDic) {
            for (NSString *key in resultDic) {
                NSLog(@"%@->%@",key,[resultDic objectForKey:key]);
            }
        }];
    }
    return YES;
}

-(void)clearLoginInfo
{
    [BPush unbindChannel];
    _userID = nil;
    _token = nil;
    AccountModel *account = [AccountTool userModel];
    account.userID = nil;
    account.password = nil;
    self.haveExit = YES;
    [AccountTool save:account];
}

-(void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"addressmanger" object:nil];
}

//百度推送*******************************************
- (void)application:(UIApplication *)application didRegisterUserNotificationSettings:(UIUserNotificationSettings *)notificationSettings {
    [application registerForRemoteNotifications];
}

- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken {
    [BPush registerDeviceToken:deviceToken];
    //    [BPush bindChannel];
}

// 当 DeviceToken 获取失败时,系统会回调此⽅方法
- (void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:( NSError *)error {
    NSLog(@"DeviceToken 获取失败,原因:%@",error);
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo {
    // App 收到推送通知
    [BPush handleNotification:userInfo];
    if (application.applicationState == UIApplicationStateActive) {
        //前台
        NSLog(@"active");
        self.messageCount ++;
        NSDictionary *messageDict = [NSDictionary dictionaryWithObjectsAndKeys:
                                     [NSNumber numberWithInt:self.messageCount],s_messageTab,
                                     nil];
        [[NSNotificationCenter defaultCenter] postNotificationName:ShowColumnNotification object:nil userInfo:messageDict];
    }
    else {
        //后台
        NSLog(@"unactive");
        [self showNotificationViewWithInfo:userInfo pushLaunch:NO];
    }
    [application setApplicationIconBadgeNumber:0];
    
}



//收到通知弹出到通知界面
- (void)showNotificationViewWithInfo:(NSDictionary *)userInfo pushLaunch:(BOOL)pushLaunch {
    NSLog(@"%@",userInfo);
    [[UIApplication sharedApplication] setApplicationIconBadgeNumber:1];
    [[UIApplication sharedApplication] setApplicationIconBadgeNumber:0];
    NSString *messageID = nil;
    if ([userInfo objectForKey:@"msgId"] && ![[userInfo objectForKey:@"msgId"] isKindOfClass:[NSNull class]]) {
        messageID = [NSString stringWithFormat:@"%@",[userInfo objectForKey:@"msgId"]];
    }
    if (self.userID) {
        MessageChildViewController *detailC = [[MessageChildViewController alloc] init];
        UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:detailC];
        detailC.messageID = messageID;
        detailC.isFromPush = YES;
        if (!pushLaunch) {
            [self.window.rootViewController presentViewController:nav animated:YES completion:nil];
        }
    }
    else {
        if (!pushLaunch) {
//            LoginViewController *loginC = [[LoginViewController alloc] init];
//            UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:loginC];
//            [self.window.rootViewController presentViewController:nav animated:YES completion:nil];
        }
    }
}
- (void)onMethod:(NSString*)method response:(NSDictionary *)data {
    NSLog(@"On method:%@", method);
    NSLog(@"data:%@", [data description]);
    NSDictionary* res = [[NSDictionary alloc] initWithDictionary:data];
    if ([BPushRequestMethodBind isEqualToString:method]) {
        NSString *appid = [res valueForKey:BPushRequestAppIdKey];
        NSString *userid = [res valueForKey:BPushRequestUserIdKey];
        NSString *channelid = [res valueForKey:BPushRequestChannelIdKey];
        int returnCode = [[res valueForKey:BPushRequestErrorCodeKey] intValue];
        NSLog(@"tttt = %@,%@,%@,%d",appid ,userid, channelid,returnCode);
        if (returnCode == 0) {
            [self uploadPushChannel:channelid];
        }
        
    } else if ([BPushRequestMethodUnbind isEqualToString:method]) {
        
    }
    
}

//绑定成功向服务端提交信息
- (void)uploadPushChannel:(NSString *)channel {
    NSString *appInfo = [NSString stringWithFormat:@"%d%@",kAppChannel,channel];
    [NetworkInterface uploadPushInfoWithUserID:self.userID channelInfo:appInfo finished:^(BOOL success, NSData *response) {
        NSLog(@"!!%@",[[NSString alloc] initWithData:response encoding:NSUTF8StringEncoding]);
    }];
}


@end
