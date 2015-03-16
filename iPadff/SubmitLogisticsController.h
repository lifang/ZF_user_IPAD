//
//  SubmitLogisticsController.h
//  iPadff
//
//  Created by 黄含章 on 15/3/16.
//  Copyright (c) 2015年 LanTaiPro. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol SubmitLogisticsClickWithDataDelegate <NSObject>

@optional

-(void)SubmitLogisticsClickedWithName:(NSString *)companyName AndNum:(NSString *)logisticsNum;

@end

@interface SubmitLogisticsController : UIViewController

@property(nonatomic,weak)id SubmitLogisticsClickWithDataDelegate;
@property(nonatomic,assign)BOOL isChild;

@end
