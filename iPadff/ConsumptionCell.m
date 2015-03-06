//
//  ConsumptionCell.m
//  iPadff
//
//  Created by 黄含章 on 15/3/6.
//  Copyright (c) 2015年 LanTaiPro. All rights reserved.
//

#import "ConsumptionCell.h"

@implementation ConsumptionCell

+(instancetype)cellWithTableView:(UITableView *)tableView
{
    static NSString *ID = @"ConsumptionCell";
    ConsumptionCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (cell == nil) {
        cell = [[ConsumptionCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:ID];
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
        
        self.settleLabel = [[UILabel alloc]init];
        _settleLabel.font = mainFont;
        _settleLabel.textColor = mainColor;
        [self addSubview:_settleLabel];
        
        self.poundageLabel = [[UILabel alloc]init];
        _poundageLabel.font = mainFont;
        _poundageLabel.textColor = mainColor;
        [self addSubview:_poundageLabel];
        
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
    
    _settleLabel.frame = CGRectMake(CGRectGetMaxX(_timeLabel.frame) + 10, mainY, 180, mainY);
    
    _poundageLabel.frame = CGRectMake(CGRectGetMaxX(_settleLabel.frame) , mainY, 180, mainY);
    
    _terminalLabel.frame = CGRectMake(CGRectGetMaxX(_poundageLabel.frame) - 25, mainY, 200, mainY);
    
    _dealMoney.frame = CGRectMake(CGRectGetMaxX(_terminalLabel.frame) - 24, mainY, 100, mainY);
    
    _dealStates.frame = CGRectMake(CGRectGetMaxX(_dealMoney.frame) + 70, mainY, 30, mainY);
    
}

@end
