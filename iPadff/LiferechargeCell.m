//
//  LiferechargeCell.m
//  iPadff
//
//  Created by 黄含章 on 15/3/6.
//  Copyright (c) 2015年 LanTaiPro. All rights reserved.
//

#import "LiferechargeCell.h"

@implementation LiferechargeCell

+(instancetype)cellWithTableView:(UITableView *)tableView
{
    static NSString *ID = @"LiferechargeCell";
    LiferechargeCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (cell == nil) {
        cell = [[LiferechargeCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:ID];
    }
    return cell;
}

-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        UIFont *mainFont = [UIFont systemFontOfSize:14];
        UIColor *mainColor = kColor(67, 67, 67, 1.0);
        
        self.timeLabel = [[UILabel alloc]init];
        _timeLabel.font = mainFont;
        _timeLabel.textColor = mainColor;
        [self addSubview:_timeLabel];
        
        self.usernameLabel = [[UILabel alloc]init];
        _usernameLabel.font = mainFont;
        _usernameLabel.textColor = mainColor;
        [self addSubview:_usernameLabel];
        
        self.useraccountLabel = [[UILabel alloc]init];
        _useraccountLabel.font = mainFont;
        _useraccountLabel.textColor = mainColor;
        [self addSubview:_useraccountLabel];
        
        self.terminalLabel = [[UILabel alloc]init];
        _terminalLabel.font = mainFont;
        _terminalLabel.textColor = mainColor;
        [self addSubview:_terminalLabel];
        
        self.dealMoney = [[UILabel alloc]init];
        _dealMoney.font = mainFont;
        _dealMoney.textColor = mainColor;
        [self addSubview:_dealMoney];
        
        self.dealStates = [[UILabel alloc]init];
        _dealStates.font = mainFont;
        _dealStates.textColor = mainColor;
        [self addSubview:_dealStates];
        
        
    }
    return self;
}

-(void)layoutSubviews
{
    [super layoutSubviews];
    
    CGFloat mainY = 25.f;
    
    _timeLabel.frame = CGRectMake(40, mainY, 180, mainY);
    
    _usernameLabel.frame = CGRectMake(CGRectGetMaxX(_timeLabel.frame) + 40, mainY, 180, mainY);
    
    _useraccountLabel.frame = CGRectMake(CGRectGetMaxX(_usernameLabel.frame) - 40 , mainY, 180, mainY);
    
    _terminalLabel.frame = CGRectMake(CGRectGetMaxX(_useraccountLabel.frame) , mainY, 200, mainY);
    
    _dealMoney.frame = CGRectMake(CGRectGetMaxX(_terminalLabel.frame) - 15, mainY, 100, mainY);
    
    _dealStates.frame = CGRectMake(CGRectGetMaxX(_dealMoney.frame) + 45, mainY, 50, mainY);
    
}

@end
