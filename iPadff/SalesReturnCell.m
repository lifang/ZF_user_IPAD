//
//  SalesReturnCell.m
//  iPadff
//
//  Created by 黄含章 on 15/3/12.
//  Copyright (c) 2015年 LanTaiPro. All rights reserved.
//

#import "SalesReturnCell.h"

@implementation SalesReturnCell

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
        
        self.SalesReturnNum = [[UILabel alloc]init];
        _SalesReturnNum.textColor = mainColor;
        _SalesReturnNum.font = mainFont;
        _SalesReturnNum.textAlignment = NSTextAlignmentCenter;
        _SalesReturnNum.font = mainFont;
        [self addSubview:_SalesReturnNum];
        
        self.SalesReturnTime = [[UILabel alloc]init];
        _SalesReturnTime.textColor = mainColor;
        _SalesReturnTime.font = mainFont;
        _SalesReturnTime.textAlignment = NSTextAlignmentCenter;
        _SalesReturnTime.font = mainFont;
        [self addSubview:_SalesReturnTime];
        
        self.SalesReturnStatus = [[UILabel alloc]init];
        _SalesReturnStatus.textColor = mainColor;
        _SalesReturnStatus.font = mainFont;
        _SalesReturnStatus.font = mainFont;
        _SalesReturnStatus.textAlignment = NSTextAlignmentCenter;
        [self addSubview:_SalesReturnStatus];
        
        self.SalesReturnCelltype = [self SalesReturnCelltypeWithString:reuseIdentifier];
        
        switch (_SalesReturnCelltype) {
            case SalesReturnCellTypeReady:
                _SalesReturnStatus.text = @"待处理";
                for (int i = 0; i < 1; i++) {
                    UIButton *button = [[UIButton alloc]init];
                    button.titleLabel.font = [UIFont systemFontOfSize:17];
                    CALayer *readBtnLayer = [button layer];
                    [readBtnLayer setMasksToBounds:YES];
                    [readBtnLayer setCornerRadius:2.0];
                    [readBtnLayer setBorderWidth:1.0];
                    [readBtnLayer setBorderColor:[[UIColor orangeColor] CGColor]];
                    button.tag = i + 224;
                    [button addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
                    button.frame = CGRectMake(mainBtnX, 15 + i * mainBtnH + 10, mainBtnW, mainBtnH);
                    button.backgroundColor = [UIColor clearColor];
                    [button setTitleColor:[UIColor orangeColor] forState:UIControlStateNormal];
                    [button setTitle:@"取消申请" forState:UIControlStateNormal];
                    [self addSubview:button];
                }
                break;
                
            case SalesReturnCellTypeIng:
                _SalesReturnStatus.text = @"退货中";
                for (int i = 0; i < 1; i++) {
                    UIButton *button = [[UIButton alloc]init];
                    button.titleLabel.font = [UIFont systemFontOfSize:17];
                    CALayer *readBtnLayer = [button layer];
                    [readBtnLayer setMasksToBounds:YES];
                    [readBtnLayer setCornerRadius:2.0];
                    [readBtnLayer setBorderWidth:1.0];
                    [readBtnLayer setBorderColor:[[UIColor orangeColor] CGColor]];
                    button.tag = i + 225;
                    [button addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
                    button.frame = CGRectMake(mainBtnX, 15 + i * mainBtnH, mainBtnW, mainBtnH);
                    button.backgroundColor = kColor(252, 78, 29, 1.0);
                    [button setTitle:@"提交物流信息" forState:UIControlStateNormal];
                    [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
                    [self addSubview:button];
                }
                break;
                
            case SalesReturnCellTypeDone:
                _SalesReturnStatus.text = @"处理完成";
                break;
                
            case SalesReturnCellTypeAbolish:
                _SalesReturnStatus.text = @"已取消";
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
    
    _SalesReturnNum.frame = CGRectMake(10, mainY, 160, mainH);
    
    _terminalLabel.frame = CGRectMake(CGRectGetMaxX(_SalesReturnNum.frame), mainY, 160, mainH);
    
    _SalesReturnTime.frame = CGRectMake(CGRectGetMaxX(_terminalLabel.frame), mainY, 180, mainH);
    
    _SalesReturnStatus.frame = CGRectMake(CGRectGetMaxX(_SalesReturnTime.frame) + 30, mainY, 70, mainH);
    
}

-(SalesReturnCellType)SalesReturnCelltypeWithString:(NSString *)reuseIdentifier
{
    SalesReturnCellType type = SalesReturnCellTypeNone;
    if ([reuseIdentifier isEqualToString:@"SalesReturnCell1"]) {
        type = SalesReturnCellTypeReady;
    }
    if ([reuseIdentifier isEqualToString:@"SalesReturnCell2"]) {
        type = SalesReturnCellTypeAbolish;
    }
    if ([reuseIdentifier isEqualToString:@"SalesReturnCell3"]) {
        type = SalesReturnCellTypeDone;
    }
    if ([reuseIdentifier isEqualToString:@"SalesReturnCell4"]) {
        type = SalesReturnCellTypeIng;
    }
    return type;
}

/**
 Btn Tag
 224 取消申请
 225 提交物流信息
 */


-(void)buttonClick:(UIButton *)button
{
    [self.SalesReturnCellBtnDelegate SalesReturnCellBtnClick:button.tag];
}


@end
