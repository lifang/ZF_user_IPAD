//
//  OrderDetailModel.m
//  ZFUB
//
//  Created by 徐宝桥 on 15/3/6.
//  Copyright (c) 2015年 ___MyCompanyName___. All rights reserved.
//

#import "OrderDetailModel.h"

@implementation OrderDetailModel

- (id)initWithParseDictionary:(NSDictionary *)dict {
    if (self = [super init]) {
        if ([dict objectForKey:@"order_status"]) {
            _orderStatus = [NSString stringWithFormat:@"%@",[dict objectForKey:@"order_status"]];
        }
        if ([dict objectForKey:@"order_totalPrice"]) {
            _orderTotalPrice = [[dict objectForKey:@"order_totalPrice"] floatValue] / 100;
        }
        if ([dict objectForKey:@"order_psf"]) {
            _orderDeliveryFee = [[dict objectForKey:@"order_psf"] floatValue] / 100;
        }
        if ([dict objectForKey:@"order_receiver"]) {
            _orderReceiver = [NSString stringWithFormat:@"%@",[dict objectForKey:@"order_receiver"]];
        }
        if ([dict objectForKey:@"order_receiver_phone"]) {
            _orderReceiverPhone = [NSString stringWithFormat:@"%@",[dict objectForKey:@"order_receiver_phone"]];
        }
        if ([dict objectForKey:@"order_address"]) {
            _orderAddress = [NSString stringWithFormat:@"%@",[dict objectForKey:@"order_address"]];
        }
        if ([dict objectForKey:@"order_comment"]) {
            _orderComment = [NSString stringWithFormat:@"%@",[dict objectForKey:@"order_comment"]];
        }
        if ([dict objectForKey:@"order_invoce_type"]) {
            _orderInvoceType = [NSString stringWithFormat:@"%@",[dict objectForKey:@"order_invoce_type"]];
        }
        if ([dict objectForKey:@"order_invoce_info"]) {
            _orderInvoceTitle = [NSString stringWithFormat:@"%@",[dict objectForKey:@"order_invoce_info"]];
        }
        if ([dict objectForKey:@"order_number"]) {
            _orderNumber = [NSString stringWithFormat:@"%@",[dict objectForKey:@"order_number"]];
        }
        if ([dict objectForKey:@"order_payment_type"]) {
            _orderPayType = [NSString stringWithFormat:@"%@",[dict objectForKey:@"order_payment_type"]];
        }
        if ([dict objectForKey:@"order_createTime"]) {
            _orderTime = [NSString stringWithFormat:@"%@",[dict objectForKey:@"order_createTime"]];
        }
        if ([dict objectForKey:@"order_totalNum"]) {
            _orderTotalNumber = [NSString stringWithFormat:@"%@",[dict objectForKey:@"order_totalNum"]];
        }
        id recordObject = [[dict objectForKey:@"comments"] objectForKey:@"content"];
        if ([recordObject isKindOfClass:[NSArray class]]) {
            _recordList = [[NSMutableArray alloc] init];
            for (int i = 0; i < [recordObject count]; i++) {
                id recordDict = [recordObject objectAtIndex:i];
                if ([recordDict isKindOfClass:[NSDictionary class]]) {
                    RecordModel *model = [[RecordModel alloc] initWithParseDictionary:recordDict];
                    [_recordList addObject:model];
                }
            }
        }
        id goodObject = [dict objectForKey:@"order_goodsList"];
        if ([goodObject isKindOfClass:[NSArray class]]) {
            _goodList = [[NSMutableArray alloc] init];
            for (int i = 0; i < [goodObject count]; i++) {
                id goodDict = [goodObject objectAtIndex:i];
                if ([goodDict isKindOfClass:[NSDictionary class]]) {
                    OrderGoodModel *model = [[OrderGoodModel alloc] initWithParseDictionary:goodDict];
                    [_goodList addObject:model];
                }
            }
        }
    }
    return self;
}

- (NSString *)getStatusString {
    NSString *status = nil;
    switch ([_orderStatus intValue]) {
        case OrderStatusUnPaid:
            status = @"未付款";
            break;
        case OrderStatusSending:
            status = @"已发货";
            break;
        case OrderStatusReview:
            status = @"已评价";
            break;
        case OrderStatusCancel:
            status = @"已取消";
            break;
        case OrderStatusClosed:
            status = @"交易关闭";
            break;
        case OrderStatusPaid:
            status = @"已付款";
            break;
        default:
            break;
    }
    return status;
}

@end
