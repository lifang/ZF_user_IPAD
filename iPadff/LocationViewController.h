//
//  LocationViewController.h
//  ZFUB
//
//  Created by 徐宝桥 on 15/2/11.
//  Copyright (c) 2015年 ___MyCompanyName___. All rights reserved.
//

#import "CommonViewController.h"
#import "CityHandle.h"

@protocol sendCity <NSObject>

@optional

-(void)sendCity:(NSString *)city WithCity_id:(NSString *)city_id;

- (void)getSelectedLocation:(CityModel *)selectedCity;

@end

@interface LocationViewController : CommonViewController

@property(nonatomic,weak)id<sendCity> delegate;

@end
