//
//  GoodDetaildetailViewController.h
//  iPadff
//
//  Created by comdosoft on 15/3/18.
//  Copyright (c) 2015年 LanTaiPro. All rights reserved.
//

#import "CommonViewController.h"
#import "GoodDetialModel.h"
#import "ChannelModel.h"
@interface GoodDetaildetailViewController : CommonViewController
{ UIScrollView*_mainScrollView ;
    
    UIView *view;
    
    UIBarButtonItem *shoppingItem;

    
}
@property (nonatomic, strong) NSArray *tradeRateItem;
@property (nonatomic, strong) GoodDetialModel *goodDetail;
@property (nonatomic, strong) ChannelModel *channelData;

@property (nonatomic, strong) NSString *goodID;
@property (nonatomic, assign) NSInteger  secletA;
@end
