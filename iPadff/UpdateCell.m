//
//  UpdateCell.m
//  iPadff
//
//  Created by 黄含章 on 15/3/12.
//  Copyright (c) 2015年 LanTaiPro. All rights reserved.
//

#import "UpdateCell.h"

@implementation UpdateCell

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
        
        self.UpdateNum = [[UILabel alloc]init];
        _UpdateNum.textColor = mainColor;
        _UpdateNum.font = mainFont;
        _UpdateNum.textAlignment = NSTextAlignmentCenter;
        _UpdateNum.font = mainFont;
        [self addSubview:_UpdateNum];
        
        self.UpdateTime = [[UILabel alloc]init];
        _UpdateTime.textColor = mainColor;
        _UpdateTime.font = mainFont;
        _UpdateTime.textAlignment = NSTextAlignmentCenter;
        _UpdateTime.font = mainFont;
        [self addSubview:_UpdateTime];
        
        self.UpdateStatus = [[UILabel alloc]init];
        _UpdateStatus.textColor = mainColor;
        _UpdateStatus.font = mainFont;
        _UpdateStatus.font = mainFont;
        _UpdateStatus.textAlignment = NSTextAlignmentCenter;
        [self addSubview:_UpdateStatus];
        
        self.UpdateCelltype = [self UpdateCelltypeWithString:reuseIdentifier];
        
        switch (_UpdateCelltype) {
            case UpdateCellTypeReady:
                _UpdateStatus.text = @"待处理";
                for (int i = 0; i < 1; i++) {
                    UIButton *button = [[UIButton alloc]init];
                    button.titleLabel.font = [UIFont systemFontOfSize:17];
                    CALayer *readBtnLayer = [button layer];
                    [readBtnLayer setMasksToBounds:YES];
                    [readBtnLayer setCornerRadius:2.0];
                    [readBtnLayer setBorderWidth:1.0];
                    [readBtnLayer setBorderColor:[[UIColor orangeColor] CGColor]];
                    button.tag = i + 228;
                    [button addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
                    button.frame = CGRectMake(mainBtnX, 15 + i * mainBtnH + 4, mainBtnW, mainBtnH);
                    button.backgroundColor = [UIColor clearColor];
                    [button setTitleColor:[UIColor orangeColor] forState:UIControlStateNormal];
                    [button setTitle:@"取消申请" forState:UIControlStateNormal];
                    [self addSubview:button];
                }
                break;
                
            case UpdateCellTypeIng:
                _UpdateStatus.text = @"处理中";
                break;
                
            case UpdateCellTypeDone:
                _UpdateStatus.text = @"处理完成";
                break;
                
            case UpdateCellTypeAbolish:
                _UpdateStatus.text = @"已取消";
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
    
    _UpdateNum.frame = CGRectMake(30, mainY, 160, mainH);
    
    _terminalLabel.frame = CGRectMake(CGRectGetMaxX(_UpdateNum.frame), mainY, 160, mainH);
    
    _UpdateTime.frame = CGRectMake(CGRectGetMaxX(_terminalLabel.frame), mainY, 180, mainH);
    
    _UpdateStatus.frame = CGRectMake(CGRectGetMaxX(_UpdateTime.frame) + 30, mainY, 70, mainH);
    
}

-(UpdateCellType)UpdateCelltypeWithString:(NSString *)reuseIdentifier
{
    UpdateCellType type = UpdateCellTypeNone;
    if ([reuseIdentifier isEqualToString:@"UpdateCell1"]) {
        type = UpdateCellTypeReady;
    }
    if ([reuseIdentifier isEqualToString:@"UpdateCell2"]) {
        type = UpdateCellTypeIng;
    }
    if ([reuseIdentifier isEqualToString:@"UpdateCell4"]) {
        type = UpdateCellTypeDone;
    }
    if ([reuseIdentifier isEqualToString:@"UpdateCell5"]) {
        type = UpdateCellTypeAbolish;
    }
    return type;
}

/**
 Btn Tag
 228 取消申请
 */


-(void)buttonClick:(UIButton *)button
{
    [self.UpdateCellBtnDelegate UpdateCellBtnClick:button.tag WithSelectedID:_selectedID];
}

@end
