//
//  MineCommonController.h
//  iPadff
//
//  Created by 黄含章 on 15/3/11.
//  Copyright (c) 2015年 LanTaiPro. All rights reserved.
//

#import "CommonViewController.h"
#import "ChooseView.h"

@interface MineCommonController : CommonViewController

@property(nonatomic,strong)ChooseView *chooseView;

-(void)orderClick;

-(void)setLeftViewWith:(ChooseViewType)choosetype;
-(void)messageBtnClick;


@end
