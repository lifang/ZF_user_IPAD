//
//  TerminalAddViewController.h
//  iPadff
//
//  Created by 黄含章 on 15/3/9.
//  Copyright (c) 2015年 LanTaiPro. All rights reserved.
//

#import "CommonViewController.h"

@protocol addTerminal <NSObject>

@optional
-(void)addTerminalSuccess;
@end

@interface TerminalAddViewController : CommonViewController
@property(nonatomic,weak)id TerminalDelegates;
@end
