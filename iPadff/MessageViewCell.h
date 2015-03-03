//
//  MessageViewCell.h
//  iPadff
//
//  Created by 黄含章 on 15/3/3.
//  Copyright (c) 2015年 LanTaiPro. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MessageViewCell : UITableViewCell

+(instancetype)cellWithTableView:(UITableView *)tableView;

@property(nonatomic,strong)UIButton *leftBtn;

@property(nonatomic,strong)UILabel *timeLabel;

@property(nonatomic,assign)BOOL btnStatus;
@end
