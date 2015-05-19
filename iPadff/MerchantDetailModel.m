//
//  MerchantDetailModel.m
//  ZFUB
//
//  Created by 徐宝桥 on 15/3/5.
//  Copyright (c) 2015年 ___MyCompanyName___. All rights reserved.
//

#import "MerchantDetailModel.h"

@implementation MerchantDetailModel

- (id)initWithParseDictionary:(NSDictionary *)dict {
    if (self = [super init]) {
        if ([dict objectForKey:@"id"]) {
            _merchantID = [NSString stringWithFormat:@"%@",[dict objectForKey:@"id"]];
        }else
        {
            _merchantID = @"";
        }
        if ([dict objectForKey:@"title"]) {
            _merchantName = [NSString stringWithFormat:@"%@",[dict objectForKey:@"title"]];
        }
        else{
            _merchantName = @"";
        }
        if ([dict objectForKey:@"legalPersonName"]) {
            _merchantPersonName = [NSString stringWithFormat:@"%@",[dict objectForKey:@"legalPersonName"]];
        }else{
            _merchantPersonName = @"";
        }
        if ([dict objectForKey:@"legalPersonCardId"]) {
            _merchantPersonID = [NSString stringWithFormat:@"%@",[dict objectForKey:@"legalPersonCardId"]];
        }else{
            _merchantPersonID = @"";
        }
        if ([dict objectForKey:@"businessLicenseNo"]) {
            _merchantBusinessID = [NSString stringWithFormat:@"%@",[dict objectForKey:@"businessLicenseNo"]];
        }else{
            _merchantBusinessID = @"";
        }
        if ([dict objectForKey:@"taxRegisteredNo"]) {
            _merchantTaxID = [NSString stringWithFormat:@"%@",[dict objectForKey:@"taxRegisteredNo"]];
        }else{
            _merchantTaxID = @"";
        }
        if ([dict objectForKey:@"organizationCodeNo"]) {
            _merchantOrganizationID = [NSString stringWithFormat:@"%@",[dict objectForKey:@"organizationCodeNo"]];
        }else{
            _merchantOrganizationID = @"";
        }
        if ([dict objectForKey:@"accountBankName"]) {
            _merchantBank = [NSString stringWithFormat:@"%@",[dict objectForKey:@"accountBankName"]];
        }else{
            _merchantBank = @"";
        }
        if ([dict objectForKey:@"bankOpenAccount"]) {
            _merchantBankID = [NSString stringWithFormat:@"%@",[dict objectForKey:@"bankOpenAccount"]];
        }else{
            _merchantBankID = @"";
        }
        if ([dict objectForKey:@"cityId"]) {
            _merchantCityID = [NSString stringWithFormat:@"%@",[dict objectForKey:@"cityId"]];
        }else{
            _merchantCityID = @"";
        }
        if ([dict objectForKey:@"cardIdFrontPhotoPath"]) {
            _frontPath = [NSString stringWithFormat:@"%@",[dict objectForKey:@"cardIdFrontPhotoPath"]];
        }else{
            _frontPath = @"";
        }
        if ([dict objectForKey:@"cardIdBackPhotoPath"]) {
            _backPath = [NSString stringWithFormat:@"%@",[dict objectForKey:@"cardIdBackPhotoPath"]];
        }else{
            _backPath = @"";
        }
        if ([dict objectForKey:@"bodyPhotoPath"]) {
            _bodyPath = [NSString stringWithFormat:@"%@",[dict objectForKey:@"bodyPhotoPath"]];
        }else{
            _bodyPath = @"";
        }
        if ([dict objectForKey:@"licenseNoPicPath"]) {
            _licensePath = [NSString stringWithFormat:@"%@",[dict objectForKey:@"licenseNoPicPath"]];
        }else{
            _licensePath = @"";
        }
        if ([dict objectForKey:@"taxNoPicPath"]) {
            _taxPath = [NSString stringWithFormat:@"%@",[dict objectForKey:@"taxNoPicPath"]];
        }else{
            _taxPath = @"";
        }
        if ([dict objectForKey:@"orgCodeNoPicPath"]) {
            _organizationPath = [NSString stringWithFormat:@"%@",[dict objectForKey:@"orgCodeNoPicPath"]];
        }else{
            _organizationPath = @"";
        }
        if ([dict objectForKey:@"accountPicPath"]) {
            _bankPath = [NSString stringWithFormat:@"%@",[dict objectForKey:@"accountPicPath"]];
        }else{
            _backPath = @"";
        }
    }
    return self;
}

@end
