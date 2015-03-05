//
//  TopDealRoadCell.m
//  iPadff
//
//  Created by 黄含章 on 15/3/5.
//  Copyright (c) 2015年 LanTaiPro. All rights reserved.
//

#import "TopDealRoadCell.h"

@implementation TopDealRoadCell

-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        NSLog(@"创建的标示%@",reuseIdentifier);
        UIView *topView = [[UIView alloc]init];
        topView.backgroundColor = kColor(212, 212, 212, 1.0);
        topView.frame = CGRectMake(0, 0, SCREEN_WIDTH, 0.7);
        if (iOS7) {
            topView.frame = CGRectMake(0, 0, SCREEN_HEIGHT, 0.7);
        }
        [self addSubview:topView];
        
        UILabel *dealLabel = [[UILabel alloc]init];
        dealLabel.text = @"交易流水:";
        dealLabel.textColor = kColor(114, 114, 114, 1.0);
        dealLabel.font = [UIFont systemFontOfSize:15];
        dealLabel.frame = CGRectMake(40, CGRectGetMaxY(topView.frame) + 15, 80, 20);
        [self addSubview:dealLabel];
        
        UIView *contentView = [[UIView alloc]init];
        [self setupContentView];
        contentView.backgroundColor = kColor(228, 228, 228, 1.0);
        contentView.frame = CGRectMake(0, CGRectGetMaxY(dealLabel.frame) + 10, SCREEN_WIDTH,50 -  CGRectGetMaxY(dealLabel.frame) + 20);
        [self addSubview:contentView];
        
    }
    return self;
}

-(void)setupContentView
{
    
}

#pragma mark - 调整子控件的位置
-(void)layoutSubviews
{
    [super layoutSubviews];
    
}


@end
