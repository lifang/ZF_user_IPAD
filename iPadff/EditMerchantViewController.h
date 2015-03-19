//
//  EditMerchantViewController.h
//  iPadff
//
//  Created by wufei on 15/3/13.
//  Copyright (c) 2015年 LanTaiPro. All rights reserved.
//


#import "MerchantImageLoadViewController.h"
#import "MerchantDetailModel.h"

static NSString *EditMerchantInfoNotification = @"EditMerchantInfoNotification";


@interface EditMerchantViewController : MerchantImageLoadViewController

@property (nonatomic, strong) MerchantDetailModel *editmerchant;





@end
