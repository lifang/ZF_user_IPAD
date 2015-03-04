//
//  GoodsCollectionViewCell2.h
//  iPadff
//
//  Created by comdosoft on 15/3/4.
//  Copyright (c) 2015年 LanTaiPro. All rights reserved.
//

#import <UIKit/UIKit.h>
#define kGoodCellHeight  136.f
#import "UIImageView+WebCache.h"
@interface GoodsCollectionViewCell2 : UICollectionViewCell
//图片框
@property (nonatomic, strong) UIImageView *pictureView;
//标题
@property (nonatomic, strong) UILabel *titleLabel;
//价格
@property (nonatomic, strong) UILabel *priceLabel;
//销售量
@property (nonatomic, strong) UILabel *salesVolumeLabel;
//品牌型号
@property (nonatomic, strong) UILabel *brandLabel;
//支付通道
@property (nonatomic, strong) UILabel *channelLabel;

//是否可租赁
@property (nonatomic, strong) UIImageView *attrView;


@end
