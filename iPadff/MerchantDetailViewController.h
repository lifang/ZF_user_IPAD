//
//  MerchantDetailViewController.h
//  iPadff
//
//  Created by wufei on 15/3/13.
//  Copyright (c) 2015年 LanTaiPro. All rights reserved.
//

#import "MerchantImageLoadViewController.h"
#import "MerchantModel.h"

@interface MerchantDetailViewController : MerchantImageLoadViewController
//@interface MerchantDetailViewController : UIViewController
@property (nonatomic, strong) MerchantModel *merchant;

@end
