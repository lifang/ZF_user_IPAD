//
//  SystemNoticeCell.h
//  iPadff
//
//  Created by 黄含章 on 15/3/24.
//  Copyright (c) 2015年 LanTaiPro. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SystemNoticeCell : UITableViewCell

+(instancetype)cellWithTableView:(UITableView *)tableView;

@property(nonatomic,strong)UILabel *timeLabel;

@end
