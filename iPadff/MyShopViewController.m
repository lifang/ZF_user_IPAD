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
#import "MerchantCell.h"
#import "MerchantTitleCell.h"
#import "CreateMerchantViewController.h"

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
@property (nonatomic, assign) NSArray *MerchantList;

@property(strong,nonatomic) UIAlertView * alertView;

@end

@implementation MyShopViewController

{
    NSString *demerchant;
}

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
    headerView.backgroundColor = [UIColor whiteColor];
    headerView.frame = CGRectMake(160, 0, SCREEN_WIDTH-160.f, 60);
    if (iOS7) {
        headerView.frame = CGRectMake(160, 0, SCREEN_HEIGHT - 160.f, 60);
    }
    [self.view addSubview:headerView];
    
    UILabel *titleLB = [[UILabel alloc] init];
    [titleLB setBackgroundColor:[UIColor clearColor]];
    [titleLB setFont:[UIFont systemFontOfSize:20]];
    titleLB.textColor= [UIColor colorWithHexString:@"292929"];
    titleLB.text=@"我的商户";
    [headerView addSubview:titleLB];
    [titleLB makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(headerView.centerY);
        make.left.equalTo(headerView.left).offset(100);
        make.width.equalTo(@120);
        
    }];
    
    
    UIButton *addBtn = [[UIButton alloc] init];
    addBtn.clipsToBounds = YES;
    CALayer *readBtnLayer = [addBtn layer];
    [readBtnLayer setMasksToBounds:YES];
    [readBtnLayer setCornerRadius:2.0];
    [readBtnLayer setBorderWidth:1.0];
    [readBtnLayer setBorderColor:[[UIColor orangeColor] CGColor]];
    addBtn.layer.cornerRadius = 3.0f;
    [addBtn setTitle:@"创建商户资料" forState:UIControlStateNormal];
    addBtn.backgroundColor=[UIColor clearColor];
    [addBtn setTitleColor:[UIColor orangeColor] forState:UIControlStateNormal];
    [addBtn addTarget:self action:@selector(addMerchant:) forControlEvents:UIControlEventTouchUpInside];
    [headerView addSubview:addBtn];
    [addBtn makeConstraints:^(MASConstraintMaker *make) {
        //make.top.equalTo(_backView.top).offset(5);
        //make.left.equalTo(_backView.left).offset(5);
        make.centerY.equalTo(headerView.centerY);
        make.width.equalTo(@120);
        make.right.equalTo(headerView.right).offset(-120);
        make.height.equalTo(@50);
    }];
    
    
}

#pragma mark - UI


- (void)initAndLayoutUI {
    
    
    if(iOS7)
    {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(160+20, 60, SCREEN_HEIGHT-220-20*2, SCREEN_WIDTH)];
        
    }else
    {
        
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(160+20, 60, SCREEN_WIDTH-220-20*2, SCREEN_HEIGHT)];
        
    }
    
    
    
    //_tableView.translatesAutoresizingMaskIntoConstraints = NO;
    _tableView.backgroundColor = [UIColor whiteColor];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    [self.view addSubview:_tableView];
    
    
    _topRefreshView = [[RefreshView alloc] initWithFrame:CGRectMake(0, -60,_tableView.frame.size.width, 60)];
    _topRefreshView.direction = PullFromTop;
    _topRefreshView.delegate = self;
    [_tableView addSubview:_topRefreshView];
    
    _bottomRefreshView = [[RefreshView alloc] initWithFrame:CGRectMake(0, 0, _tableView.frame.size.width, 60)];
    _bottomRefreshView.direction = PullFromBottom;
    _bottomRefreshView.delegate = self;
    _bottomRefreshView.hidden = YES;
    [_tableView addSubview:_bottomRefreshView];
    
}

-(void) delete:(MerchantModel *)model
{
    // 使用一个UIAlertView来显示用户选中的列表项
    _alertView = [[UIAlertView alloc]
                  initWithTitle:@"提示"
                  message:[NSString stringWithFormat:@"删除当前商户"]
                  delegate:nil
                  cancelButtonTitle:@"取消"
                  otherButtonTitles:@"确定", nil];
    _alertView.delegate = self;
    [_alertView show];
    demerchant=[[NSString alloc] initWithString:model.merchantID];
    //[self deleteMerchant:model.merchantID];
}


- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    
    if (buttonIndex==1) {
        
       // [self deleteMerchant:model.merchantID];
        [self deleteMerchant:demerchant];
        
    }
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


- (void)deleteMerchant:(id )merchantId {
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
    hud.labelText = @"删除中...";
    AppDelegate *delegate = [AppDelegate shareAppDelegate];
    [NetworkInterface deleteMerchantWithToken:delegate.token merchantIDs:merchantId finished:^(BOOL success, NSData *response) {
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
                    hud.labelText = @"删除商户成功";
                   // [self.navigationController popViewControllerAnimated:YES];
                   
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
    // NSArray *MerchantList = [[dict objectForKey:@"result"] objectForKey:@"list"];
    _MerchantList = [[dict objectForKey:@"result"] objectForKey:@"list"];
    for (int i = 0; i < [_MerchantList count]; i++) {
        MerchantModel *model = [[MerchantModel alloc] initWithParseDictionary:[_MerchantList objectAtIndex:i]];
        [_MerchantItems addObject:model];
    }
    NSLog(@"Items:%@",_MerchantItems);
    [_tableView reloadData];
}



- (void)addMerchant:(id)sender {
    CreateMerchantViewController *createVC = [[CreateMerchantViewController alloc] init];
    createVC.hidesBottomBarWhenPushed=YES;
    [self.navigationController pushViewController:createVC animated:YES];
}



#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return 2;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0)
    {
        return 1;
    }
    else
    {
        return [_MerchantItems count];
    }
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    //标题Cell
    if (indexPath.section == 0)
    {
        
        static NSString *identifier = @"Merchant";
        MerchantTitleCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
        if (cell == nil) {
            cell = [[MerchantTitleCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:identifier];
        }
        
        return cell;
    }
    else
    {
        //内容Cell
        static NSString *identifier = @"Merchant";
        MerchantModel *model = [_MerchantItems objectAtIndex:indexPath.row];
        MerchantCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
        if (cell == nil) {
            cell = [[MerchantCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:identifier];
        }
        [cell setMerchantModel:model andTarget:self];
        
        return cell;
    }
}


-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section==0) {
        
        return 40;
        
    }
    else
    {
        return 80;
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
   // [self downloadDataWithPage:self.page isMore:YES];
    NSLog(@"上拉加载");
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
