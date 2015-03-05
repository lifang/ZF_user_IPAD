//
//  DredgeViewCell.h
//  iPadff
//
//  Created by 黄含章 on 15/3/4.
//  Copyright (c) 2015年 LanTaiPro. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DredgeViewCell : UITableViewCell

+(instancetype)cellWithTableView:(UITableView *)tableView;
/** 终端号 */
@property(nonatomic,strong)UILabel *terminalLabel;
/** POS机 */
@property(nonatomic,strong)UILabel *posLabel;
/** 支付通道 */
@property(nonatomic,strong)UILabel *payRoad;
/** 开通状态 */
@property(nonatomic,strong)UILabel *dredgeStatus;
/** 申请开通 */
@property(nonatomic,strong)UIButton *applicationBtn;
/** 视频认证 */
@property(nonatomic,strong)UIButton *vedioConfirmBtn;

@end
