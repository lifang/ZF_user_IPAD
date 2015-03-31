//
//  ChangeGoodCell.m
//  iPadff
//
//  Created by 黄含章 on 15/3/12.
//  Copyright (c) 2015年 LanTaiPro. All rights reserved.
//

#import "ChangeGoodCell.h"

@implementation ChangeGoodCell

-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        UIFont *mainFont = [UIFont systemFontOfSize:14];
        CGFloat mainBtnW = 110.f;
        CGFloat mainBtnH = 40.f;
        CGFloat mainBtnX = (SCREEN_WIDTH - 130.f - 230.f);
        if (iOS7) {
            mainBtnX = SCREEN_HEIGHT - 130.f - 230.f;
        }
        UIColor *mainColor = kColor(79, 79, 79, 1.0);
        
        self.terminalLabel = [[UILabel alloc]init];
        _terminalLabel.textColor = mainColor;
        _terminalLabel.font = mainFont;
        _terminalLabel.textAlignment = NSTextAlignmentCenter;
        _terminalLabel.font = mainFont;
        [self addSubview:_terminalLabel];
        
        self.ChangeGoodNum = [[UILabel alloc]init];
        _ChangeGoodNum.textColor = mainColor;
        _ChangeGoodNum.font = mainFont;
        _ChangeGoodNum.textAlignment = NSTextAlignmentCenter;
        _ChangeGoodNum.font = mainFont;
        [self addSubview:_ChangeGoodNum];
        
        self.ChangeGoodTime = [[UILabel alloc]init];
        _ChangeGoodTime.textColor = mainColor;
        _ChangeGoodTime.font = mainFont;
        _ChangeGoodTime.textAlignment = NSTextAlignmentCenter;
        _ChangeGoodTime.font = mainFont;
        [self addSubview:_ChangeGoodTime];
        
        self.ChangeGoodStatus = [[UILabel alloc]init];
        _ChangeGoodStatus.textColor = mainColor;
        _ChangeGoodStatus.font = mainFont;
        _ChangeGoodStatus.font = mainFont;
        _ChangeGoodStatus.textAlignment = NSTextAlignmentCenter;
        [self addSubview:_ChangeGoodStatus];
        
        self.ChangeGoodCelltype = [self ChangeGoodCelltypeWithString:reuseIdentifier];
        
        switch (_ChangeGoodCelltype) {
            case ChangeGoodCellTypeReady:
                _ChangeGoodStatus.text = @"待处理";
                for (int i = 0; i < 1; i++) {
                    UIButton *button = [[UIButton alloc]init];
                    button.titleLabel.font = [UIFont systemFontOfSize:17];
                    CALayer *readBtnLayer = [button layer];
                    [readBtnLayer setMasksToBounds:YES];
                    [readBtnLayer setCornerRadius:2.0];
                    [readBtnLayer setBorderWidth:1.0];
                    [readBtnLayer setBorderColor:[[UIColor orangeColor] CGColor]];
                    button.tag = i + 226;
                    [button addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
                    button.frame = CGRectMake(mainBtnX, 15 + i * mainBtnH + 4, mainBtnW, mainBtnH);
                    button.backgroundColor = [UIColor clearColor];
                    [button setTitleColor:[UIColor orangeColor] forState:UIControlStateNormal];
                    [button setTitle:@"取消申请" forState:UIControlStateNormal];
                    [self addSubview:button];
                }
                break;
                
            case ChangeGoodCellTypeIng:
                _ChangeGoodStatus.text = @"换货中";
                for (int i = 0; i < 1; i++) {
                    UIButton *button = [[UIButton alloc]init];
                    button.titleLabel.font = [UIFont systemFontOfSize:17];
                    CALayer *readBtnLayer = [button layer];
                    [readBtnLayer setMasksToBounds:YES];
                    [readBtnLayer setCornerRadius:2.0];
                    [readBtnLayer setBorderWidth:1.0];
                    [readBtnLayer setBorderColor:[[UIColor orangeColor] CGColor]];
                    button.tag = i + 227;
                    [button addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
                    button.frame = CGRectMake(mainBtnX, 15 + i * mainBtnH, mainBtnW, mainBtnH);
                    button.backgroundColor = kColor(252, 78, 29, 1.0);
                    [button setTitle:@"提交物流信息" forState:UIControlStateNormal];
                    [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
                    [self addSubview:button];
                }
                break;
                
            case ChangeGoodCellTypeDone:
                _ChangeGoodStatus.text = @"处理完成";
                break;
                
            case ChangeGoodCellTypeAbolish:
                _ChangeGoodStatus.text = @"已取消";
                break;
                
            default:
                break;
        }
    }
    return self;
}

#pragma mark - 调整子控件的位置
-(void)layoutSubviews
{
    [super layoutSubviews];
    
    CGFloat mainY = self.frame.size.height / 2 - 5;
    CGFloat mainH = 15.f;
    
    _ChangeGoodNum.frame = CGRectMake(30, mainY, 160, mainH);
    
    _terminalLabel.frame = CGRectMake(CGRectGetMaxX(_ChangeGoodNum.frame), mainY, 160, mainH);
    
    _ChangeGoodTime.frame = CGRectMake(CGRectGetMaxX(_terminalLabel.frame), mainY, 180, mainH);
    
    _ChangeGoodStatus.frame = CGRectMake(CGRectGetMaxX(_ChangeGoodTime.frame) + 30, mainY, 70, mainH);
    
}

-(ChangeGoodCellType)ChangeGoodCelltypeWithString:(NSString *)reuseIdentifier
{
    ChangeGoodCellType type = ChangeGoodCellTypeNone;
    if ([reuseIdentifier isEqualToString:@"ChangeGoodCell1"]) {
        type = ChangeGoodCellTypeReady;
    }
    if ([reuseIdentifier isEqualToString:@"ChangeGoodCell2"]) {
        type = ChangeGoodCellTypeIng;
    }
    if ([reuseIdentifier isEqualToString:@"ChangeGoodCell4"]) {
        type = ChangeGoodCellTypeDone;
    }
    if ([reuseIdentifier isEqualToString:@"ChangeGoodCell5"]) {
        type = ChangeGoodCellTypeAbolish;
    }
    return type;
}

/**
 Btn Tag
 226 取消申请
 227 提交物流信息
 */


-(void)buttonClick:(UIButton *)button
{
    [self.ChangeGoodCellBtnDelegate ChangeGoodCellBtnClick:button.tag WithSelectedID:_selectedID];
}

@end
