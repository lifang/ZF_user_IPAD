//
//  RateModel.m
//  ZFUB
//
//  Created by 徐宝桥 on 15/3/6.
//  Copyright (c) 2015年 ___MyCompanyName___. All rights reserved.
//

#import "RateModel.h"

@implementation RateModel

- (id)initWithParseDictionary:(NSDictionary *)dict {
    if (self = [super init]) {
        if ([dict objectForKey:@"id"]) {
            _rateID = [NSString stringWithFormat:@"%@",[dict objectForKey:@"id"]];
        }
        if ([dict objectForKey:@"trade_value"]) {
            _rateName = [NSString stringWithFormat:@"%@",[dict objectForKey:@"trade_value"]];
        }
        if ([dict objectForKey:@"service_rate"]) {
            _rateService = [NSString stringWithFormat:@"%@",[dict objectForKey:@"service_rate"]];
        }
        if ([dict objectForKey:@"service_rate"]) {
            _rateTerminal = [NSString stringWithFormat:@"%@",[dict objectForKey:@"terminal_rate"]];
        }
        if ([dict objectForKey:@"base_rate"]) {
            _rateBase = [NSString stringWithFormat:@"%@",[dict objectForKey:@"base_rate"]];
        }
        if ([dict objectForKey:@"status"]) {
            _rateStatus = (RateStatus)[[dict objectForKey:@"status"] intValue];
        }
    }
    return self;
}

- (NSString *)statusString {
    if (_rateStatus == RateStatusOpened) {
        return @"开通";
    }
    return @"未开通";
}

@end
