//
//  IntegralCell.m
//  iPadff
//
//  Created by 黄含章 on 15/3/17.
//  Copyright (c) 2015年 LanTaiPro. All rights reserved.
//

#import "IntegralCell.h"

@interface IntegralCell()

@property(nonatomic,strong)NSString *reuseIdentifiers;

@end

@implementation IntegralCell

-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.reuseIdentifiers = reuseIdentifier;
        UIFont *mainFont = [UIFont systemFontOfSize:14];
        UIColor *mainColor = kColor(67, 67, 67, 1.0);

        _orderNumLabel = [[UILabel alloc]init];
        _orderNumLabel.textAlignment = NSTextAlignmentCenter;
        _orderNumLabel.textColor = mainColor;
        _orderNumLabel.font = mainFont;
        [self addSubview:_orderNumLabel];
        
        _tradeTimeLabel = [[UILabel alloc]init];
        _tradeTimeLabel.textAlignment = NSTextAlignmentCenter;
        _tradeTimeLabel.textColor = mainColor;
        _tradeTimeLabel.font = mainFont;
        [self addSubview:_tradeTimeLabel];
        
        _intergralLabel = [[UILabel alloc]init];
        _intergralLabel.textAlignment = NSTextAlignmentCenter;
        _intergralLabel.textColor = mainColor;
        _intergralLabel.font = mainFont;
        [self addSubview:_intergralLabel];
        
        _intergralType = [[UILabel alloc]init];
        _intergralType.textAlignment = NSTextAlignmentCenter;
        _intergralType.textColor = mainColor;
        _intergralType.font = mainFont;
        [self addSubview:_intergralType];
        
        
        if ([reuseIdentifier isEqualToString:@"IntegralCell1"]) {
            self.backgroundColor = kColor(228, 228, 228, 1.0);
            _orderNumLabel.text = @"订单单号";
            _tradeTimeLabel.text = @"交易时间";
            _intergralLabel.text = @"获得/使用积分";
            _intergralType.text = @"积分类型";
            _lineView.hidden = YES;
        }
        
        
    }
    return self;
}

-(void)layoutSubviews
{
    [super layoutSubviews];
    CGFloat mainY = 2.f;
    CGFloat mainHeight = 30.f;
    
    if ([_reuseIdentifiers isEqualToString:@"IntegralCell2"]) {
        mainY = 10.f;
    }
    
    _orderNumLabel.frame = CGRectMake(20, mainY, 160, mainHeight);
    _tradeTimeLabel.frame = CGRectMake(CGRectGetMaxX(_orderNumLabel.frame) + 50, mainY, 200, mainHeight);
    _intergralLabel.frame = CGRectMake(CGRectGetMaxX(_tradeTimeLabel.frame) + 50, mainY, 120, mainHeight);
    _intergralType.frame = CGRectMake(CGRectGetMaxX(_intergralLabel.frame) + 50, mainY, 120, mainHeight);
    
    
}

@end
