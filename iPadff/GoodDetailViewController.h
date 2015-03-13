//
//  GoodDetailViewController.h
//  ZFUB
//
//  Created by 徐宝桥 on 15/2/26.
//  Copyright (c) 2015年 ___MyCompanyName___. All rights reserved.
//

#import "CommonViewController.h"

@interface GoodDetailViewController : CommonViewController

{
    
        CGFloat leftSpace ;  //左侧间距
        
        
    CGFloat  originXs;
    
    UIButton*  _shopcartButton;
    UIButton*  _buyGoodButton;

    

}
@property (nonatomic, strong) NSString *goodID;

@end
