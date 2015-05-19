//
//  AfterTitleCell.m
//  iPadff
//
//  Created by 黄含章 on 15/3/12.
//  Copyright (c) 2015年 LanTaiPro. All rights reserved.
//

#import "AfterTitleCell.h"

@interface AfterTitleCell()

@property(nonatomic,strong)NSString *reuseIdentifierID;
@property(nonatomic,strong)UIView *bottomView;
@property(nonatomic,strong)UILabel *lable;

@end

@implementation AfterTitleCell

-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        NSLog(@"创建的标示%@",reuseIdentifier);
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.reuseIdentifierID = reuseIdentifier;
        UIView *bottomView = [[UIView alloc]init];
        bottomView.backgroundColor = kColor(226, 226, 226, 1.0);
        bottomView.frame = CGRectMake(15, 30, SCREEN_WIDTH - 170, 30);
        if (iOS7) {
            bottomView.frame = CGRectMake(15, 30, SCREEN_HEIGHT - 170, 30);
        }
        self.bottomView = bottomView;
        [self setupContentView];
        [self addSubview:_bottomView];
        
    }
    return self;
}

-(void)setupContentView
{
    CGFloat labelWidth = 160.f;
    for (int i = 0; i < 4; i++) {
        UILabel *label = [[UILabel alloc]init];
        label.textAlignment = NSTextAlignmentCenter;
        label.textColor = kColor(60, 60, 60, 1.0);
        label.font = [UIFont systemFontOfSize:16];
        label.backgroundColor = [UIColor clearColor];
        label.tag = i +1234;
        label.frame = CGRectMake(20 + i * labelWidth, 3, labelWidth, 25);
        self.lable = label;
        [self layoutTitle];
        [_bottomView addSubview:label];
    }
}

//布局标题
-(void)layoutTitle
{
    //维修
    if ([_reuseIdentifierID isEqualToString:@"cell1"]) {
        switch (_lable.tag) {
            case 1234:
                _lable.text = @"维修编号";
                break;
            case 1235:
                _lable.text = @"终端号";
                break;
            case 1236:
                _lable.text = @"申请日期";
                break;
            case 1237:
                _lable.text = @"维修状态";
                break;
                
            default:
                break;
        }
    }
    //注销
    if ([_reuseIdentifierID isEqualToString:@"cell2"]) {
        switch (_lable.tag) {
            case 1234:
                _lable.text = @"注销编号";
                break;
            case 1235:
                _lable.text = @"终端号";
                break;
            case 1236:
                _lable.text = @"申请日期";
                break;
            case 1237:
                _lable.text = @"注销状态";
                break;
                
            default:
                break;
        }
    }
    //退货
    if ([_reuseIdentifierID isEqualToString:@"cell3"]) {
        switch (_lable.tag) {
            case 1234:
                _lable.text = @"退货编号";
                break;
            case 1235:
                _lable.text = @"终端号";
                break;
            case 1236:
                _lable.text = @"申请日期";
                break;
            case 1237:
                _lable.text = @"退货状态";
                break;
                
            default:
                break;
        }
        
    }
    //换货
    if ([_reuseIdentifierID isEqualToString:@"cell4"]) {
        switch (_lable.tag) {
            case 1234:
                _lable.text = @"换货编号";
                break;
            case 1235:
                _lable.text = @"终端号";
                break;
            case 1236:
                _lable.text = @"申请日期";
                break;
            case 1237:
                _lable.text = @"换货状态";
                break;
                
            default:
                break;
        }
        
    }
    //更新资料
    if ([_reuseIdentifierID isEqualToString:@"cell5"]) {
        switch (_lable.tag) {
            case 1234:
                _lable.text = @"更新资料编号";
                break;
            case 1235:
                _lable.text = @"终端号";
                break;
            case 1236:
                _lable.text = @"申请日期";
                break;
            case 1237:
                _lable.text = @"更新资料状态";
                break;
                
            default:
                break;
        }
        
    }
    //租凭退还
    if ([_reuseIdentifierID isEqualToString:@"cell6"]) {
        switch (_lable.tag) {
            case 1234:
                _lable.text = @"租凭退还编号";
                break;
            case 1235:
                _lable.text = @"终端号";
                break;
            case 1236:
                _lable.text = @"申请日期";
                break;
            case 1237:
                _lable.text = @"租凭退还状态";
                break;
                
            default:
                break;
        }
        
    }

}


@end
