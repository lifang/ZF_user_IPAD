//
//  MerchantImageLoadViewController.h
//  iPadff
//
//  Created by wufei on 15/3/13.
//  Copyright (c) 2015年 LanTaiPro. All rights reserved.
//


#import "NetworkInterface.h"
#import "AppDelegate.h"
#import "CityHandle.h"
#import "ScanImageViewController.h"

static NSString *key_frontImage = @"key_frontImage";
static NSString *key_backImage = @"key_backImage";
static NSString *key_bodyImage = @"key_bodyImage";
static NSString *key_licenseImage = @"key_licenseImage";
static NSString *key_taxImage = @"key_taxImage";
static NSString *key_organizationImage = @"key_organizationImage";
static NSString *key_bankImage = @"key_bankImage";

@interface MerchantImageLoadViewController : ScanImageViewController

@property (nonatomic, strong) NSString *selectedImageKey;  //选中的图片行

@property (nonatomic, strong) UIPickerView *pickerView;

@property (nonatomic, strong) UIToolbar *toolbar;

@property (nonatomic, strong) NSArray *cityArray;  //pickerView 第二列

@property (nonatomic, assign) CGRect imageRect;

- (void)initPickerView;

- (void)selectedKey:(NSString *)imageKey
           hasImage:(BOOL)hasImage;

- (void)saveWithURLString:(NSString *)urlString;

- (void)modifyLocation:(id)sender;

- (void)pickerHide;
//- (void)pickerDisplay;
- (void)pickerDisplay:(UIButton *)button;



@end
