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
#import "ReviewModel.h"
#import "OrderCommentCell.h"
#import "MyOrderViewController.h"
#import "GoodListViewController.h"
#import "ShoppingCartController.h"
@interface OrderDetailController ()<UITableViewDataSource,UITableViewDelegate,OrderCommentDelegate,UIAlertViewDelegate>

@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, strong) OrderDetailModel *orderDetail;
@property (nonatomic, strong) UITableView *tableViewPJ;
@property (nonatomic, strong) UITextView *editingView;

@property (nonatomic, strong) UITextField *tempField;
@property (nonatomic, strong) UIView *detailFooterView;

@end

@implementation OrderDetailController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.navigationController.navigationBar setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIColor whiteColor], NSForegroundColorAttributeName, NavTitle_FONT(NavTitle_FONTSIZE),NSFontAttributeName,nil]];
    [[UINavigationBar appearance] setBarTintColor:kColor(233, 91, 38, 1)];

    // Do any additional setup after loading the view.
    
    if(self.ordertype==1)
    {
        
        self.title = @"订单详情";

    }else
    {
        self.title = @"租赁订单详情";

        
    }

    self.view.backgroundColor = [UIColor whiteColor];
    [self downloadDetail];
    UIBarButtonItem *spaceItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace
                                                                               target:nil
                                                                               action:nil];
    spaceItem.width = 52;
    UIImage *image=[UIImage imageNamed:@"back_btn_white"];
    
    UIButton *btn=[UIButton buttonWithType:UIButtonTypeCustom];
    
    btn.frame=CGRectMake(0, 0, 25, 40);
    
    [btn setImage :image forState:UIControlStateNormal];
    
    [btn addTarget:self action:@selector(goPervious:) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem *backItem = [[UIBarButtonItem alloc] initWithCustomView:btn];
    
    self.navigationItem.leftBarButtonItems = [NSArray arrayWithObjects:spaceItem,backItem,spaceItem,nil];
}
- (IBAction)goPervious:(id)sender {
    if (_fromType == PayWayFromNone) {
        [self.navigationController popViewControllerAnimated:YES];
    }
    else if (_fromType == PayWayFromOrder) {
        UIViewController *controller = nil;
        for (UIViewController *listC in self.navigationController.childViewControllers) {
            if ([listC isMemberOfClass:[MyOrderViewController class]]) {
                controller = listC;
                break;
            }
        }
        if (controller) {
            [self.navigationController popToViewController:controller animated:YES];
        }
        else {
            [self.navigationController popToRootViewControllerAnimated:YES];
        }
    }
    else if (_fromType == PayWayFromGood) {
        UIViewController *controller = nil;
        for (UIViewController *listC in self.navigationController.childViewControllers) {
            if ([listC isMemberOfClass:[GoodListViewController class]]) {
                controller = listC;
                break;
            }
        }
        if (controller) {
            [self.navigationController popToViewController:controller animated:YES];
        }
        else {
            [self.navigationController popToRootViewControllerAnimated:YES];
        }
    }
    else if (_fromType == PayWayFromCart) {
        UIViewController *controller = nil;
        for (UIViewController *listC in self.navigationController.childViewControllers) {
            if ([listC isMemberOfClass:[ShoppingCartController class]]) {
                controller = listC;
                break;
            }
        }
        if (controller) {
            [self.navigationController popToViewController:controller animated:YES];
        }
        else {
            [self.navigationController popToRootViewControllerAnimated:YES];
        }
    }
    else if (_fromType == PayWayFromCS) {
        
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UI

- (void)setHeaderAndFooterView {
    
    CGFloat wide;
    CGFloat height;
    if(iOS7)
    {
        wide=SCREEN_HEIGHT;
        height=SCREEN_WIDTH;
        
        
    }
    else
    {  wide=SCREEN_WIDTH;
        height=SCREEN_HEIGHT;
        
    }

    //追踪记录
    if ([_orderDetail.recordList count] > 0) {
        CGFloat leftSpace = 20.f;
        UILabel *tipLabel = [[UILabel alloc] initWithFrame:CGRectMake(leftSpace, 10, wide - leftSpace * 2 , 24)];
        tipLabel.backgroundColor = [UIColor clearColor];
        tipLabel.font = [UIFont systemFontOfSize:15.f];
        tipLabel.text = @"追踪记录：";
        RecordView *recordView = [[RecordView alloc] initWithRecords:_orderDetail.recordList
                                                               width:(wide - leftSpace * 2)];
        CGFloat recordHeight = [recordView getHeight];
        recordView.frame = CGRectMake(leftSpace, 34, wide - leftSpace * 2, recordHeight);
        
        UIView *footerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, wide, recordHeight + 40)];
        footerView.backgroundColor = [UIColor clearColor];
        [footerView addSubview:tipLabel];
        [footerView addSubview:recordView];
        _tableView.tableFooterView = footerView;
        [recordView initAndLayoutUI];
    }
}

- (void)initAndLayoutUI {
    
    LLgoodList = [[NSMutableArray alloc] init];

    
    
    for (OrderGoodModel *model in _orderDetail.goodList) {
        ReviewModel *review = [[ReviewModel alloc] init];
        review.goodID = model.goodID;
        review.goodName = model.goodName;
        review.goodBrand = model.goodBrand;
        review.goodPicture = model.goodPicture;
        review.goodChannel = model.goodChannel;
        review.score = 50;
        [LLgoodList addObject:review];
    }
    CGFloat footerHeight = 0.f;
    int status = [_orderDetail.orderStatus intValue];
    if (status == OrderStatusUnPaid || status == OrderStatusSending) {
        footerHeight = 60.f;
        //底部按钮
        _detailFooterView = [[UIView alloc] init];
//        _detailFooterView.translatesAutoresizingMaskIntoConstraints = NO;
//        _detailFooterView.backgroundColor = [UIColor whiteColor];
//        [self.view addSubview:_detailFooterView];
//        [self.view addConstraint:[NSLayoutConstraint constraintWithItem:_detailFooterView
//                                                              attribute:NSLayoutAttributeTop
//                                                              relatedBy:NSLayoutRelationEqual
//                                                                 toItem:self.view
//                                                              attribute:NSLayoutAttributeBottom
//                                                             multiplier:1.0
//                                                               constant:-footerHeight]];
//        [self.view addConstraint:[NSLayoutConstraint constraintWithItem:_detailFooterView
//                                                              attribute:NSLayoutAttributeLeft
//                                                              relatedBy:NSLayoutRelationEqual
//                                                                 toItem:self.view
//                                                              attribute:NSLayoutAttributeLeft
//                                                             multiplier:1.0
//                                                               constant:0]];
//        [self.view addConstraint:[NSLayoutConstraint constraintWithItem:_detailFooterView
//                                                              attribute:NSLayoutAttributeRight
//                                                              relatedBy:NSLayoutRelationEqual
//                                                                 toItem:self.view
//                                                              attribute:NSLayoutAttributeRight
//                                                             multiplier:1.0
//                                                               constant:0]];
//        [self.view addConstraint:[NSLayoutConstraint constraintWithItem:_detailFooterView
//                                                              attribute:NSLayoutAttributeBottom
//                                                              relatedBy:NSLayoutRelationEqual
//                                                                 toItem:self.view
//                                                              attribute:NSLayoutAttributeBottom
//                                                             multiplier:1.0
//                                                               constant:0]];
        [self footerViewAddSubview];

    }
    
    _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
    _tableView.translatesAutoresizingMaskIntoConstraints = NO;
    _tableView.backgroundColor = [UIColor whiteColor];
    _tableView.delegate = self;
    _tableView.dataSource = self;
//    [self setHeaderAndFooterView];
    [self.view addSubview:_tableView];
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;

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
                                                           constant:0]];
}

- (void)footerViewAddSubview {
//    UIView *line = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 0.5)];
//    line.backgroundColor = kColor(135, 135, 135, 1);
//    [_detailFooterView addSubview:line];
//    CGFloat middleSpace = 10.f;
//    CGFloat btnWidth = (kScreenWidth - 4 * middleSpace) / 2;
//    CGFloat btnHeight = 36.f;
//    int status = [_orderDetail.orderStatus intValue];
//    if (status == OrderStatusUnPaid) {
//        UIButton *cancelButton = [UIButton buttonWithType:UIButtonTypeCustom];
//        cancelButton.frame = CGRectMake(middleSpace, 12, btnWidth, btnHeight);
////        cancelButton.layer.cornerRadius = 4.f;
//        cancelButton.layer.masksToBounds = YES;
//        cancelButton.layer.borderWidth = 1.f;
//        cancelButton.layer.borderColor = kColor(255, 102, 36, 1).CGColor;
//        [cancelButton setTitleColor:kColor(255, 102, 36, 1) forState:UIControlStateNormal];
//        [cancelButton setTitleColor:kColor(134, 56, 0, 1) forState:UIControlStateHighlighted];
//        [cancelButton setTitle:@"取消订单" forState:UIControlStateNormal];
//        cancelButton.titleLabel.font = [UIFont systemFontOfSize:16.f];
//        [cancelButton addTarget:self action:@selector(cancelOrder:) forControlEvents:UIControlEventTouchUpInside];
//        [_detailFooterView addSubview:cancelButton];
//        
//        UIButton *payButton = [UIButton buttonWithType:UIButtonTypeCustom];
//        payButton.frame = CGRectMake(btnWidth + 3 * middleSpace, 12, btnWidth, btnHeight);
////        payButton.layer.cornerRadius = 4.f;
//        payButton.layer.masksToBounds = YES;
//        [payButton setBackgroundImage:kImageName(@"orange.png") forState:UIControlStateNormal];
//        [payButton setTitle:@"付款" forState:UIControlStateNormal];
//        payButton.titleLabel.font = [UIFont systemFontOfSize:16.f];
//        [payButton addTarget:self action:@selector(payOrder:) forControlEvents:UIControlEventTouchUpInside];
//        [_detailFooterView addSubview:payButton];
//    }
//    else if (status == OrderStatusSending) {
//        UIButton *commentButton = [UIButton buttonWithType:UIButtonTypeCustom];
//        commentButton.frame = CGRectMake(middleSpace, 12, kScreenWidth - 2 * middleSpace, btnHeight);
////        commentButton.layer.cornerRadius = 4.f;
//        commentButton.layer.masksToBounds = YES;
//        [commentButton setBackgroundImage:kImageName(@"orange.png") forState:UIControlStateNormal];
//        [commentButton setTitle:@"评价" forState:UIControlStateNormal];
//        commentButton.titleLabel.font = [UIFont systemFontOfSize:16.f];
//        [commentButton addTarget:self action:@selector(commentOrder:) forControlEvents:UIControlEventTouchUpInside];
//        [_detailFooterView addSubview:commentButton];
//    }
}

- (void)setLabel:(UILabel *)label withString:(NSString *)string {
    label.backgroundColor = [UIColor clearColor];
    label.font = [UIFont systemFontOfSize:16.f];
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
                    [self goPervious:nil];
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
-(void)createui
{
    CGFloat wide;
    CGFloat height;
    if(iOS7)
    {
        wide=SCREEN_HEIGHT;
        height=SCREEN_WIDTH;
        
        
    }
    else
    {  wide=SCREEN_WIDTH;
        height=SCREEN_HEIGHT;
        
    }
    
    bigsview=[[UIImageView alloc]initWithFrame:CGRectMake(0, 0, wide, height)];
    
    [self.view addSubview:bigsview];
    bigsview.image=[UIImage imageNamed:@"backimage"];
    bigsview.userInteractionEnabled=YES;
    
    
    UIView*witeview=[[UIView alloc]initWithFrame:CGRectMake(0, 0, wide/2, wide/2)];
    witeview.backgroundColor=[UIColor whiteColor];
    witeview.center=CGPointMake(wide/2, height/2-120);
    witeview.alpha=1;
    
    [bigsview addSubview:witeview];
    
    
    
    UIButton *okButton = [UIButton buttonWithType:UIButtonTypeCustom];
    okButton.frame = CGRectMake(  10, 10, 30, 30);
    [okButton setImage:kImageName(@"xx.png") forState:UIControlStateNormal];
    [okButton addTarget:self action:@selector(cancelclick) forControlEvents:UIControlEventTouchUpInside];
    [witeview addSubview:okButton];
    
    UILabel*newaddress=[[UILabel alloc]initWithFrame:CGRectMake(0, 10,wide/2, 30)];
    [witeview addSubview:newaddress];
    newaddress.textAlignment = NSTextAlignmentCenter;
    
    newaddress.text=@"评价";
    newaddress .font = [UIFont systemFontOfSize:20.f];
    
    UIView*lineview=[[UIView alloc]initWithFrame:CGRectMake(0, 50, wide/2, 1)];
    lineview.backgroundColor=[UIColor grayColor];
    
    [witeview addSubview:lineview];
    _tableViewPJ = [[UITableView alloc] initWithFrame:CGRectMake(0, 51, wide/2, wide/2) style:UITableViewStyleGrouped];
    _tableViewPJ.backgroundColor = kColor(244, 243, 243, 1);
    _tableViewPJ.delegate = self;
    _tableViewPJ.dataSource = self;
    [witeview addSubview:_tableViewPJ];
    
    _tempField = [[UITextField alloc] init];
    _tempField.hidden = YES;
    [witeview addSubview:_tempField];
    UIView *hearderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, wide/2, 0.001)];
    hearderView.backgroundColor = [UIColor clearColor];
    _tableViewPJ.tableHeaderView = hearderView;
    
    UIView *footerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, wide/2, 100)];
    footerView.backgroundColor = [UIColor clearColor];
    UIButton *submitBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    submitBtn.frame = CGRectMake(80, 20, wide/2 - 160, 40);
    submitBtn.layer.cornerRadius = 4;
    submitBtn.layer.masksToBounds = YES;
    submitBtn.titleLabel.font = [UIFont systemFontOfSize:16.f];
    [submitBtn setTitle:@"提交" forState:UIControlStateNormal];
    [submitBtn setBackgroundImage:[UIImage imageNamed:@"orange.png"] forState:UIControlStateNormal];
    [submitBtn addTarget:self action:@selector(submitComment:) forControlEvents:UIControlEventTouchUpInside];
    [footerView addSubview:submitBtn];
    _tableViewPJ.tableFooterView = footerView;


}
#pragma mark - UITextView

#pragma mark - UI




#pragma mark - Request

- (void)reviewForGoodsWithReviewList:(NSArray *)reviewList {
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
    hud.labelText = @"提交中...";
    AppDelegate *delegate = [AppDelegate shareAppDelegate];
    NSLog(@"%@",self.orderID);
    [NetworkInterface reviewMultiOrderWithToken:delegate.token orderID:self.orderID reviewList:reviewList  finished:^(BOOL success, NSData *response) {
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
                    [self downloadDetail];

                    hud.labelText = @"评论成功";
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

#pragma mark - Action

- (IBAction)submitComment:(id)sender {
     

    NSLog(@"%d",[_tempField.text length]);
    
    [_tempField becomeFirstResponder];
    [_tempField resignFirstResponder];
    AppDelegate *delegate = [AppDelegate shareAppDelegate];
    NSMutableArray *reviews = [[NSMutableArray alloc] init];
    for (ReviewModel *model in LLgoodList) {
        NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
        [dict setObject:[NSNumber numberWithInt:[delegate.userID intValue]] forKey:@"customer_id"];
        [dict setObject:[NSNumber numberWithInt:[model.goodID intValue]] forKey:@"good_id"];
        [dict setObject:[NSNumber numberWithInt:model.score] forKey:@"score"];
        if (model.review && ![model.review isEqualToString:@""]) {
            [dict setObject:model.review forKey:@"content"];
        }
        else {
            [dict setObject:@"默认好评" forKey:@"content"];
        }
        [reviews addObject:dict];
    }
    [self reviewForGoodsWithReviewList:reviews];
}

#pragma mark - UITableView





-(void)cancelclick
{
    
    
    [bigsview removeFromSuperview];
}
#pragma mark - UITableView

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {

if(tableView==_tableViewPJ)
{
    return [LLgoodList count];


}else
{

    return 2;

}
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    if(tableView==_tableViewPJ)
    {
    
        return 1;
        
    }else
    {
    
    
        if(section==0)
        {
            tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
            
            
        }
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

}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if(tableView==_tableViewPJ)
    {
        OrderCommentCell *cell = [[OrderCommentCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
        ReviewModel *model = [LLgoodList objectAtIndex:indexPath.section];
        cell.delegate = self;

        [cell setContentsWithData:model];
        
       
        return cell;
    
    }else
    {
    
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;

    
        CGFloat wide;
        CGFloat height;
        if(iOS7)
        {
            wide=SCREEN_HEIGHT;
            height=SCREEN_WIDTH;
            
            
        }
        else
        {  wide=SCREEN_WIDTH;
            height=SCREEN_HEIGHT;
            
        }
        
        UITableViewCell *cell = nil;
        CGFloat originX = 50.f;
        switch (indexPath.section) {
            case 0: {
                switch (indexPath.row) {
                    case 0: {
                        //80
                        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
                        UIImageView *statusView = [[UIImageView alloc] initWithFrame:CGRectMake(originX, 10, 18, 18)];
                        statusView.image = kImageName(@"order.png");
                        [cell.contentView addSubview:statusView];
                        cell.selectionStyle = UITableViewCellSelectionStyleNone;
                        
                        //状态
                        UILabel *statusLabel = [[UILabel alloc] initWithFrame:CGRectMake(originX , 10, wide - originX , 20.f)];
                        statusLabel.backgroundColor = [UIColor clearColor];
                        statusLabel.font = [UIFont boldSystemFontOfSize:16.f];
                        statusLabel.text = [NSString stringWithFormat:@"订单状态：%@",[_orderDetail getStatusString]];
                        [cell.contentView addSubview:statusLabel];
                        //实付
                        UILabel *payLabel = [[UILabel alloc] initWithFrame:CGRectMake(originX, 30, wide - originX * 2, 20.f)];
                        [self setLabel:payLabel withString:[NSString stringWithFormat:@"实付金额（含配送费）：￥%.2f",_orderDetail.orderTotalPrice]];
                        [cell.contentView addSubview:payLabel];
                        //配送费
                        UILabel *deliveryLabel = [[UILabel alloc] initWithFrame:CGRectMake(originX, 50, wide - originX * 2, 20.f)];
                        [self setLabel:deliveryLabel withString:[NSString stringWithFormat:@"配  送  费：￥%.2f",_orderDetail.orderDeliveryFee]];
                        [cell.contentView addSubview:deliveryLabel];
                        
                        
                        int status = [_orderDetail.orderStatus intValue];
                        if (status == OrderStatusUnPaid) {
                            CGFloat wide;
                            
                            if(iOS7)
                            {
                                wide=SCREEN_HEIGHT;
                                
                                
                            }
                            else
                            {  wide=SCREEN_WIDTH;
                                
                            }
                            
                            
                            UIButton *cancelButton = [UIButton buttonWithType:UIButtonTypeCustom];
                            cancelButton.frame = CGRectMake(wide-150, 12, 100, 40);
                            //        cancelButton.layer.cornerRadius = 4.f;
                            cancelButton.layer.masksToBounds = YES;
                            cancelButton.layer.borderWidth = 1.f;
                            cancelButton.layer.borderColor = kColor(255, 102, 36, 1).CGColor;
                            [cancelButton setTitleColor:kColor(255, 102, 36, 1) forState:UIControlStateNormal];
                            [cancelButton setTitleColor:kColor(134, 56, 0, 1) forState:UIControlStateHighlighted];
                            [cancelButton setTitle:@"取消订单" forState:UIControlStateNormal];
                            cancelButton.titleLabel.font = [UIFont systemFontOfSize:16.f];
                            [cancelButton addTarget:self action:@selector(cancelOrder:) forControlEvents:UIControlEventTouchUpInside];
                            [cell.contentView addSubview:cancelButton];
                            
                            UIButton *payButton = [UIButton buttonWithType:UIButtonTypeCustom];
                            payButton.frame = CGRectMake(wide-150-120, 12, 100, 40);
                            //        payButton.layer.cornerRadius = 4.f;
                            payButton.layer.masksToBounds = YES;
                            [payButton setBackgroundImage:kImageName(@"orange.png") forState:UIControlStateNormal];
                            [payButton setTitle:@"付款" forState:UIControlStateNormal];
                            payButton.titleLabel.font = [UIFont systemFontOfSize:16.f];
                            [payButton addTarget:self action:@selector(payOrder:) forControlEvents:UIControlEventTouchUpInside];
                            [cell.contentView addSubview:payButton];
                        }
                        else if (status == OrderStatusSending) {
                            CGFloat wide;
                            
                            if(iOS7)
                            {
                                wide=SCREEN_HEIGHT;
                                
                                
                            }
                            else
                            {  wide=SCREEN_WIDTH;
                                
                            }
                            
                            UIButton *commentButton = [UIButton buttonWithType:UIButtonTypeCustom];
                            commentButton.frame = CGRectMake(wide-150, 12, 100, 40);
                            //        commentButton.layer.cornerRadius = 4.f;
                            commentButton.layer.masksToBounds = YES;
                            [commentButton setBackgroundImage:kImageName(@"orange.png") forState:UIControlStateNormal];
                            [commentButton setTitle:@"评价" forState:UIControlStateNormal];
                            commentButton.titleLabel.font = [UIFont systemFontOfSize:16.f];
                            [commentButton addTarget:self action:@selector(commentOrder:) forControlEvents:UIControlEventTouchUpInside];
                            [cell.contentView addSubview:commentButton];
                        }
                        
                        
                        
                        
                        
                        
                    }
                        break;
                    case 1: {
                        //60
                        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
                        cell.selectionStyle = UITableViewCellSelectionStyleNone;
                        
                        //收件人
                        UILabel *receiverLabel = [[UILabel alloc] initWithFrame:CGRectMake(originX, 10, wide - originX * 2, 20.f)];
                        [self setLabel:receiverLabel withString:[NSString stringWithFormat:@"收  件  人：%@  %@",_orderDetail.orderReceiver,_orderDetail.orderReceiverPhone]];
                        [cell.contentView addSubview:receiverLabel];
                        //地址
                        UILabel *addressLabel = [[UILabel alloc] initWithFrame:CGRectMake(originX, 30, wide - originX * 2, 20.f)];
                        [self setLabel:addressLabel withString:[NSString stringWithFormat:@"收件地址：%@",_orderDetail.orderAddress]];
                        [cell.contentView addSubview:addressLabel];
                    }
                        break;
                    case 2: {
                        CGFloat wide;
                        if(iOS7)
                        {
                            wide=SCREEN_HEIGHT;
                            
                            
                        }
                        else
                        {  wide=SCREEN_WIDTH;
                            
                        }
                        
                        
                        CGFloat btnWidth = 80.f;
                        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
                        //订单
                        UILabel *orderLabel = [[UILabel alloc] initWithFrame:CGRectMake(originX, 10, wide - originX * 2 - btnWidth, 20)];
                        orderLabel.backgroundColor = [UIColor clearColor];
                        orderLabel.font = [UIFont systemFontOfSize:16.f];
                        //                    orderLabel.textColor = kColor(116, 116, 116, 1);
                        orderLabel.text = [NSString stringWithFormat:@"订单编号：%@",_orderDetail.orderNumber];
                        [cell.contentView addSubview:orderLabel];
                        //支付方式
                        UILabel *typeLabel = [[UILabel alloc] initWithFrame:CGRectMake(originX, 30, wide - originX * 2 - btnWidth, 20.f)];
                        typeLabel.backgroundColor = [UIColor clearColor];
                        typeLabel.font = [UIFont systemFontOfSize:16.f];
                        //                    typeLabel.textColor = kColor(116, 116, 116, 1);
                        if([_orderDetail.orderPayType  isEqualToString:@"1"])
                        {
                            typeLabel.text = [NSString stringWithFormat:@"支付方式 :支付宝"];
                            
                            
                        }
                        if([_orderDetail.orderPayType  isEqualToString:@"2"])
                        {
                            typeLabel.text = [NSString stringWithFormat:@"支付方式：银联"];
                            
                            
                        }
                        
                        if([_orderDetail.orderPayType  isEqualToString:@"3"])
                        {
                            typeLabel.text = [NSString stringWithFormat:@"支付方式：现金"];
                            
                            
                        }
                        

                        typeLabel.text = [NSString stringWithFormat:@"支付方式：%@",_orderDetail.orderPayType];
                        [cell.contentView addSubview:typeLabel];
                        //订单日期
                        UILabel *dateLabel = [[UILabel alloc] initWithFrame:CGRectMake(originX, 50, wide - originX * 2 - btnWidth, 20)];
                        dateLabel.backgroundColor = [UIColor clearColor];
                        dateLabel.font = [UIFont systemFontOfSize:16.f];
                        //                    dateLabel.textColor = kColor(116, 116, 116, 1);
                        dateLabel.text = [NSString stringWithFormat:@"订单日期：%@",_orderDetail.orderTime];
                        [cell.contentView addSubview:dateLabel];
                        
                        //留言
                        NSString *comment = [NSString stringWithFormat:@"留       言：%@",_orderDetail.orderComment];
                        CGFloat height = [self heightForString:comment withWidth:wide - originX * 2];
                        UILabel *commentLabel = [[UILabel alloc] initWithFrame:CGRectMake(wide/2, 10, wide - originX *2, height)];
                        commentLabel.numberOfLines = 0;
                        [self setLabel:commentLabel withString:comment];
                        [cell.contentView addSubview:commentLabel];
                   
                        //发票
                        UILabel *invoceTypeLabel = [[UILabel alloc] initWithFrame:CGRectMake(wide/2, 10 + height, wide - originX * 2, 20.f)];
                        [cell.contentView addSubview:invoceTypeLabel];
                        UILabel *invoceTitleLabel = [[UILabel alloc] initWithFrame:CGRectMake(wide/2, 30 + height, wide - originX * 2, 20.f)];
                        
                        if([self isBlankString:_orderDetail.orderInvoceType])
                        {
                            
                            
                            
                        }
                        else
                        {
                            [self setLabel:invoceTypeLabel withString:[NSString stringWithFormat:@"发票类型：%@",_orderDetail.orderInvoceType]];

                            [self setLabel:invoceTitleLabel withString:[NSString stringWithFormat:@"发票抬头：%@",_orderDetail.orderInvoceTitle]];

                            
                        }
                        cell.selectionStyle = UITableViewCellSelectionStyleNone;
                        
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
                    
                    
                    CGFloat wide;
                    CGFloat height;
                    if(iOS7)
                    {
                        wide=SCREEN_HEIGHT;
                        height=SCREEN_WIDTH;
                        
                        
                    }
                    else
                    {  wide=SCREEN_WIDTH;
                        height=SCREEN_HEIGHT;
                        
                    }
                    //80
//                    CGFloat btnWidth = 80.f;
                    cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
                    
                    
                    cell.selectionStyle = UITableViewCellSelectionStyleNone;
                    
                    
                    
                    
                    
                    UIView*rootview  = [[UIView alloc] initWithFrame:CGRectMake(50, 10, wide-100, 20)];
                    rootview.backgroundColor = kColor(235, 233, 233, 1);
                    [cell.contentView addSubview: rootview];
                    
                    
                    UILabel*goodslable=[[UILabel alloc]initWithFrame:CGRectMake(100, 0, 60, 20)];
                    [rootview addSubview:goodslable];
                    goodslable.textAlignment = NSTextAlignmentCenter;
                    goodslable.text=@"商品";

                    
                    UILabel*phonelable=[[UILabel alloc]initWithFrame:CGRectMake(wide/2-35, 0, 60, 20)];
                    [rootview addSubview:phonelable];
                    //                phonelable.textAlignment = NSTextAlignmentCenter;
                    UILabel*numberlable=[[UILabel alloc]initWithFrame:CGRectMake(wide-200, 0, 80, 20)];
                    [rootview addSubview:numberlable];
                    //                numberlable.textAlignment = NSTextAlignmentCenter;
                    
                    if(self.ordertype==1)
                    {
                        numberlable.text=@"购买数量";

                        phonelable.text=@"单价";

                    }else
                    {
                        phonelable.text=@"押金";
                        numberlable.text=@"租赁数量";

                        
                    }

                 
                }
                else if (indexPath.row == [_orderDetail.goodList count] + 1) {
                    cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
                    CGFloat wide;
                    CGFloat height;
                    if(iOS7)
                    {
                        wide=SCREEN_HEIGHT;
                        height=SCREEN_WIDTH;
                        
                        
                    }
                    else
                    {  wide=SCREEN_WIDTH;
                        height=SCREEN_HEIGHT;
                        
                    }
                    
                                        //80
                    cell.selectionStyle = UITableViewCellSelectionStyleNone;
                    
                    UILabel *totalLabel = [[UILabel alloc] initWithFrame:CGRectMake(originX, 10, wide - originX * 2, 20)];
                    totalLabel.backgroundColor = [UIColor clearColor];
                    totalLabel.font = [UIFont systemFontOfSize:16.f];
                    totalLabel.textAlignment = NSTextAlignmentRight;
                    totalLabel.text = [NSString stringWithFormat:@"共计%@件商品  实付金额：￥%.2f",_orderDetail.orderTotalNumber,_orderDetail.orderTotalPrice];
                    [cell.contentView addSubview:totalLabel];
                    
                    
                    int status = [_orderDetail.orderStatus intValue];
                    if (status == OrderStatusPaid || status == OrderStatusSending || status == OrderStatusReview) {
                        UIButton *terminalBtn = [UIButton buttonWithType:UIButtonTypeCustom];
                        terminalBtn.frame = CGRectMake(50, 5, 100, 30);
                        terminalBtn.layer.masksToBounds = YES;
                        terminalBtn.layer.borderWidth = 1.f;
                        terminalBtn.layer.borderColor = kColor(255, 102, 36, 1).CGColor;
                        [terminalBtn setTitleColor:kColor(255, 102, 36, 1) forState:UIControlStateNormal];
                        [terminalBtn setTitleColor:kColor(134, 56, 0, 1) forState:UIControlStateHighlighted];
                        terminalBtn.titleLabel.font = [UIFont boldSystemFontOfSize:14.f];
                        [terminalBtn setTitle:@"查看终端号" forState:UIControlStateNormal];
                        [terminalBtn addTarget:self action:@selector(scanTerminalNumber:) forControlEvents:UIControlEventTouchUpInside];
                        
                        [cell.contentView addSubview:terminalBtn];

                    }

                }
                else {
                    static NSString *orderIdentifier = @"orderIdentifier";
                    cell = [tableView dequeueReusableCellWithIdentifier:orderIdentifier];
                    if (cell == nil) {
                        cell = [[OrderDetailCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:orderIdentifier];
                    }
                    OrderGoodModel *model = [_orderDetail.goodList objectAtIndex:indexPath.row - 1];
                    [(OrderDetailCell *)cell setContentsWithData:model];
                    CGFloat wide;
                    CGFloat height;
                    if(iOS7)
                    {
                        wide=SCREEN_HEIGHT;
                        height=SCREEN_WIDTH;
                        
                        
                    }
                    else
                    {  wide=SCREEN_WIDTH;
                        height=SCREEN_HEIGHT;
                        
                    }
                   UILabel* linlable  = [[UILabel alloc] initWithFrame:CGRectMake(50, 89, wide-100, 1)];
                    
                    
                    linlable.backgroundColor=[UIColor colorWithWhite:0.7 alpha:1];
                    
                    
                    [cell.contentView addSubview:linlable];
                    
                    cell.selectionStyle = UITableViewCellSelectionStyleNone;
                    
//                    UILabel *totalLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 90, wide-40, 1)];
//                    totalLabel.backgroundColor = [UIColor colorWithWhite:0.8 alpha:0.5];
//                    
//                    [cell.contentView addSubview:totalLabel];
                }
            }
                break;
            default:
                break;
        }
        return cell;
    
    }
    
  
}
- (IBAction)scanTerminalNumber:(id)sender
{
    NSLog(@"%@",_orderDetail.terminals);
    
if([self isBlankString:_orderDetail.terminals])
{

_orderDetail.terminals=@"暂无终端号";
    


}
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"终端号"
                                                    message:_orderDetail.terminals
                                                   delegate:self
                                          cancelButtonTitle:@"确定"
                                          otherButtonTitles:nil];
    alert.tag=102;
    
    [alert show];
}

- (BOOL) isBlankString:(NSString *)string {
    if (string == nil || string == NULL) {
        return YES;
    }
    if ([string isKindOfClass:[NSNull class]]) {
        return YES;
    }
    if ([[string stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]] length]==0) {
        return YES;
    }
    return NO;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if(tableView==_tableViewPJ)
    {
        return 230;
        
    }else
    {
    
        CGFloat height = 0.f;
        
        CGFloat wide;
        if(iOS7)
        {
            wide=SCREEN_HEIGHT;
            
            
        }
        else
        {  wide=SCREEN_WIDTH;
            
        }
        
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
                        CGFloat commentHeight = [self heightForString:comment withWidth:wide - 40];
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
                    height = 40.f;
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
    }



- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    
    if(tableView==_tableViewPJ)
    {
        return 0.001f;

    
    }else
    {
        if (section == 0) {
            return 1.f;
        }
        else {
            return 2.f;
        }
    
    }
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    
    if(tableView==_tableViewPJ)
    {
        return 0.001f;

        
    }else
    {
        return 0.001f;
  
        
    }
}



#pragma mark - Action

- (IBAction)cancelOrder:(id)sender {
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示信息"
                                                    message:@"确定取消此订单？"
                                                   delegate:self
                                          cancelButtonTitle:@"取消"
                                          otherButtonTitles:@"确定", nil];
    [alert show];
    alert.tag=1028;
    
}
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    
    if(alertView.tag==1028)
    {
        if (buttonIndex != alertView.cancelButtonIndex) {
            [self cancelOrder];
        }
    
    }
    
}

- (IBAction)payOrder:(id)sender {
    PayWayViewController *payWayC = [[PayWayViewController alloc] init];
    payWayC.totalPrice = _orderDetail.orderTotalPrice;
    payWayC.orderID = _orderID;
    payWayC.ordertype=self.ordertype;
    
    payWayC.goodName = _goodName;
    if (_fromType == PayWayFromNone) {
        payWayC.fromType = PayWayFromOrder;
    }
    else {
        payWayC.fromType = _fromType;
    }

    payWayC.hidesBottomBarWhenPushed =  YES ;


    [self.navigationController pushViewController:payWayC animated:YES];
}

- (IBAction)commentOrder:(id)sender {
    [self createui];
    
}
#pragma mark - OrderCommentDelegate

- (void)commentViewWillEdit:(UITextView *)textView {
    self.editingView = textView;
}

- (void)commentViewEndEdit {
    self.editingView = nil;
}

@end
