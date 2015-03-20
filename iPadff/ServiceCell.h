//
//  ServiceCell.h
//  iPadff
//
//  Created by 黄含章 on 15/3/12.
//  Copyright (c) 2015年 LanTaiPro. All rights reserved.
//

#import <UIKit/UIKit.h>
//枚举状态
typedef enum{
    ServieceBtnTypeNone = 0,     //无
    ServieceBtnTypePay = 1,  //未付款
    ServieceBtnTypeback = 2, //待发回
    ServieceBtnTypeIng = 3,//维修中
    ServieceBtnTypeDone = 5,//处理完成
    ServieceBtnTypeCancel = 6,//已取消
}ServieceBtnType;

//点击协议
@protocol ServiceBtnClickDelegate <NSObject>
@optional
-(void)serviceBtnClick:(int)btnTag WithSelectedID:(NSString *)selectedID WithRepair_price:(NSString *)repair_price;
@end

@interface ServiceCell : UITableViewCell
/** 终端号 */
@property(nonatomic,strong)UILabel *terminalLabel;
/** 维修单号 */
@property(nonatomic,strong)UILabel *seviceNum;
/** 申请日期 */
@property(nonatomic,strong)UILabel *seviceTime;
/** 申请状态 */
@property(nonatomic,strong)UILabel *seviceStatus;

@property(nonatomic,strong)NSString *selectedID;

@property(nonatomic,strong)NSString *repair_price;

@property(nonatomic,assign)ServieceBtnType ServieceBtntype;
@property(nonatomic,weak)id<ServiceBtnClickDelegate> ServieceBtnDelgete;

@end
