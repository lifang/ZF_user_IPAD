//
//  BankModel.h
//  ZFUB
//
//  Created by 徐宝桥 on 15/3/16.
//  Copyright (c) 2015年 ___MyCompanyName___. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BankModel : NSObject

@property (nonatomic, strong) NSString *bankName;

@property (nonatomic, strong) NSString *bankCode;

@property (nonatomic, assign) BOOL isSelected;

- (id)initWithParseDictionary:(NSDictionary *)dict;

@end
