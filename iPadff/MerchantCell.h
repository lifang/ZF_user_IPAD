//
//  MerchantCell.h
//  iPadff
//
//  Created by wufei on 15/3/16.
//  Copyright (c) 2015年 LanTaiPro. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MerchantModel.h"

@interface MerchantCell : UITableViewCell

@property(strong,nonatomic) UIView * backView;

@property(strong,nonatomic) UILabel * titleLB;

@property(strong,nonatomic) UIButton * deleteBtn;

@property(strong,nonatomic) MerchantModel * merchantModel;
@property(weak,nonatomic) id superTarget;
-(void)setMerchantModel:(MerchantModel *)merchantModel andTarget:(id)target;

@end
