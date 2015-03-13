//
//  RentBackCell.h
//  iPadff
//
//  Created by 黄含章 on 15/3/12.
//  Copyright (c) 2015年 LanTaiPro. All rights reserved.
//

#import <UIKit/UIKit.h>

//枚举状态
typedef enum{
    RentBackCellTypeNone = 0,     //无
    RentBackCellTypeIng = 1,  //处理中
    RentBackCellTypeAbolish = 2,//已取消
    RentBackCellTypeDone = 3,//处理完成
    RentBackCellTypeReady = 4,//待处理
}RentBackCellType;

//点击协议
@protocol RentBackCellBtnClickDelegate <NSObject>
@optional
-(void)RentBackCellBtnClick:(int)btnTag WithSelectedID:(NSString *)selectedID;
@end


@interface RentBackCell : UITableViewCell

/** 终端号 */
@property(nonatomic,strong)UILabel *terminalLabel;
/** 租凭退还单号 */
@property(nonatomic,strong)UILabel *RentBackNum;
/** 租凭退还事件 */
@property(nonatomic,strong)UILabel *RentBackTime;
/** 租凭退还状态 */
@property(nonatomic,strong)UILabel *RentBackStatus;

@property(nonatomic,strong)NSString *selectedID;

@property(nonatomic,assign)RentBackCellType RentBackCelltype;
@property(nonatomic,weak)id<RentBackCellBtnClickDelegate> RentBackCellBtnDelegate;



@end
