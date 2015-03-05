//
//  MessageViewCell.m
//  iPadff
//
//  Created by 黄含章 on 15/3/3.
//  Copyright (c) 2015年 LanTaiPro. All rights reserved.
//

#import "MessageViewCell.h"

@implementation MessageViewCell

+(instancetype)cellWithTableView:(UITableView *)tableView
{
    static NSString *ID = @"dynamic";
    MessageViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (cell == nil) {
        cell = [[MessageViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:ID];
    }
    return cell;
}

-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        //设置标题的字体
        self.textLabel.font = [UIFont boldSystemFontOfSize:18];
        self.textLabel.textColor = [UIColor blackColor];
        self.detailTextLabel.font = [UIFont systemFontOfSize:14];
        self.detailTextLabel.textColor = [UIColor blackColor];
        self.leftBtn = [[UIButton alloc]init];
        self.btnStatus = YES;
        [_leftBtn addTarget:self action:@selector(btnClicked) forControlEvents:UIControlEventTouchUpInside];
        [_leftBtn setBackgroundImage:[UIImage imageNamed:@"noSelected"] forState:UIControlStateNormal];
        [self addSubview:_leftBtn];
        self.timeLabel = [[UILabel alloc]init];
        _timeLabel.font = [UIFont systemFontOfSize:14];
        [self addSubview:_timeLabel];
    }
    return self;
}

-(void)btnClicked
{
    if (self.btnStatus == YES) {
        [_leftBtn setBackgroundImage:[UIImage imageNamed:@"selected"] forState:UIControlStateNormal];
    }
    else{
        [_leftBtn setBackgroundImage:[UIImage imageNamed:@"noSelected"] forState:UIControlStateNormal];
    }
    
    self.btnStatus = !self.btnStatus;
}

#pragma mark - 调整子控件的位置
-(void)layoutSubviews
{
    [super layoutSubviews];
    
    self.leftBtn.frame = CGRectMake(30, 10, 30, 30);
    self.textLabel.frame = CGRectMake(CGRectGetMaxX(_leftBtn.frame) + 20, 5, 400, 40);
    self.detailTextLabel.frame = CGRectMake(CGRectGetMaxX(self.textLabel.frame) + 200, 5, 100, 40);
    self.timeLabel.frame = CGRectMake(CGRectGetMaxX(self.detailTextLabel.frame) + 50, 5, 60, 40);
}

@end
