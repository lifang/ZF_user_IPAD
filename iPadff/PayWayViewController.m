//
//  PayWayViewController.m
//  ZFUB
//
//  Created by 徐宝桥 on 15/3/9.
//  Copyright (c) 2015年 ___MyCompanyName___. All rights reserved.
//

#import "PayWayViewController.h"
#import "OrderDetailController.h"
#import "NetworkInterface.h"
#import "AlipayHelper.h"
#import "RepairDetailController.h"

#include <sys/socket.h> // Per msqr
#include <sys/sysctl.h>
#include <net/if.h>
#include <net/if_dl.h>
#import "UPPayPlugin.h"


#define KBtn_width        200
#define KBtn_height       80
#define KXOffSet          (self.view.frame.size.width - KBtn_width) / 2
#define KYOffSet          80
#define kCellHeight_Normal  50
#define kCellHeight_Manual  145

#define kVCTitle          @"商户测试"
#define kBtnFirstTitle    @"获取订单，开始测试"
#define kWaiting          @"正在获取TN,请稍后..."
#define kNote             @"提示"
#define kConfirm          @"确定"
#define kErrorNet         @"网络错误"
#define kResult           @"支付结果：%@"


@interface PayWayViewController ()<UIActionSheetDelegate>
{
  UIAlertView* _alertView;
}
@property (nonatomic, strong) NSString *payNumber;   //支付单号

@property (nonatomic, strong) UITableView *tableView;

@property(nonatomic, copy)NSString *tnMode;//环境

@end

@implementation PayWayViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor=[UIColor whiteColor];
    NSDictionary *attributes = [NSDictionary dictionaryWithObjectsAndKeys:[UIColor whiteColor],NSForegroundColorAttributeName,[UIFont boldSystemFontOfSize:22],NSFontAttributeName, nil];
    [self.navigationController.navigationBar setTitleTextAttributes:attributes];
    self.title = @"选择支付方式";
    NSLog(@"!!!!!!!!!!%@~~~~~~~~~~~~~%f",_orderID,_totalPrice);
    if (_fromType == PayWayFromCS) {
        [self getRepairInfo];
    }
    else {
        [self getOrderInfo];
    }

   [self setHeaderAndFooterView];
    UIBarButtonItem *spaceItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace
                                                                               target:nil
                                                                               action:nil];
    spaceItem.width = 52;
    UIImage *image=[UIImage imageNamed:@"back_btn_white"];
    
    UIButton *btn=[UIButton buttonWithType:UIButtonTypeCustom];
    
    btn.frame=CGRectMake(0, 0, 25, 40);
    
    [btn setImage :image forState:UIControlStateNormal];
    
    [btn addTarget:self action:@selector(popself) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem *backItem = [[UIBarButtonItem alloc] initWithCustomView:btn];
    
    self.navigationItem.leftBarButtonItems = [NSArray arrayWithObjects:spaceItem,backItem,spaceItem,nil];
    
    // Do any additional setup after loading the view.
}
-(void)popself

{
    
    UIActionSheet *sheet = [[UIActionSheet alloc] initWithTitle:@"放弃付款？"
                                                       delegate:self
                                              cancelButtonTitle:@"取消"
                                         destructiveButtonTitle:@"确定"
                                              otherButtonTitles:nil];
    [sheet showInView:self.view];
    
}


- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (buttonIndex != actionSheet.cancelButtonIndex) {
        if (_fromType == PayWayFromCS) {
            [self showRepairDetail];
        }
        else {
            [self showDetail];
        }
    }

}




- (void)getOrderInfo {
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
    hud.labelText = @"加载中...";
    [NetworkInterface orderConfirmWithOrderID:_orderID finished:^(BOOL success, NSData *response) {
        NSLog(@"%@",[[NSString alloc] initWithData:response encoding:NSUTF8StringEncoding]);
        hud.customView = [[UIImageView alloc] init];
        hud.mode = MBProgressHUDModeCustomView;
        [hud hide:YES afterDelay:0.5f];
        if (success) {
            id object = [NSJSONSerialization JSONObjectWithData:response options:NSJSONReadingMutableLeaves error:nil];
            if ([object isKindOfClass:[NSDictionary class]]) {
                NSString *errorCode = [object objectForKey:@"code"];
                if ([errorCode intValue] == RequestFail) {
                    //返回错误代码
                    hud.labelText = [NSString stringWithFormat:@"%@",[object objectForKey:@"message"]];
                }
                else if ([errorCode intValue] == RequestSuccess) {
                    [hud hide:YES];
                    [self parseOrderDataWithDictionary:object];
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

- (void)getRepairInfo {
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
    hud.labelText = @"加载中...";
    [NetworkInterface repairConfirmWithRepairID:_orderID finished:^(BOOL success, NSData *response) {
        NSLog(@"%@",[[NSString alloc] initWithData:response encoding:NSUTF8StringEncoding]);
        hud.customView = [[UIImageView alloc] init];
        hud.mode = MBProgressHUDModeCustomView;
        [hud hide:YES afterDelay:0.5f];
        if (success) {
            id object = [NSJSONSerialization JSONObjectWithData:response options:NSJSONReadingMutableLeaves error:nil];
            if ([object isKindOfClass:[NSDictionary class]]) {
                NSString *errorCode = [object objectForKey:@"code"];
                if ([errorCode intValue] == RequestFail) {
                    //返回错误代码
                    hud.labelText = [NSString stringWithFormat:@"%@",[object objectForKey:@"message"]];
                }
                else if ([errorCode intValue] == RequestSuccess) {
                    [hud hide:YES];
                    [self parseRepairDataWithDictionary:object];
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

#pragma mark - Pay

- (void)payWithAlipay {
    //支付宝
    if (_payNumber) {
   
        BOOL isOrderPay = YES;
        if (_fromType == PayWayFromCS) {
            isOrderPay = NO;
        }
            [AlipayHelper alipayWithOrderNumber:_payNumber goodName:_goodName totalPrice:_totalPrice isOrderPay:isOrderPay payResult:^(NSDictionary *resultDict) {

            int resultCode = [[resultDict objectForKey:@"resultStatus"] intValue];
            NSString *tipString = @"";
            if (resultCode == 9000) {
                tipString = @"订单支付成功";
                if (_fromType == PayWayFromCS) {
                    [[NSNotificationCenter defaultCenter] postNotificationName:RefreshCSListNotification object:nil];
                    [self performSelector:@selector(showRepairDetail) withObject:nil afterDelay:0.5];

                }
                else {
                    [[NSNotificationCenter defaultCenter] postNotificationName:RefreshMyOrderListNotification object:nil];
                    [self performSelector:@selector(showDetail) withObject:nil afterDelay:0.5];

                }
            }
            else {
                if (resultCode == 8000) {
                    tipString = @"正在处理中";
                }
                else if (resultCode == 4000) {
                    tipString = @"订单支付失败";
                }
                else if (resultCode == 6001) {
                    tipString = @"用户中途取消";
                }
                else if (resultCode == 6002) {
                    tipString = @"网络连接出错";
                }
                MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
                hud.customView = [[UIImageView alloc] init];
                hud.mode = MBProgressHUDModeCustomView;
                [hud hide:YES afterDelay:1.f];
                hud.labelText = tipString;
            }
        }];
    }
    else {
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
        hud.customView = [[UIImageView alloc] init];
        hud.mode = MBProgressHUDModeCustomView;
        [hud hide:YES afterDelay:1.f];
        hud.labelText = @"获取订单号失败";
    }
}

#pragma mark - Data

- (void)parseOrderDataWithDictionary:(NSDictionary *)dict {
    if (![dict objectForKey:@"result"] || ![[dict objectForKey:@"result"] isKindOfClass:[NSDictionary class]]) {
        return;
    }
    id infoDict = [dict objectForKey:@"result"];
    if ([infoDict isKindOfClass:[NSDictionary class]]) {
        _totalPrice = [[infoDict objectForKey:@"total_price"] floatValue] / 100;
        _payNumber = [infoDict objectForKey:@"order_number"];
    }
    priceLabel.text = [NSString stringWithFormat:@"￥%.2f",_totalPrice];
}

- (void)parseRepairDataWithDictionary:(NSDictionary *)dict {
    if (![dict objectForKey:@"result"] || ![[dict objectForKey:@"result"] isKindOfClass:[NSDictionary class]]) {
        return;
    }
    id infoDict = [dict objectForKey:@"result"];
    if ([infoDict isKindOfClass:[NSDictionary class]]) {
        _totalPrice = [[infoDict objectForKey:@"repair_price"] floatValue] / 100;
        _payNumber = [infoDict objectForKey:@"apply_num"];
    }
    priceLabel.text = [NSString stringWithFormat:@"￥%.2f",_totalPrice];

}








#pragma mark - 跳转详情
- (void)showDetail {
    OrderDetailController *detailC = [[OrderDetailController alloc] init];
    detailC.fromType = _fromType;
    detailC.orderID = _orderID;
    detailC.goodName = _goodName;
    detailC.ordertype=self.ordertype;
    
    detailC.hidesBottomBarWhenPushed=YES;
    
    [self.navigationController pushViewController:detailC animated:YES];
}
- (void)showRepairDetail {
    RepairDetailController *detailC = [[RepairDetailController alloc] init];
    detailC.csID = _orderID;
    detailC.csType = CSTypeRepair;
    detailC.fromType = _fromType;
    detailC.goodName = @"维修费";
    detailC.hidesBottomBarWhenPushed=YES;

    [self.navigationController pushViewController:detailC animated:YES];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UI

- (void)setHeaderAndFooterView {
    CGFloat hearderHeight = 160.f;
    CGFloat blackViewHeight = 130.f;
    UIView *headerView = [[UIView alloc] init];
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
    


      headerView.frame=CGRectMake(0, 0, wide, hearderHeight+20);
        
    

//    headerView.backgroundColor = kColor(244, 243, 243, 1);
    [self.view addSubview:headerView];
    
    UIView *blackView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, wide, blackViewHeight+20)];
    blackView.backgroundColor = kColor(33, 32, 42, 1);
    [headerView addSubview:blackView];
    
    CGFloat topSpace = 20.f;
    CGFloat leftSpace = 20.f;
    CGFloat rightSpace = 20.f;
    UILabel *infoLabel = [[UILabel alloc] initWithFrame:CGRectMake(leftSpace, topSpace, wide - leftSpace - rightSpace, 20.f)];
    infoLabel.backgroundColor = [UIColor clearColor];
    infoLabel.textColor = [UIColor whiteColor];
    infoLabel.font = [UIFont systemFontOfSize:14.f];
    infoLabel.text = @"付款金额";
    [blackView addSubview:infoLabel];
    //金额
     priceLabel = [[UILabel alloc] initWithFrame:CGRectMake(leftSpace, 60, wide - leftSpace - rightSpace, 60.f)];
    priceLabel.backgroundColor = [UIColor clearColor];
    priceLabel.textColor = [UIColor whiteColor];
    priceLabel.font = [UIFont boldSystemFontOfSize:48.f];
    priceLabel.adjustsFontSizeToFitWidth = YES;
    [blackView addSubview:priceLabel];
    
    UILabel *typeLabel = [[UILabel alloc] initWithFrame:CGRectMake(leftSpace, hearderHeight +40, wide - leftSpace - rightSpace, 20.f)];
    typeLabel.backgroundColor = [UIColor clearColor];
    typeLabel.textColor = kColor(150, 150, 150, 1);
    typeLabel.font = [UIFont systemFontOfSize:14.f];
    typeLabel.text = @"选择支付方式";
    [self.view addSubview:typeLabel];
    
    
    
    UIButton *zhifubao = [[UIButton alloc]init];
   
    [zhifubao addTarget:self action:@selector(zhifubaoclick) forControlEvents:UIControlEventTouchUpInside];
    zhifubao.backgroundColor = [UIColor clearColor];
    [zhifubao setBackgroundImage:[UIImage imageNamed:@"zhifubao"] forState:UIControlStateNormal];
    zhifubao.frame = CGRectMake(0,0,400,122);
    zhifubao.center=CGPointMake(wide/4, hearderHeight +60+100);
    
    [self.view addSubview:zhifubao];
    UIButton *yinlianbutton = [[UIButton alloc]init];
    
    [yinlianbutton addTarget:self action:@selector(yinlianclick) forControlEvents:UIControlEventTouchUpInside];
    yinlianbutton.backgroundColor = [UIColor clearColor];
    [yinlianbutton setBackgroundImage:[UIImage imageNamed:@"yinlian"] forState:UIControlStateNormal];
    yinlianbutton.frame = CGRectMake(0,0,400,122);
    yinlianbutton.center=CGPointMake(wide/4*3, hearderHeight +60+100);
    
    [self.view addSubview:yinlianbutton];

}
-(void)zhifubaoclick
{

    [self payWithAlipay];

}

-(void)yinlianclick
{
    _tnMode = kMode_Production;
    [self startUnionPayRequest];
    
}

#pragma mark - Alert

- (void)showAlertWait
{
    [self hideAlert];
    _alertView = [[UIAlertView alloc] initWithTitle:kWaiting message:nil delegate:self cancelButtonTitle:nil otherButtonTitles: nil];
    [_alertView show];
    UIActivityIndicatorView* aiv = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
    aiv.center = CGPointMake(_alertView.frame.size.width / 2.0f - 15, _alertView.frame.size.height / 2.0f + 10 );
    [aiv startAnimating];
    [_alertView addSubview:aiv];
    
}


- (void)showAlertMessage:(NSString*)msg
{
    [self hideAlert];
    _alertView = [[UIAlertView alloc] initWithTitle:kNote message:msg delegate:self cancelButtonTitle:kConfirm otherButtonTitles:nil, nil];
    [_alertView show];
    
}

- (void)hideAlert
{
    if (_alertView != nil)
    {
        [_alertView dismissWithClickedButtonIndex:0 animated:NO];
        _alertView = nil;
    }
}


#pragma mark UPPayPluginResult
- (void)UPPayPluginResult:(NSString *)result
{
    //NSString* msg = [NSString stringWithFormat:kResult, result];
    //[self showAlertMessage:msg];
    if ([result isEqualToString:@"success"]) {
        [self UnionPaySucess];
    }
    if ([result isEqualToString:@"fail"]) {
        [self showAlertMessage:@"支付失败"];
    }
    if ([result isEqualToString:@"cancel"]) {
        [self showAlertMessage:@"取消支付"];
    }
}



-(void)startUnionPayRequest
{
    [self showAlertWait];
    
    NSURL *URL=[NSURL URLWithString:[NSString stringWithFormat:kUnionPayURL]];
    
    NSString *Price=[NSString stringWithFormat:@"%.0f", _totalPrice*100];
    NSString *str = [NSString stringWithFormat:@"frontOrBack=back&orderId=%@&txnAmt=%@&wap=wap&txnType=01&android=android", _payNumber,Price];
    //设置参数
    NSData *postData = [str dataUsingEncoding:NSUTF8StringEncoding];
    
    NSMutableURLRequest *request=[NSMutableURLRequest requestWithURL:URL];
    [request setHTTPMethod:@"POST"];
    [request setHTTPBody:postData];
    
    
    NSOperationQueue *queue=[NSOperationQueue mainQueue];
    [NSURLConnection sendAsynchronousRequest:request queue:queue completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
        //解析data
        if (data) {//请求成功
            [self hideAlert];
            NSDictionary *dict=[NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:nil];
            NSLog(@"dict:%@",dict);
            
            NSString *error=dict[@"error"];
            if (error) {
                [self showAlertMessage:kErrorNet];
            }else
            {
                NSString* tn = [[NSMutableString alloc] initWithData:data encoding:NSUTF8StringEncoding];
                if (tn != nil && tn.length > 0)
                {
                    NSLog(@"tn=%@",tn);
                    [UPPayPlugin startPay:tn mode:_tnMode viewController:self delegate:self];
                }
                
            }
        }else   //请求失败
        {
            [self showAlertMessage:kErrorNet];
        }
        
    }];
    
    
}


-(void)UnionPaySucess
{
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
    hud.customView = [[UIImageView alloc] init];
    hud.mode = MBProgressHUDModeCustomView;
    [hud hide:YES afterDelay:1.f];
    hud.labelText = @"订单支付成功";
    if (_fromType == PayWayFromCS) {
        
        [self performSelector:@selector(goRepairDetail) withObject:nil afterDelay:3];
        
    }
    else
    {
        [self performSelector:@selector(goDetail) withObject:nil afterDelay:3];
        
    }
    
}

-(void)goRepairDetail
{
    [[NSNotificationCenter defaultCenter] postNotificationName:RefreshCSListNotification object:nil];
    [self showRepairDetail];
    
}

-(void)goDetail
{
    [[NSNotificationCenter defaultCenter] postNotificationName:RefreshMyOrderListNotification object:nil];
    [self showDetail];
    
}



//- (void)initAndLauoutUI {
//    _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
//    _tableView.translatesAutoresizingMaskIntoConstraints = NO;
//    _tableView.backgroundColor = kColor(244, 243, 243, 1);
//    _tableView.delegate = self;
//    _tableView.dataSource = self;
//    [self setHeaderAndFooterView];
//    [self.view addSubview:_tableView];
//    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:_tableView
//                                                          attribute:NSLayoutAttributeTop
//                                                          relatedBy:NSLayoutRelationEqual
//                                                             toItem:self.view
//                                                          attribute:NSLayoutAttributeTop
//                                                         multiplier:1.0
//                                                           constant:0]];
//    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:_tableView
//                                                          attribute:NSLayoutAttributeLeft
//                                                          relatedBy:NSLayoutRelationEqual
//                                                             toItem:self.view
//                                                          attribute:NSLayoutAttributeLeft
//                                                         multiplier:1.0
//                                                           constant:0]];
//    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:_tableView
//                                                          attribute:NSLayoutAttributeRight
//                                                          relatedBy:NSLayoutRelationEqual
//                                                             toItem:self.view
//                                                          attribute:NSLayoutAttributeRight
//                                                         multiplier:1.0
//                                                           constant:0]];
//    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:_tableView
//                                                          attribute:NSLayoutAttributeBottom
//                                                          relatedBy:NSLayoutRelationEqual
//                                                             toItem:self.view
//                                                          attribute:NSLayoutAttributeBottom
//                                                         multiplier:1.0
//                                                           constant:0]];
//}
//
//#pragma mark - UITableView
//
//- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
//    return 2;
//}
//
//- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
//    return 1;
//}
//
//- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
//    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
//    NSString *title = nil;
//    switch (indexPath.section) {
//        case 0:
//            title = @"支付宝";
//            break;
//        case 1:
//            title = @"银联";
//            break;
//        default:
//            break;
//    }
//    cell.textLabel.text = title;
//    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
//    return cell;
//}
//
//- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
//    return 0.001f;
//}
//
//- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
//    return 5.f;
//}

@end
