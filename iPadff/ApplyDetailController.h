//
//  ApplyDetailController.h
//  iPadff
//
//  Created by comdosoft on 15/3/27.
//  Copyright (c) 2015年 LanTaiPro. All rights reserved.
//

#import "ScanImageViewController.h"
static NSString *key_selected = @"key_selected";
static NSString *key_name = @"key_name";
static NSString *key_merchantName = @"key_merchantName";
static NSString *key_sex = @"key_sex";
static NSString *key_birth = @"key_birth";
static NSString *key_cardID = @"key_cardID";
static NSString *key_phone = @"key_phone";
static NSString *key_email = @"key_email";
static NSString *key_location = @"key_location";
static NSString *key_bank = @"key_bank";
static NSString *key_bankID = @"key_bankID";
static NSString *key_bankAccount = @"key_bankAccount";
static NSString *key_taxID = @"key_taxID";
static NSString *key_organID = @"key_organID";
static NSString *key_channel = @"key_channel";

typedef enum {
    OpenStatusNew = 1,  //开通
    OpenStatusReopen,   //重新开通
}OpenStatus;

@interface ApplyDetailController : ScanImageViewController
{ UIButton* accountnamebutton;
    NSInteger sexint;
    UIButton* _cityField ;
    UIButton* birthdaybutton;
    UIDatePicker *datePicker;
    UIButton *makeSureBtn;
    UIButton* locationbutton;
    UIButton*blankseclectbutton;

    NSArray*keynamesarry;
    NSInteger pickint;
    UIButton* blankbutton ;
    UIButton* zhifubutton;
    UIView*datepickview;
    UIButton *cancelBtn;
    BOOL isopen;
    NSArray*namesarry;
    NSInteger lastlength;
    UIButton *submitBtn ;
       int pictureint;
}

@property (nonatomic, strong) NSString *terminalID;
@property (nonatomic, assign) OpenStatus openStatus;
@end
