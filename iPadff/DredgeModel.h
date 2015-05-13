//
//  DredgeModel.h
//  iPadff
//
//  Created by 黄含章 on 15/4/2.
//  Copyright (c) 2015年 LanTaiPro. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum {
    SerminalStatusNone = 0,
    SerminalStatusOpened,       //已开通
    SerminalStatusPartOpened,   //部分开通
    SerminalStatusUnOpened,     //未开通
    SerminalStatusCanceled,     //已注销
    SerminalStatusStopped,      //已停用
}SerminalStatus;

@interface DredgeModel : NSObject

@property (nonatomic, strong) NSString *TM_ID;      //终端记录id

@property (nonatomic, strong) NSString *TM_status;  //终端记录状态

@property (nonatomic, strong) NSString *TM_serialNumber;  //终端号

@property (nonatomic, strong) NSString *TM_channelName;  //通道

@property (nonatomic, strong) NSString *TM_brandsName;  //品牌

@property (nonatomic, strong) NSString *TM_model_number;  //型号

@property(nonatomic,assign)BOOL isHaveVideo;
/*
 若有值，订单状态为已开通，有视频认证和找回POS密码操作,否则是自助开通
 若有值，订单状态为未开通，无同步操作
 */
@property (nonatomic, strong) NSString *appID;
- (id)initWithParseDictionary:(NSDictionary *)dict;

- (NSString *)getStatusString;
@end
