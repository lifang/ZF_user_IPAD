//
//  ChangeGoodCell.h
//  iPadff
//
//  Created by 黄含章 on 15/3/12.
//  Copyright (c) 2015年 LanTaiPro. All rights reserved.
//

#import <UIKit/UIKit.h>

//枚举状态
typedef enum{
    ChangeGoodCellTypeNone = 0,     //无
    ChangeGoodCellTypeReady = 1,//待处理
    ChangeGoodCellTypeIng = 2,  //换货中
    ChangeGoodCellTypeDone = 4,//处理完成
    ChangeGoodCellTypeAbolish = 5,//已取消
}ChangeGoodCellType;

//点击协议
@protocol ChangeGoodCellBtnClickDelegate <NSObject>
@optional
-(void)ChangeGoodCellBtnClick:(int)btnTag WithSelectedID:(NSString *)selectedID;
@end

@interface ChangeGoodCell : UITableViewCell
/** 终端号 */
@property(nonatomic,strong)UILabel *terminalLabel;
/** 换货单号 */
@property(nonatomic,strong)UILabel *ChangeGoodNum;
/** 换货日期 */
@property(nonatomic,strong)UILabel *ChangeGoodTime;
/** 换货状态 */
@property(nonatomic,strong)UILabel *ChangeGoodStatus;

@property(nonatomic,strong)NSString *selectedID;

@property(nonatomic,assign)ChangeGoodCellType ChangeGoodCelltype;
@property(nonatomic,weak)id<ChangeGoodCellBtnClickDelegate> ChangeGoodCellBtnDelegate;

@end
