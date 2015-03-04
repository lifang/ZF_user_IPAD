//
//  FilterContentViewController.h
//  ZFUB
//
//  Created by 徐宝桥 on 15/2/11.
//  Copyright (c) 2015年 ___MyCompanyName___. All rights reserved.
//

#import "CommonViewController.h"

@interface FilterContentViewController : CommonViewController

//保存用户选中的筛选条件
@property (nonatomic, strong) NSMutableDictionary *selectedFilterDict;
//当前的筛选属性,如s_brands,s_category等
@property (nonatomic, strong) NSString *key;
//可选的数据，树形结构
@property (nonatomic, strong) NSArray *dataItem;

@end
