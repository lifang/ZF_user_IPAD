//
//  ShoppingCartFooterView.m
//  ZFUB
//
//  Created by 徐宝桥 on 15/2/4.
//  Copyright (c) 2015年 ___MyCompanyName___. All rights reserved.
//

#import "ShoppingCartFooterView.h"

@implementation ShoppingCartFooterView

//- (id)init {
//    if (self = [super init]) {
//        [self initAndLayoutUI];
//    }
//    return self;
//}

- (id)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self initAndLayoutUI];
    }
    return self;
}

#pragma mark - UI

- (void)initAndLayoutUI {
    CGFloat wide;
    CGFloat height;
    if(iOS7)
    {
        wide=SCREEN_HEIGHT-60;
        height=SCREEN_WIDTH;
        
    
    }
    else
    {  wide=SCREEN_WIDTH-60;
        height=SCREEN_HEIGHT;
    
    }
    UIView *line = [[UIView alloc] initWithFrame:CGRectMake(0, 0, wide, 1)];
    line.backgroundColor = kColor(188, 187, 187, 1);
    [self addSubview:line];
    
    
    _finishButton = [UIButton buttonWithType:UIButtonTypeCustom];
    _finishButton.frame=CGRectMake(wide-80, 50, 60, 40);
//    _finishButton.layer.cornerRadius = 4;
    _finishButton.layer.masksToBounds = YES;
    _finishButton.titleLabel.font = [UIFont systemFontOfSize:16.f];
    [_finishButton setTitle:@"结算" forState:UIControlStateNormal];
    [_finishButton setBackgroundImage:[UIImage imageNamed:@"orange.png"] forState:UIControlStateNormal];
    [self addSubview:_finishButton];
       //选中按钮
    _selectedButton = [UIButton buttonWithType:UIButtonTypeCustom];
    _selectedButton.frame=CGRectMake(20, 10, 30, 30);
    if (isSelected) {
        
        [_selectedButton setBackgroundImage:kImageName(@"select_height") forState:UIControlStateNormal];
        _selectedLabel.textColor = [UIColor blackColor];
    }
    else {
        
        [_selectedButton setBackgroundImage:kImageName(@"select_normal") forState:UIControlStateNormal];
        _selectedLabel.textColor = kColor(128, 126, 126, 1);
    }

    [_selectedButton addTarget:self action:@selector(selectedAll:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:_selectedButton];
        //全选文字
    _selectedLabel = [[UILabel alloc]  initWithFrame:CGRectMake(60, 10, 30, 30)];

    _selectedLabel.backgroundColor = [UIColor clearColor];
    _selectedLabel.font = [UIFont systemFontOfSize:15.f];
    _selectedLabel.textColor = kColor(128, 126, 126, 1);
    _selectedLabel.text = @"全选";
    _selectedLabel.userInteractionEnabled = YES;
    [self addSubview:_selectedLabel];

        _numbertotalLabel = [[UILabel alloc]  initWithFrame:CGRectMake(wide-140, 10, 120, 30)];

    _numbertotalLabel.font = [UIFont boldSystemFontOfSize:14.f];
    _numbertotalLabel.text = @"共计：";
    [self addSubview:_numbertotalLabel];
    
    
    
    _totalLabel = [[UILabel alloc] initWithFrame:CGRectMake(wide-240, 50, 100, 25)];

    _totalLabel.backgroundColor = [UIColor clearColor];
    
    
    _totalLabel.font = [UIFont boldSystemFontOfSize:14.f];
    _totalLabel.textAlignment = NSTextAlignmentRight;
    _totalLabel.text = @"合计:￥0.00";
    [self addSubview:_totalLabel];
       //文字
    UILabel *detailLabel = [[UILabel alloc] initWithFrame:CGRectMake(wide-200, 75, 100, 15)];
    detailLabel.backgroundColor = [UIColor clearColor];
    detailLabel.font = [UIFont systemFontOfSize:12.f];
    detailLabel.textAlignment = NSTextAlignmentRight;
    detailLabel.text = @"(不含配送费)";
    [self addSubview:detailLabel];
   }

#pragma mark - Action

- (IBAction)selectedAll:(id)sender {
    NSLog(@"%hhd", _selectedButton.selected);

    isSelected = !isSelected;
    NSLog(@"%hhd", _selectedButton.selected);
    
    if (_delegate && [_delegate respondsToSelector:@selector(selectedAllShoppingCart:)]) {
        [_delegate selectedAllShoppingCart:isSelected];
    }
}

//- (void)selectButton:(UITapGestureRecognizer *)tap {
//    [self selectedAll:nil];
//}

@end
