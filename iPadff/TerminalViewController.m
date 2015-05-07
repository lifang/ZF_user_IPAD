//
//  TerminalViewController.m
//  iPadff
//
//  Created by 黄含章 on 15/3/5.
//  Copyright (c) 2015年 LanTaiPro. All rights reserved.
//

#import "TerminalViewController.h"
#import "TerminalViewCell.h"
#import "AppDelegate.h"
#import "NetworkInterface.h"
#import "RefreshView.h"
#import "TerminalAddViewController.h"
#import "TerminalManagerModel.h"
#import "TerminalChildController.h"
#import "LoginViewController.h"
#import "AccountTool.h"
#import "ApplyDetailController.h"
#import "VideoAuthController.h"


@interface TerminalViewController ()<terminalCellSendBtnClicked,RefreshDelegate,addTerminal,LoginSuccessDelegate>

/***************上下拉刷新**********/
@property (nonatomic, strong) RefreshView *topRefreshView;
@property (nonatomic, strong) RefreshView *bottomRefreshView;

@property (nonatomic, assign) BOOL reloading;
@property (nonatomic, assign) CGFloat primaryOffsetY;
@property (nonatomic, assign) int page;
/**********************************/

//终端信息数据
@property (nonatomic, strong) NSMutableArray *terminalItems;

@property(nonatomic,strong)UIImageView *findPosView;

@property(nonatomic,assign)BOOL isPush;

@property(nonatomic,strong)UIView *headerView;

@property(nonatomic,strong)UILabel *findPassword;

@end

@implementation TerminalViewController
-(void)ShowLoginVC
{
    AccountModel *account = [AccountTool userModel];
    NSLog(@"%@",account);
    if (account.password) {
        [self setupNavBar];
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
    [self setupNavBar];
    [self firstLoadData];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    if (_isPush) {
        [self ShowLoginVC];
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    _isPush = YES;
    NSDictionary *attributes = [NSDictionary dictionaryWithObjectsAndKeys:[UIColor whiteColor],NSForegroundColorAttributeName,[UIFont boldSystemFontOfSize:22],NSFontAttributeName, nil];
    [self.navigationController.navigationBar setTitleTextAttributes:attributes];
    self.title = @"终端管理";
    _terminalItems = [[NSMutableArray alloc]init];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self setupHeaderView];
    [self setRefreshView];
}


-(void)leftClicked
{
    [self removePOSView];
}

-(void)removePOSView
{
    [_findPosView removeFromSuperview];
}


-(void)setupHeaderView
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
    first.frame = CGRectMake(65, 0, 70, 25);
    [bottomView addSubview:first];
    bottomView.backgroundColor = kColor(226, 226, 226, 1.0);
    
    UILabel *second = [[UILabel alloc]init];
    second.font = mainFont;
    second.text = @"POS机";
    second.frame = CGRectMake(CGRectGetMaxX(first.frame) + 60, 0, 70, 25);
    [bottomView addSubview:second];
    
    UILabel *third = [[UILabel alloc]init];
    third.font = mainFont;
    third.text = @"支付通道";
    third.frame = CGRectMake(CGRectGetMaxX(second.frame) + 60, 0, 90, 25);
    [bottomView addSubview:third];
    
    UILabel *fourth = [[UILabel alloc]init];
    fourth.font = mainFont;
    fourth.text = @"开通状态";
    fourth.frame = CGRectMake(CGRectGetMaxX(third.frame) + 50, 0, 90, 25);
    [bottomView addSubview:fourth];
    
    bottomView.frame = CGRectMake(0, 36, SCREEN_WIDTH, 24);
    if (iOS7) {
        bottomView.frame = CGRectMake(0, 36, SCREEN_HEIGHT, 24);
    }
    [headerView addSubview:bottomView];
    self.headerView = headerView;
}
-(void)setupNavBar
{
    self.view.backgroundColor = [UIColor whiteColor];
    [self.navigationController.navigationBar setBackgroundImage:[UIImage resizedImage:@"orange"] forBarPosition:UIBarPositionTop barMetrics:UIBarMetricsDefault];
    
    UIBarButtonItem *zeroBar = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
    zeroBar.width = 30.f;
    
    UIBarButtonItem *rightZeroBar = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
    rightZeroBar.width = 40.f;
    
    UIButton *rightBtn = [[UIButton alloc]init];
    [rightBtn addTarget:self action:@selector(addTerminal) forControlEvents:UIControlEventTouchUpInside];
    rightBtn.frame = CGRectMake(0, 0, 24, 24);
    [rightBtn setImage:[UIImage imageNamed:@"+"] forState:UIControlStateNormal];
    UIBarButtonItem *rightBar = [[UIBarButtonItem alloc]initWithCustomView:rightBtn];
    NSArray *rightArr = [NSArray arrayWithObjects:rightZeroBar,rightBar,nil];
    self.navigationItem.rightBarButtonItems = rightArr;
    
    UIView *footerView = [[UIView alloc]init];
    footerView.backgroundColor = kColor(210, 210, 210, 1.0);
    footerView.frame = CGRectMake(0, 0, SCREEN_WIDTH, 1);
    if (iOS7) {
        footerView.frame = CGRectMake(0, 0, SCREEN_HEIGHT, 1);
    }
    self.tableView.tableFooterView = footerView;
}

-(void)setRefreshView
{
    _topRefreshView = [[RefreshView alloc] initWithFrame:CGRectMake(0, -80, self.view.bounds.size.width, 80)];
    _topRefreshView.direction = PullFromTop;
    _topRefreshView.delegate = self;
    [self.tableView addSubview:_topRefreshView];
    
    _bottomRefreshView = [[RefreshView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, 60)];
    _bottomRefreshView.direction = PullFromBottom;
    _bottomRefreshView.delegate = self;
    _bottomRefreshView.hidden = YES;
    [self.tableView addSubview:_bottomRefreshView];
}

-(void)addTerminal
{
    //添加终端
    TerminalAddViewController *terminalAddC = [[TerminalAddViewController alloc]init];
    terminalAddC.TerminalDelegates = self;
    UINavigationController *nav = [[UINavigationController alloc]initWithRootViewController:terminalAddC];
    nav.navigationBarHidden = YES;
    nav.modalPresentationStyle = UIModalPresentationCustom;
    nav.modalTransitionStyle = UIModalTransitionStyleCoverVertical;
    [self presentViewController:nav animated:YES completion:nil];
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
    [NetworkInterface getTerminalManagerListWithToken:delegate.token userID:delegate.userID page:page rows:kPageSize finished:^(BOOL success, NSData *response) {
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
                        [_terminalItems removeAllObjects];
                    }
                    
                    id list = [[object objectForKey:@"result"] objectForKey:@"list"];
                    if ([list isKindOfClass:[NSArray class]] && [list count] > 0) {
                        //有数据
                        self.page++;
                        [hud hide:YES];
                    }
                    else {
                        //无数据
                        hud.labelText = @"没有更多数据了...";
                    }
                    [self parseTerminalDataWithDictionary:object];
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

- (void)parseTerminalDataWithDictionary:(NSDictionary *)dict {
    if (![dict objectForKey:@"result"] || ![[dict objectForKey:@"result"] isKindOfClass:[NSDictionary class]]) {
        return;
    }
    NSArray *TM_List = [[dict objectForKey:@"result"] objectForKey:@"list"];
    for (int i = 0; i < [TM_List count]; i++) {
        TerminalManagerModel *tm_Model = [[TerminalManagerModel alloc] initWithParseDictionary:[TM_List objectAtIndex:i]];
        [_terminalItems addObject:tm_Model];
    }
    NSLog(@"~~~~~~~~%@",_terminalItems);
    [self.tableView reloadData];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _terminalItems.count;
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
    if (_terminalItems.count == 0) {
        NSString *ID = @"cell";
        TerminalViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
        if (cell == nil) {
            cell = [[TerminalViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:ID];
        }
        return cell;
    }else{
        TerminalManagerModel *model = [_terminalItems objectAtIndex:indexPath.row];
        NSString *IDs = [NSString stringWithFormat:@"cell-%@",model.TM_status];
        TerminalViewCell *cell = [tableView dequeueReusableCellWithIdentifier:IDs];
        if (cell == nil) {
            cell = [[TerminalViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:IDs];
            cell.TerminalViewCellDelegate = self;
        }
        cell.selectedID = model.TM_ID;
        cell.terminalLabel.text = model.TM_serialNumber;
        cell.posLabel.text = [NSString stringWithFormat:@"%@%@",model.TM_brandsName,model.TM_model_number];
        cell.payRoad.text = model.TM_channelName;
        cell.indexNum = indexPath.row;
        if ([model.TM_status isEqualToString:@"1"]) {
            cell.dredgeStatus.text = @"已开通";
            cell.cellStates = @"已开通";
        }
        if ([model.TM_status isEqualToString:@"3"]) {
            cell.dredgeStatus.text = @"未开通";
            cell.cellStates = @"未开通";
        }
        if ([model.TM_status isEqualToString:@"2"]) {
            cell.dredgeStatus.text = @"部分开通";
            cell.cellStates = @"部分开通";
        }
        if ([model.TM_status isEqualToString:@"5"]) {
            cell.dredgeStatus.text = @"已停用";
            cell.cellStates = @"已停用";
        }
        if ([model.TM_status isEqualToString:@"4"]) {
            cell.dredgeStatus.text = @"已注销";
            cell.cellStates = @"已注销";
        }
        return cell;
    }
}


#pragma mark terminalCell的代理
-(void)terminalCellBtnClicked:(int)btnTag WithSelectedID:(NSString *)selectedID Withindex:(int)indexNum
{
    if (btnTag == 1000) {
        NSLog(@"点击了找回POS密码 信息ID为%@",selectedID);
        [self initFindPosViewWithSelectedID:selectedID WithIndexNum:indexNum];
    }
    if (btnTag == 1001) {
        VideoAuthController *videoAuthC = [[VideoAuthController alloc] init];
        videoAuthC.terminalID = selectedID;
        videoAuthC.hidesBottomBarWhenPushed=YES;
        
        
        [self.navigationController pushViewController:videoAuthC animated:YES];    }
    if (btnTag == 2000) {
        VideoAuthController *videoAuthC = [[VideoAuthController alloc] init];
        videoAuthC.terminalID = selectedID;
        videoAuthC.hidesBottomBarWhenPushed=YES;

        [self.navigationController pushViewController:videoAuthC animated:YES];    }
    if (btnTag == 2001) {
        NSLog(@"点击了申请开通");
        [self pushApplyVCWithSelectedID:selectedID];
    }
    if (btnTag == 2002) {
        NSLog(@"点击了同步(未开通)");
    }
    if (btnTag == 3000) {
        NSLog(@"点击了找回POS密码（部分开通）");
        [self initFindPosViewWithSelectedID:selectedID WithIndexNum:indexNum];
    }
    if (btnTag == 3001) {
        VideoAuthController *videoAuthC = [[VideoAuthController alloc] init];
        videoAuthC.hidesBottomBarWhenPushed=YES;

        videoAuthC.terminalID = selectedID;
        [self.navigationController pushViewController:videoAuthC animated:YES];    }
    if (btnTag == 3002) {
        NSLog(@"点击了重新申请开通");
        [self pushApplyNewVCWithSelectedID:selectedID];
    }
    if (btnTag == 3003) {
        NSLog(@"点击了同步（部分开通）");
    }
    if (btnTag == 4000) {
        NSLog(@"点击了更新资料");
    }
    if (btnTag == 4001) {
        NSLog(@"点击了同步（已停用）");
    }
    if (btnTag == 5000) {
        NSLog(@"点击了租凭退换");
    }
    
}
//找回PS密码
-(void)initFindPosViewWithSelectedID:(NSString *)selectedID WithIndexNum:(int)indexP
{
    CGFloat width;
    CGFloat height;
    if(iOS7)
    {
        width = SCREEN_HEIGHT;
        height = SCREEN_WIDTH;
    }
    else
    {
        width = SCREEN_WIDTH;
        height = SCREEN_HEIGHT;
    }
    NSLog(@"~~~~~~~~~~~~第%d行",indexP);
    _findPosView = [[UIImageView alloc]init];
    
    _findPosView.frame = CGRectMake(0, 0, width, height);
    
    [self.view.window addSubview:_findPosView];
    _findPosView.image=[UIImage imageNamed:@"backimage"];
    _findPosView.userInteractionEnabled=YES;
    
    UIView *whiteView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 440, 220)];
    whiteView.center = CGPointMake(width / 2, (height - 100) / 2);
    whiteView.backgroundColor = [UIColor whiteColor];
    [_findPosView addSubview:whiteView];
    
    UIButton *leftXBtn = [[UIButton alloc]init];
    [leftXBtn addTarget:self action:@selector(leftClicked) forControlEvents:UIControlEventTouchUpInside];
    [leftXBtn setBackgroundImage:[UIImage imageNamed:@"X_black"] forState:UIControlStateNormal];
    leftXBtn.frame = CGRectMake(15, 15, 25, 25);
    [whiteView addSubview:leftXBtn];
    
    UILabel *FindPOSLable = [[UILabel alloc]init];
    FindPOSLable.text = @"找回POS密码";
    FindPOSLable.textColor = kColor(38, 38, 38, 1.0);
    FindPOSLable.font = [UIFont systemFontOfSize:22];
    FindPOSLable.frame = CGRectMake(150, 10, 200, 40);
    [whiteView addSubview:FindPOSLable];
    
    UIView *line = [[UIView alloc]init];
    line.backgroundColor = kColor(128, 128, 128, 1.0);
    line.frame = CGRectMake(0, CGRectGetMaxY(FindPOSLable.frame) + 10, whiteView.frame.size.width, 1);
    [whiteView addSubview:line];
    
    UILabel *POSLable = [[UILabel alloc]init];
    POSLable.text = @"POS机密码";
    POSLable.textColor = kColor(56, 56, 56, 1.0);
    POSLable.font = [UIFont systemFontOfSize:20];
    POSLable.frame = CGRectMake(FindPOSLable.frame.origin.x - 40, CGRectGetMaxY(line.frame) + 50, 120, 30);
    [whiteView addSubview:POSLable];
    
    
    
    _findPassword = [[UILabel alloc]init];
    _findPassword.textColor = kColor(132, 132, 132, 1.0);
    _findPassword.font = [UIFont systemFontOfSize:20];
    _findPassword.frame = CGRectMake(CGRectGetMaxX(POSLable.frame), POSLable.frame.origin.y, 300, 30);
    [whiteView addSubview:_findPassword];
    
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
    hud.labelText = @"加载中...";
     AppDelegate *delegate = [AppDelegate shareAppDelegate];
    [NetworkInterface findPOSPasswordWithToken:delegate.token tmID:selectedID finished:^(BOOL success, NSData *response) {
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
                    id tipInfo = [object objectForKey:@"result"];
                    if ([tipInfo isKindOfClass:[NSString class]]) {
                        _findPassword.text = tipInfo;
                    }
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



//重新申请开通
-(void)pushApplyNewVCWithSelectedID:(NSString *)selectedID
{
    ApplyDetailController *detailC = [[ApplyDetailController alloc] init];
    detailC.terminalID = selectedID;
    detailC.openStatus = OpenStatusReopen;
    detailC.hidesBottomBarWhenPushed = YES;
    
    [self.navigationController pushViewController:detailC animated:YES];
}


//新开通
-(void)pushApplyVCWithSelectedID:(NSString *)selectedID
{
    ApplyDetailController *detailC = [[ApplyDetailController alloc] init];
    detailC.terminalID = selectedID;
    detailC.openStatus = OpenStatusNew;
    detailC.hidesBottomBarWhenPushed = YES;
    
    [self.navigationController pushViewController:detailC animated:YES];
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    self.isPush = NO;
    TerminalManagerModel *model = [_terminalItems objectAtIndex:indexPath.row];
    
    if ([model.TM_status intValue] == TerminalStatusOpened && !model.appID) {
        //自助开通无法查看详情
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
        hud.customView = [[UIImageView alloc] init];
        hud.mode = MBProgressHUDModeCustomView;
        [hud hide:YES afterDelay:1.f];
        hud.labelText = @"自助开通终端无详情信息";
        return;
    }
    else{
        TerminalChildController *terminalChildV = [[TerminalChildController alloc]init];
        terminalChildV.hidesBottomBarWhenPushed = YES;
        terminalChildV.dealStatus = model.TM_status;
        terminalChildV.tm_ID = model.TM_ID;
        [self.navigationController pushViewController:terminalChildV animated:YES];
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 80;
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
        _bottomRefreshView.frame = CGRectMake(0, self.tableView.contentSize.height, self.tableView.bounds.size.width, 60);
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

-(void)addTerminalSuccess
{
    [self firstLoadData];
}

@end
