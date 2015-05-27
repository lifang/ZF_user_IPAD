//
//  Constants.h
//  ZFUB
//
//  Created by 徐宝桥 on 15/1/23.
//  Copyright (c) 2015年 ___MyCompanyName___. All rights reserved.
//

#define kColor(r,g,b,a) [UIColor colorWithRed:r / 255.0f green:g / 255.0f blue:b / 255.0f alpha:a]

#define kScreenHeight [UIScreen mainScreen].bounds.size.height

#define kScreenWidth  [UIScreen mainScreen].bounds.size.width

#define kScaling  kScreenWidth / 320   //用于计算高度

#define kDeviceVersion [[[UIDevice currentDevice] systemVersion] floatValue]

#define kAppVersionType  5   //版本更新

#define kLineHeight   1.0f
#define kAppChannel  6
#define kMainColor kColor(254, 79, 29, 1.0)

#define kPageSize 10   //分页加载每页行数
#define NavTitle_FONTSIZE  36
#define kServiceURL @"http://121.40.84.2:8080/ZFMerchant/api"
//#define kServiceURL @"http://121.40.64.167:8080/api"

//#define kServiceURL  @"http://www.ebank007.com/api"

#define kImageName(name) [UIImage imageNamed:name]

#define kColor(r,g,b,a) [UIColor colorWithRed:r / 255.0f green:g / 255.0f blue:b / 255.0f alpha:a]
#define iOS7 ([UIDevice currentDevice].systemVersion.floatValue >= 7.0&&8.0>[UIDevice currentDevice].systemVersion.floatValue )
#define iOS8 ([UIDevice currentDevice].systemVersion.floatValue >= 8.0)


#define SCREEN_HEIGHT [[UIScreen mainScreen] bounds].size.height
#define SCREEN_WIDTH [[UIScreen mainScreen] bounds].size.width

#define kVideoAuthIP    @"121.40.84.2"      //测试
//#define kVideoAuthIP      @"121.40.64.120"    //线上
#define kVideoAuthPort  8906
//#define kVideoServiceURL @"http://admin.ebank007.com/notice/video"   //线上
#define kVideoServiceURL @"http://121.40.84.2:38080/ZFManager/notice/video"

#define kOrderCallBackURL  @"http://121.40.84.2:8080/ZFMerchant/app_notify_url.jsp"
#define kCSCallBackURL     @"http://121.40.84.2:8080/ZFMerchant/repair_app_notify_url.jsp"

//#define kWhalesaleCallBackURL   @"http://121.40.84.2:8080/ZFMerchant/deposit_app_notify_url.jsp"
//#define kProcurementCallBackURL @"http://121.40.84.2:8080/ZFMerchant/app_notify_url.jsp"


//UnionPay
#define kMode_Production             @"01" //测试
#define kUnionPayURL  @"http://121.40.84.2:8080/ZFMerchant/unionpay.do" //测试

//#define kMode_Production             @"00"  //线上
//#define kUnionPayURL  @"http://www.ebank007.com/unionpay.do" //线上


#define SubHead_FONT(s) [UIFont fontWithName:@"[STHeitiSC](light)" size:s]
#define NavTitle_FONT(s) [UIFont fontWithName:@"[STHeitiSC](Medium)" size:s]


#define kServiceReturnWrong  @"服务端数据返回错误"
#define kNetworkFailed       @"网络连接失败"