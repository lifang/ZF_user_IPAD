//
//  ShoppingCartCell.m
//  ZFUB
//
//  Created by 徐宝桥 on 15/2/3.
//  Copyright (c) 2015年 ___MyCompanyName___. All rights reserved.
//

#import "ShoppingCartCell.h"
#import "RegularFormat.h"

@implementation ShoppingCartCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self initAndLayoutUI];
        if ([reuseIdentifier isEqualToString:shoppingCartIdentifier_normal]) {
            [self normalStyleUI];
        }
        else if ([reuseIdentifier isEqualToString:shoppingCartIdentifier_edit]) {
            [self editStyleUI];
        }
    }
    return self;
}

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

#pragma mark - UI

- (void)initAndLayoutUI {
    CGFloat leftBorderSpace = 35.f; //左间距
    CGFloat topBorderSpace = 10.f;  //上间距
    CGFloat labelHeight = 30.f;     //标题高度
    CGFloat selectBtnSize = 24.f;   //选中按钮大小
    CGFloat pictureSize = 80.f;     //图片大小
    CGFloat editHeight = 24.f;      //编辑按钮高度
    CGFloat deleteSize = 40.f;      //删除按钮大小
    
    //选中按钮
    _selectedButton = [UIButton buttonWithType:UIButtonTypeCustom];
    _selectedButton.translatesAutoresizingMaskIntoConstraints = NO;
    [_selectedButton setImage :kImageName(@"select_normal") forState:UIControlStateNormal];
    [_selectedButton setImage:kImageName(@"select_height") forState:UIControlStateHighlighted];
    [_selectedButton addTarget:self action:@selector(selectedOrder:) forControlEvents:UIControlEventTouchUpInside];
    [self.contentView addSubview:_selectedButton];
    [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:_selectedButton
                                                                 attribute:NSLayoutAttributeLeft
                                                                 relatedBy:NSLayoutRelationEqual
                                                                    toItem:self.contentView
                                                                 attribute:NSLayoutAttributeLeft
                                                                multiplier:1.0
                                                                  constant:leftBorderSpace]];
    [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:_selectedButton
                                                                 attribute:NSLayoutAttributeCenterY
                                                                 relatedBy:NSLayoutRelationEqual
                                                                    toItem:self.contentView
                                                                 attribute:NSLayoutAttributeCenterY
                                                                multiplier:1.0
                                                                  constant:0.f]];
    [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:_selectedButton
                                                                 attribute:NSLayoutAttributeWidth
                                                                 relatedBy:NSLayoutRelationEqual
                                                                    toItem:nil
                                                                 attribute:NSLayoutAttributeNotAnAttribute
                                                                multiplier:0.0
                                                                  constant:selectBtnSize]];
    [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:_selectedButton
                                                                 attribute:NSLayoutAttributeHeight
                                                                 relatedBy:NSLayoutRelationEqual
                                                                    toItem:nil
                                                                 attribute:NSLayoutAttributeNotAnAttribute
                                                                multiplier:0.0
                                                                  constant:selectBtnSize]];
    //图片
    _pictureView = [[UIImageView alloc] init];
    _pictureView.translatesAutoresizingMaskIntoConstraints = NO;
    [self.contentView addSubview:_pictureView];
    [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:_pictureView
                                                                 attribute:NSLayoutAttributeLeft
                                                                 relatedBy:NSLayoutRelationEqual
                                                                    toItem:_selectedButton
                                                                 attribute:NSLayoutAttributeRight
                                                                multiplier:1.0
                                                                  constant:10.f]];
    [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:_pictureView
                                                                 attribute:NSLayoutAttributeCenterY
                                                                 relatedBy:NSLayoutRelationEqual
                                                                    toItem:self.contentView
                                                                 attribute:NSLayoutAttributeCenterY
                                                                multiplier:1.0
                                                                  constant:0.f]];
    [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:_pictureView
                                                                 attribute:NSLayoutAttributeWidth
                                                                 relatedBy:NSLayoutRelationEqual
                                                                    toItem:nil
                                                                 attribute:NSLayoutAttributeNotAnAttribute
                                                                multiplier:0.0
                                                                  constant:pictureSize]];
    [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:_pictureView
                                                                 attribute:NSLayoutAttributeHeight
                                                                 relatedBy:NSLayoutRelationEqual
                                                                    toItem:nil
                                                                 attribute:NSLayoutAttributeNotAnAttribute
                                                                multiplier:0.0
                                                                  constant:pictureSize]];
    
    //编辑按钮
//    _editButton = [UIButton buttonWithType:UIButtonTypeCustom];
//    _editButton.translatesAutoresizingMaskIntoConstraints = NO;
//    _editButton.titleLabel.font = [UIFont systemFontOfSize:12.f];
//    [_editButton setTitle:@"编辑" forState:UIControlStateNormal];
//    [_editButton setTitleColor:kColor(255, 102, 36, 1) forState:UIControlStateNormal];
//    [_editButton setTitleColor:[UIColor lightGrayColor] forState:UIControlStateHighlighted];
//    [_editButton addTarget:self action:@selector(editOrder:) forControlEvents:UIControlEventTouchUpInside];
//    [self.contentView addSubview:_editButton];
//    [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:_editButton
//                                                                 attribute:NSLayoutAttributeRight
//                                                                 relatedBy:NSLayoutRelationEqual
//                                                                    toItem:self.contentView
//                                                                 attribute:NSLayoutAttributeRight
//                                                                multiplier:1.0
//                                                                  constant:0.f]];
//    [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:_editButton
//                                                                 attribute:NSLayoutAttributeTop
//                                                                 relatedBy:NSLayoutRelationEqual
//                                                                    toItem:self.contentView
//                                                                 attribute:NSLayoutAttributeTop
//                                                                multiplier:1.0
//                                                                  constant:labelHeight - editHeight + topBorderSpace]];
//    [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:_editButton
//                                                                 attribute:NSLayoutAttributeWidth
//                                                                 relatedBy:NSLayoutRelationEqual
//                                                                    toItem:nil
//                                                                 attribute:NSLayoutAttributeNotAnAttribute
//                                                                multiplier:0.0
//                                                                  constant:40]];
//    [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:_editButton
//                                                                 attribute:NSLayoutAttributeHeight
//                                                                 relatedBy:NSLayoutRelationEqual
//                                                                    toItem:nil
//                                                                 attribute:NSLayoutAttributeNotAnAttribute
//                                                                multiplier:0.0
//                                                                  constant:editHeight]];
//    
    //标题
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

    _titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(155, 10, 180, 30)];
    _titleLabel.backgroundColor = [UIColor clearColor];
    _titleLabel.font = [UIFont systemFontOfSize:16.f];
    [self.contentView addSubview:_titleLabel];
   
    //竖线
    UIImageView *vLine = [[UIImageView alloc] init];
    vLine.translatesAutoresizingMaskIntoConstraints = NO;
//    vLine.image = kImageName(@"gray.png");
    [self.contentView addSubview:vLine];
    [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:vLine
                                                                 attribute:NSLayoutAttributeRight
                                                                 relatedBy:NSLayoutRelationEqual
                                                                    toItem:_editButton
                                                                 attribute:NSLayoutAttributeLeft
                                                                multiplier:1.0
                                                                  constant:20]];
    [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:vLine
                                                                 attribute:NSLayoutAttributeTop
                                                                 relatedBy:NSLayoutRelationEqual
                                                                    toItem:self.contentView
                                                                 attribute:NSLayoutAttributeTop
                                                                multiplier:1.0
                                                                  constant:topBorderSpace]];
    [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:vLine
                                                                 attribute:NSLayoutAttributeWidth
                                                                 relatedBy:NSLayoutRelationEqual
                                                                    toItem:nil
                                                                 attribute:NSLayoutAttributeNotAnAttribute
                                                                multiplier:0.0
                                                                  constant:kLineHeight]];
    [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:vLine
                                                                 attribute:NSLayoutAttributeHeight
                                                                 relatedBy:NSLayoutRelationEqual
                                                                    toItem:nil
                                                                 attribute:NSLayoutAttributeNotAnAttribute
                                                                multiplier:0.0
                                                                  constant:16.f]];
    //横线
//    UIImageView *hLine = [[UIImageView alloc] init];
//    hLine.translatesAutoresizingMaskIntoConstraints = NO;
//    hLine.image = kImageName(@"gray.png");
//    [self.contentView addSubview:hLine];
//    [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:hLine
//                                                                 attribute:NSLayoutAttributeLeft
//                                                                 relatedBy:NSLayoutRelationEqual
//                                                                    toItem:_pictureView
//                                                                 attribute:NSLayoutAttributeRight
//                                                                multiplier:1.0
//                                                                  constant:leftBorderSpace]];
//    [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:hLine
//                                                                 attribute:NSLayoutAttributeTop
//                                                                 relatedBy:NSLayoutRelationEqual
//                                                                    toItem:_titleLabel
//                                                                 attribute:NSLayoutAttributeBottom
//                                                                multiplier:1.0
//                                                                  constant:0]];
//    [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:hLine
//                                                                 attribute:NSLayoutAttributeRight
//                                                                 relatedBy:NSLayoutRelationEqual
//                                                                    toItem:self.contentView
//                                                                 attribute:NSLayoutAttributeRight
//                                                                multiplier:1.0
//                                                                  constant:0]];
//    [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:hLine
//                                                                 attribute:NSLayoutAttributeHeight
//                                                                 relatedBy:NSLayoutRelationEqual
//                                                                    toItem:nil
//                                                                 attribute:NSLayoutAttributeNotAnAttribute
//                                                                multiplier:0.0
//                                                                  constant:kLineHeight]];
    //支付通道
    _channelLabel = [[UILabel alloc] init];
    _channelLabel.translatesAutoresizingMaskIntoConstraints = NO;
    _channelLabel.backgroundColor = [UIColor clearColor];
    _channelLabel.font = [UIFont systemFontOfSize:14.f];
    [self.contentView addSubview:_channelLabel];
    [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:_channelLabel
                                                                 attribute:NSLayoutAttributeLeft
                                                                 relatedBy:NSLayoutRelationEqual
                                                                    toItem:_pictureView
                                                                 attribute:NSLayoutAttributeRight
                                                                multiplier:1.0
                                                                  constant:10]];
    [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:_channelLabel
                                                                 attribute:NSLayoutAttributeBottom
                                                                 relatedBy:NSLayoutRelationEqual
                                                                    toItem:self.contentView
                                                                 attribute:NSLayoutAttributeBottom
                                                                multiplier:1.0
                                                                  constant:-topBorderSpace-5]];
    [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:_channelLabel
                                                                 attribute:NSLayoutAttributeRight
                                                                 relatedBy:NSLayoutRelationEqual
                                                                    toItem:self.contentView
                                                                 attribute:NSLayoutAttributeRight
                                                                multiplier:1.0
                                                                  constant:-(deleteSize + 20)]];
    [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:_channelLabel
                                                                 attribute:NSLayoutAttributeHeight
                                                                 relatedBy:NSLayoutRelationEqual
                                                                    toItem:nil
                                                                 attribute:NSLayoutAttributeNotAnAttribute
                                                                multiplier:0.0
                                                                  constant:16.f]];
    
    //品牌
    _brandLabel = [[UILabel alloc] init];
    _brandLabel.translatesAutoresizingMaskIntoConstraints = NO;
    _brandLabel.backgroundColor = [UIColor clearColor];
    _brandLabel.font = [UIFont systemFontOfSize:14.f];
    [self.contentView addSubview:_brandLabel];
    [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:_brandLabel
                                                                 attribute:NSLayoutAttributeLeft
                                                                 relatedBy:NSLayoutRelationEqual
                                                                    toItem:_pictureView
                                                                 attribute:NSLayoutAttributeRight
                                                                multiplier:1.0
                                                                  constant:10]];
    [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:_brandLabel
                                                                 attribute:NSLayoutAttributeBottom
                                                                 relatedBy:NSLayoutRelationEqual
                                                                    toItem:_channelLabel
                                                                 attribute:NSLayoutAttributeTop
                                                                multiplier:1.0
                                                                  constant:0.f]];
    [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:_brandLabel
                                                                 attribute:NSLayoutAttributeRight
                                                                 relatedBy:NSLayoutRelationEqual
                                                                    toItem:self.contentView
                                                                 attribute:NSLayoutAttributeRight
                                                                multiplier:1.0
                                                                  constant:-(deleteSize + 20)]];
    [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:_brandLabel
                                                                 attribute:NSLayoutAttributeHeight
                                                                 relatedBy:NSLayoutRelationEqual
                                                                    toItem:nil
                                                                 attribute:NSLayoutAttributeNotAnAttribute
                                                                multiplier:0.0
                                                                  constant:16.f]];
}

- (void)normalStyleUI {
    CGFloat priceWidth = 100.f;
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

    _priceLabel = [[UILabel alloc] initWithFrame:CGRectMake(wide/2-50, 28, 100, 30)];
    _priceLabel.backgroundColor = [UIColor clearColor];
//    _priceLabel.font = [UIFont boldSystemFontOfSize:14.f];
    _priceLabel.textAlignment = NSTextAlignmentCenter;
//    _priceLabel.textColor = kColor(255, 102, 36, 1);
    [self.contentView addSubview:_priceLabel];
    
    
    _countLabel = [[UILabel alloc] initWithFrame:CGRectMake(wide/2-50, 58, 100, 20)];

    _countLabel.backgroundColor = [UIColor clearColor];
//    _countLabel.font = [UIFont systemFontOfSize:12.f];
    _countLabel.textAlignment = NSTextAlignmentCenter;
    [self.contentView addSubview:_countLabel];
    _linelable = [[UILabel alloc] initWithFrame:CGRectMake(30, 107, wide-75, 1)];
    _linelable.backgroundColor = [UIColor colorWithWhite:0.7 alpha:1];
    [self.contentView addSubview:_linelable];

    
}

- (void)editStyleUI {
    CGFloat vSpace = 5.f;
    CGFloat inputwidth = 90.f;
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

    _numberField = [[UITextField alloc] initWithFrame:CGRectMake(wide-150-110, 39, 130, 40)];
    _numberField.delegate = self;
    _numberField.layer.borderWidth = 1;
    _numberField.layer.borderColor = kColor(193, 192, 192, 1).CGColor;
    _numberField.borderStyle = UITextBorderStyleNone;
    _numberField.font = [UIFont systemFontOfSize:16.f];
    _numberField.textAlignment = NSTextAlignmentCenter;
    _numberField.leftViewMode = UITextFieldViewModeAlways;
    _numberField.rightViewMode = UITextFieldViewModeAlways;
    
    _minusButton = [UIButton buttonWithType:UIButtonTypeCustom];
//    _minusButton.backgroundColor = [UIColor redColor];
    _minusButton.frame = CGRectMake(0, 0, 40, 40);
//    [_minusButton setBackgroundImage:kImageName(@"numberback.png") forState:UIControlStateNormal];
    [_minusButton setTitle:@"-" forState:UIControlStateNormal];
    [_minusButton addTarget:self action:@selector(countMinus:) forControlEvents:UIControlEventTouchUpInside];
    [_minusButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    _numberField.leftView = _minusButton;
    CALayer *layer=[_minusButton  layer];
    //是否设置边框以及是否可见
    [layer setMasksToBounds:YES];
    //设置边框圆角的弧度
    
    //设置边框线的宽
    //
    [layer setBorderWidth:1];
    //设置边框线的颜色
    [layer setBorderColor:[kColor(193, 192, 192, 1) CGColor]];
    _addButton = [UIButton buttonWithType:UIButtonTypeCustom];
    _addButton.frame = CGRectMake(0, 0, 40, 40);
//    [_addButton setBackgroundImage:kImageName(@"numberback.png") forState:UIControlStateNormal];
    [_addButton setTitle:@"+" forState:UIControlStateNormal];
    [_addButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [_addButton addTarget:self action:@selector(countAdd:) forControlEvents:UIControlEventTouchUpInside];
    _numberField.rightView = _addButton;
    [self.contentView addSubview:_numberField];
    
    CALayer *layers=[_addButton  layer];
    //是否设置边框以及是否可见
    [layers setMasksToBounds:YES];
    //设置边框圆角的弧度
    
    //设置边框线的宽
    //
    [layers setBorderWidth:1];
    //设置边框线的颜色
    [layers setBorderColor:[kColor(193, 192, 192, 1) CGColor]];
    
    
    
    _deleteButton = [UIButton buttonWithType:UIButtonTypeCustom];
    _deleteButton.frame=CGRectMake(wide-120, 39, 100, 30);
    [_deleteButton setTitle:@"删除" forState:UIControlStateNormal];
    [_deleteButton setTitleColor:kColor(233, 91, 38, 1) forState:UIControlStateNormal];
    _deleteButton.titleLabel.font = [UIFont systemFontOfSize: 14.0];
    

    [_deleteButton addTarget:self action:@selector(deletealert) forControlEvents:UIControlEventTouchUpInside];
    [self.contentView addSubview:_deleteButton];
    
    //    [self.contentView addSubview:_deleteButton];
    
       [self normalStyleUI ];

}


#pragma mark - Data
-(void)deletealert
{UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"温馨提示" message:@"您确定删除吗？" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
               [alert show];



}
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    //回调方法把alert本身传过来是为了区分多个alertView时，哪个alert进行的回调
   
        switch (buttonIndex)
        { case 0:
                
                
                
                break;
                
            case 1:
                [self deleteOrder];
                
                break;
                
            default:
                break;
                
                
        }
  
}

- (IBAction)deleteOrder {
    if (_delegate && [_delegate respondsToSelector:@selector(deleteOrderForCell:)]) {
        [_delegate deleteOrderForCell:self];
    }
}
- (void)setShoppingCartData:(ShoppingCartModel *)cart {
    _cartData = cart;
    [self.pictureView sd_setImageWithURL:[NSURL URLWithString:cart.cartImagePath]
                        placeholderImage:kImageName(@"test1.png")];
    self.titleLabel.text = cart.cartTitle;
    self.brandLabel.text = [NSString stringWithFormat:@"品牌型号   %@",cart.cartModel];
    self.channelLabel.text = [NSString stringWithFormat:@"支付通道   %@",cart.cartChannel];
    self.priceLabel.text = [NSString stringWithFormat:@"￥%.2f",(cart.cartPrice + cart.channelCost) ];
    self.countLabel.text = [NSString stringWithFormat:@"X %d",cart.cartCount];
    if (cart.isSelected) {
        [_selectedButton setImage :kImageName(@"select_height") forState:UIControlStateNormal];
    }
    else {
        [_selectedButton setImage:kImageName(@"select_normal") forState:UIControlStateNormal];
    }
        _numberField.text = [NSString stringWithFormat:@"%d",cart.cartCount];
}

#pragma mark - Action

- (IBAction)selectedOrder:(id)sender {
    _cartData.isSelected = !_cartData.isSelected;
    
}

- (IBAction)editOrder:(id)sender {
    if (_delegate && [_delegate respondsToSelector:@selector(editOrderForCell:)]) {
        [_delegate editOrderForCell:self];
    }
}

- (IBAction)countMinus:(id)sender {
    BOOL isNumber = [RegularFormat isNumber:_numberField.text];
    if (isNumber) {
        int currentCount = [_numberField.text intValue];
        if (currentCount > 1) {
            currentCount--;
            _numberField.text = [NSString stringWithFormat:@"%d",currentCount];
            if (_delegate && [_delegate respondsToSelector:@selector(minusCountForCell:)]) {
                [_delegate minusCountForCell:self];
            }
        }
        else {
            
        }
    }
    else {
        _numberField.text = [NSString stringWithFormat:@"%d",_cartData.cartCount];
    }
}

- (IBAction)countAdd:(id)sender {
    BOOL isNumber = [RegularFormat isNumber:_numberField.text];
    if (isNumber) {
        int currentCount = [_numberField.text intValue];
        currentCount++;
        _numberField.text = [NSString stringWithFormat:@"%d",currentCount];
        if (_delegate && [_delegate respondsToSelector:@selector(addCountForCell:)]) {
            [_delegate addCountForCell:self];
        }
    }
    else {
        _numberField.text = [NSString stringWithFormat:@"%d",_cartData.cartCount];
    }
}



#pragma mark - UITextField

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    BOOL isNumber = [RegularFormat isNumber:_numberField.text];
    if (isNumber && [_numberField.text intValue] > 0) {
        int currentCount = [_numberField.text intValue];
        _numberField.text = [NSString stringWithFormat:@"%d",currentCount];
        if (_delegate && [_delegate respondsToSelector:@selector(addCountForCell:)]) {
            [_delegate addCountForCell:self];
        }
    }
    else {
        _numberField.text = [NSString stringWithFormat:@"%d",_cartData.cartCount];
    }
    return YES;
}

@end