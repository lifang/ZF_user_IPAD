//
//  GoodListViewController.h
//  ZFUB
//
//  Created by 徐宝桥 on 15/1/24.
//  Copyright (c) 2015年 ___MyCompanyName___. All rights reserved.
//

#import "CommonViewController.h"
#import "FilterViewController.h"
@interface GoodListViewController : CommonViewController

{
    
    UICollectionViewFlowLayout *flowLayout;
    UIButton*button1;
    UIButton*button2;
    NSInteger changA;
    UIBarButtonItem *shoppingItem;
    
    FilterViewController *filterC;
    

}
@end
