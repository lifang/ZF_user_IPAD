//
//  SystemNoticeCell.m
//  iPadff
//
//  Created by 黄含章 on 15/3/24.
//  Copyright (c) 2015年 LanTaiPro. All rights reserved.
//

#import "SystemNoticeCell.h"

@implementation SystemNoticeCell

+(instancetype)cellWithTableView:(UITableView *)tableView
{
    static NSString *ID = @"system";
    SystemNoticeCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (cell == nil) {
        cell = [[SystemNoticeCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:ID];
    }
    return cell;
}

-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        //设置标题的字体
        self.textLabel.font = [UIFont systemFontOfSize:18];
        self.textLabel.textColor = [UIColor blackColor];
        self.timeLabel = [[UILabel alloc]init];
        self.timeLabel.translatesAutoresizingMaskIntoConstraints = NO;
        _timeLabel.textColor = kColor(70, 70, 70, 1.0);
        _timeLabel.font = [UIFont systemFontOfSize:14];
        [self addSubview:_timeLabel];
        
    }
    return self;
}

#pragma mark - 调整子控件的位置
-(void)layoutSubviews
{
    [super layoutSubviews];
    self.textLabel.textColor = [UIColor blackColor];
    self.timeLabel.textColor = kColor(70, 70, 70, 1.0);
    self.textLabel.frame = CGRectMake(80, 10, 400, 40);
    
    [self addConstraint:[NSLayoutConstraint constraintWithItem:_timeLabel
                                                     attribute:NSLayoutAttributeTop
                                                     relatedBy:NSLayoutRelationEqual
                                                        toItem:self
                                                     attribute:NSLayoutAttributeTop
                                                    multiplier:1.0
                                                      constant:10]];
    [self addConstraint:[NSLayoutConstraint constraintWithItem:_timeLabel
                                                     attribute:NSLayoutAttributeLeft
                                                     relatedBy:NSLayoutRelationEqual
                                                        toItem:self.textLabel
                                                     attribute:NSLayoutAttributeRight
                                                    multiplier:1.0
                                                      constant:350]];
    [self addConstraint:[NSLayoutConstraint constraintWithItem:_timeLabel
                                                     attribute:NSLayoutAttributeWidth
                                                     relatedBy:NSLayoutRelationEqual
                                                        toItem:nil
                                                     attribute:NSLayoutAttributeNotAnAttribute
                                                    multiplier:0.0
                                                      constant:200]];
    [self addConstraint:[NSLayoutConstraint constraintWithItem:_timeLabel
                                                     attribute:NSLayoutAttributeHeight
                                                     relatedBy:NSLayoutRelationEqual
                                                        toItem:nil
                                                     attribute:NSLayoutAttributeNotAnAttribute
                                                    multiplier:1.0
                                                      constant:40]];
}


@end
