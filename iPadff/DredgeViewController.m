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
@interface DredgeViewController ()<RefreshDelegate>

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

@end

@implementation DredgeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _applyList = [[NSMutableArray alloc]init];
    [self setupNavBar];
    [self setupHeaderAndFooterView];
    [self firstLoadData];
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
    self.tableView.tableHeaderView = headerView;
    
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
        TerminalManagerModel *tm_Model = [[TerminalManagerModel alloc] initWithParseDictionary:[TM_List objectAtIndex:i]];
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


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    DredgeViewCell *cell = [DredgeViewCell cellWithTableView:tableView];
    TerminalManagerModel *model = [_applyList objectAtIndex:indexPath.row];
    cell.terminalLabel.text = model.TM_serialNumber;
    cell.posLabel.text = model.TM_brandsName;
    cell.payRoad.text = model.TM_channelName;
    self.status = model.TM_status;
    cell.dredgeStatus.text = [self getStatusString];
    
    //用来标识数据的id
    cell.applicationBtn.tag = [model.TM_ID intValue];
    cell.vedioConfirmBtn.tag = [model.TM_ID intValue];
    if(  [model.TM_status  isEqualToString:@"2"])
    {
        [cell.applicationBtn setTitle:@"重新申请开通" forState:UIControlStateNormal];

        cell.applicationBtn.titleLabel.font=[UIFont systemFontOfSize:16];
        [cell.applicationBtn addTarget:self action:@selector(applicationClicks:) forControlEvents:UIControlEventTouchUpInside];

        
    }
    else
    {
        [cell.applicationBtn setTitle:@"申请开通" forState:UIControlStateNormal];
        [cell.applicationBtn addTarget:self action:@selector(applicationClick:) forControlEvents:UIControlEventTouchUpInside];

    
    }
    
    [cell.vedioConfirmBtn addTarget:self action:@selector(vedioConfirmClick:) forControlEvents:UIControlEventTouchUpInside];
    return cell;
}

-(void)vedioConfirmClick:(UIButton *)button
{
    NSLog(@"%d",button.tag);
}

-(void)applicationClick:(UIButton *)button
{
    ApplyDetailController *detailC = [[ApplyDetailController alloc] init];
    detailC.terminalID =[NSString stringWithFormat:@"%d",button.tag];
    detailC.openStatus = OpenStatusNew;
    detailC.hidesBottomBarWhenPushed = YES;

    [self.navigationController pushViewController:detailC animated:YES];
}
-(void)applicationClicks:(UIButton *)button
{
    NSLog(@"%ld",(long)button.tag);

    ApplyDetailController *detailC = [[ApplyDetailController alloc] init];
    detailC.terminalID =[NSString stringWithFormat:@"%d",button.tag];
    detailC.openStatus = OpenStatusReopen;
    detailC.hidesBottomBarWhenPushed = YES;
    
    [self.navigationController pushViewController:detailC animated:YES];
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    //    DynamicStatus *status = [_listArray objectAtIndex:indexPath.row];
    //    DynamicChildViewController *dynamicVC = [[DynamicChildViewController alloc]init];
    //    dynamicVC.page =  status.ids;
    //    [self.navigationController pushViewController:dynamicVC animated:YES];
    //    SLog(@"点击了第%ld行",indexPath.row);
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
