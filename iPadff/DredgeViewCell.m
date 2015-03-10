//
//  DredgeViewCell.m
//  iPadff
//
//  Created by 黄含章 on 15/3/4.
//  Copyright (c) 2015年 LanTaiPro. All rights reserved.
//

#import "DredgeViewCell.h"

@implementation DredgeViewCell

+(instancetype)cellWithTableView:(UITableView *)tableView
{
    static NSString *ID = @"dynamic";
    DredgeViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (cell == nil) {
        cell = [[DredgeViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:ID];
    }
    return cell;
}

-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        UIFont *mainFont = [UIFont systemFontOfSize:16];
        self.selectionStyle = UITableViewCellSelectionStyleNone;
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
        [self addSubview:_dredgeStatus];
        
        self.applicationBtn = [[UIButton alloc]init];
        [_applicationBtn setTitle:@"申请开通" forState:UIControlStateNormal];
        [_applicationBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_applicationBtn setBackgroundColor:kColor(241, 81, 8, 1.0)];
        [self addSubview:_applicationBtn];
        
        self.vedioConfirmBtn = [[UIButton alloc]init];
        [_vedioConfirmBtn setTitle:@"视频认证" forState:UIControlStateNormal];
        [_vedioConfirmBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_vedioConfirmBtn setBackgroundColor:kColor(241, 81, 8, 1.0)];
        [self addSubview:_vedioConfirmBtn];
        
    }
    return self;
}

#pragma mark - 调整子控件的位置
-(void)layoutSubviews
{
    [super layoutSubviews];
    
    CGFloat mainWidth = 160.f;
    CGFloat mainheight = 24.f;
    CGFloat mainY = 60.f;
    
    _terminalLabel.frame = CGRectMake(85, mainY, mainWidth, mainheight);
    
    _posLabel.frame = CGRectMake(CGRectGetMaxX(_terminalLabel.frame) + 70, mainY, mainWidth * 0.5, mainheight);
    
    _payRoad.frame = CGRectMake(CGRectGetMaxX(_posLabel.frame) + 100, mainY, mainWidth * 0.5, mainheight);
    
    _dredgeStatus.frame = CGRectMake(CGRectGetMaxX(_payRoad.frame) + 65, mainY, mainWidth * 0.5, mainheight);
    
    _applicationBtn.frame = CGRectMake(CGRectGetMaxX(_dredgeStatus.frame) + 100, mainY / 3, mainWidth * 0.7, mainheight * 1.5);
    
    _vedioConfirmBtn.frame = CGRectMake(_applicationBtn.frame.origin.x, CGRectGetMaxY(_applicationBtn.frame) + 25, _applicationBtn.frame.size.width, _applicationBtn.frame.size.height);
    
}

@end
