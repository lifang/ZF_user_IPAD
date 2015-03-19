//
//  MerchantTitleCell.m
//  iPadff
//
//  Created by wufei on 15/3/16.
//  Copyright (c) 2015年 LanTaiPro. All rights reserved.
//

#import "MerchantTitleCell.h"

@implementation MerchantTitleCell

-(id) initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        _backView = [[UIView alloc] init];
         _backView.backgroundColor=[UIColor colorWithHexString:@"f2f1f1"];
        [self.contentView addSubview:_backView];
        [_backView makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self.contentView).with.insets(UIEdgeInsetsMake(0, 0, 0, 0));
        }];
        
        //float paddingLeft = (self.frame.size.width - 120 -120)/4.0;
        _titleLB = [[UILabel alloc] init];
        [_titleLB setBackgroundColor:[UIColor clearColor]];
        [_titleLB setFont:[UIFont systemFontOfSize:14]];
        _titleLB.textColor= [UIColor colorWithHexString:@"292929"];
        _titleLB.text=@"商户名";
        [_backView addSubview:_titleLB];
        [_titleLB makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(_backView.centerY);
            make.left.equalTo(_backView.left).offset(120);
            //make.right.equalTo(_backView.right).offset(-5);
            make.width.equalTo(@120);
        }];
        
        _actionLB = [[UILabel alloc] init];
        [_actionLB setBackgroundColor:[UIColor clearColor]];
        [_actionLB setFont:[UIFont systemFontOfSize:14]];
        _actionLB.textColor= [UIColor colorWithHexString:@"292929"];
        _actionLB.text=@"操作";
        _actionLB.textAlignment=NSTextAlignmentCenter;
        [_backView addSubview:_actionLB];
        [_actionLB makeConstraints:^(MASConstraintMaker *make) {
           // make.top.equalTo(_backView.top).offset(5);
            //make.left.equalTo(_backView.left).offset(30);
            make.centerY.equalTo(_backView.centerY);
            make.right.equalTo(_backView.right).offset(-120);
            make.width.equalTo(@120);
           // make.height.equalTo(@40);
        }];

        
    }
    
    return self;
}

- (void)awakeFromNib {
    // Initialization code
}
/*
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
*/
@end
