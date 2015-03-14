//
//  RentBackCell.m
//  iPadff
//
//  Created by 黄含章 on 15/3/12.
//  Copyright (c) 2015年 LanTaiPro. All rights reserved.
//

#import "RentBackCell.h"

@implementation RentBackCell

-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        NSLog(@"~~~~~%@",reuseIdentifier);
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
        
        self.RentBackNum = [[UILabel alloc]init];
        _RentBackNum.textColor = mainColor;
        _RentBackNum.font = mainFont;
        _RentBackNum.textAlignment = NSTextAlignmentCenter;
        _RentBackNum.font = mainFont;
        [self addSubview:_RentBackNum];
        
        self.RentBackTime = [[UILabel alloc]init];
        _RentBackTime.textColor = mainColor;
        _RentBackTime.font = mainFont;
        _RentBackTime.textAlignment = NSTextAlignmentCenter;
        _RentBackTime.font = mainFont;
        [self addSubview:_RentBackTime];
        
        self.RentBackStatus = [[UILabel alloc]init];
        _RentBackStatus.textColor = mainColor;
        _RentBackStatus.font = mainFont;
        _RentBackStatus.font = mainFont;
        _RentBackStatus.textAlignment = NSTextAlignmentCenter;
        [self addSubview:_RentBackStatus];
        
        self.RentBackCelltype = [self RentBackCelltypeWithString:reuseIdentifier];
        
        switch (_RentBackCelltype) {
            case RentBackCellTypeReady:
                _RentBackStatus.text = @"待处理";
                for (int i = 0; i < 1; i++) {
                    UIButton *button = [[UIButton alloc]init];
                    button.titleLabel.font = [UIFont systemFontOfSize:17];
                    CALayer *readBtnLayer = [button layer];
                    [readBtnLayer setMasksToBounds:YES];
                    [readBtnLayer setCornerRadius:2.0];
                    [readBtnLayer setBorderWidth:1.0];
                    [readBtnLayer setBorderColor:[[UIColor orangeColor] CGColor]];
                    button.tag = i + 229;
                    [button addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
                    button.frame = CGRectMake(mainBtnX, 15 + i * mainBtnH + 4, mainBtnW, mainBtnH);
                    button.backgroundColor = [UIColor clearColor];
                    [button setTitleColor:[UIColor orangeColor] forState:UIControlStateNormal];
                    [button setTitle:@"取消申请" forState:UIControlStateNormal];
                    [self addSubview:button];
                }
                break;
                
            case RentBackCellTypeIng:
                _RentBackStatus.text = @"处理中";
                break;
                
            case RentBackCellTypeDone:
                _RentBackStatus.text = @"处理完成";
                break;
                
            case RentBackCellTypeAbolish:
                _RentBackStatus.text = @"已取消";
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
    CGFloat mainH = 10.f;
    
    _RentBackNum.frame = CGRectMake(30, mainY, 160, mainH);
    
    _terminalLabel.frame = CGRectMake(CGRectGetMaxX(_RentBackNum.frame), mainY, 160, mainH);
    
    _RentBackTime.frame = CGRectMake(CGRectGetMaxX(_terminalLabel.frame), mainY, 180, mainH);
    
    _RentBackStatus.frame = CGRectMake(CGRectGetMaxX(_RentBackTime.frame) + 30, mainY, 70, mainH);
    
}

-(RentBackCellType)RentBackCelltypeWithString:(NSString *)reuseIdentifier
{
    RentBackCellType type = RentBackCellTypeDone;
    if ([reuseIdentifier isEqualToString:@"RentBackCell1"]) {
        type = RentBackCellTypeReady;
    }
    if ([reuseIdentifier isEqualToString:@"RentBackCell2"]) {
        type = RentBackCellTypeIng;
    }
    if ([reuseIdentifier isEqualToString:@"RentBackCell4"]) {
        type = RentBackCellTypeDone;
    }
    if ([reuseIdentifier isEqualToString:@"RentBackCell5"]) {
        type = RentBackCellTypeAbolish;
    }
    return type;
}

/**
 Btn Tag
 229 取消申请
 */


-(void)buttonClick:(UIButton *)button
{
    [self.RentBackCellBtnDelegate RentBackCellBtnClick:button.tag WithSelectedID:_selectedID];
}


@end
