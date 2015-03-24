//
//  ShoppingCartController.h
//  ZFUB
//
//  Created by 徐宝桥 on 15/1/23.
//  Copyright (c) 2015年 ___MyCompanyName___. All rights reserved.
//

#import "CommonViewController.h"
#import "ShoppingCartModel.h"
@interface ShoppingCartController : CommonViewController
{
    
    BOOL isSelecteds;
    CGFloat summaryPrice;
    NSInteger sumall;
    
    
}
//@property (nonatomic, strong) UIButton *deleteButton;

//全选文字 颜色根据是否选中变化
@property (nonatomic, strong) UILabel *selectedLabel;
@property (nonatomic, strong) UILabel *numbertotalLabel;

@property (nonatomic, strong) UILabel *totalLabel;
@property (nonatomic, strong) ShoppingCartModel *cartData;

@property (nonatomic, strong) UIButton *finishButton;
@end
