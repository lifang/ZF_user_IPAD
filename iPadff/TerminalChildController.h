//
//  TerminalChildController.h
//  iPadff
//
//  Created by 黄含章 on 15/3/10.
//  Copyright (c) 2015年 LanTaiPro. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TerminalManagerModel.h"
#import "ScanImageViewController.h"
#import "TerminalModel.h"

@interface TerminalChildController : ScanImageViewController

@property(nonatomic,strong)NSString *dealStatus;

@property(nonatomic,assign)BOOL isHaveVideo;

@property (nonatomic, strong) NSString *tm_ID; //终端信息id

@property(nonatomic,strong)NSString *appID;

@property(nonatomic,strong)NSString *type;

@property(nonatomic,strong)NSString *openStatus;

@property(nonatomic,strong)NSString *protocol;

@end
