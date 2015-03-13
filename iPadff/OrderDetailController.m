//
//  OrderDetailController.m
//  ZFUB
//
//  Created by 徐宝桥 on 15/3/6.
//  Copyright (c) 2015年 ___MyCompanyName___. All rights reserved.
//

#import "OrderDetailController.h"
#import "NetworkInterface.h"
#import "AppDelegate.h"
#import "OrderDetailModel.h"
#import "OrderDetailCell.h"
#import "RecordView.h"
#import "PayWayViewController.h"
#import "OrderCommentController.h"

@interface OrderDetailController ()<UITableViewDataSource,UITableViewDelegate>

@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, strong) OrderDetailModel *orderDetail;

@property (nonatomic, strong) UIView *detailFooterView;

@end

@implementation OrderDetailController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"订单详情";
    self.view.backgroundColor = kColor(244, 243, 243, 1);
    [self downloadDetail];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UI

- (void)setHeaderAndFooterView {
    //追踪记录
    if ([_orderDetail.recordList count] > 0) {
        CGFloat leftSpace = 20.f;
        UILabel *tipLabel = [[UILabel alloc] initWithFrame:CGRectMake(leftSpace, 20, kScreenWidth - leftSpace * 2 , 14)];
        tipLabel.backgroundColor = [UIColor clearColor];
        tipLabel.font = [UIFont systemFontOfSize:10.f];
        tipLabel.text = @"追踪记录：";
        RecordView *recordView = [[RecordView alloc] initWithRecords:_orderDetail.recordList
                                                               width:(kScreenWidth - leftSpace * 2)];
        CGFloat recordHeight = [recordView getHeight];
        recordView.frame = CGRectMake(leftSpace, 34, kScreenWidth - leftSpace * 2, recordHeight);
        
        UIView *footerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, recordHeight + 40)];
        footerView.backgroundColor = [UIColor clearColor];
        [footerView addSubview:tipLabel];
        [footerView addSubview:recordView];
        _tableView.tableFooterView = footerView;
        [recordView initAndLayoutUI];
    }
}

- (void)initAndLayoutUI {
    CGFloat footerHeight = 0.f;
    int status = [_orderDetail.orderStatus intValue];
    if (status == OrderStatusUnPaid || status == OrderStatusSending) {
        footerHeight = 60.f;
        //底部按钮
        _detailFooterView = [[UIView alloc] init];
        _detailFooterView.translatesAutoresizingMaskIntoConstraints = NO;
        _detailFooterView.backgroundColor = [UIColor whiteColor];
        [self.view addSubview:_detailFooterView];
        [self.view addConstraint:[NSLayoutConstraint constraintWithItem:_detailFooterView
                                                              attribute:NSLayoutAttributeTop
                                                              relatedBy:NSLayoutRelationEqual
                                                                 toItem:self.view
                                                              attribute:NSLayoutAttributeBottom
                                                             multiplier:1.0
                                                               constant:-footerHeight]];
        [self.view addConstraint:[NSLayoutConstraint constraintWithItem:_detailFooterView
                                                              attribute:NSLayoutAttributeLeft
                                                              relatedBy:NSLayoutRelationEqual
                                                                 toItem:self.view
                                                              attribute:NSLayoutAttributeLeft
                                                             multiplier:1.0
                                                               constant:0]];
        [self.view addConstraint:[NSLayoutConstraint constraintWithItem:_detailFooterView
                                                              attribute:NSLayoutAttributeRight
                                                              relatedBy:NSLayoutRelationEqual
                                                                 toItem:self.view
                                                              attribute:NSLayoutAttributeRight
                                                             multiplier:1.0
                                                               constant:0]];
        [self.view addConstraint:[NSLayoutConstraint constraintWithItem:_detailFooterView
                                                              attribute:NSLayoutAttributeBottom
                                                              relatedBy:NSLayoutRelationEqual
                                                                 toItem:self.view
                                                              attribute:NSLayoutAttributeBottom
                                                             multiplier:1.0
                                                               constant:0]];
        [self footerViewAddSubview];

    }
    _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
    _tableView.translatesAutoresizingMaskIntoConstraints = NO;
    _tableView.backgroundColor = kColor(244, 243, 243, 1);
    _tableView.delegate = self;
    _tableView.dataSource = self;
    [self setHeaderAndFooterView];
    [self.view addSubview:_tableView];
    if (kDeviceVersion >= 7.0) {
        _tableView.separatorInset = UIEdgeInsetsMake(0, 10, 0, 10);
    }
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:_tableView
                                                          attribute:NSLayoutAttributeTop
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:self.view
                                                          attribute:NSLayoutAttributeTop
                                                         multiplier:1.0
                                                           constant:0]];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:_tableView
                                                          attribute:NSLayoutAttributeLeft
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:self.view
                                                          attribute:NSLayoutAttributeLeft
                                                         multiplier:1.0
                                                           constant:0]];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:_tableView
                                                          attribute:NSLayoutAttributeRight
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:self.view
                                                          attribute:NSLayoutAttributeRight
                                                         multiplier:1.0
                                                           constant:0]];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:_tableView
                                                          attribute:NSLayoutAttributeBottom
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:self.view
                                                          attribute:NSLayoutAttributeBottom
                                                         multiplier:1.0
                                                           constant:-footerHeight]];
}

- (void)footerViewAddSubview {
    UIView *line = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 0.5)];
    line.backgroundColor = kColor(135, 135, 135, 1);
    [_detailFooterView addSubview:line];
    CGFloat middleSpace = 10.f;
    CGFloat btnWidth = (kScreenWidth - 4 * middleSpace) / 2;
    CGFloat btnHeight = 36.f;
    int status = [_orderDetail.orderStatus intValue];
    if (status == OrderStatusUnPaid) {
        UIButton *cancelButton = [UIButton buttonWithType:UIButtonTypeCustom];
        cancelButton.frame = CGRectMake(middleSpace, 12, btnWidth, btnHeight);
        cancelButton.layer.cornerRadius = 4.f;
        cancelButton.layer.masksToBounds = YES;
        cancelButton.layer.borderWidth = 1.f;
        cancelButton.layer.borderColor = kColor(255, 102, 36, 1).CGColor;
        [cancelButton setTitleColor:kColor(255, 102, 36, 1) forState:UIControlStateNormal];
        [cancelButton setTitleColor:kColor(134, 56, 0, 1) forState:UIControlStateHighlighted];
        [cancelButton setTitle:@"取消订单" forState:UIControlStateNormal];
        cancelButton.titleLabel.font = [UIFont systemFontOfSize:16.f];
        [cancelButton addTarget:self action:@selector(cancelOrder:) forControlEvents:UIControlEventTouchUpInside];
        [_detailFooterView addSubview:cancelButton];
        
        UIButton *payButton = [UIButton buttonWithType:UIButtonTypeCustom];
        payButton.frame = CGRectMake(btnWidth + 3 * middleSpace, 12, btnWidth, btnHeight);
        payButton.layer.cornerRadius = 4.f;
        payButton.layer.masksToBounds = YES;
        [payButton setBackgroundImage:kImageName(@"orange.png") forState:UIControlStateNormal];
        [payButton setTitle:@"付款" forState:UIControlStateNormal];
        payButton.titleLabel.font = [UIFont systemFontOfSize:16.f];
        [payButton addTarget:self action:@selector(payOrder:) forControlEvents:UIControlEventTouchUpInside];
        [_detailFooterView addSubview:payButton];
    }
    else if (status == OrderStatusSending) {
        UIButton *commentButton = [UIButton buttonWithType:UIButtonTypeCustom];
        commentButton.frame = CGRectMake(middleSpace, 12, kScreenWidth - 2 * middleSpace, btnHeight);
        commentButton.layer.cornerRadius = 4.f;
        commentButton.layer.masksToBounds = YES;
        [commentButton setBackgroundImage:kImageName(@"orange.png") forState:UIControlStateNormal];
        [commentButton setTitle:@"评价" forState:UIControlStateNormal];
        commentButton.titleLabel.font = [UIFont systemFontOfSize:16.f];
        [commentButton addTarget:self action:@selector(commentOrder:) forControlEvents:UIControlEventTouchUpInside];
        [_detailFooterView addSubview:commentButton];
    }
}

- (void)setLabel:(UILabel *)label withString:(NSString *)string {
    label.backgroundColor = [UIColor clearColor];
    label.font = [UIFont systemFontOfSize:13.f];
    label.text = string;
}

- (CGFloat)heightForString:(NSString *)string
                 withWidth:(CGFloat)width {
    NSDictionary *attr = [NSDictionary dictionaryWithObjectsAndKeys:
                          [UIFont systemFontOfSize:14.f],NSFontAttributeName,
                          nil];
    CGRect rect = [string boundingRectWithSize:CGSizeMake(width, CGFLOAT_MAX)
                                       options:NSStringDrawingUsesLineFragmentOrigin
                                    attributes:attr
                                       context:nil];
    return rect.size.height + 1 < 20.f ? 20.f : rect.size.height + 1;
}

#pragma mark - Request

- (void)downloadDetail {
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
    hud.labelText = @"加载中...";
    AppDelegate *delegate = [AppDelegate shareAppDelegate];
    [NetworkInterface getMyOrderDetailWithToken:delegate.token orderID:_orderID finished:^(BOOL success, NSData *response) {
        NSLog(@"%@",[[NSString alloc] initWithData:response encoding:NSUTF8StringEncoding]);
        hud.customView = [[UIImageView alloc] init];
        hud.mode = MBProgressHUDModeCustomView;
        [hud hide:YES afterDelay:0.5f];
        if (success) {
            id object = [NSJSONSerialization JSONObjectWithData:response options:NSJSONReadingMutableLeaves error:nil];
            if ([object isKindOfClass:[NSDictionary class]]) {
                NSString *errorCode = [NSString stringWithFormat:@"%@",[object objectForKey:@"code"]];
                if ([errorCode intValue] == RequestFail) {
                    //返回错误代码
                    hud.labelText = [NSString stringWithFormat:@"%@",[object objectForKey:@"message"]];
                }
                else if ([errorCode intValue] == RequestSuccess) {
                    [hud hide:YES];
                    [self parseOrderDetailDataWithDictionary:object];
                }
            }
            else {
                //返回错误数据
                hud.labelText = kServiceReturnWrong;
            }
        }
        else {
            hud.labelText = kNetworkFailed;
        }
    }];
}

//取消订单
- (void)cancelOrder {
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
    hud.labelText = @"加载中...";
    AppDelegate *delegate = [AppDelegate shareAppDelegate];
    [NetworkInterface cancelMyOrderWithToken:delegate.token orderID:_orderID finished:^(BOOL success, NSData *response) {
        NSLog(@"%@",[[NSString alloc] initWithData:response encoding:NSUTF8StringEncoding]);
        hud.customView = [[UIImageView alloc] init];
        hud.mode = MBProgressHUDModeCustomView;
        [hud hide:YES afterDelay:0.5f];
        if (success) {
            id object = [NSJSONSerialization JSONObjectWithData:response options:NSJSONReadingMutableLeaves error:nil];
            if ([object isKindOfClass:[NSDictionary class]]) {
                NSString *errorCode = [NSString stringWithFormat:@"%@",[object objectForKey:@"code"]];
                if ([errorCode intValue] == RequestFail) {
                    //返回错误代码
                    hud.labelText = [NSString stringWithFormat:@"%@",[object objectForKey:@"message"]];
                }
                else if ([errorCode intValue] == RequestSuccess) {
                    [hud hide:YES];
                    hud.labelText = @"订单取消成功";
                    [[NSNotificationCenter defaultCenter] postNotificationName:RefreshMyOrderListNotification object:nil];
                    [self.navigationController popViewControllerAnimated:YES];
                }
            }
            else {
                //返回错误数据
                hud.labelText = kServiceReturnWrong;
            }
        }
        else {
            hud.labelText = kNetworkFailed;
        }
    }];
}

#pragma mark - Data

- (void)parseOrderDetailDataWithDictionary:(NSDictionary *)dict {
    if (![dict objectForKey:@"result"] || ![[dict objectForKey:@"result"] isKindOfClass:[NSArray class]]) {
        return;
    }
    id object = [dict objectForKey:@"result"];
    if ([object count] > 0) {
        id detailDict = [object objectAtIndex:0];
        if ([detailDict isKindOfClass:[NSDictionary class]]) {
            _orderDetail = [[OrderDetailModel alloc] initWithParseDictionary:detailDict];
            [self initAndLayoutUI];
        }
    }
}

#pragma mark - UITableView

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSInteger row = 0;
    switch (section) {
        case 0:
            row = 3;
            break;
        case 1:
            row = [_orderDetail.goodList count] + 2;
            break;
        default:
            break;
    }
    return row;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = nil;
    CGFloat originX = 20.f;
    switch (indexPath.section) {
        case 0: {
            switch (indexPath.row) {
                case 0: {
                    //80
                    cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
                    UIImageView *statusView = [[UIImageView alloc] initWithFrame:CGRectMake(originX, 10, 18, 18)];
                    statusView.image = kImageName(@"order.png");
                    [cell.contentView addSubview:statusView];
                    //状态
                    UILabel *statusLabel = [[UILabel alloc] initWithFrame:CGRectMake(originX + 30, 10, kScreenWidth - originX - 30, 20.f)];
                    statusLabel.backgroundColor = [UIColor clearColor];
                    statusLabel.font = [UIFont boldSystemFontOfSize:16.f];
                    statusLabel.text = [_orderDetail getStatusString];
                    [cell.contentView addSubview:statusLabel];
                    //实付
                    UILabel *payLabel = [[UILabel alloc] initWithFrame:CGRectMake(originX, 30, kScreenWidth - originX * 2, 20.f)];
                    [self setLabel:payLabel withString:[NSString stringWithFormat:@"实付金额（含配送费）：￥%.2f",_orderDetail.orderTotalPrice]];
                    [cell.contentView addSubview:payLabel];
                    //配送费
                    UILabel *deliveryLabel = [[UILabel alloc] initWithFrame:CGRectMake(originX, 50, kScreenWidth - originX * 2, 20.f)];
                    [self setLabel:deliveryLabel withString:[NSString stringWithFormat:@"配送费：￥%.2f",_orderDetail.orderDeliveryFee]];
                    [cell.contentView addSubview:deliveryLabel];
                }
                    break;
                case 1: {
                    //60
                    cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
                    //收件人
                    UILabel *receiverLabel = [[UILabel alloc] initWithFrame:CGRectMake(originX, 10, kScreenWidth - originX * 2, 20.f)];
                    [self setLabel:receiverLabel withString:[NSString stringWithFormat:@"收件人：%@  %@",_orderDetail.orderReceiver,_orderDetail.orderReceiverPhone]];
                    [cell.contentView addSubview:receiverLabel];
                    //地址
                    UILabel *addressLabel = [[UILabel alloc] initWithFrame:CGRectMake(originX, 30, kScreenWidth - originX * 2, 20.f)];
                    [self setLabel:addressLabel withString:[NSString stringWithFormat:@"收件地址：%@",_orderDetail.orderAddress]];
                    [cell.contentView addSubview:addressLabel];
                }
                    break;
                case 2: {
                    cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
                    //留言
                    NSString *comment = [NSString stringWithFormat:@"留言：%@",_orderDetail.orderComment];
                    CGFloat height = [self heightForString:comment withWidth:kScreenWidth - originX * 2];
                    UILabel *commentLabel = [[UILabel alloc] initWithFrame:CGRectMake(originX, 10, kScreenWidth - originX *2, height)];
                    commentLabel.numberOfLines = 0;
                    [self setLabel:commentLabel withString:comment];
                    [cell.contentView addSubview:commentLabel];
                    //发票
                    UILabel *invoceTypeLabel = [[UILabel alloc] initWithFrame:CGRectMake(originX, 10 + height, kScreenWidth - originX * 2, 20.f)];
                    [self setLabel:invoceTypeLabel withString:[NSString stringWithFormat:@"发票类型：%@",_orderDetail.orderInvoceType]];
                    [cell.contentView addSubview:invoceTypeLabel];
                    UILabel *invoceTitleLabel = [[UILabel alloc] initWithFrame:CGRectMake(originX, 30 + height, kScreenWidth - originX * 2, 20.f)];
                    [self setLabel:invoceTitleLabel withString:[NSString stringWithFormat:@"发票抬头：%@",_orderDetail.orderInvoceTitle]];
                    
                    [cell.contentView addSubview:invoceTitleLabel];
                }
                    break;
                default:
                    break;
            }
        }
            break;
        case 1: {
            if (indexPath.row == 0) {
                //80
                CGFloat btnWidth = 80.f;
                cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
                //订单
                UILabel *orderLabel = [[UILabel alloc] initWithFrame:CGRectMake(originX, 10, kScreenWidth - originX * 2 - btnWidth, 20)];
                orderLabel.backgroundColor = [UIColor clearColor];
                orderLabel.font = [UIFont systemFontOfSize:12.f];
                orderLabel.textColor = kColor(116, 116, 116, 1);
                orderLabel.text = [NSString stringWithFormat:@"订单编号：%@",_orderDetail.orderNumber];
                [cell.contentView addSubview:orderLabel];
                //支付方式
                UILabel *typeLabel = [[UILabel alloc] initWithFrame:CGRectMake(originX, 30, kScreenWidth - originX * 2 - btnWidth, 20.f)];
                typeLabel.backgroundColor = [UIColor clearColor];
                typeLabel.font = [UIFont systemFontOfSize:12.f];
                typeLabel.textColor = kColor(116, 116, 116, 1);
                typeLabel.text = [NSString stringWithFormat:@"支付方式：%@",_orderDetail.orderPayType];
                [cell.contentView addSubview:typeLabel];
                //订单日期
                UILabel *dateLabel = [[UILabel alloc] initWithFrame:CGRectMake(originX, 50, kScreenWidth - originX * 2 - btnWidth, 20)];
                dateLabel.backgroundColor = [UIColor clearColor];
                dateLabel.font = [UIFont systemFontOfSize:12.f];
                dateLabel.textColor = kColor(116, 116, 116, 1);
                dateLabel.text = [NSString stringWithFormat:@"订单日期：%@",_orderDetail.orderTime];
                [cell.contentView addSubview:dateLabel];
            }
            else if (indexPath.row == [_orderDetail.goodList count] + 1) {
                cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
                UILabel *totalLabel = [[UILabel alloc] initWithFrame:CGRectMake(originX, 10, kScreenWidth - originX * 2, 20)];
                totalLabel.backgroundColor = [UIColor clearColor];
                totalLabel.font = [UIFont systemFontOfSize:13.f];
                totalLabel.textAlignment = NSTextAlignmentRight;
                totalLabel.text = [NSString stringWithFormat:@"共计%@件商品 实付金额：￥%.2f",_orderDetail.orderTotalNumber,_orderDetail.orderTotalPrice];
                [cell.contentView addSubview:totalLabel];
            }
            else {
                static NSString *orderIdentifier = @"orderIdentifier";
                cell = [tableView dequeueReusableCellWithIdentifier:orderIdentifier];
                if (cell == nil) {
                    cell = [[OrderDetailCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:orderIdentifier];
                }
                OrderGoodModel *model = [_orderDetail.goodList objectAtIndex:indexPath.row - 1];
                [(OrderDetailCell *)cell setContentsWithData:model];
            }
        }
            break;
        default:
            break;
    }
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    CGFloat height = 0.f;
    switch (indexPath.section) {
        case 0: {
            switch (indexPath.row) {
                case 0:
                    height = 80.f;
                    break;
                case 1:
                    height = 60.f;
                    break;
                case 2: {
                    NSString *comment = [NSString stringWithFormat:@"留言：%@",_orderDetail.orderComment];
                    CGFloat commentHeight = [self heightForString:comment withWidth:kScreenWidth - 40];
                    height = commentHeight + 60;
                }
                    break;
                default:
                    break;
            }
        }
            break;
        case 1: {
            if (indexPath.row == 0) {
                height = 80.f;
            }
            else if (indexPath.row == [_orderDetail.goodList count] + 1) {
                height = 40.f;
            }
            else {
                height = kOrderDetailCellHeight;
            }
        }
            break;
        default:
            break;
    }
    return height;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (section == 0) {
        return 16.f;
    }
    else {
        return 5.f;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.001f;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

#pragma mark - Action

- (IBAction)cancelOrder:(id)sender {
    [self cancelOrder];
}

- (IBAction)payOrder:(id)sender {
    PayWayViewController *payWayC = [[PayWayViewController alloc] init];
    payWayC.totalPrice = _orderDetail.orderTotalPrice;
    payWayC.orderID = _orderID;
    [self.navigationController pushViewController:payWayC animated:YES];
}

- (IBAction)commentOrder:(id)sender {
    OrderCommentController *commentC = [[OrderCommentController alloc] init];
    commentC.orderID = _orderID;
    [self.navigationController pushViewController:commentC animated:YES];
}

@end
