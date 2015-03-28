//
//  ShoppingCartController.m
//  ZFUB
//
//  Created by 徐宝桥 on 15/1/23.
//  Copyright (c) 2015年 ___MyCompanyName___. All rights reserved.
//

#import "ShoppingCartController.h"
#import "ShoppingCartCell.h"
#import "ShoppingCartFooterView.h"
#import "NetworkInterface.h"
#import "AppDelegate.h"
#import "ShoppingCartModel.h"
#import "ShoppingCartOrderController.h"
#import "RefreshView.h"

@interface ShoppingCartController ()<UITableViewDataSource,UITableViewDelegate,ShoppingCartDelegate,SelectedShopCartDelegate,RefreshDelegate>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) UIButton *selectedButtonss;

@property (nonatomic, strong) ShoppingCartFooterView *bottomView;

@property (nonatomic, strong) NSMutableArray *dataItem;

@property (nonatomic, strong) RefreshView *topRefreshView;

@property (nonatomic, assign) BOOL reloading;

@property (nonatomic, assign) CGFloat primaryOffsetY;

@end

@implementation ShoppingCartController
- (void)viewWillAppear:(BOOL)animated
{
    
    
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = YES;
    
}
- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    CGFloat wide;
    CGFloat height;
    if(iOS7)
    {
        wide=SCREEN_HEIGHT-60;
        height=SCREEN_WIDTH;
        
        
    }
    else
    {  wide=SCREEN_WIDTH-60;
        height=SCREEN_HEIGHT;
        
    }
    UIView*vieu=[[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 80)];
    [self.view addSubview:vieu];
    
    UILabel*la=[[UILabel alloc]initWithFrame:CGRectMake(30, 30, 80, 30)];
    [vieu addSubview:la];
    UIView *line = [[UIView alloc] initWithFrame:CGRectMake(30, 79, wide-76, 1)];
    line.backgroundColor = kColor(188, 187, 187, 1);
    [vieu addSubview:line];
    
    la.text=@"购物车";
    la.font=[UIFont systemFontOfSize:20];
    
    [self initAndLayoutUI];
    _dataItem = [[NSMutableArray alloc] init];
    [self getShoppingList];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(refreshCartList:)
                                                 name:RefreshShoppingCartNotification
                                               object:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UI


- (void)initAndLayoutUI {
    
    if(iOS7)
    {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 80, SCREEN_HEIGHT-64, SCREEN_WIDTH-64) style:UITableViewStyleGrouped];
        _topRefreshView = [[RefreshView alloc] initWithFrame:CGRectMake(0, -80, SCREEN_HEIGHT-50, 80)];

        
    }else
    {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 80, SCREEN_WIDTH-64, SCREEN_HEIGHT-64) style:UITableViewStyleGrouped];
        
        _topRefreshView = [[RefreshView alloc] initWithFrame:CGRectMake(0, -80, SCREEN_WIDTH-50, 80)];

    }
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;

    //    _tableView.translatesAutoresizingMaskIntoConstraints = NO;
    _tableView.backgroundColor = [UIColor whiteColor];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    [self.view addSubview:_tableView];
    _topRefreshView.direction = PullFromTop;
    _topRefreshView.delegate = self;
    [_tableView addSubview:_topRefreshView];
}

#pragma mark - Data

- (void)getShoppingList {
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
    hud.labelText = @"加载中...";
    AppDelegate *delegate = [AppDelegate shareAppDelegate];
    NSLog(@"%@",delegate.token);
    
    [NetworkInterface getShoppingCartWithToken:delegate.token userID:delegate.userID finished:^(BOOL success, NSData *response) {
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
                    [hud hide:YES];
                    [_dataItem removeAllObjects];
                    [self parseDataWithDictionary:object];
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
        [self refreshViewFinishedLoadingWithDirection:PullFromTop];
    }];
}

- (void)parseDataWithDictionary:(NSDictionary *)dict {
    if (![dict objectForKey:@"result"] || ![[dict objectForKey:@"result"] isKindOfClass:[NSArray class]]) {
        return;
    }
    NSArray *cartList = [dict objectForKey:@"result"];
    for (int i = 0; i < [cartList count]; i++) {
        NSDictionary *dict = [cartList objectAtIndex:i];
        ShoppingCartModel *cart = [[ShoppingCartModel alloc] initWithParseDictionary:dict];
        [_dataItem addObject:cart];
    }
    [_tableView reloadData];
}

//计算总价
- (void)getSummaryPrice {
    sumall=0;
    summaryPrice = 0.f;

    for (ShoppingCartModel *model in _dataItem) {
        if (model.isSelected) {
            summaryPrice += (model.cartPrice + model.channelCost) * model.cartCount;
            sumall +=  model.cartCount ;

        }
    }
    _totalLabel.text = [NSString stringWithFormat:@"合计：￥%.2f",summaryPrice];
    [_tableView reloadData];
    
}

#pragma mark - Action

- (IBAction)orderConfirm:(id)sender {
    NSMutableArray *selectedOrder = [[NSMutableArray alloc] init];
    for (ShoppingCartModel *model in _dataItem) {
        if (model.isSelected) {
            [selectedOrder addObject:model];
        }
    }
    if ([selectedOrder count] <= 0) {
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
        hud.customView = [[UIImageView alloc] init];
        hud.mode = MBProgressHUDModeCustomView;
        [hud hide:YES afterDelay:1.f];
        hud.labelText = @"请至少选择一件商品";
        return;
    }
    ShoppingCartOrderController *orderC = [[ShoppingCartOrderController alloc] init];
    orderC.shoppingCartItem = selectedOrder;
    orderC.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:orderC animated:YES];
}

#pragma mark - UITableView


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [_dataItem count];}



- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    ShoppingCartCell *cell = nil;
    ShoppingCartModel *cart = [_dataItem objectAtIndex:indexPath.row];
    //    if (!cart.isEditing) {
    //        cell = [tableView dequeueReusableCellWithIdentifier:shoppingCartIdentifier_normal];
    //        if (cell == nil) {
    //            cell = [[ShoppingCartCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:shoppingCartIdentifier_normal];
    //        }
    //    }
    //    else {
    cell = [tableView dequeueReusableCellWithIdentifier:shoppingCartIdentifier_edit];
    if (cell == nil) {
        cell = [[ShoppingCartCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:shoppingCartIdentifier_edit];
    }
   
    //    }
    cell.delegate = self;
    [cell setShoppingCartData:cart];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return kShoppingCartCellHeight;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    
    UIView*rootview = [[UIView alloc] init];
    
    CGFloat wide;
    CGFloat height;
    if(iOS7)
    {
        wide=SCREEN_HEIGHT-60;
        height=SCREEN_WIDTH;
        
        
    }
    else
    {  wide=SCREEN_WIDTH-60;
        height=SCREEN_HEIGHT;
        
    }
    UIView*samallview=[[UIView alloc]initWithFrame:CGRectMake(30, 10, wide-76, 40)];
    
    samallview.backgroundColor = kColor(235, 233, 233, 1);
    
    [rootview addSubview:samallview];
    
    
    
    _finishButton = [UIButton buttonWithType:UIButtonTypeCustom];
    _finishButton.frame=CGRectMake(wide-146, 70, 100, 40);
    //    _finishButton.layer.cornerRadius = 4;
    _finishButton.layer.masksToBounds = YES;
    _finishButton.titleLabel.font = [UIFont systemFontOfSize:16.f];
    [_finishButton setTitle:@"结算" forState:UIControlStateNormal];
    [_finishButton addTarget:self action:@selector(orderConfirm:) forControlEvents:UIControlEventTouchUpInside];
    
    [_finishButton setBackgroundImage:[UIImage imageNamed:@"orange.png"] forState:UIControlStateNormal];
    [rootview addSubview:_finishButton];
    //选中按钮
    _selectedButtonss = [UIButton buttonWithType:UIButtonTypeCustom];
    _selectedButtonss.frame=CGRectMake(35, 15, 30, 30);
    
    [_selectedButtonss addTarget:self action:@selector(selectedAllShoppingCart) forControlEvents:UIControlEventTouchUpInside];
    [rootview addSubview:_selectedButtonss];
    
    //全选文字
    _selectedLabel = [[UILabel alloc]  initWithFrame:CGRectMake(80, 15, 30, 30)];
    
    _selectedLabel.backgroundColor = [UIColor clearColor];
    _selectedLabel.font = [UIFont systemFontOfSize:15.f];
    _selectedLabel.textColor = kColor(128, 126, 126, 1);
    _selectedLabel.text = @"全选";
  
    
    if (isSelecteds) {
        
        [_selectedButtonss setImage:kImageName(@"select_height") forState:UIControlStateNormal];
        _selectedLabel.textColor = [UIColor blackColor];
    }
    else {
        
        [_selectedButtonss setImage:kImageName(@"select_normal") forState:UIControlStateNormal];
        _selectedLabel.textColor = kColor(128, 126, 126, 1);
    }
    
    _selectedLabel.userInteractionEnabled = YES;
    [rootview addSubview:_selectedLabel];
    
    _numbertotalLabel = [[UILabel alloc]  initWithFrame:CGRectMake(wide-150, 15, 120, 30)];
    
    _numbertotalLabel.font = [UIFont boldSystemFontOfSize:16.f];
    _numbertotalLabel.text = [NSString stringWithFormat:@"共计：￥%d件",sumall];
    
    [rootview addSubview:_numbertotalLabel];
    
    
    
    _totalLabel = [[UILabel alloc] initWithFrame:CGRectMake(wide-310, 70, 160, 25)];
    
    _totalLabel.backgroundColor = [UIColor clearColor];
    
    
    _totalLabel.font = [UIFont boldSystemFontOfSize:17.f];
    _totalLabel.textAlignment = NSTextAlignmentCenter;
    _totalLabel.text =[NSString stringWithFormat:@"合计：￥%.2f",summaryPrice];
    [rootview addSubview:_totalLabel];
    //文字
    UILabel *detailLabel = [[UILabel alloc] initWithFrame:CGRectMake(wide-270, 95, 100, 15)];
    detailLabel.backgroundColor = [UIColor clearColor];
    detailLabel.font = [UIFont systemFontOfSize:12.f];
    detailLabel.textAlignment = NSTextAlignmentRight;
    detailLabel.text = @"(不含配送费)";
    [rootview addSubview:detailLabel];
    return rootview;
    
    
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 0.00001;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 120;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    ShoppingCartCell *cell = (ShoppingCartCell *)[tableView cellForRowAtIndexPath:indexPath];
    [cell selectedOrder:nil];
    if (_cartData.isSelected) {
        [cell.selectedButton setImage:kImageName(@"select_height") forState:UIControlStateNormal];
    }
    else {
        [cell.selectedButton setImage:kImageName(@"select_normal") forState:UIControlStateNormal];
    }

    [self getSummaryPrice];
    

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
        [_topRefreshView refreshViewDidFinishedLoading:_tableView];
    }
}

- (BOOL)refreshViewIsLoading:(RefreshView *)view {
    return _reloading;
}

- (void)refreshViewDidEndTrackingForRefresh:(RefreshView *)view {
    [self refreshViewReloadData];
    //loading...
    [self getShoppingList];
}


#pragma mark - UIScrollView

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    _primaryOffsetY = scrollView.contentOffset.y;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if (scrollView == _tableView) {
        CGPoint newPoint = scrollView.contentOffset;
        if (_primaryOffsetY < newPoint.y) {

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
        }
        else {
            //下拉
            [_topRefreshView refreshViewDidEndDragging:scrollView];
        }
    }
}

#pragma mark - ShoppingCartDelegate

- (void)selectRowForCell {
    //计算总价
    [self getSummaryPrice];
}

- (void)editOrderForCell:(ShoppingCartCell *)cell {
    cell.cartData.isEditing = !cell.cartData.isEditing;
    NSArray *indexPaths = [NSArray arrayWithObjects:
                           [_tableView indexPathForCell:cell],
                           nil];
    [_tableView beginUpdates];
    [_tableView reloadRowsAtIndexPaths:indexPaths withRowAnimation:UITableViewRowAnimationAutomatic];
    [_tableView endUpdates];
}

- (void)minusCountForCell:(ShoppingCartCell *)cell {
    [self updateShoppingCartWithCart:cell.cartData
                            newCount:[cell.numberField.text intValue]];
}

- (void)addCountForCell:(ShoppingCartCell *)cell {
    [self updateShoppingCartWithCart:cell.cartData
                            newCount:[cell.numberField.text intValue]];
}

- (void)deleteOrderForCell:(ShoppingCartCell *)cell {
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
    hud.labelText = @"提交中...";
    AppDelegate *delegate = [AppDelegate shareAppDelegate];
    [NetworkInterface deleteShoppingCartWithToken:delegate.token cartID:cell.cartData.cartID finished:^(BOOL success, NSData *response) {
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
                    hud.labelText = @"删除成功";
//                    NSIndexPath *indexPath = [_tableView indexPathForCell:cell];
//                    [_dataItem removeObjectAtIndex:indexPath.section];
//                    [_tableView beginUpdates];
//                    [_tableView deleteSections:[NSIndexSet indexSetWithIndex:indexPath.section]
//                              withRowAnimation:UITableViewRowAnimationAutomatic];
//                    [_tableView endUpdates];
                    [self getShoppingList];
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

- (void)updateShoppingCartWithCart:(ShoppingCartModel *)cart
                          newCount:(int)count {
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
    hud.labelText = @"提交中...";
    AppDelegate *delegate = [AppDelegate shareAppDelegate];
    [NetworkInterface updateShoppingCartWithToken:delegate.token cartID:cart.cartID count:count finished:^(BOOL success, NSData *response) {
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
                    [hud hide:YES];
                    cart.cartCount = count;
                    [self getSummaryPrice];
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

#pragma mark - SelectedShopCartDelegate

- (void)selectedAllShoppingCart {
    isSelecteds = !isSelecteds;

    for (ShoppingCartModel *model in _dataItem) {
        model.isSelected = isSelecteds;
        NSLog(@"%d",isSelecteds);
        
    }
    [self getSummaryPrice];
}

#pragma mark - Notification 

- (void)refreshCartList:(NSNotification *)notification {
    [self getShoppingList];
}

@end
