//
//  TerminalViewCell.m
//  iPadff
//
//  Created by 黄含章 on 15/3/5.
//  Copyright (c) 2015年 LanTaiPro. All rights reserved.
//

#import "TerminalViewCell.h"

@implementation TerminalViewCell

-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        UIFont *mainFont = [UIFont systemFontOfSize:14];
        
        CGFloat mainBtnW = 110.f;
        CGFloat mainBtnH = 40.f;
        CGFloat mainBtnX = (SCREEN_WIDTH - 130.f);
        CGFloat mainBtnY = 20.f;
        
        self.terminalLabel = [[UILabel alloc]init];
        _terminalLabel.font = mainFont;
        [self addSubview:_terminalLabel];
        
        self.posLabel = [[UILabel alloc]init];
        _posLabel.font = mainFont;
        [self addSubview:_posLabel];
        
        self.payRoad = [[UILabel alloc]init];
        _payRoad.font = mainFont;
        [self addSubview:_payRoad];
        
        self.dredgeStatus = [[UILabel alloc]init];
        _dredgeStatus.font = mainFont;
        _dredgeStatus.textAlignment = UITextAlignmentCenter;
        [self addSubview:_dredgeStatus];
        
        if ([reuseIdentifier isEqualToString:@"cell-已开通"]) {
            for (int i = 0; i < 2; i++) {
                UIButton *button = [[UIButton alloc]init];
                button.titleLabel.font = [UIFont systemFontOfSize:17];
                [button setTitleColor:[UIColor orangeColor] forState:UIControlStateNormal];
                CALayer *readBtnLayer = [button layer];
                [readBtnLayer setMasksToBounds:YES];
                [readBtnLayer setCornerRadius:2.0];
                [readBtnLayer setBorderWidth:1.0];
                [readBtnLayer setBorderColor:[[UIColor orangeColor] CGColor]];
                button.backgroundColor = [UIColor clearColor];
                button.tag = i + 1000;
                [button addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
                button.frame = CGRectMake(mainBtnX - (i * 120), mainBtnY, mainBtnW, mainBtnH);
                [self addSubview:button];
                if (i == 0) {
                    [button setTitle:@"找回POS密码" forState:UIControlStateNormal];
                }
                else{
                    [button setTitle:@"视频认证" forState:UIControlStateNormal];
                }
            }
        }
        if ([reuseIdentifier isEqualToString:@"cell-未开通"]) {
            for (int i = 0; i < 3; i++) {
                UIButton *button = [[UIButton alloc]init];
                button.titleLabel.font = [UIFont systemFontOfSize:17];
                [button setTitleColor:[UIColor orangeColor] forState:UIControlStateNormal];
                CALayer *readBtnLayer = [button layer];
                [readBtnLayer setMasksToBounds:YES];
                [readBtnLayer setCornerRadius:2.0];
                [readBtnLayer setBorderWidth:1.0];
                [readBtnLayer setBorderColor:[[UIColor orangeColor] CGColor]];
                button.backgroundColor = [UIColor clearColor];
                button.tag = i + 2000;
                [button addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
                button.frame = CGRectMake(mainBtnX - (i * 120), mainBtnY, mainBtnW, mainBtnH);
                [self addSubview:button];
                if (i == 0) {
                    [button setTitle:@"视频认证" forState:UIControlStateNormal];
                }
                if (i == 1) {
                    [button setTitle:@"申请开通" forState:UIControlStateNormal];
                }
                if (i == 2) {
                    [button setTitle:@"同步" forState:UIControlStateNormal];
                }
            }
        }
        if ([reuseIdentifier isEqualToString:@"cell-部分开通"]) {
            for (int i = 0; i < 4; i++) {
                UIButton *button = [[UIButton alloc]init];
                button.titleLabel.font = [UIFont systemFontOfSize:17];
                [button setTitleColor:[UIColor orangeColor] forState:UIControlStateNormal];
                CALayer *readBtnLayer = [button layer];
                [readBtnLayer setMasksToBounds:YES];
                [readBtnLayer setCornerRadius:2.0];
                [readBtnLayer setBorderWidth:1.0];
                [readBtnLayer setBorderColor:[[UIColor orangeColor] CGColor]];
                button.backgroundColor = [UIColor clearColor];
                button.tag = i + 3000;
                [button addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
                button.frame = CGRectMake(mainBtnX - (i * 120), mainBtnY, mainBtnW, mainBtnH);
                [self addSubview:button];
                if (i == 0) {
                    [button setTitle:@"找回POS密码" forState:UIControlStateNormal];
                }
                if (i == 1) {
                    [button setTitle:@"视频认证" forState:UIControlStateNormal];
                }
                if (i == 2) {
                    [button setTitle:@"重新申请开通" forState:UIControlStateNormal];
                }
                if (i == 3) {
                    [button setTitle:@"同步" forState:UIControlStateNormal];
                }
            }
        }
        if ([reuseIdentifier isEqualToString:@"cell-已停用"]) {
            for (int i = 0; i < 2; i++) {
                UIButton *button = [[UIButton alloc]init];
                button.titleLabel.font = [UIFont systemFontOfSize:17];
                [button setTitleColor:[UIColor orangeColor] forState:UIControlStateNormal];
                CALayer *readBtnLayer = [button layer];
                [readBtnLayer setMasksToBounds:YES];
                [readBtnLayer setCornerRadius:2.0];
                [readBtnLayer setBorderWidth:1.0];
                [readBtnLayer setBorderColor:[[UIColor orangeColor] CGColor]];
                button.backgroundColor = [UIColor clearColor];
                button.tag = i + 4000;
                [button addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
                button.frame = CGRectMake(mainBtnX - (i * 120), mainBtnY, mainBtnW, mainBtnH);
                [self addSubview:button];
                if (i == 0) {
                    [button setTitle:@"更新资料" forState:UIControlStateNormal];
                }
                if (i == 1) {
                    [button setTitle:@"同步" forState:UIControlStateNormal];
                }
            }
        }
        if ([reuseIdentifier isEqualToString:@"cell-已注销"]) {
            for (int i = 0; i < 1; i++) {
                UIButton *button = [[UIButton alloc]init];
                button.titleLabel.font = [UIFont systemFontOfSize:17];
                [button setTitleColor:[UIColor orangeColor] forState:UIControlStateNormal];
                CALayer *readBtnLayer = [button layer];
                [readBtnLayer setMasksToBounds:YES];
                [readBtnLayer setCornerRadius:2.0];
                [readBtnLayer setBorderWidth:1.0];
                [readBtnLayer setBorderColor:[[UIColor orangeColor] CGColor]];
                button.backgroundColor = [UIColor clearColor];
                button.tag = i + 5000;
                [button addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
                button.frame = CGRectMake(mainBtnX - (i * 120), mainBtnY, mainBtnW, mainBtnH);
                [self addSubview:button];
                if (i == 0) {
                    [button setTitle:@"租凭退换" forState:UIControlStateNormal];
                }
            }
        }
    }
    return self;
}



-(void)buttonClick:(UIButton *)button
{
    [self.TerminalViewCellDelegate terminalCellBtnClicked:button.tag];
}


#pragma mark - 调整子控件的位置
-(void)layoutSubviews
{
    [super layoutSubviews];
    
    CGFloat mainWidth = 160.f;
    CGFloat mainheight = 24.f;
    CGFloat mainY = 30.f;
    
    _terminalLabel.frame = CGRectMake(20, mainY, mainWidth, mainheight);
    
    _posLabel.frame = CGRectMake(CGRectGetMaxX(_terminalLabel.frame) + 20, mainY, mainWidth * 0.5, mainheight);
    
    _payRoad.frame = CGRectMake(CGRectGetMaxX(_posLabel.frame) + 65, mainY, mainWidth * 0.5, mainheight);
    
    _dredgeStatus.frame = CGRectMake(CGRectGetMaxX(_payRoad.frame) + 20, mainY, mainWidth * 0.5, mainheight);
}

@end
