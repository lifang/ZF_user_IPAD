//
//  BankSelectedController.h
//  ZFUB
//
//  Created by 徐宝桥 on 15/3/12.
//  Copyright (c) 2015年 ___MyCompanyName___. All rights reserved.
//

#import "CommonViewController.h"
#import "BankModel.h"

@protocol BankSelectedDelegate <NSObject>

- (void)getSelectedBank:(BankModel *)model;

@end

@interface BankSelectedController : CommonViewController

@property (nonatomic, assign) id<BankSelectedDelegate>delegate;

@property (nonatomic, strong) NSMutableArray *bankItems;

@end
