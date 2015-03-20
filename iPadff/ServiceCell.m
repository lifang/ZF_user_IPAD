//
//  ServiceCell.m
//  iPadff
//
//  Created by 黄含章 on 15/3/12.
//  Copyright (c) 2015年 LanTaiPro. All rights reserved.
//

#import "ServiceCell.h"

@implementation ServiceCell

-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        NSLog(@"~~~~~%@",reuseIdentifier);
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
        
        self.seviceNum = [[UILabel alloc]init];
        _seviceNum.textColor = mainColor;
        _seviceNum.font = mainFont;
        _seviceNum.textAlignment = NSTextAlignmentCenter;
        _seviceNum.font = mainFont;
        [self addSubview:_seviceNum];
        
        self.seviceTime = [[UILabel alloc]init];
        _seviceTime.textColor = mainColor;
        _seviceTime.font = mainFont;
        _seviceTime.textAlignment = NSTextAlignmentCenter;
        _seviceTime.font = mainFont;
        [self addSubview:_seviceTime];
        
        self.seviceStatus = [[UILabel alloc]init];
        _seviceStatus.textColor = mainColor;
        _seviceStatus.font = mainFont;
        _seviceStatus.font = mainFont;
        _seviceStatus.textAlignment = NSTextAlignmentCenter;
        [self addSubview:_seviceStatus];
        
        self.ServieceBtntype = [self ServieceBtntypeWithString:reuseIdentifier];
        
        switch (_ServieceBtntype) {
            case ServieceBtnTypePay:
                _seviceStatus.text = @"未付款";
                for (int i = 0; i < 2; i++) {
                    UIButton *button = [[UIButton alloc]init];
                    button.titleLabel.font = [UIFont systemFontOfSize:17];
                    CALayer *readBtnLayer = [button layer];
                    [readBtnLayer setMasksToBounds:YES];
                    [readBtnLayer setCornerRadius:2.0];
                    [readBtnLayer setBorderWidth:1.0];
                    [readBtnLayer setBorderColor:[[UIColor orangeColor] CGColor]];
                    button.tag = i + 111;
                    [button addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
                    button.frame = CGRectMake(mainBtnX, 15 + i * mainBtnH, mainBtnW, mainBtnH);
                    [self addSubview:button];
                    if (i == 0) {
                        button.backgroundColor = kColor(252, 78, 29, 1.0);
                        [button setTitle:@"支付维修费" forState:UIControlStateNormal];
                        [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
                    }
                    else{
                        button.frame = CGRectMake(mainBtnX, 15 + i * mainBtnH + 10, mainBtnW, mainBtnH);
                        button.backgroundColor = [UIColor clearColor];
                        [button setTitleColor:[UIColor orangeColor] forState:UIControlStateNormal];
                        [button setTitle:@"取消申请" forState:UIControlStateNormal];
                    }

                }
                break;
                
                case ServieceBtnTypeback:
                _seviceStatus.text = @"待发回";
                for (int i = 0; i < 1; i++) {
                    UIButton *button = [[UIButton alloc]init];
                    button.titleLabel.font = [UIFont systemFontOfSize:17];
                    CALayer *readBtnLayer = [button layer];
                    [readBtnLayer setMasksToBounds:YES];
                    [readBtnLayer setCornerRadius:2.0];
                    [readBtnLayer setBorderWidth:1.0];
                    [readBtnLayer setBorderColor:[[UIColor orangeColor] CGColor]];
                    button.tag = i + 113;
                    [button addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
                    button.frame = CGRectMake(mainBtnX, 15 + i * mainBtnH, mainBtnW, mainBtnH);
                    button.backgroundColor = kColor(252, 78, 29, 1.0);
                    [button setTitle:@"提交物流信息" forState:UIControlStateNormal];
                    [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
                    [self addSubview:button];
                }
                break;
                
                case ServieceBtnTypeIng:
                _seviceStatus.text = @"维修中";
                break;
                
                case ServieceBtnTypeDone:
                _seviceStatus.text = @"处理完成";
                break;
                
                case ServieceBtnTypeCancel:
                _seviceStatus.text = @"已取消";
                break;

            default:
                break;
        }
    }
    return self;
}

-(ServieceBtnType)ServieceBtntypeWithString:(NSString *)reuseIdentifier
{
    ServieceBtnType type = ServieceBtnTypeNone;
    if ([reuseIdentifier isEqualToString:@"ServiceCell1"]) {
        type = ServieceBtnTypePay;
    }
    if ([reuseIdentifier isEqualToString:@"ServiceCell2"]) {
        type = ServieceBtnTypeback;
    }
    if ([reuseIdentifier isEqualToString:@"ServiceCell3"]) {
        type = ServieceBtnTypeIng;
    }
    if ([reuseIdentifier isEqualToString:@"ServiceCell4"]) {
        type = ServieceBtnTypeDone;
    }
    if ([reuseIdentifier isEqualToString:@"ServiceCell5"]) {
        type = ServieceBtnTypeCancel;
    }
    return type;
}

#pragma mark - 调整子控件的位置
-(void)layoutSubviews
{
    [super layoutSubviews];
    
    CGFloat mainY = self.frame.size.height / 2 - 5;
    CGFloat mainH = 10.f;
    
    _seviceNum.frame = CGRectMake(30, mainY, 160, mainH);
    
    _terminalLabel.frame = CGRectMake(CGRectGetMaxX(_seviceNum.frame), mainY, 160, mainH);
    
    _seviceTime.frame = CGRectMake(CGRectGetMaxX(_terminalLabel.frame), mainY, 180, mainH);
    
    _seviceStatus.frame = CGRectMake(CGRectGetMaxX(_seviceTime.frame) + 30, mainY, 70, mainH);
    
    
}

/**
 Btn Tag
 111 支付维修费
 112 取消申请
 113 提交物流信息
 */


-(void)buttonClick:(UIButton *)button
{
    [self.ServieceBtnDelgete serviceBtnClick:button.tag WithSelectedID:_selectedID WithRepair_price:_repair_price];
}

@end
