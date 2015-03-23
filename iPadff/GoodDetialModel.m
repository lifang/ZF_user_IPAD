//
//  GoodDetialModel.m
//  ZFUB
//
//  Created by 徐宝桥 on 15/3/7.
//  Copyright (c) 2015年 ___MyCompanyName___. All rights reserved.
//

#import "GoodDetialModel.h"

@implementation RelativeGood

- (id)initWithParseDictionary:(NSDictionary *)dict {
    if (self = [super init]) {
        if ([dict objectForKey:@"id"]) {
            _relativeID = [NSString stringWithFormat:@"%@",[dict objectForKey:@"id"]];
        }
        if ([dict objectForKey:@"url_path"]) {
            _pictureURL = [NSString stringWithFormat:@"%@",[dict objectForKey:@"url_path"]];
        }
        if ([dict objectForKey:@"retail_price"]) {
            _price = [[dict objectForKey:@"retail_price"] floatValue] / 100;
        }
        if ([dict objectForKey:@"Title"]) {
            _title = [NSString stringWithFormat:@"%@",[dict objectForKey:@"Title"]];
        }
    }
    return self;
}


@end

@implementation GoodDetialModel

- (id)initWithParseDictionary:(NSDictionary *)dict {
    if (self = [super init]) {
        id goodInfo = [dict objectForKey:@"goodinfo"];
        if ([goodInfo isKindOfClass:[NSDictionary class]]) {
            if ([goodInfo objectForKey:@"id"]) {
                _goodID = [NSString stringWithFormat:@"%@",[goodInfo objectForKey:@"id"]];
            }
            if ([goodInfo objectForKey:@"Title"]) {
                _goodName = [NSString stringWithFormat:@"%@",[goodInfo objectForKey:@"Title"]];
            }
            if ([goodInfo objectForKey:@"second_title"]) {
                _detailName = [NSString stringWithFormat:@"%@",[goodInfo objectForKey:@"second_title"]];
            }
            if ([goodInfo objectForKey:@"good_brand"]) {
                _goodBrand = [NSString stringWithFormat:@"%@",[goodInfo objectForKey:@"good_brand"]];
            }
            if ([goodInfo objectForKey:@"Model_number"]) {
                _goodModel = [NSString stringWithFormat:@"%@",[goodInfo objectForKey:@"Model_number"]];
            }
            if ([goodInfo objectForKey:@"category"]) {
                _goodCategory = [NSString stringWithFormat:@"%@",[goodInfo objectForKey:@"category"]];
            }
            if ([goodInfo objectForKey:@"shell_material"]) {
                _goodMaterial = [NSString stringWithFormat:@"%@",[goodInfo objectForKey:@"shell_material"]];
            }
            if ([goodInfo objectForKey:@"battery_info"]) {
                _goodBattery = [NSString stringWithFormat:@"%@",[goodInfo objectForKey:@"battery_info"]];
            }
            if ([goodInfo objectForKey:@"sign_order_way"]) {
                _goodSignWay = [NSString stringWithFormat:@"%@",[goodInfo objectForKey:@"sign_order_way"]];
            }
            if ([goodInfo objectForKey:@"encrypt_card_way"]) {
                _goodEncryptWay = [NSString stringWithFormat:@"%@",[goodInfo objectForKey:@"encrypt_card_way"]];
            }
            if ([goodInfo objectForKey:@"volume_number"]) {
                _goodSaleNumber = [NSString stringWithFormat:@"%@",[goodInfo objectForKey:@"volume_number"]];
            }
            if ([goodInfo objectForKey:@"has_lease"]) {
                _canRent = [[goodInfo objectForKey:@"has_lease"] integerValue];
            }
            if ([goodInfo objectForKey:@"retail_price"]) {
                _goodPrice = [[goodInfo objectForKey:@"retail_price"] floatValue] / 100;
            }
            if ([goodInfo objectForKey:@"lease_time"]) {
                _minTime = [NSString stringWithFormat:@"%@",[goodInfo objectForKey:@"lease_time"]];
            }
            if ([goodInfo objectForKey:@"return_time"]) {
                _maxTime = [NSString stringWithFormat:@"%@",[goodInfo objectForKey:@"return_time"]];
            }
            if ([goodInfo objectForKey:@"lease_price"]) {
                _leasePrice = [[goodInfo objectForKey:@"lease_price"] floatValue] / 100;
            }
            if ([goodInfo objectForKey:@"lease_deposit"]) {
                _deposit = [[goodInfo objectForKey:@"lease_deposit"] floatValue] / 100;
            }
            if ([goodInfo objectForKey:@"description"]) {
                _goodDescription = [NSString stringWithFormat:@"%@",[goodInfo objectForKey:@"description"]];
            }
            if ([goodInfo objectForKey:@"lease_description"]) {
                _leaseDescription = [NSString stringWithFormat:@"%@",[goodInfo objectForKey:@"lease_description"]];
            }
            if ([goodInfo objectForKey:@"lease_agreement"]) {
                _leaseProtocol = [NSString stringWithFormat:@"%@",[goodInfo objectForKey:@"lease_agreement"]];
            }
        }
        id factoryInfo = [dict objectForKey:@"factory"];
        if ([factoryInfo isKindOfClass:[NSDictionary class]]) {
            if ([factoryInfo objectForKey:@"name"]) {
                _factoryName = [NSString stringWithFormat:@"%@",[factoryInfo objectForKey:@"name"]];
            }
            if ([factoryInfo objectForKey:@"website_url"]) {
                _factoryWebsite = [NSString stringWithFormat:@"%@",[factoryInfo objectForKey:@"website_url"]];
            }
            if ([factoryInfo objectForKey:@"description"]) {
                _factorySummary = [NSString stringWithFormat:@"%@",[factoryInfo objectForKey:@"description"]];
            }
            if ([factoryInfo objectForKey:@"logo_file_path"]) {
                _factoryImagePath = [NSString stringWithFormat:@"%@",[factoryInfo objectForKey:@"logo_file_path"]];
            }
        }
        if ([dict objectForKey:@"commentsCount"]) {
            _goodComment = [NSString stringWithFormat:@"%@",[dict objectForKey:@"commentsCount"]];
        }
        id pictureObject = [dict objectForKey:@"goodPics"];
        if ([pictureObject isKindOfClass:[NSArray class]]) {
            _goodImageList = [[NSMutableArray alloc] init];
            [_goodImageList addObjectsFromArray:pictureObject];
        }
        id defaultChannelObject = [dict objectForKey:@"paychannelinfo"];
        if ([defaultChannelObject isKindOfClass:[NSDictionary class]]) {
            _defaultChannel = [[ChannelModel alloc] initWithParseDictionary:defaultChannelObject];
        }
        id channelObject = [dict objectForKey:@"payChannelList"];
        if ([channelObject isKindOfClass:[NSArray class]]) {
            _channelItem = [[NSMutableArray alloc] init];
            for (int i = 0; i < [channelObject count]; i++) {
                id channelDict = [channelObject objectAtIndex:i];
                if ([channelDict isKindOfClass:[NSDictionary class]]) {
                    ChannelModel *model = [[ChannelModel alloc] initWithParseDictionary:channelDict];
                    [_channelItem addObject:model];
                }
            }
        }
        //相关商品
        id relativeObject = [dict objectForKey:@"relativeShopList"];
        if ([relativeObject isKindOfClass:[NSArray class]]) {
            _relativeItem = [[NSMutableArray alloc] init];
            for (int i = 0; i < [relativeObject count]; i++) {
                id relativeDict = [relativeObject objectAtIndex:i];
                if ([relativeDict isKindOfClass:[NSDictionary class]]) {
                    RelativeGood *model = [[RelativeGood alloc] initWithParseDictionary:relativeDict];
                    [_relativeItem addObject:model];
                }
            }
        }
        
        [self setDownloadStatus];
    }
    return self;
}

- (void)setDownloadStatus {
    ChannelModel *currentChannel = nil;
    NSInteger oldIndex = -1;
    for (ChannelModel *model in _channelItem) {
        oldIndex ++;
        if (_defaultChannel.channelID && [model.channelID isEqualToString:_defaultChannel.channelID]) {
            currentChannel = model;
            _defaultChannel.isAlreadyLoad = YES;
            break;
        }
    }
    [_channelItem replaceObjectAtIndex:oldIndex withObject:_defaultChannel];
}

@end
