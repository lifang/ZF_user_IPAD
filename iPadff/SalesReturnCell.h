//
//  SalesReturnCell.h
//  iPadff
//
//  Created by 黄含章 on 15/3/12.
//  Copyright (c) 2015年 LanTaiPro. All rights reserved.
//

#import <UIKit/UIKit.h>
//枚举状态
typedef enum{
    SalesReturnCellTypeNone = 0,     //无
    SalesReturnCellTypeReady = 1,//待处理
    SalesReturnCellTypeIng = 2,  //退货中
    SalesReturnCellTypeDone = 4,//处理完成
    SalesReturnCellTypeAbolish = 5,//已取消
}SalesReturnCellType;

//点击协议
@protocol SalesReturnCellBtnClickDelegate <NSObject>
@optional
-(void)SalesReturnCellBtnClick:(int)btnTag WithSelectedID:(NSString *)selectedID;
@end

@interface SalesReturnCell : UITableViewCell

/** 终端号 */
@property(nonatomic,strong)UILabel *terminalLabel;
/** 退货单号 */
@property(nonatomic,strong)UILabel *SalesReturnNum;
/** 退货日期 */
@property(nonatomic,strong)UILabel *SalesReturnTime;
/** 退货状态 */
@property(nonatomic,strong)UILabel *SalesReturnStatus;

@property(nonatomic,strong)NSString *selectedID;

@property(nonatomic,assign)SalesReturnCellType SalesReturnCelltype;
@property(nonatomic,weak)id<SalesReturnCellBtnClickDelegate> SalesReturnCellBtnDelegate;

@end
