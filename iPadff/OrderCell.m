//
//  OrderCell.m
//  ZFUB
//
//  Created by 徐宝桥 on 15/3/3.
//  Copyright (c) 2015年 ___MyCompanyName___. All rights reserved.
//

#import "OrderCell.h"

static NSString *orderBtnStyleFirst = @"orderBtnStyleFirst";
static NSString *orderBtnStyleSecond = @"orderBtnStyleSecond";

typedef enum {
    BtnPositionLeft = 1,
    BtnPositionMiddle,
    BtnPositionRight,
}BtnPosition;

@implementation OrderCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        _identifier = reuseIdentifier;
        [self initAndLayoutUI];
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
    CGFloat topSpace = 5.f;
    CGFloat leftSpace = 10.f;
    CGFloat labelHeight = 18.f;

    CGFloat imageSize = 70.f;
    headerView = [[UIView alloc]init];
    if (iOS7) {
        headerView.frame = CGRectMake(0, 0, SCREEN_HEIGHT - 160.f, SCREEN_WIDTH);
    }
    else
    {
        headerView.frame = CGRectMake(0, 0, SCREEN_WIDTH - 160.f, SCREEN_HEIGHT);
        
        
    }
    [self.contentView addSubview:headerView];
    

    //订单编号
    _orderNoLabel = [[UILabel alloc] init];
    _orderNoLabel.translatesAutoresizingMaskIntoConstraints = NO;
    _orderNoLabel.backgroundColor = [UIColor clearColor];
    _orderNoLabel.textColor = kColor(117, 117, 117, 1);
    _orderNoLabel.font = [UIFont systemFontOfSize:12.f];
    [headerView addSubview:_orderNoLabel];
    [headerView addConstraint:[NSLayoutConstraint constraintWithItem:_orderNoLabel
                                                                 attribute:NSLayoutAttributeTop
                                                                 relatedBy:NSLayoutRelationEqual
                                                                    toItem:headerView
                                                                 attribute:NSLayoutAttributeTop
                                                                multiplier:1.0
                                                                  constant:10.f]];
    [headerView addConstraint:[NSLayoutConstraint constraintWithItem:_orderNoLabel
                                                                 attribute:NSLayoutAttributeLeft
                                                                 relatedBy:NSLayoutRelationEqual
                                                                    toItem:headerView
                                                                 attribute:NSLayoutAttributeLeft
                                                                multiplier:1.0
                                                                  constant:leftSpace+10]];
    [headerView addConstraint:[NSLayoutConstraint constraintWithItem:_orderNoLabel
                                                                 attribute:NSLayoutAttributeWidth
                                                                 relatedBy:NSLayoutRelationEqual
                                                                    toItem:headerView
                                                                 attribute:NSLayoutAttributeWidth
                                                                multiplier:0.45
                                                                  constant:-leftSpace]];
    [headerView addConstraint:[NSLayoutConstraint constraintWithItem:_orderNoLabel
                                                                 attribute:NSLayoutAttributeHeight
                                                                 relatedBy:NSLayoutRelationEqual
                                                                    toItem:nil
                                                                 attribute:NSLayoutAttributeNotAnAttribute
                                                                multiplier:0.0
                                                                  constant:labelHeight]];
    //时间
    _timeLabel = [[UILabel alloc] init];
    _timeLabel.translatesAutoresizingMaskIntoConstraints = NO;
    _timeLabel.backgroundColor = [UIColor clearColor];
    _timeLabel.textColor = kColor(117, 117, 117, 1);
    _timeLabel.font = [UIFont systemFontOfSize:12.f];
    [headerView addSubview:_timeLabel];
    [headerView addConstraint:[NSLayoutConstraint constraintWithItem:_timeLabel
                                                                 attribute:NSLayoutAttributeTop
                                                                 relatedBy:NSLayoutRelationEqual
                                                                    toItem:headerView
                                                                 attribute:NSLayoutAttributeTop
                                                                multiplier:1.0
                                                                  constant:10.f]];
    [headerView addConstraint:[NSLayoutConstraint constraintWithItem:_timeLabel
                                                                 attribute:NSLayoutAttributeLeft
                                                                 relatedBy:NSLayoutRelationEqual
                                                                    toItem:_orderNoLabel
                                                                 attribute:NSLayoutAttributeRight
                                                                multiplier:1.0
                                                                  constant:-40.f]];
    [headerView addConstraint:[NSLayoutConstraint constraintWithItem:_timeLabel
                                                                 attribute:NSLayoutAttributeWidth
                                                                 relatedBy:NSLayoutRelationEqual
                                                                    toItem:headerView
                                                                 attribute:NSLayoutAttributeWidth
                                                                multiplier:0.35
                                                                  constant:-leftSpace]];
    [headerView addConstraint:[NSLayoutConstraint constraintWithItem:_timeLabel
                                                                 attribute:NSLayoutAttributeHeight
                                                                 relatedBy:NSLayoutRelationEqual
                                                                    toItem:nil
                                                                 attribute:NSLayoutAttributeNotAnAttribute
                                                                multiplier:0.0
                                                                  constant:labelHeight]];
    //状态
    _statusLabel = [[UILabel alloc] init];
    _statusLabel.translatesAutoresizingMaskIntoConstraints = NO;
    _statusLabel.backgroundColor = [UIColor clearColor];
    _statusLabel.textColor = kColor(117, 117, 117, 1);
    _statusLabel.textAlignment = NSTextAlignmentRight;
    _statusLabel.font = [UIFont systemFontOfSize:13.f];
    [headerView addSubview:_statusLabel];
    [headerView addConstraint:[NSLayoutConstraint constraintWithItem:_statusLabel
                                                                 attribute:NSLayoutAttributeTop
                                                                 relatedBy:NSLayoutRelationEqual
                                                                    toItem:headerView
                                                                 attribute:NSLayoutAttributeTop
                                                                multiplier:1.0
                                                                  constant:10.f]];
    [headerView addConstraint:[NSLayoutConstraint constraintWithItem:_statusLabel
                                                                 attribute:NSLayoutAttributeRight
                                                                 relatedBy:NSLayoutRelationEqual
                                                                    toItem:headerView
                                                                 attribute:NSLayoutAttributeRight
                                                                multiplier:1.0
                                                                  constant:-120]];
    [headerView addConstraint:[NSLayoutConstraint constraintWithItem:_statusLabel
                                                                 attribute:NSLayoutAttributeLeft
                                                                 relatedBy:NSLayoutRelationEqual
                                                                    toItem:_timeLabel
                                                                 attribute:NSLayoutAttributeRight
                                                                multiplier:1.0
                                                                  constant:20.f]];
    [headerView addConstraint:[NSLayoutConstraint constraintWithItem:_statusLabel
                                                                 attribute:NSLayoutAttributeHeight
                                                                 relatedBy:NSLayoutRelationEqual
                                                                    toItem:nil
                                                                 attribute:NSLayoutAttributeNotAnAttribute
                                                                multiplier:0.0
                                                                  constant:labelHeight]];
    //划线
    UIImageView *firstLine = [[UIImageView alloc] init];
//    firstLine.image = kImageName(@"gray.png");
    firstLine.translatesAutoresizingMaskIntoConstraints = NO;
    [headerView addSubview:firstLine];
    [headerView addConstraint:[NSLayoutConstraint constraintWithItem:firstLine
                                                                 attribute:NSLayoutAttributeTop
                                                                 relatedBy:NSLayoutRelationEqual
                                                                    toItem:_orderNoLabel
                                                                 attribute:NSLayoutAttributeBottom
                                                                multiplier:1.0
                                                                  constant:0.f]];
    [headerView addConstraint:[NSLayoutConstraint constraintWithItem:firstLine
                                                                 attribute:NSLayoutAttributeLeft
                                                                 relatedBy:NSLayoutRelationEqual
                                                                    toItem:headerView
                                                                 attribute:NSLayoutAttributeLeft
                                                                multiplier:1.0
                                                                  constant:leftSpace]];
    [headerView addConstraint:[NSLayoutConstraint constraintWithItem:firstLine
                                                                 attribute:NSLayoutAttributeRight
                                                                 relatedBy:NSLayoutRelationEqual
                                                                    toItem:headerView
                                                                 attribute:NSLayoutAttributeRight
                                                                multiplier:1.0
                                                                  constant:-leftSpace]];
    [headerView addConstraint:[NSLayoutConstraint constraintWithItem:firstLine
                                                                 attribute:NSLayoutAttributeHeight
                                                                 relatedBy:NSLayoutRelationEqual
                                                                    toItem:nil
                                                                 attribute:NSLayoutAttributeNotAnAttribute
                                                                multiplier:0.0
                                                                  constant:1.0]];
    
    //图片
    _pictureView = [[UIImageView alloc] init];
    _pictureView.translatesAutoresizingMaskIntoConstraints = NO;
    [headerView addSubview:_pictureView];
    [headerView addConstraint:[NSLayoutConstraint constraintWithItem:_pictureView
                                                                 attribute:NSLayoutAttributeTop
                                                                 relatedBy:NSLayoutRelationEqual
                                                                    toItem:_orderNoLabel
                                                                 attribute:NSLayoutAttributeBottom
                                                                multiplier:1.0
                                                                  constant:topSpace]];
    [headerView addConstraint:[NSLayoutConstraint constraintWithItem:_pictureView
                                                                 attribute:NSLayoutAttributeLeft
                                                                 relatedBy:NSLayoutRelationEqual
                                                                    toItem:headerView                                                                 attribute:NSLayoutAttributeLeft
                                                                multiplier:1.0
                                                                  constant:20.f]];
    [headerView addConstraint:[NSLayoutConstraint constraintWithItem:_pictureView
                                                                 attribute:NSLayoutAttributeWidth
                                                                 relatedBy:NSLayoutRelationEqual
                                                                    toItem:nil
                                                                 attribute:NSLayoutAttributeNotAnAttribute
                                                                multiplier:0.0
                                                                  constant:imageSize]];
    [headerView addConstraint:[NSLayoutConstraint constraintWithItem:_pictureView
                                                                 attribute:NSLayoutAttributeHeight
                                                                 relatedBy:NSLayoutRelationEqual
                                                                    toItem:nil
                                                                 attribute:NSLayoutAttributeNotAnAttribute
                                                                multiplier:0.0
                                                                  constant:imageSize]];
    //商品名
    _nameLabel = [[UILabel alloc] init];
    [self layoutGoodLabel:_nameLabel WithTopView:_orderNoLabel topSpace:5.f alignment:NSTextAlignmentLeft];
    //价格
    _priceLabel = [[UILabel alloc] init];
    [self layoutGoodLabel:_priceLabel WithTopView:_nameLabel topSpace:0.f alignment:NSTextAlignmentRight];
    //数量
    _numberLabel = [[UILabel alloc] init];
    [self layoutGoodLabel:_numberLabel WithTopView:_priceLabel topSpace:0.f alignment:NSTextAlignmentRight];
    //型号
    _brandLabel = [[UILabel alloc] init];
    [self layoutGoodLabel:_brandLabel WithTopView:_numberLabel topSpace:0.f alignment:NSTextAlignmentLeft];
    //支付通道
    _channelLabel = [[UILabel alloc] init];
    [self layoutGoodLabel:_channelLabel WithTopView:_brandLabel topSpace:3.0f alignment:NSTextAlignmentLeft];
    
    //划线
    UIImageView *secondLine = [[UIImageView alloc] init];
//    secondLine.image = kImageName(@"gray.png");
    secondLine.translatesAutoresizingMaskIntoConstraints = NO;
    [headerView addSubview:secondLine];
    [headerView addConstraint:[NSLayoutConstraint constraintWithItem:secondLine
                                                                 attribute:NSLayoutAttributeTop
                                                                 relatedBy:NSLayoutRelationEqual
                                                                    toItem:_pictureView
                                                                 attribute:NSLayoutAttributeBottom
                                                                multiplier:1.0
                                                                  constant:topSpace]];
    [headerView addConstraint:[NSLayoutConstraint constraintWithItem:secondLine
                                                                 attribute:NSLayoutAttributeLeft
                                                                 relatedBy:NSLayoutRelationEqual
                                                                    toItem:headerView
                                                                 attribute:NSLayoutAttributeLeft
                                                                multiplier:1.0
                                                                  constant:leftSpace]];
    [headerView addConstraint:[NSLayoutConstraint constraintWithItem:secondLine
                                                                 attribute:NSLayoutAttributeRight
                                                                 relatedBy:NSLayoutRelationEqual
                                                                    toItem:headerView                                                                 attribute:NSLayoutAttributeRight
                                                                multiplier:1.0
                                                                  constant:-leftSpace]];
    [headerView addConstraint:[NSLayoutConstraint constraintWithItem:secondLine
                                                                 attribute:NSLayoutAttributeHeight
                                                                 relatedBy:NSLayoutRelationEqual
                                                                    toItem:nil
                                                                 attribute:NSLayoutAttributeNotAnAttribute
                                                                multiplier:0.0
                                                                  constant:1.0]];
    //共计
    _totalCountLabel = [[UILabel alloc] init];
    _totalCountLabel.translatesAutoresizingMaskIntoConstraints = NO;
    _totalCountLabel.backgroundColor = [UIColor clearColor];
    _totalCountLabel.font = [UIFont systemFontOfSize:14.f];
    _totalCountLabel.textColor = kColor(117, 117, 117, 1);
    [headerView addSubview:_totalCountLabel];
    [headerView addConstraint:[NSLayoutConstraint constraintWithItem:_totalCountLabel
                                                                 attribute:NSLayoutAttributeTop
                                                                 relatedBy:NSLayoutRelationEqual
                                                                    toItem:secondLine
                                                                 attribute:NSLayoutAttributeBottom
                                                                multiplier:1.0
                                                                  constant:topSpace]];
    [headerView addConstraint:[NSLayoutConstraint constraintWithItem:_totalCountLabel
                                                                 attribute:NSLayoutAttributeLeft
                                                                 relatedBy:NSLayoutRelationEqual
                                                                    toItem:headerView
                                                                 attribute:NSLayoutAttributeLeft
                                                                multiplier:1.0
                                                                  constant:leftSpace+10]];
    [headerView addConstraint:[NSLayoutConstraint constraintWithItem:_totalCountLabel
                                                                 attribute:NSLayoutAttributeWidth
                                                                 relatedBy:NSLayoutRelationEqual
                                                                    toItem:headerView
                                                                 attribute:NSLayoutAttributeWidth
                                                                multiplier:0.3
                                                                  constant:-leftSpace]];
    [headerView addConstraint:[NSLayoutConstraint constraintWithItem:_totalCountLabel
                                                                 attribute:NSLayoutAttributeHeight
                                                                 relatedBy:NSLayoutRelationEqual
                                                                    toItem:nil
                                                                 attribute:NSLayoutAttributeNotAnAttribute
                                                                multiplier:0.0
                                                                  constant:labelHeight]];
    //配送费
    _deliveryFeeLabel = [[UILabel alloc] init];
    _deliveryFeeLabel.translatesAutoresizingMaskIntoConstraints = NO;
    _deliveryFeeLabel.backgroundColor = [UIColor clearColor];
    _deliveryFeeLabel.font = [UIFont systemFontOfSize:14.f];
    _deliveryFeeLabel.textColor = kColor(117, 117, 117, 1);
    [headerView addSubview:_deliveryFeeLabel];
    [headerView addConstraint:[NSLayoutConstraint constraintWithItem:_deliveryFeeLabel
                                                                 attribute:NSLayoutAttributeTop
                                                                 relatedBy:NSLayoutRelationEqual
                                                                    toItem:secondLine
                                                                 attribute:NSLayoutAttributeBottom
                                                                multiplier:1.0
                                                                  constant:topSpace]];
    [headerView addConstraint:[NSLayoutConstraint constraintWithItem:_deliveryFeeLabel
                                                                 attribute:NSLayoutAttributeLeft
                                                                 relatedBy:NSLayoutRelationEqual
                                                                    toItem:_totalCountLabel
                                                                 attribute:NSLayoutAttributeRight
                                                                multiplier:1.0
                                                                  constant:0.f]];
    [headerView addConstraint:[NSLayoutConstraint constraintWithItem:_deliveryFeeLabel
                                                                 attribute:NSLayoutAttributeWidth
                                                                 relatedBy:NSLayoutRelationEqual
                                                                    toItem:headerView
                                                                 attribute:NSLayoutAttributeWidth
                                                                multiplier:0.3
                                                                  constant:-leftSpace]];
    [headerView addConstraint:[NSLayoutConstraint constraintWithItem:_deliveryFeeLabel
                                                                 attribute:NSLayoutAttributeHeight
                                                                 relatedBy:NSLayoutRelationEqual
                                                                    toItem:nil
                                                                 attribute:NSLayoutAttributeNotAnAttribute
                                                                multiplier:0.0
                                                                  constant:labelHeight]];
    //实付
    _payLabel = [[UILabel alloc] init];
    _payLabel.translatesAutoresizingMaskIntoConstraints = NO;
    _payLabel.backgroundColor = [UIColor clearColor];
    _payLabel.font = [UIFont systemFontOfSize:14.f];
    _payLabel.textColor = kColor(117, 117, 117, 1);
    _payLabel.textAlignment = NSTextAlignmentRight;
    [headerView addSubview:_payLabel];
    [headerView addConstraint:[NSLayoutConstraint constraintWithItem:_payLabel
                                                                 attribute:NSLayoutAttributeTop
                                                                 relatedBy:NSLayoutRelationEqual
                                                                    toItem:secondLine
                                                                 attribute:NSLayoutAttributeBottom
                                                                multiplier:1.0
                                                                  constant:topSpace]];
    [headerView addConstraint:[NSLayoutConstraint constraintWithItem:_payLabel
                                                                 attribute:NSLayoutAttributeRight
                                                                 relatedBy:NSLayoutRelationEqual
                                                                    toItem:headerView
                                                                 attribute:NSLayoutAttributeRight
                                                                multiplier:1.0
                                                                  constant:-100]];
    [headerView addConstraint:[NSLayoutConstraint constraintWithItem:_payLabel
                                                                 attribute:NSLayoutAttributeWidth
                                                                 relatedBy:NSLayoutRelationEqual
                                                                    toItem:headerView
                                                                 attribute:NSLayoutAttributeWidth
                                                                multiplier:0.4
                                                                  constant:-leftSpace]];
    [headerView addConstraint:[NSLayoutConstraint constraintWithItem:_payLabel
                                                                 attribute:NSLayoutAttributeHeight
                                                                 relatedBy:NSLayoutRelationEqual
                                                                    toItem:nil
                                                                 attribute:NSLayoutAttributeNotAnAttribute
                                                                multiplier:0.0
                                                                  constant:labelHeight]];
    [self setContentForReuseIdentifier];
}

- (void)setContentForReuseIdentifier {
    CGFloat wide;
    CGFloat height;
    if(iOS7)
    {
        wide=SCREEN_HEIGHT-160;
        height=SCREEN_WIDTH;
        
        
    }
    else
    {  wide=SCREEN_WIDTH-160;
        height=SCREEN_HEIGHT;
        
    }

    if ([_identifier isEqualToString:otherIdentifier]) {
        return;
    }
    else if ([_identifier isEqualToString:unPaidIdentifier]) {
        //未付款
//        [self addLine];
        UIButton *cancelBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [cancelBtn addTarget:self action:@selector(cancelOrder:) forControlEvents:UIControlEventTouchUpInside];
        [cancelBtn setTitle:@"取消订单" forState:UIControlStateNormal];
        
//        cancelBtn.layer.cornerRadius = 5;
        
        
        cancelBtn.layer.masksToBounds = YES;
        cancelBtn.layer.borderWidth = 1.f;
        cancelBtn.layer.borderColor = kColor(255, 102, 36, 1).CGColor;
        [cancelBtn setTitleColor:kColor(255, 102, 36, 1) forState:UIControlStateNormal];
        [cancelBtn setTitleColor:kColor(134, 56, 0, 1) forState:UIControlStateHighlighted];
        [headerView addSubview:cancelBtn];
        cancelBtn.frame=CGRectMake(wide-180, 70, 100, 30);
        
        UIButton *payBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [payBtn addTarget:self action:@selector(payOrder:) forControlEvents:UIControlEventTouchUpInside];
        [payBtn setTitle:@"付款" forState:UIControlStateNormal];
        payBtn.layer.masksToBounds = YES;

//        payBtn.layer.cornerRadius = 5;
        [payBtn setBackgroundImage:kImageName(@"orange.png") forState:UIControlStateNormal];
        
        [headerView addSubview:payBtn];
        payBtn.frame=CGRectMake(wide-180, 30, 100, 30);
    }
    else if ([_identifier isEqualToString:sendingIdentifier]) {
        //已发货
        UIButton *reviewBtn = [UIButton buttonWithType:UIButtonTypeCustom];
//        [reviewBtn addTarget:self action:@selector(reviewOrder:) forControlEvents:UIControlEventTouchUpInside];
//        [reviewBtn setTitle:@"评价" forState:UIControlStateNormal];
        reviewBtn.layer.masksToBounds = YES;

//        reviewBtn.layer.cornerRadius = 5;
//        [reviewBtn setBackgroundImage:kImageName(@"orange.png") forState:UIControlStateNormal];

        [headerView addSubview:reviewBtn];
        reviewBtn.frame=CGRectMake(wide-180, 50, 100, 30);
        
    }
}

- (void)layoutGoodLabel:(UILabel *)label
            WithTopView:(UIView *)topView
               topSpace:(CGFloat)space
              alignment:(NSTextAlignment)alignment {
    
    CGFloat wide;
    CGFloat height;
    if(iOS7)
    {
        wide=SCREEN_HEIGHT-160;
        height=SCREEN_WIDTH;
        
        
    }
    else
    {  wide=SCREEN_WIDTH-160;
        height=SCREEN_HEIGHT;
        
    }

    CGFloat leftSpace = 10.f;
    CGFloat labelHeight = 14.f;
    label.translatesAutoresizingMaskIntoConstraints = NO;
    label.backgroundColor = [UIColor clearColor];
    label.font = [UIFont systemFontOfSize:13.f];
    label.textAlignment = alignment;
    [headerView addSubview:label];
    [headerView addConstraint:[NSLayoutConstraint constraintWithItem:label
                                                                 attribute:NSLayoutAttributeTop
                                                                 relatedBy:NSLayoutRelationEqual
                                                                    toItem:topView
                                                                 attribute:NSLayoutAttributeBottom
                                                                multiplier:1.0
                                                                  constant:space]];
    [headerView addConstraint:[NSLayoutConstraint constraintWithItem:label
                                                                 attribute:NSLayoutAttributeLeft
                                                                 relatedBy:NSLayoutRelationEqual
                                                                    toItem:_pictureView
                                                                 attribute:NSLayoutAttributeRight
                                                                multiplier:1.0
                                                                  constant:20.f]];
    [headerView addConstraint:[NSLayoutConstraint constraintWithItem:label
                                                                 attribute:NSLayoutAttributeRight
                                                                 relatedBy:NSLayoutRelationEqual
                                                                    toItem:headerView
                                                                 attribute:NSLayoutAttributeRight
                                                                multiplier:1.0
                                                                  constant:-wide/2]];
    [headerView addConstraint:[NSLayoutConstraint constraintWithItem:label
                                                                 attribute:NSLayoutAttributeHeight
                                                                 relatedBy:NSLayoutRelationEqual
                                                                    toItem:nil
                                                                 attribute:NSLayoutAttributeNotAnAttribute
                                                                multiplier:0.0
                                                                  constant:labelHeight]];
    
}

- (void)layoutButton:(UIButton *)button location:(BtnPosition)position {
    CGFloat wide;
    CGFloat height;
    if(iOS7)
    {
        wide=SCREEN_HEIGHT-160;
        height=SCREEN_WIDTH;
        
        
    }
    else
    {  wide=SCREEN_WIDTH-160;
        height=SCREEN_HEIGHT;
        
    }

    CGFloat middleSpace = 5.f;
    CGFloat btnWidth = (wide - 8 * middleSpace) / 2;
    CGFloat btnHeight = 36.f;
    [headerView addConstraint:[NSLayoutConstraint constraintWithItem:button
                                                                 attribute:NSLayoutAttributeTop
                                                                 relatedBy:NSLayoutRelationEqual
                                                                    toItem:_totalCountLabel
                                                                 attribute:NSLayoutAttributeBottom
                                                                multiplier:1.0
                                                                  constant:middleSpace + 1]];
    switch (position) {
        case BtnPositionLeft: {
            [headerView addConstraint:[NSLayoutConstraint constraintWithItem:button
                                                                         attribute:NSLayoutAttributeLeft
                                                                         relatedBy:NSLayoutRelationEqual
                                                                            toItem:headerView
                                                                         attribute:NSLayoutAttributeLeft
                                                                        multiplier:1.0
                                                                          constant:middleSpace * 2]];
        }
            break;
        case BtnPositionRight: {
            [headerView addConstraint:[NSLayoutConstraint constraintWithItem:button
                                                                         attribute:NSLayoutAttributeRight
                                                                         relatedBy:NSLayoutRelationEqual
                                                                            toItem:headerView                                                                         attribute:NSLayoutAttributeRight
                                                                        multiplier:1.0
                                                                          constant:-middleSpace * 2]];
        }
            break;
        case BtnPositionMiddle: {
            [headerView addConstraint:[NSLayoutConstraint constraintWithItem:button
                                                                         attribute:NSLayoutAttributeCenterX
                                                                         relatedBy:NSLayoutRelationEqual
                                                                            toItem:headerView
                                                                         attribute:NSLayoutAttributeCenterX
                                                                        multiplier:1.0
                                                                          constant:0.f]];
        }
            break;
        default:
            break;
    }
    [headerView addConstraint:[NSLayoutConstraint constraintWithItem:button
                                                                 attribute:NSLayoutAttributeWidth
                                                                 relatedBy:NSLayoutRelationEqual
                                                                    toItem:nil
                                                                 attribute:NSLayoutAttributeNotAnAttribute
                                                                multiplier:0.0
                                                                  constant:btnWidth]];
    [headerView addConstraint:[NSLayoutConstraint constraintWithItem:button
                                                                 attribute:NSLayoutAttributeHeight
                                                                 relatedBy:NSLayoutRelationEqual
                                                                    toItem:nil
                                                                 attribute:NSLayoutAttributeNotAnAttribute
                                                                multiplier:0.0
                                                                  constant:btnHeight]];
}

- (UIButton *)buttonWithTitle:(NSString *)titleName
                       action:(SEL)action
                        style:(NSString *)style{
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.translatesAutoresizingMaskIntoConstraints = NO;
//    button.layer.cornerRadius = 4;
    button.layer.masksToBounds = YES;
    if ([style isEqualToString:orderBtnStyleFirst]) {
        button.layer.borderWidth = 1.f;
        button.layer.borderColor = kColor(255, 102, 36, 1).CGColor;
        [button setTitleColor:kColor(255, 102, 36, 1) forState:UIControlStateNormal];
        [button setTitleColor:kColor(134, 56, 0, 1) forState:UIControlStateHighlighted];
    }
    else {
        [button setBackgroundImage:kImageName(@"orange.png") forState:UIControlStateNormal];
    }
    button.titleLabel.font = [UIFont boldSystemFontOfSize:16.f];
    [button setTitle:titleName forState:UIControlStateNormal];
    [button addTarget:self action:action forControlEvents:UIControlEventTouchUpInside];
    return button;
}

- (void)addLine {
    UIImageView *line = [[UIImageView alloc] init];
    line.image = kImageName(@"gray.png");
    line.translatesAutoresizingMaskIntoConstraints = NO;
    [headerView addSubview:line];
    [headerView addConstraint:[NSLayoutConstraint constraintWithItem:line
                                                                 attribute:NSLayoutAttributeTop
                                                                 relatedBy:NSLayoutRelationEqual
                                                                    toItem:_totalCountLabel
                                                                 attribute:NSLayoutAttributeBottom
                                                                multiplier:1.0
                                                                  constant:0.f]];
    [headerView addConstraint:[NSLayoutConstraint constraintWithItem:line
                                                                 attribute:NSLayoutAttributeLeft
                                                                 relatedBy:NSLayoutRelationEqual
                                                                    toItem:headerView
                                                                 attribute:NSLayoutAttributeLeft
                                                                multiplier:1.0
                                                                  constant:10.f]];
    [headerView addConstraint:[NSLayoutConstraint constraintWithItem:line
                                                                 attribute:NSLayoutAttributeRight
                                                                 relatedBy:NSLayoutRelationEqual
                                                                    toItem:headerView
                                                                 attribute:NSLayoutAttributeRight
                                                                multiplier:1.0
                                                                  constant:-10.f]];

    [headerView addConstraint:[NSLayoutConstraint constraintWithItem:line
                                                                 attribute:NSLayoutAttributeHeight
                                                                 relatedBy:NSLayoutRelationEqual
                                                                    toItem:nil
                                                                 attribute:NSLayoutAttributeNotAnAttribute
                                                                multiplier:0.0
                                                                  constant:1.0]];
}

#pragma mark - Data

- (void)setContentsWithData:(OrderModel *)data {
    _cellData = data;
    self.orderNoLabel.text = [NSString stringWithFormat:@"订单编号：%@",_cellData.orderNumber];
    self.timeLabel.text = _cellData.orderTime;
    self.statusLabel.text = [_cellData getStatusString];
    self.nameLabel.text = _cellData.orderGood.goodName;
    if(_cellData.order_type==1)
    {
        self.priceLabel.text = [NSString stringWithFormat:@"￥%.2f",_cellData.orderGood.goodPrice];

    }
    else
    {
    
        self.priceLabel.text = [NSString stringWithFormat:@"￥%.2f(押金)",_cellData.orderGood.goodPrice];

    }
    self.numberLabel.text = [NSString stringWithFormat:@"X %d",[_cellData.orderGood.goodNumber intValue]];
    self.brandLabel.text = [NSString stringWithFormat:@"品牌型号 %@",_cellData.orderGood.goodBrand];
    self.channelLabel.text = [NSString stringWithFormat:@"支付通道 %@",_cellData.orderGood.goodChannel];
    self.totalCountLabel.text = [NSString stringWithFormat:@"共计：%@件",_cellData.orderTotalNum];
    self.deliveryFeeLabel.text = [NSString stringWithFormat:@"配送费：￥%.2f",_cellData.orderDeliverFee];
    self.payLabel.text = [NSString stringWithFormat:@"实付：￥%.2f",_cellData.orderTotalPrice];
    [self.pictureView sd_setImageWithURL:[NSURL URLWithString:_cellData.orderGood.goodPicture ]placeholderImage:kImageName(@"test1.png")];
}


#pragma mark - Action

- (IBAction)cancelOrder:(id)sender {
    if (_delegate && [_delegate respondsToSelector:@selector(orderCellCancelOrderForData:)]) {
        [_delegate orderCellCancelOrderForData:_cellData];
    }
}

- (IBAction)payOrder:(id)sender {
    if (_delegate && [_delegate respondsToSelector:@selector(orderCellPayOrderForData:)]) {
        [_delegate orderCellPayOrderForData:_cellData];
    }
}

- (IBAction)reviewOrder:(id)sender {
    if (_delegate && [_delegate respondsToSelector:@selector(orderCellCommentOrderForData:)]) {
        [_delegate orderCellCommentOrderForData:_cellData];
    }
}

@end
