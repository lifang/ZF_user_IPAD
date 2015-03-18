//
//  MerchantCell.m
//  iPadff
//
//  Created by wufei on 15/3/16.
//  Copyright (c) 2015年 LanTaiPro. All rights reserved.
//

#import "MerchantCell.h"

@implementation MerchantCell

-(id) initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        _backView = [[UIView alloc] init];
        [self.contentView addSubview:_backView];
        
        [_backView makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self.contentView).with.insets(UIEdgeInsetsMake(0, 0, 0, 0));
        }];
       
    
        _titleLB = [[UILabel alloc] init];
        [_titleLB setBackgroundColor:[UIColor clearColor]];
        [_titleLB setFont:[UIFont systemFontOfSize:14]];
        _titleLB.textColor= [UIColor colorWithHexString:@"292929"];
        [_backView addSubview:_titleLB];
        [_titleLB makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(_backView.centerY);
            make.left.equalTo(_backView.left).offset(120);
            //make.right.equalTo(_backView.right).offset(-5);
            make.width.equalTo(@120);
           // make.height.equalTo(@50);
        }];

    
        _deleteBtn = [[UIButton alloc] init];
        _deleteBtn.clipsToBounds = YES;
        CALayer *readBtnLayer = [_deleteBtn layer];
        [readBtnLayer setMasksToBounds:YES];
        [readBtnLayer setCornerRadius:2.0];
        [readBtnLayer setBorderWidth:1.0];
        [readBtnLayer setBorderColor:[[UIColor orangeColor] CGColor]];
        _deleteBtn.layer.cornerRadius = 3.0f;
        [_deleteBtn setTitle:@"删除" forState:UIControlStateNormal];
        _deleteBtn.backgroundColor=[UIColor clearColor];
        [ _deleteBtn setTitleColor:[UIColor orangeColor] forState:UIControlStateNormal];
        [_deleteBtn addTarget:self action:@selector(delete:) forControlEvents:UIControlEventTouchUpInside];
        [_backView addSubview:_deleteBtn];
        [_deleteBtn makeConstraints:^(MASConstraintMaker *make) {
            //make.top.equalTo(_backView.top).offset(5);
            //make.left.equalTo(_backView.left).offset(5);
            make.centerY.equalTo(_backView.centerY);
            make.width.equalTo(@120);
            make.right.equalTo(_backView.right).offset(-120);
            make.height.equalTo(@50);
        }];
        
    }
   
     return self;
}


-(void)setMerchantModel:(MerchantModel *)merchantModel andTarget:(id)target
{
    
    _merchantModel = merchantModel;
    _superTarget = target;
    [_titleLB setText:merchantModel.merchantName];
    
    
}

-(void)delete:(id)sender
{


}



- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
