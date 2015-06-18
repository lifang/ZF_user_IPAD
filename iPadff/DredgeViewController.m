//
//  DredgeViewController.m
//  iPadff
//
//  Created by 黄含章 on 15/3/4.
//  Copyright (c) 2015年 LanTaiPro. All rights reserved.
//

#import "DredgeViewController.h"
#import "DredgeViewCell.h"
#import "ApplicationViewController.h"
#import "RefreshView.h"
#import "AppDelegate.h"
#import "NetworkInterface.h"
#import "TerminalManagerModel.h"
#import "ApplyDetailController.h"
#import "LoginViewController.h"
#import "AccountTool.h"
#import "DredgeModel.h"
#import "VideoAuthController.h"
#import "TerminalChildController.h"
#import "AgreenMentController.h"


@interface DredgeViewController ()<RefreshDelegate,LoginSuccessDelegate>

@property(nonatomic,strong)UIView *headerView;

/***************上下拉刷新**********/
@property (nonatomic, strong) RefreshView *topRefreshView;
@property (nonatomic, strong) RefreshView *bottomRefreshView;

@property (nonatomic, assign) BOOL reloading;
@property (nonatomic, assign) CGFloat primaryOffsetY;
@property (nonatomic, assign) int page;
/**********************************/

@property(nonatomic,strong)NSString *status;

//终端信息数据
@property (nonatomic, strong) NSMutableArray *applyList;

@property(nonatomic,assign)BOOL *isPush;

@property(nonatomic,strong)NSString *tm_id;


@end

@implementation DredgeViewController
-(void)ShowLoginVC
{
    AccountModel *account = [AccountTool userModel];
    NSLog(@"%@",account);
    if (account.password) {
        [self firstLoadData];
        self.tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    }
    else
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
    [self firstLoadData];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    if (!_isPush) {
        
    }else{
       [self ShowLoginVC];
    }
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    _applyList = [[NSMutableArray alloc]init];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(pushtoNewApply:) name:@"newApply" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(SQresh) name:@"SQlist" object:nil];

    [self setupNavBar];
    [self setupHeaderAndFooterView];
    [self firstLoadData];
}
-(void)SQresh
{
    [self firstLoadData];


}

- (void)pushtoNewApply:(NSNotification *)notification {
    ApplyDetailController *detailC = [[ApplyDetailController alloc] init];
    detailC.hidesBottomBarWhenPushed = YES;
    detailC.openStatus = OpenStatusNew;
    detailC.terminalID = _tm_id;
    [self.navigationController pushViewController:detailC animated:YES];
}

-(void)setupRefreshView
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

    _topRefreshView = [[RefreshView alloc] initWithFrame:CGRectMake(0, -80, wide, 80)];
    _topRefreshView.direction = PullFromTop;
    _topRefreshView.delegate = self;
    [self.tableView addSubview:_topRefreshView];
    
    _bottomRefreshView = [[RefreshView alloc] initWithFrame:CGRectMake(0, 0, wide, 60)];
    _bottomRefreshView.direction = PullFromBottom;
    _bottomRefreshView.delegate = self;
    _bottomRefreshView.hidden = YES;
    [self.tableView addSubview:_bottomRefreshView];
}

-(void)setupHeaderAndFooterView
{
    UIView *headerView = [[UIView alloc]init];
    headerView.backgroundColor = [UIColor whiteColor];
    headerView.frame = CGRectMake(0, 0, SCREEN_WIDTH, 60);
    if (iOS7) {
        headerView.frame = CGRectMake(0, 0, SCREEN_HEIGHT, 60);
    }
    UIView *bottomView = [[UIView alloc]init];
    UIFont *mainFont = [UIFont systemFontOfSize:14];
    
    UILabel *first = [[UILabel alloc]init];
    first.font = mainFont;
    first.text = @"终端号";
    first.frame = CGRectMake(110, 0, 70, 25);
    [bottomView addSubview:first];
    bottomView.backgroundColor = kColor(226, 226, 226, 1.0);
    
    UILabel *second = [[UILabel alloc]init];
    second.font = mainFont;
    second.text = @"POS机";
    second.frame = CGRectMake(CGRectGetMaxX(first.frame) + 130, 0, 70, 25);
    [bottomView addSubview:second];
    
    UILabel *third = [[UILabel alloc]init];
    third.font = mainFont;
    third.text = @"支付通道";
    third.frame = CGRectMake(CGRectGetMaxX(second.frame) + 100, 0, 90, 25);
    [bottomView addSubview:third];

    UILabel *fourth = [[UILabel alloc]init];
    fourth.font = mainFont;
    fourth.text = @"开通状态";
    fourth.frame = CGRectMake(CGRectGetMaxX(third.frame) + 80, 0, 90, 25);
    [bottomView addSubview:fourth];
    
    bottomView.frame = CGRectMake(0, 36, SCREEN_WIDTH, 24);
    if (iOS7) {
        bottomView.frame = CGRectMake(0, 36, SCREEN_HEIGHT, 24);
    }
    [headerView addSubview:bottomView];
    self.headerView = headerView;
    
    UIView *footerView = [[UIView alloc]init];
    footerView.backgroundColor = kColor(210, 210, 210, 1.0);
    footerView.frame = CGRectMake(0, 0, SCREEN_WIDTH, 1);
    if (iOS7) {
        footerView.frame = CGRectMake(0, 0, SCREEN_HEIGHT, 1);
    }
    self.tableView.tableFooterView = footerView;
    
    [self setupRefreshView];
}
-(void)setupNavBar
{
    self.title = @"开通认证";
    self.view.backgroundColor = [UIColor whiteColor];
    NSDictionary *attributes = [NSDictionary dictionaryWithObjectsAndKeys:[UIColor whiteColor],NSForegroundColorAttributeName,[UIFont boldSystemFontOfSize:22],NSFontAttributeName, nil];
    [self.navigationController.navigationBar setTitleTextAttributes:attributes];
    [self.navigationController.navigationBar setBackgroundImage:[UIImage resizedImage:@"orange"] forBarPosition:UIBarPositionTop barMetrics:UIBarMetricsDefault];
}

-(void)backHome
{
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
    NSLog(@"%@-%@-%d-%d",delegate.token,delegate.userID,page,kPageSize);
    
    [NetworkInterface getApplyListWithToken:delegate.token userID:delegate.userID page:page rows:kPageSize finished:^(BOOL success, NSData *response) {
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
                        [_applyList removeAllObjects];
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
                    [self parseApplyDataWithDictionary:object];
                    
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

#pragma mark - Data

- (void)parseApplyDataWithDictionary:(NSDictionary *)dict {
    if (![dict objectForKey:@"result"] || ![[dict objectForKey:@"result"] isKindOfClass:[NSArray class]]) {
        return;
    }
    NSArray *TM_List = [dict objectForKey:@"result"];
    for (int i = 0; i < [TM_List count]; i++) {
        DredgeModel *tm_Model = [[DredgeModel alloc] initWithParseDictionary:[TM_List objectAtIndex:i]];
        [_applyList addObject:tm_Model];
    }
    [self.tableView reloadData];
}

#pragma mark - Refresh

- (void)refreshViewReloadData {
    _reloading = YES;
}

- (void)refreshViewFinishedLoadingWithDirection:(PullDirection)direction {
    _reloading = NO;
    if (direction == PullFromTop) {
        [_topRefreshView refreshViewDidFinishedLoading:self.tableView];
    }
    else if (direction == PullFromBottom) {
        _bottomRefreshView.frame = CGRectMake(0,self.tableView.contentSize.height, self.tableView.bounds.size.width, 60);
        [_bottomRefreshView refreshViewDidFinishedLoading:self.tableView];
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
    _bottomRefreshView.frame = CGRectMake(0, self.tableView.contentSize.height, self.tableView.bounds.size.width, 60);
    _bottomRefreshView.hidden = NO;
    if (self.tableView.contentSize.height < self.tableView.frame.size.height) {
        _bottomRefreshView.hidden = YES;
    }
}

#pragma mark - UIScrollView

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    _primaryOffsetY = scrollView.contentOffset.y;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if (scrollView == self.tableView) {
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
    if (scrollView == self.tableView) {
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
- (NSString *)getStatusString {
    NSString *statusString = nil;
    int index = [_status intValue];
    switch (index) {
        case TerminalStatusOpened:
            statusString = @"已开通";
            break;
        case TerminalStatusPartOpened:
            statusString = @"部分开通";
            break;
        case TerminalStatusUnOpened:
            statusString = @"未开通";
            break;
        case TerminalStatusCanceled:
            statusString = @"已注销";
            break;
        case TerminalStatusStopped:
            statusString = @"已停用";
            break;
        default:
            break;
    }
    return statusString;
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _applyList.count;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    return _headerView;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 60;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    DredgeModel *model = [_applyList objectAtIndex:indexPath.row];
    NSString *ID = [NSString stringWithFormat:@"isHaveVedio%d",model.isHaveVideo];
    DredgeViewCell *cell = [[DredgeViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:ID];
    cell.terminalLabel.text = model.TM_serialNumber;
    cell.posLabel.text = [NSString stringWithFormat:@"%@%@",model.TM_brandsName,model.TM_model_number];
    cell.payRoad.text = model.TM_channelName;
    self.status = model.TM_status;
    cell.dredgeStatus.text = [self getStatusString];
    
    //用来标识数据的id
    cell.applicationBtn.tag = indexPath.row;
    cell.vedioConfirmBtn.tag = indexPath.row;
    if(  [model.TM_status  isEqualToString:@"2"])
    {
        [cell.applicationBtn setTitle:@"重新申请开通" forState:UIControlStateNormal];
        cell.applicationBtn.titleLabel.font=[UIFont systemFontOfSize:16];
        [cell.applicationBtn addTarget:self action:@selector(applicationClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    else
    {
        if ([model.appID isEqualToString:@""]) {
            [cell.applicationBtn setTitle:@"申请开通" forState:UIControlStateNormal];
        }else{
            [cell.applicationBtn setTitle:@"重新申请开通" forState:UIControlStateNormal];
        }
        [cell.applicationBtn addTarget:self action:@selector(applicationClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    [cell.vedioConfirmBtn addTarget:self action:@selector(vedioConfirmClick:) forControlEvents:UIControlEventTouchUpInside];
    return cell;
}

-(void)vedioConfirmClick:(UIButton *)button
{
    TerminalManagerModel *model = [_applyList objectAtIndex:button.tag];
    if ([model.appID isEqualToString:@""]) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示信息"
                                                        message:@"请先申请开通！"
                                                       delegate:self
                                              cancelButtonTitle:@"确定"
                                              otherButtonTitles:nil];
        [alert show];
        return;
    }
    [self beginVideoAuthWithTerminalID:[NSString stringWithFormat:@"%@",model.TM_ID]];

    VideoAuthController *videoAuthC = [[VideoAuthController alloc] init];
    videoAuthC.terminalID = model.TM_ID;
    videoAuthC.hidesBottomBarWhenPushed=YES;
    
    [self.navigationController pushViewController:videoAuthC animated:YES];}

//发起视频请求
- (void)beginVideoAuthWithTerminalID:(NSString *)terminalID {
    [NetworkInterface beginVideoAuthWithTerminalID:terminalID finished:^(BOOL success, NSData *response) {
        NSLog(@"!!!!%@",[[NSString alloc] initWithData:response encoding:NSUTF8StringEncoding]);
        if (success) {
            id object = [NSJSONSerialization JSONObjectWithData:response options:NSJSONReadingMutableLeaves error:nil];
            if ([object isKindOfClass:[NSDictionary class]]) {
                NSString *errorCode = [object objectForKey:@"code"];
                if ([errorCode intValue] == RequestFail) {
                    //返回错误代码
                }
                else if
                    ([errorCode intValue] == RequestSuccess)
                {
                    
                    
                }
            }
            else {
                //返回错误数据
            }
        }
        else {
        }
    }];
}

-(void)applicationClick:(UIButton *)button
{
    
    self.isPush = NO;
    
    TerminalManagerModel *model = [_applyList objectAtIndex:button.tag];
    if ([model.openstatus isEqualToString:@"6"]) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示信息"
                                                        message:@"正在第三方审核,请耐心等待..."
                                                       delegate:self
                                              cancelButtonTitle:@"确定"
                                              otherButtonTitles:nil];
        [alert show];
        return;
    }
    
    ApplyDetailController *detailC = [[ApplyDetailController alloc] init];
    detailC.hidesBottomBarWhenPushed = YES;
    
    if( [model.appID  isEqualToString:@""])
    {
        _tm_id = model.TM_ID;
        //申请开通
        AgreenMentController *agreenVC = [[AgreenMentController alloc]init];
        agreenVC.tm_id = model.TM_ID;
        agreenVC.protocolStr = model.protocol;
        UINavigationController *nav = [[UINavigationController alloc]initWithRootViewController:agreenVC];
        agreenVC.pushStyle = PushDredge;
        nav.navigationBarHidden = YES;
        
        nav.modalPresentationStyle = UIModalPresentationFormSheet;
        
        nav.modalTransitionStyle = UIModalTransitionStyleCoverVertical;
        
        [self presentViewController:nav animated:YES completion:nil];
    }else
    {
        //重新申请开通
        detailC.openStatus = OpenStatusReopen;
        detailC.terminalID = model.TM_ID;
        
        [self.navigationController pushViewController:detailC animated:YES];

    }
}
//-(void)applicationClicks:(UIButton *)button
//{
//    NSLog(@"%ld",(long)button.tag);
//
//    ApplyDetailController *detailC = [[ApplyDetailController alloc] init];
//    detailC.terminalID =[NSString stringWithFormat:@"%d",button.tag];
//    detailC.openStatus = OpenStatusReopen;
//    detailC.hidesBottomBarWhenPushed = YES;
//    
//    [self.navigationController pushViewController:detailC animated:YES];
//}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    DredgeModel *model = [_applyList objectAtIndex:indexPath.row];
    if ([model.type isEqualToString:@"2"]) {
        //自助开通无法查看详情
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
        hud.customView = [[UIImageView alloc] init];
        hud.mode = MBProgressHUDModeCustomView;
        [hud hide:YES afterDelay:1.f];
        hud.labelText = @"自助开通终端无详情信息";
        return;
    }else{
        TerminalChildController *terminalVC = [[TerminalChildController alloc]init];
        terminalVC.hidesBottomBarWhenPushed = YES;
        terminalVC.dealStatus = model.TM_status;
        terminalVC.isHaveVideo = model.isHaveVideo;
        terminalVC.tm_ID = model.TM_ID;
        terminalVC.appID = model.appID;
        terminalVC.type = model.type;
        terminalVC.openStatus = model.openstatus;
        [self.navigationController pushViewController:terminalVC animated:YES];
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 140;
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    if ([tableView respondsToSelector:@selector(setSeparatorInset:)]) {
        [tableView setSeparatorInset:UIEdgeInsetsZero];
    }
    if ([tableView respondsToSelector:@selector(setLayoutMargins:)]) {
        [tableView setLayoutMargins:UIEdgeInsetsZero];
    }
    if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
        [cell setLayoutMargins:UIEdgeInsetsZero];
    }
}

//- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
//    return 40.f;
//}
//
//-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
//{
//    return _headerView;
//}

@end
