//
//  EditMerchantViewController.h
//  iPadff
//
//  Created by wufei on 15/3/13.
//  Copyright (c) 2015年 LanTaiPro. All rights reserved.
//

#import "CommonViewController.h"
#import "MerchantDetailModel.h"

static NSString *EditMerchantInfoNotification = @"EditMerchantInfoNotification";

typedef enum {
    MerchantEditName = 0,
    MerchantEditPersonName,
    MerchantEditPersonID,
    MerchantEditLicense,
    MerchantEditTax,
    MerchantEditOrganization,
    MerchantEditBank = 10,
    MerchantEditBankID,
}MerchantEditType;


@interface EditMerchantViewController : CommonViewController

@property (nonatomic, strong) MerchantDetailModel *merchant;

@property (nonatomic, assign) MerchantEditType editType;



@end
