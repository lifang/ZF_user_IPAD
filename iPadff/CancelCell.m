//
//  CancelCell.m
//  iPadff
//
//  Created by 黄含章 on 15/3/12.
//  Copyright (c) 2015年 LanTaiPro. All rights reserved.
//

#import "CancelCell.h"

@implementation CancelCell

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
        
        self.CancelNum = [[UILabel alloc]init];
        _CancelNum.textColor = mainColor;
        _CancelNum.font = mainFont;
        _CancelNum.textAlignment = NSTextAlignmentCenter;
        _CancelNum.font = mainFont;
        [self addSubview:_CancelNum];
        
        self.CancelTime = [[UILabel alloc]init];
        _CancelTime.textColor = mainColor;
        _CancelTime.font = mainFont;
        _CancelTime.textAlignment = NSTextAlignmentCenter;
        _CancelTime.font = mainFont;
        [self addSubview:_CancelTime];
        
        self.CancelStatus = [[UILabel alloc]init];
        _CancelStatus.textColor = mainColor;
        _CancelStatus.font = mainFont;
        _CancelStatus.font = mainFont;
        _CancelStatus.textAlignment = NSTextAlignmentCenter;
        [self addSubview:_CancelStatus];
        
        self.CancelCellBtntype = [self CancelBtntypeWithString:reuseIdentifier];
        
        switch (_CancelCellBtntype) {
            case CancelCellBtnReady:
                _CancelStatus.text = @"待处理";
                for (int i = 0; i < 1; i++) {
                    UIButton *button = [[UIButton alloc]init];
                    button.titleLabel.font = [UIFont systemFontOfSize:17];
                    CALayer *readBtnLayer = [button layer];
                    [readBtnLayer setMasksToBounds:YES];
                    [readBtnLayer setCornerRadius:2.0];
                    [readBtnLayer setBorderWidth:1.0];
                    [readBtnLayer setBorderColor:[[UIColor orangeColor] CGColor]];
                    button.tag = i + 222;
                    [button addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
                    button.frame = CGRectMake(mainBtnX, 15 + i * mainBtnH + 4, mainBtnW, mainBtnH);
                    button.backgroundColor = [UIColor clearColor];
                    [button setTitleColor:[UIColor orangeColor] forState:UIControlStateNormal];
                    [button setTitle:@"取消申请" forState:UIControlStateNormal];
                    [self addSubview:button];
                }
                break;
                
            case CancelCellBtnAbolish:
                _CancelStatus.text = @"已取消";
                for (int i = 0; i < 1; i++) {
                    UIButton *button = [[UIButton alloc]init];
                    button.titleLabel.font = [UIFont systemFontOfSize:17];
                    CALayer *readBtnLayer = [button layer];
                    [readBtnLayer setMasksToBounds:YES];
                    [readBtnLayer setCornerRadius:2.0];
                    [readBtnLayer setBorderWidth:1.0];
                    [readBtnLayer setBorderColor:[[UIColor orangeColor] CGColor]];
                    button.tag = i + 223;
                    [button addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
                    button.frame = CGRectMake(mainBtnX, 15 + i * mainBtnH, mainBtnW, mainBtnH);
                    button.backgroundColor = kColor(252, 78, 29, 1.0);
                    [button setTitle:@"重新提交注销" forState:UIControlStateNormal];
                    [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
                    [self addSubview:button];
                }
                break;
                
            case CancelCellBtnDone:
                _CancelStatus.text = @"处理完成";
                break;
                
            case CancelCellBtnIng:
                _CancelStatus.text = @"处理中";
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
    
    _CancelNum.frame = CGRectMake(30, mainY, 160, mainH);
    
    _terminalLabel.frame = CGRectMake(CGRectGetMaxX(_CancelNum.frame), mainY, 160, mainH);
    
    _CancelTime.frame = CGRectMake(CGRectGetMaxX(_terminalLabel.frame), mainY, 180, mainH);
    
    _CancelStatus.frame = CGRectMake(CGRectGetMaxX(_CancelTime.frame) + 30, mainY, 70, mainH);
    
}

-(CancelCellBtnType)CancelBtntypeWithString:(NSString *)reuseIdentifier
{
    CancelCellBtnType type = CancelCellBtnTypeNone;
    if ([reuseIdentifier isEqualToString:@"CancelCell1"]) {
        type = CancelCellBtnReady;
    }
    if ([reuseIdentifier isEqualToString:@"CancelCell2"]) {
        type = CancelCellBtnIng;
    }
    if ([reuseIdentifier isEqualToString:@"CancelCell4"]) {
        type = CancelCellBtnDone;
    }
    if ([reuseIdentifier isEqualToString:@"CancelCell5"]) {
        type = CancelCellBtnAbolish;
    }
    return type;
}

/**
 Btn Tag
 222 取消申请
 223 重新提交注销
 */


-(void)buttonClick:(UIButton *)button
{
    [self.CancelCellBtndelegate CancelCellBtnClick:button.tag WithSelectedID:_selectedID];
}



@end
