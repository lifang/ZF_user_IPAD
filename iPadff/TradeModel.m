//
//  TradeModel.m
//  ZFUB
//
//  Created by 徐宝桥 on 15/2/26.
//  Copyright (c) 2015年 ___MyCompanyName___. All rights reserved.
//

#import "TradeModel.h"

@implementation TradeModel

- (id)initWithParseDictionary:(NSDictionary *)dict {
    if (self = [super init]) {
        _tradeID = [NSString stringWithFormat:@"%@",[dict objectForKey:@"id"]];
        _tradeStatus = [NSString stringWithFormat:@"%@",[dict objectForKey:@"tradedStatus"]];
        _terminalNumber = [NSString stringWithFormat:@"%@",[dict objectForKey:@"terminalNumber"]];
        _amount = [NSString stringWithFormat:@"%@",[dict objectForKey:@"amount"]];
        _tradeTime = [NSString stringWithFormat:@"%@",[dict objectForKey:@"tradedTimeStr"]];
        if ([dict objectForKey:@"payIntoAccount"]) {
            _payIntoAccount = [NSString stringWithFormat:@"%@",[dict objectForKey:@"payIntoAccount"]];
        }
        if ([dict objectForKey:@"payFromAccount"]) {
            _payFromAccount = [NSString stringWithFormat:@"%@",[dict objectForKey:@"payFromAccount"]];
        }
        if ([dict objectForKey:@"payedTimeStr"]) {
            _payedTime = [NSString stringWithFormat:@"%@",[dict objectForKey:@"payedTimeStr"]];
        }
        if ([dict objectForKey:@"poundage"]) {
            _poundage = [NSString stringWithFormat:@"%@",[dict objectForKey:@"poundage"]];
        }
        if ([dict objectForKey:@"account_name"]) {
            _accountName = [NSString stringWithFormat:@"%@",[dict objectForKey:@"account_name"]];
        }
        if ([dict objectForKey:@"account_number"]) {
            _accountNumber = [NSString stringWithFormat:@"%@",[dict objectForKey:@"account_number"]];
        }
        if ([dict objectForKey:@"phone"]) {
            _phoneNumber = [NSString stringWithFormat:@"%@",[dict objectForKey:@"phone"]];
        }
        
    }
    return self;
}

@end
