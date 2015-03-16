//
//  AddressCell.m
//  iPadff
//
//  Created by 黄含章 on 15/3/16.
//  Copyright (c) 2015年 LanTaiPro. All rights reserved.
//

#import "AddressCell.h"

@interface AddressCell()

@property(nonatomic,strong)UILabel *consigneeLabel;

@property(nonatomic,strong)UILabel *areaLabel;

@property(nonatomic,strong)UILabel *particularAddressLabel;

@property(nonatomic,strong)UILabel *postcodeLabel;

@property(nonatomic,strong)UILabel *telLabel;

@property(nonatomic,strong)UILabel *defaultLabel;

@property(nonatomic,strong)UIButton *changeBtn;


@end

@implementation AddressCell


-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        UIFont *mainFont = [UIFont systemFontOfSize:14];
        UIColor *mainColor = kColor(67, 67, 67, 1.0);
        
        self.textLabel.frame = CGRectMake(100, 10, 60, 30);
        
        
    }
    return self;
}



@end
