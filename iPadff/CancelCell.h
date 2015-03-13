//
//  CancelCell.h
//  iPadff
//
//  Created by 黄含章 on 15/3/12.
//  Copyright (c) 2015年 LanTaiPro. All rights reserved.
//

#import <UIKit/UIKit.h>

//枚举状态
typedef enum{
    CancelCellBtnTypeNone = 0,     //无
    CancelCellBtnIng = 1,  //处理中
    CancelCellBtnAbolish = 2,//已取消
    CancelCellBtnDone = 3,//处理完成
    CancelCellBtnReady = 4,//待处理
}CancelCellBtnType;

//点击协议
@protocol CancelCellBtnClickDelegate <NSObject>
@optional
-(void)CancelCellBtnClick:(int)btnTag WithSelectedID:(NSString *)selectedID;
@end


@interface CancelCell : UITableViewCell
/** 终端号 */
@property(nonatomic,strong)UILabel *terminalLabel;
/** 注销单号 */
@property(nonatomic,strong)UILabel *CancelNum;
/** 注销日期 */
@property(nonatomic,strong)UILabel *CancelTime;
/** 注销状态 */
@property(nonatomic,strong)UILabel *CancelStatus;

@property(nonatomic,strong)NSString *selectedID;

@property(nonatomic,assign)CancelCellBtnType CancelCellBtntype;
@property(nonatomic,weak)id<CancelCellBtnClickDelegate> CancelCellBtndelegate;

@end
