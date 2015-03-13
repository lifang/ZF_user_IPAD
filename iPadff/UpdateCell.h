//
//  UpdateCell.h
//  iPadff
//
//  Created by 黄含章 on 15/3/12.
//  Copyright (c) 2015年 LanTaiPro. All rights reserved.
//

#import <UIKit/UIKit.h>
//枚举状态
typedef enum{
    UpdateCellTypeNone = 0,     //无
    UpdateCellTypeIng = 1,  //处理中
    UpdateCellTypeAbolish = 2,//已取消
    UpdateCellTypeDone = 3,//处理完成
    UpdateCellTypeReady = 4,//待处理
}UpdateCellType;

//点击协议
@protocol UpdateCellBtnClickDelegate <NSObject>
@optional
-(void)UpdateCellBtnClick:(int)btnTag;
@end

@interface UpdateCell : UITableViewCell
/** 终端号 */
@property(nonatomic,strong)UILabel *terminalLabel;
/** 更新资料单号 */
@property(nonatomic,strong)UILabel *UpdateNum;
/** 更新资料日期 */
@property(nonatomic,strong)UILabel *UpdateTime;
/** 更新资料状态 */
@property(nonatomic,strong)UILabel *UpdateStatus;

@property(nonatomic,assign)UpdateCellType UpdateCelltype;
@property(nonatomic,weak)id<UpdateCellBtnClickDelegate> UpdateCellBtnDelegate;

@end
