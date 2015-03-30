//
//  MyOrderViewController.m
//  iPadff
//
//  Created by 黄含章 on 15/3/11.
//  Copyright (c) 2015年 LanTaiPro. All rights reserved.
//

#import "MyOrderViewController.h"
#import "KxMenu.h"
#import "RefreshView.h"
#import "NetworkInterface.h"
#import "AppDelegate.h"
#import "OrderCell.h"
#import "OrderDetailController.h"
#import "PayWayViewController.h"
#import "OrderCommentController.h"
#import "LoginViewController.h"
#import "AccountTool.h"

@interface MyOrderViewController ()<UITableViewDelegate,UITableViewDataSource,RefreshDelegate,OrderCellDelegate,UIAlertViewDelegate,LoginSuccessDelegate>

@property (nonatomic, assign) OrderType currentType;

@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, strong) UIButton *statusButton;

@property (nonatomic, strong) UILabel *statusLabel;

/***************上下拉刷新**********/
@property (nonatomic, strong) RefreshView *topRefreshView;
@property (nonatomic, strong) RefreshView *bottomRefreshView;

@property (nonatomic, assign) BOOL reloading;
@property (nonatomic, assign) CGFloat primaryOffsetY;
@property (nonatomic, assign) int page;
/**********************************/

//订单信息
@property (nonatomic, strong) NSMutableArray *orderItems;

//保存进行操作的cell对应的数据
@property (nonatomic, strong) OrderModel *selectedModel;

@end

@implementation MyOrderViewController

-(void)ShowLoginVC
{
    AppDelegate *delegate = [AppDelegate shareAppDelegate];
    AccountModel *account = [AccountTool userModel];
    NSLog(@"%@",account);
    if (account.password) {
        [self initAndLayoutUI];
        [self firstLoadData];
    }
    if (delegate.haveExit) {
        NSLog(@"已退出！");
        [self firstLoadData];
        LoginViewController *loginC = [[LoginViewController alloc]init];
        loginC.LoginSuccessDelegate = self;
        loginC.view.frame = CGRectMake(0, 0, 320, 320);
        UINavigationController *nav = [[UINavigationController alloc]initWithRootViewController:loginC];
        nav.navigationBarHidden = YES;
        nav.modalPresentationStyle = UIModalPresentationCustom;
        nav.modalTransitionStyle = UIModalTransitionStyleCoverVertical;
        [self presentViewController:nav animated:YES completion:nil];
    }
    else if(account.password == nil)
    {
        LoginViewController *loginC = [[LoginViewController alloc]init];
        loginC.LoginSuccessDelegate = self;
        loginC.view.frame = CGRectMake(0, 0, 320, 320);
        UINavigationController *nav = [[UINavigationController alloc]initWithRootViewController:loginC];
        nav.navigationBarHidden = YES;
        nav.modalPresentationStyle = UIModalPresentationCustom;
        nav.modalTransitionStyle = UIModalTransitionStyleCoverVertical;
        [self presentViewController:nav animated:YES completion:nil];
    }
}

-(void)LoginSuccess
{
    [self initAndLayoutUI];
    [self firstLoadData];
}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [self ShowLoginVC];
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setLeftViewWith:ChooseViewMyOrder];
    
    // Do any additional setup after loading the view.
    self.title = @"我的订单";

    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(okaddress) name:@"okaddress" object:nil];

    _orderItems = [[NSMutableArray alloc] init];
    
    self.currentType = OrderTypeAll;

    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshOrderList:) name:RefreshMyOrderListNotification object:nil];
}

-(void)okaddress
{
    
//    [self setLeftViewWith:3];
    
    
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
        wide=SCREEN_HEIGHT-160;
        height=SCREEN_WIDTH;
        
        
    }
    else
    {  wide=SCREEN_WIDTH-160;
        height=SCREEN_HEIGHT;
        
    }

    
    UIView *headerViews = [[UIView alloc] initWithFrame:CGRectMake(160, 0, wide, 70)];
    headerViews.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:headerViews];
    
    UIView *headerViewsg = [[UIView alloc] initWithFrame:CGRectMake(20, 70, wide-100, 1)];
    headerViewsg.backgroundColor = [UIColor grayColor];
    [headerViews addSubview:headerViewsg];

    

   
    
    _statusButton = [UIButton buttonWithType:UIButtonTypeCustom];
    _statusButton.frame = CGRectMake(10, 20, 110, 30);
    _statusButton.titleLabel.font = [UIFont systemFontOfSize:23.f];
    [_statusButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [_statusButton setTitle:@"我的订单" forState:UIControlStateNormal];
    [_statusButton setImage:kImageName(@"arrow.png") forState:UIControlStateNormal];
//    [_statusButton addTarget:self action:@selector(showOrderStatus:) forControlEvents:UIControlEventTouchUpInside];
    [headerViews addSubview:_statusButton];
    bugbutton = [UIButton buttonWithType:UIButtonTypeCustom];
    bugbutton.frame = CGRectMake(wide-130, 20, 60, 30);
    bugbutton.titleLabel.font = [UIFont systemFontOfSize:18.f];
    [bugbutton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [bugbutton setTitle:@"租赁" forState:UIControlStateNormal];
   [bugbutton addTarget:self action:@selector(selectStatus:) forControlEvents:UIControlEventTouchUpInside];
    [headerViews addSubview:bugbutton];
    bugbutton.tag=2;
    
    UIView *linview = [[UIView alloc] initWithFrame:CGRectMake(wide-140, 22, 1, 20)];
    linview.backgroundColor = [UIColor grayColor];
    [headerViews addSubview:linview];

    rentbutton = [UIButton buttonWithType:UIButtonTypeCustom];
    rentbutton.frame = CGRectMake(wide-210, 20, 60, 30);
    rentbutton.titleLabel.font = [UIFont systemFontOfSize:18.f];
    [rentbutton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [rentbutton setTitle:@"购买" forState:UIControlStateNormal];
    [rentbutton addTarget:self action:@selector(selectStatus:) forControlEvents:UIControlEventTouchUpInside];
    [headerViews addSubview:rentbutton];
    
    
    rentbutton.tag=1;

    
    UIView *footerView = [[UIView alloc] init];
    footerView.backgroundColor = [UIColor clearColor];
    _tableView.tableFooterView = footerView;
}

- (void)initAndLayoutUI {
     headerView = [[UIView alloc]init];
    if (iOS7) {
        headerView.frame = CGRectMake(160, 70, SCREEN_HEIGHT - 160.f, SCREEN_WIDTH-70);
    }
    else
    {
        headerView.frame = CGRectMake(160, 70, SCREEN_WIDTH - 160.f, SCREEN_HEIGHT-70);

    
    }
    [self.view addSubview:headerView];
    

    _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
    _tableView.translatesAutoresizingMaskIntoConstraints = NO;
    _tableView.backgroundColor = kColor(244, 243, 243, 1);
    _tableView.delegate = self;
    _tableView.dataSource = self;
    [self setHeaderAndFooterView];
    [headerView addSubview:_tableView];
    [headerView addConstraint:[NSLayoutConstraint constraintWithItem:_tableView
                                                          attribute:NSLayoutAttributeTop
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:headerView
                                                          attribute:NSLayoutAttributeTop
                                                         multiplier:1.0
                                                           constant:0]];
    [headerView addConstraint:[NSLayoutConstraint constraintWithItem:_tableView
                                                          attribute:NSLayoutAttributeLeft
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:headerView
                                                          attribute:NSLayoutAttributeLeft
                                                         multiplier:1.0
                                                           constant:0]];
    [headerView addConstraint:[NSLayoutConstraint constraintWithItem:_tableView
                                                          attribute:NSLayoutAttributeRight
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:headerView
                                                          attribute:NSLayoutAttributeRight
                                                         multiplier:1.0
                                                           constant:0]];
    [headerView addConstraint:[NSLayoutConstraint constraintWithItem:_tableView
                                                          attribute:NSLayoutAttributeBottom
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:headerView
                                                          attribute:NSLayoutAttributeBottom
                                                         multiplier:1.0
                                                           constant:0]];
    _topRefreshView = [[RefreshView alloc] initWithFrame:CGRectMake(0, -80, headerView.bounds.size.width-40, 80)];
    _topRefreshView.direction = PullFromTop;
    _topRefreshView.delegate = self;
    [_tableView addSubview:_topRefreshView];
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;

    _bottomRefreshView = [[RefreshView alloc] initWithFrame:CGRectMake(0, 0, headerView.bounds.size.width-40, 60)];
    _bottomRefreshView.direction = PullFromBottom;
    _bottomRefreshView.delegate = self;
    _bottomRefreshView.hidden = YES;
    [_tableView addSubview:_bottomRefreshView];
}

- (NSString *)stringForOrderType:(OrderType)type {
    NSString *title = nil;
    switch (type) {
        case OrderTypeAll:
            title = @"全部";
            break;
        case OrderTypeBuy:
            title = @"购买";
            break;
        case OrderTypeRent:
            title = @"租赁";
            break;
        default:
            break;
    }
    return title;
}

- (void)setCurrentType:(OrderType)currentType {
    _currentType = currentType;
    _statusLabel.text = [self stringForOrderType:_currentType];
}

#pragma mark - Request

- (void)firstLoadData {
    _page = 1;
    [self downloadDataWithPage:_page isMore:NO];
}

- (void)downloadDataWithPage:(int)page isMore:(BOOL)isMore {
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
    hud.labelText = @"加载中...";
    AppDelegate *delegate = [AppDelegate shareAppDelegate];
    [NetworkInterface getMyOrderListWithToken:delegate.token userID:delegate.userID orderType:_currentType page:page rows:kPageSize finished:^(BOOL success, NSData *response) {
        hud.customView = [[UIImageView alloc] init];
        hud.mode = MBProgressHUDModeCustomView;
        [hud hide:YES afterDelay:0.3f];
        if (success) {
            NSLog(@"!!%@",[[NSString alloc] initWithData:response encoding:NSUTF8StringEncoding]);
            id object = [NSJSONSerialization JSONObjectWithData:response options:NSJSONReadingMutableLeaves error:nil];
            if ([object isKindOfClass:[NSDictionary class]]) {
                NSString *errorCode = [object objectForKey:@"code"];
                if ([errorCode intValue] == RequestFail) {
                    //返回错误代码
                    hud.labelText = [NSString stringWithFormat:@"%@",[object objectForKey:@"message"]];
                }
                else if ([errorCode intValue] == RequestSuccess) {
                    if (!isMore) {
                        [_orderItems removeAllObjects];
                    }
                    if ([[object objectForKey:@"result"] count] > 0) {
                        //有数据
                        self.page++;
                        [hud hide:YES];
                    }
                    else {
                        //无数据
                        hud.labelText = @"没有更多数据了...";
                    }
                    [self parseOrderListDataWithDictionary:object];
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
        if (!isMore) {
            [self refreshViewFinishedLoadingWithDirection:PullFromTop];
        }
        else {
            [self refreshViewFinishedLoadingWithDirection:PullFromBottom];
        }
    }];
}

//取消订单
- (void)cancelOrder {
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
    hud.labelText = @"加载中...";
    AppDelegate *delegate = [AppDelegate shareAppDelegate];
    [NetworkInterface cancelMyOrderWithToken:delegate.token orderID:_selectedModel.orderID finished:^(BOOL success, NSData *response) {
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

- (void)parseOrderListDataWithDictionary:(NSDictionary *)dict {
    if (![dict objectForKey:@"result"] || ![[dict objectForKey:@"result"] isKindOfClass:[NSDictionary class]]) {
        return;
    }
    NSArray *orderList = [[dict objectForKey:@"result"] objectForKey:@"content"];
    for (int i = 0; i < [orderList count]; i++) {
        OrderModel *model = [[OrderModel alloc] initWithParseDictionary:[orderList objectAtIndex:i]];
        [_orderItems addObject:model];
    }
    [_tableView reloadData];
}

#pragma mark - Action

- (IBAction)showOrderStatus:(id)sender {
    NSMutableArray *listArray = [NSMutableArray arrayWithObjects:
                                 [KxMenuItem menuItem:[self stringForOrderType:OrderTypeAll]
                                                image:nil
                                               target:self
                                               action:@selector(selectStatus:)
                                        selectedTitle:_statusLabel.text
                                                  tag:OrderTypeAll],
                                 [KxMenuItem menuItem:[self stringForOrderType:OrderTypeBuy]
                                                image:nil
                                               target:self
                                               action:@selector(selectStatus:)
                                        selectedTitle:_statusLabel.text
                                                  tag:OrderTypeBuy],
                                 [KxMenuItem menuItem:[self stringForOrderType:OrderTypeRent]
                                                image:nil
                                               target:self
                                               action:@selector(selectStatus:)
                                        selectedTitle:_statusLabel.text
                                                  tag:OrderTypeRent],
                                 nil];
    
    CGRect rect = CGRectMake(_statusButton.frame.origin.x + _statusButton.frame.size.width / 2, _statusButton.frame.origin.y + _statusButton.frame.size.height + 5, 0, 0);
    [KxMenu showMenuInView:headerView fromRect:rect menuItems:listArray];
}

- (IBAction)selectStatus:(id)sender {
    UIButton*but=(UIButton*)sender;
    if(but.tag==1)
    {
    
       
            [rentbutton setTitleColor:kColor(233, 91, 38, 1) forState:UIControlStateNormal];
        [bugbutton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];

        
   

    }
    else
    {
    
        [bugbutton setTitleColor:kColor(233, 91, 38, 1) forState:UIControlStateNormal];
        [rentbutton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    }
    
    self.currentType = but.tag;
    [self firstLoadData];
}

#pragma mark - UITableView

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return [_orderItems count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    OrderModel *model = [_orderItems objectAtIndex:indexPath.section];
    NSString *identifier = [model getCellIdentifier];
    OrderCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (cell == nil) {
        cell = [[OrderCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    cell.delegate = self;
    [cell setContentsWithData:model];
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

    UILabel *totalLabels = [[UILabel alloc] initWithFrame:CGRectMake(20, 180, wide-260, 1)];
    totalLabels.backgroundColor =[UIColor grayColor];
    [cell.contentView addSubview:totalLabels];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    OrderModel *model = [_orderItems objectAtIndex:indexPath.section];
    NSString *identifier = [model getCellIdentifier];
    if ([identifier isEqualToString:unPaidIdentifier] ||
        [identifier isEqualToString:sendingIdentifier]) {
        return kOrderLongCellHeight;
    }
    return kOrderShortCellHeight;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    OrderModel *model = [_orderItems objectAtIndex:indexPath.section];
    OrderDetailController *detailC = [[OrderDetailController alloc] init];
    detailC.hidesBottomBarWhenPushed =  YES ;

    
    
    detailC.ordertype = model.order_type;

    
    
    detailC.orderID = model.orderID;
    [self.navigationController pushViewController:detailC animated:YES];
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.001f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 0.001f;
}

#pragma mark - Refresh

- (void)refreshViewReloadData {
    _reloading = YES;
}

- (void)refreshViewFinishedLoadingWithDirection:(PullDirection)direction {
    _reloading = NO;
    if (direction == PullFromTop) {
        [_topRefreshView refreshViewDidFinishedLoading:_tableView];
    }
    else if (direction == PullFromBottom) {
        _bottomRefreshView.frame = CGRectMake(0, _tableView.contentSize.height, _tableView.bounds.size.width, 60);
        [_bottomRefreshView refreshViewDidFinishedLoading:_tableView];
    }
    [self updateFooterViewFrame];
}

- (BOOL)refreshViewIsLoading:(RefreshView *)view {
    return _reloading;
}

- (void)refreshViewDidEndTrackingForRefresh:(RefreshView *)view {
    [self refreshViewReloadData];
    //loading...
    if (view == _topRefreshView) {
        [self pullDownToLoadData];
    }
    else if (view == _bottomRefreshView) {
        [self pullUpToLoadData];
    }
}

- (void)updateFooterViewFrame {
    _bottomRefreshView.frame = CGRectMake(0, _tableView.contentSize.height, _tableView.bounds.size.width, 60);
    _bottomRefreshView.hidden = NO;
    if (_tableView.contentSize.height < _tableView.frame.size.height) {
        _bottomRefreshView.hidden = YES;
    }
}

#pragma mark - UIScrollView

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    _primaryOffsetY = scrollView.contentOffset.y;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if (scrollView == _tableView) {
        CGPoint newPoint = scrollView.contentOffset;
        if (_primaryOffsetY < newPoint.y) {
            //上拉
            if (_bottomRefreshView.hidden) {
                return;
            }
            [_bottomRefreshView refreshViewDidScroll:scrollView];
        }
        else {
            //下拉
            [_topRefreshView refreshViewDidScroll:scrollView];
        }
    }
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    if (scrollView == _tableView) {
        CGPoint newPoint = scrollView.contentOffset;
        if (_primaryOffsetY < newPoint.y) {
            //上拉
            if (_bottomRefreshView.hidden) {
                return;
            }
            [_bottomRefreshView refreshViewDidEndDragging:scrollView];
        }
        else {
            //下拉
            [_topRefreshView refreshViewDidEndDragging:scrollView];
        }
    }
}

#pragma mark - 上下拉刷新
//下拉刷新
- (void)pullDownToLoadData {
    [self firstLoadData];
}

//上拉加载
- (void)pullUpToLoadData {
    [self downloadDataWithPage:self.page isMore:YES];
}


#pragma mark - Notification

- (void)refreshOrderList:(NSNotification *)notification {
    [self performSelector:@selector(firstLoadData) withObject:nil afterDelay:0.1f];
}

#pragma mark - OrderCellDelegate

- (void)orderCellCancelOrderForData:(OrderModel *)model {
    _selectedModel = model;
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示信息"
                                                    message:@"确定取消此订单？"
                                                   delegate:self
                                          cancelButtonTitle:@"取消"
                                          otherButtonTitles:@"确定", nil];
    [alert show];
}

- (void)orderCellPayOrderForData:(OrderModel *)model {
    _selectedModel = model;
    PayWayViewController *payWayC = [[PayWayViewController alloc] init];
    payWayC.orderID = _selectedModel.orderID;
    payWayC.totalPrice = _selectedModel.orderTotalPrice;
    payWayC.hidesBottomBarWhenPushed =  YES ;

    [self.navigationController pushViewController:payWayC animated:YES];
}

- (void)orderCellCommentOrderForData:(OrderModel *)model {
    _selectedModel = model;
    OrderCommentController *commentC = [[OrderCommentController alloc] init];
    commentC.orderID = _selectedModel.orderID;
    [self.navigationController pushViewController:commentC animated:YES];
}

#pragma mark - AlertView

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (buttonIndex != alertView.cancelButtonIndex) {
        [self cancelOrder];
    }
}



/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
