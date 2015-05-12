//
//  TerminalViewCell.h
//  iPadff
//
//  Created by 黄含章 on 15/3/5.
//  Copyright (c) 2015年 LanTaiPro. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol terminalCellSendBtnClicked <NSObject>

@optional
-(void)terminalCellBtnClicked:(int) btnTag WithSelectedID:(NSString *)selectedID Withindex:(int)indexNum;

@end

@interface TerminalViewCell : UITableViewCell

/** 终端号 */
@property(nonatomic,strong)UILabel *terminalLabel;
/** POS机 */
@property(nonatomic,strong)UILabel *posLabel;
/** 支付通道 */
@property(nonatomic,strong)UILabel *payRoad;
/** 开通状态 */
@property(nonatomic,strong)UILabel *dredgeStatus;

@property(nonatomic,strong)NSString *cellStates;

@property(nonatomic,strong)NSString *selectedID;

@property(nonatomic,assign)int indexNum;

@property(nonatomic,weak)id<terminalCellSendBtnClicked> TerminalViewCellDelegate;

-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier WithVedeos:(BOOL)ishaveVideo;

@end
