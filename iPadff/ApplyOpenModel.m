//
//  ApplyOpenModel.m
//  ZFUB
//
//  Created by 徐宝桥 on 15/3/11.
//  Copyright (c) 2015年 ___MyCompanyName___. All rights reserved.
//

#import "ApplyOpenModel.h"

@implementation MaterialModel

- (id)initWithParseDictionary:(NSDictionary *)dict {
    if (self = [super init]) {
        if ([dict objectForKey:@"id"]) {
            _materialID = [NSString stringWithFormat:@"%@",[dict objectForKey:@"id"]];
        }
        if ([dict objectForKey:@"name"]) {
            _materialName = [NSString stringWithFormat:@"%@",[dict objectForKey:@"name"]];
        }
        if ([dict objectForKey:@"info_type"]) {
            _materialType = [[dict objectForKey:@"info_type"] intValue];
        }
        if ([dict objectForKey:@"opening_requirements_id"]) {
            _levelID = [NSString stringWithFormat:@"%@",[dict objectForKey:@"opening_requirements_id"]];
        }
    }
    return self;
}

@end

@implementation ApplyInfoModel

- (id)initWithParseDictionary:(NSDictionary *)dict {
    if (self = [super init]) {
        if ([dict objectForKey:@"target_id"]) {
            _targetID = [NSString stringWithFormat:@"%@",[dict objectForKey:@"target_id"]];
        }
        if ([dict objectForKey:@"key"]) {
            _key = [NSString stringWithFormat:@"%@",[dict objectForKey:@"key"]];
        }
        if ([dict objectForKey:@"value"]) {
            _value = [NSString stringWithFormat:@"%@",[dict objectForKey:@"value"]];
        }
        if ([dict objectForKey:@"preliminary_verify_user_id"]) {
            _levelID = [NSString stringWithFormat:@"%@",[dict objectForKey:@"preliminary_verify_user_id"]];
        }
        if ([dict objectForKey:@"types"]) {
            _type = [[dict objectForKey:@"types"] intValue];
        }
    }
    return self;
}

@end

@implementation ApplyOpenModel

- (id)initWithParseDictionary:(NSDictionary *)dict {
    if (self = [super init]) {
        id terminalDict = [dict objectForKey:@"applyDetails"];
        if ([terminalDict isKindOfClass:[NSDictionary class]]) {
            if ([terminalDict objectForKey:@"brandName"]) {
                _brandName = [NSString stringWithFormat:@"%@",[terminalDict objectForKey:@"brandName"]];
            }
            else {
                _brandName = @"";
            }
            if ([terminalDict objectForKey:@"model_number"]) {
                _modelNumber = [NSString stringWithFormat:@"%@",[terminalDict objectForKey:@"model_number"]];
            }
            else {
                _modelNumber = @"";
            }
            if ([terminalDict objectForKey:@"serial_num"]) {
                _terminalNumber = [NSString stringWithFormat:@"%@",[terminalDict objectForKey:@"serial_num"]];
            }
            else {
                _terminalNumber = @"";
            }
            if ([terminalDict objectForKey:@"channelName"]) {
                _channelName = [NSString stringWithFormat:@"%@",[terminalDict objectForKey:@"channelName"]];
            }
            else {
                _channelName = @"";
            }
            if ([terminalDict objectForKey:@"channelId"]) {
                _terminalChannelID = [NSString stringWithFormat:@"%@",[terminalDict objectForKey:@"channelId"]];
            }
            _openType = [[terminalDict objectForKey:@"supportRequirementType"] intValue];
        }
        id primaryDict = [dict objectForKey:@"openingInfos"];
        if ([primaryDict isKindOfClass:[NSDictionary class]]) {
            if ([primaryDict objectForKey:@"name"]) {
                _personName = [NSString stringWithFormat:@"%@",[primaryDict objectForKey:@"name"]];
            }
            else {
                _personName = @"";
            }

            if ([primaryDict objectForKey:@"merchant_id"]) {
                _merchantID = [NSString stringWithFormat:@"%@",[primaryDict objectForKey:@"merchant_id"]];
            }
            else {
                _merchantID = @"";
            }

            if ([primaryDict objectForKey:@"merchant_name"]) {
                _merchantName = [NSString stringWithFormat:@"%@",[primaryDict objectForKey:@"merchant_name"]];
            }
            else {
                _merchantName = @"";
            }

            if ([primaryDict objectForKey:@"sex"]) {
                _sex = [[primaryDict objectForKey:@"sex"] intValue];
            }
           
            if ([primaryDict objectForKey:@"birthdays"]) {
                _birthday = [NSString stringWithFormat:@"%@",[primaryDict objectForKey:@"birthdays"]];
            }
            else {
                _birthday = @"";
            }

            if ([primaryDict objectForKey:@"card_id"]) {
                _cardID = [NSString stringWithFormat:@"%@",[primaryDict objectForKey:@"card_id"]];
            }
            else {
                _cardID = @"";
            }

            if ([primaryDict objectForKey:@"phone"]) {
                _phoneNumber = [NSString stringWithFormat:@"%@",[primaryDict objectForKey:@"phone"]];
            }
            else {
                _phoneNumber = @"";
            }

            if ([primaryDict objectForKey:@"email"]) {
                _email = [NSString stringWithFormat:@"%@",[primaryDict objectForKey:@"email"]];
            }
            else {
                _email = @"";
            }

            if ([primaryDict objectForKey:@"city_id"]) {
                _cityID = [NSString stringWithFormat:@"%@",[primaryDict objectForKey:@"city_id"]];
            }
            else {
                _cityID = @"";
            }

            if ([primaryDict objectForKey:@"bank_name"]) {
                _bankTitleName = [NSString stringWithFormat:@"%@",[primaryDict objectForKey:@"bank_name"]];
            }
            else {
                _bankTitleName = @"";
            }

            if ([primaryDict objectForKey:@"account_bank_name"]) {
                _bankName = [NSString stringWithFormat:@"%@",[primaryDict objectForKey:@"account_bank_name"]];
            }
            else {
                _bankName = @"";
            }

            if ([primaryDict objectForKey:@"account_bank_num"]) {
                _bankNumber = [NSString stringWithFormat:@"%@",[primaryDict objectForKey:@"account_bank_num"]];
            } else {
                _bankNumber = @"";
            }

            if ([primaryDict objectForKey:@"account_bank_code"]) {
                _bankAccount = [NSString stringWithFormat:@"%@",[primaryDict objectForKey:@"account_bank_code"]];
            } else {
                _bankAccount = @"";
            }

            if ([primaryDict objectForKey:@"tax_registered_no"]) {
                _taxID = [NSString stringWithFormat:@"%@",[primaryDict objectForKey:@"tax_registered_no"]];
            } else {
                _taxID = @"";
            }

            if ([primaryDict objectForKey:@"organization_code_no"]) {
                _organID = [NSString stringWithFormat:@"%@",[primaryDict objectForKey:@"organization_code_no"]];
            }else {
                _organID = @"";
            }
            if ([primaryDict objectForKey:@"pay_channel_id"]) {
                _channelID = [NSString stringWithFormat:@"%@",[primaryDict objectForKey:@"pay_channel_id"]];
            } else {
                _channelID = @"";
            }

            if ([primaryDict objectForKey:@"channelname"]) {
                _channelOpenName = [NSString stringWithFormat:@"%@",[primaryDict objectForKey:@"channelname"]];
            } else {
                _channelOpenName = @"";
            }

            if ([primaryDict objectForKey:@"billing_cyde_id"]) {
                _billingID = [NSString stringWithFormat:@"%@",[primaryDict objectForKey:@"billing_cyde_id"]];
            } else {
                _billingID = @"";
            }

            if ([primaryDict objectForKey:@"billingname"]) {
                _billingName = [NSString stringWithFormat:@"%@",[primaryDict objectForKey:@"billingname"]];
            } else {
                _billingName = @"";
            }

        }
        id matList = [dict objectForKey:@"materialName"];
        if ([matList isKindOfClass:[NSArray class]]) {
            _materialList = [[NSMutableArray alloc] init];
            for (int i = 0; i < [matList count]; i++) {
                id materialDict = [matList objectAtIndex:i];
                if ([materialDict isKindOfClass:[NSDictionary class]]) {
                    MaterialModel *model = [[MaterialModel alloc] initWithParseDictionary:materialDict];
                    [_materialList addObject:model];
                }
            }
        }
        id merList = [dict objectForKey:@"merchants"];
        if ([merList isKindOfClass:[NSArray class]]) {
            _merchantList = [[NSMutableArray alloc] init];
            for (int i = 0; i < [merList count]; i++) {
                id merDict = [merList objectAtIndex:i];
                if ([merDict isKindOfClass:[NSDictionary class]]) {
                    MerchantModel *model = [[MerchantModel alloc] initWithParseDictionary:merDict];
                    [_merchantList addObject:model];
                }
            }
        }
        id appList = [dict objectForKey:@"applyFor"];
        if ([appList isKindOfClass:[NSArray class]]) {
            _applyList = [[NSMutableArray alloc] init];
            for (int i = 0; i < [appList count]; i++) {
                id appDict = [appList objectAtIndex:i];
                if ([appDict isKindOfClass:[NSDictionary class]]) {
                    ApplyInfoModel *model = [[ApplyInfoModel alloc] initWithParseDictionary:appDict];
                    [_applyList addObject:model];
                }
            }
        }
        NSArray *sort = [NSArray arrayWithObject:[NSSortDescriptor sortDescriptorWithKey:@"materialType" ascending:NO]];
        _materialList = [NSMutableArray arrayWithArray:[_materialList sortedArrayUsingDescriptors:sort]];
    }
    return self;
}

@end
