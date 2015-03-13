//
//  MyShopViewController.m
//  iPadff
//
//  Created by 黄含章 on 15/3/11.
//  Copyright (c) 2015年 LanTaiPro. All rights reserved.
//

#import "MyShopViewController.h"
#import "MerchantModel.h"
#import "MerchantDetailModel.h"
#import "NetworkInterface.h"
#import "AppDelegate.h"
#import "RefreshView.h"
#import "MerchantDetailViewController.h"
#import "CreatMerchantViewController.h"

@interface MyShopViewController ()<UITableViewDataSource,UITableViewDelegate,RefreshDelegate>
@property (nonatomic, strong) NSMutableArray *MerchantItems;
@property(nonatomic,strong) UITableView *tableView;

@property (nonatomic, assign) BOOL isMultiDelete;

/***************上下拉刷新**********/
@property (nonatomic, strong) RefreshView *topRefreshView;
@property (nonatomic, strong) RefreshView *bottomRefreshView;
@property (nonatomic, assign) BOOL reloading;
@property (nonatomic, assign) CGFloat primaryOffsetY;
@property (nonatomic, assign) int page;
/********************************/

@end

@implementation MyShopViewController

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.view.backgroundColor = [UIColor whiteColor];
    [self setLeftViewWith:ChooseViewMyShop];
    _MerchantItems = [[NSMutableArray alloc] init];
    [self setupHeaderView];
    [self initAndLayoutUI];
    [self firstLoadData];
    
   [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshMerchantList:)
     name:RefreshMerchantListNotification
     object:nil];
    
    
}

#pragma mark 创建HeaderView
-(void)setupHeaderView
{
    //创建头部View
    UIView *headerView = [[UIView alloc]init];
    headerView.backgroundColor = kColor(255, 102, 36, 1);
    headerView.frame = CGRectMake(160, 0, SCREEN_WIDTH-160.f, 80);
    if (iOS7) {
        headerView.frame = CGRectMake(160, 0, SCREEN_HEIGHT - 160.f, 80);
    }
    [self.view addSubview:headerView];
    
    UIButton *deleteButton = [UIButton buttonWithType:UIButtonTypeCustom];
    deleteButton.frame = CGRectMake(SCREEN_WIDTH-280, 20, 40, 40);
    [deleteButton setBackgroundImage:kImageName(@"merchant1.png") forState:UIControlStateNormal];
    [deleteButton addTarget:self action:@selector(multiDelete:) forControlEvents:UIControlEventTouchUpInside];
    [headerView addSubview:deleteButton];
    
    UIButton *addButton = [UIButton buttonWithType:UIButtonTypeCustom];
    addButton.frame = CGRectMake(SCREEN_WIDTH-340, 20, 40, 40);
    [addButton setBackgroundImage:kImageName(@"merchant2.png") forState:UIControlStateNormal];
    [addButton addTarget:self action:@selector(addMerchant:) forControlEvents:UIControlEventTouchUpInside];
    [headerView addSubview:addButton];
   
}

#pragma mark - UI


- (void)initAndLayoutUI {
    //[self initNavigationBarView];
    // [self initContentView];
    if(iOS7)
    {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(160, 80, SCREEN_HEIGHT-219, SCREEN_WIDTH)];
        
    }else
    {
        // _tableView = [[UITableView alloc] initWithFrame:CGRectMake(160, 80, SCREEN_WIDTH-160, SCREEN_HEIGHT) style:UITableViewStyleGrouped];
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(160, 80, SCREEN_WIDTH-219, SCREEN_HEIGHT)];
        
    }
    
    //_tableView.translatesAutoresizingMaskIntoConstraints = NO;
    _tableView.backgroundColor = [UIColor whiteColor];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    [self.view addSubview:_tableView];
    
    
    _topRefreshView = [[RefreshView alloc] initWithFrame:CGRectMake(0, -80,_tableView.frame.size.width, 80)];
    _topRefreshView.direction = PullFromTop;
    _topRefreshView.delegate = self;
    [_tableView addSubview:_topRefreshView];
    
    _bottomRefreshView = [[RefreshView alloc] initWithFrame:CGRectMake(0, 0, _tableView.frame.size.width, 60)];
    _bottomRefreshView.direction = PullFromBottom;
    _bottomRefreshView.delegate = self;
    _bottomRefreshView.hidden = YES;
    [_tableView addSubview:_bottomRefreshView];
    
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
    [NetworkInterface getMerchantListWithToken:delegate.token userID:delegate.userID page:page rows:kPageSize finished:^(BOOL success, NSData *response) {
        hud.customView = [[UIImageView alloc] init];
        hud.mode = MBProgressHUDModeCustomView;
        [hud hide:YES afterDelay:0.3f];
        if (success) {
            NSLog(@"数据是%@",[[NSString alloc] initWithData:response encoding:NSUTF8StringEncoding]);
            id object = [NSJSONSerialization JSONObjectWithData:response options:NSJSONReadingMutableLeaves error:nil];
            if ([object isKindOfClass:[NSDictionary class]]) {
                NSString *errorCode = [object objectForKey:@"code"];
                if ([errorCode intValue] == RequestFail) {
                    //返回错误代码
                    hud.labelText = [NSString stringWithFormat:@"%@",[object objectForKey:@"message"]];
                }
                else if ([errorCode intValue] == RequestSuccess) {
                    if (!isMore) {
                        [_MerchantItems removeAllObjects];
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
                    [self parseMerchantDataWithDictionary:object];
                    NSLog(@"object:%@",object);
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



#pragma mark - Data

- (void)parseMerchantDataWithDictionary:(NSDictionary *)dict {
    
    if (![dict objectForKey:@"result"] || ![[dict objectForKey:@"result"] isKindOfClass:[NSDictionary class]]) {
        return;
    }
    //NSArray *MerchantList = [dict objectForKey:@"result"];
    NSArray *MerchantList = [[dict objectForKey:@"result"] objectForKey:@"list"];
    for (int i = 0; i < [MerchantList count]; i++) {
        MerchantModel *model = [[MerchantModel alloc] initWithParseDictionary:[MerchantList objectAtIndex:i]];
        [_MerchantItems addObject:model];
    }
    NSLog(@"Items:%@",_MerchantItems);
    [_tableView reloadData];
}

#pragma mark - Action

- (void)multiDelete:(id)sender {
    self.isMultiDelete = !_isMultiDelete;
}

- (void)addMerchant:(id)sender {
    CreatMerchantViewController *createVC = [[CreatMerchantViewController alloc] init];
    [self.navigationController pushViewController:createVC animated:YES];
}

- (void)setIsMultiDelete:(BOOL)isMultiDelete {
    _isMultiDelete = isMultiDelete;
    [_tableView setEditing:_isMultiDelete animated:YES];
}


#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    return [_MerchantItems count];
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    //标题Cell
    static NSString *identifier = @"Merchant";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:identifier];
    }
    MerchantModel *model = [_MerchantItems objectAtIndex:indexPath.row];
    cell.textLabel.text = model.merchantName;
    cell.detailTextLabel.text = model.merchantLegal;
    cell.textLabel.textColor = kColor(108, 108, 108, 1);
    cell.detailTextLabel.textColor = kColor(182, 182, 182, 1);
    cell.textLabel.font = [UIFont systemFontOfSize:20.f];
    cell.detailTextLabel.font = [UIFont systemFontOfSize:20.f];
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    
    return cell;
    
}

/*
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    return 80;
    
}
*/

- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (_isMultiDelete) {
        return UITableViewCellEditingStyleDelete | UITableViewCellEditingStyleInsert;
    }
    else {
        return UITableViewCellEditingStyleDelete;
    }
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        NSLog(@"11111");
    }
    else if (editingStyle == 3) {
        NSLog(@"33333");
    }
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
     if (!self.isMultiDelete) {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    MerchantModel *model = [_MerchantItems objectAtIndex:indexPath.row];
    MerchantDetailViewController *detailVC = [[MerchantDetailViewController alloc] init];
    detailVC.merchant = model;
    detailVC.hidesBottomBarWhenPushed=YES;
    [self.navigationController pushViewController:detailVC animated:YES];
    
     }
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

#pragma mark - NSNotification

- (void)refreshMerchantList:(NSNotification *)notification {
    [self firstLoadData];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
