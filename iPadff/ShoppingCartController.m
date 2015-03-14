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

@interface ShoppingCartController ()<UITableViewDataSource,UITableViewDelegate,ShoppingCartDelegate,SelectedShopCartDelegate>

@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, strong) ShoppingCartFooterView *bottomView;

@property (nonatomic, strong) NSMutableArray *dataItem;

@end

@implementation ShoppingCartController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
//    self.title = @"购  物  车      ";
    [self initAndLayoutUI];
    _dataItem = [[NSMutableArray alloc] init];
    [self getShoppingList];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UI



- (void)initAndLayoutUI {
  
    
    if(iOS7)
    {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_HEIGHT-64, SCREEN_WIDTH-64) style:UITableViewStyleGrouped];

    }else
    {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH-64, SCREEN_HEIGHT-64) style:UITableViewStyleGrouped];

    
    }
    
//    _tableView.translatesAutoresizingMaskIntoConstraints = NO;
    _tableView.backgroundColor = [UIColor whiteColor];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    [self.view addSubview:_tableView];
    }

#pragma mark - Data

- (void)getShoppingList {
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
    hud.labelText = @"加载中...";
    AppDelegate *delegate = [AppDelegate shareAppDelegate];
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
     summaryPrice = 0.f;
    sumall=0;
    
    for (ShoppingCartModel *model in _dataItem) {
        if (model.isSelected) {
            summaryPrice += (model.cartPrice + model.channelCost) * model.cartCount;
            sumall +=  model.cartCount ;

        }
    }
    _bottomView.totalLabel.text = [NSString stringWithFormat:@"合计：￥%.2f",summaryPrice];
    [_tableView reloadData];
}

#pragma mark - Action

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
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{ CGFloat wide;
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
    UIView*vieu=[[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 60)];
    UILabel*la=[[UILabel alloc]initWithFrame:CGRectMake(60, 30, 80, 30)];
    [vieu addSubview:la];
    UIView *line = [[UIView alloc] initWithFrame:CGRectMake(0, 60, wide, 1)];
    line.backgroundColor = kColor(188, 187, 187, 1);
    [vieu addSubview:line];

    la.text=@"购物车";
    
    return vieu;
    
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
    UIView*samallview=[[UIView alloc]initWithFrame:CGRectMake(0, 5, wide, 40)];
    
    samallview.backgroundColor = kColor(235, 233, 233, 1);
    
    [rootview addSubview:samallview];

    UIView *line = [[UIView alloc] initWithFrame:CGRectMake(0, 0, wide, 1)];
    line.backgroundColor = kColor(188, 187, 187, 1);
    [rootview addSubview:line];
    
    
    _finishButton = [UIButton buttonWithType:UIButtonTypeCustom];
    _finishButton.frame=CGRectMake(wide-120, 70, 100, 40);
//    _finishButton.layer.cornerRadius = 4;
    _finishButton.layer.masksToBounds = YES;
    _finishButton.titleLabel.font = [UIFont systemFontOfSize:16.f];
    [_finishButton setTitle:@"结算" forState:UIControlStateNormal];
    [_finishButton addTarget:self action:@selector(orderConfirm:) forControlEvents:UIControlEventTouchUpInside];

    [_finishButton setBackgroundImage:[UIImage imageNamed:@"orange.png"] forState:UIControlStateNormal];
    [rootview addSubview:_finishButton];
    //选中按钮
    _selectedButton = [UIButton buttonWithType:UIButtonTypeCustom];
    _selectedButton.frame=CGRectMake(20, 10, 30, 30);
    
    [_selectedButton addTarget:self action:@selector(selectedAll) forControlEvents:UIControlEventTouchUpInside];
    [rootview addSubview:_selectedButton];
    _deleteButton = [UIButton buttonWithType:UIButtonTypeCustom];
    _deleteButton.frame=CGRectMake(20, 50, 30, 30);

//    _deleteButton.layer.cornerRadius = 4.f;
    _deleteButton.layer.masksToBounds = YES;
    [_deleteButton setImage:kImageName(@"delete.png") forState:UIControlStateNormal];
    [_deleteButton addTarget:self action:@selector(deleteOrder) forControlEvents:UIControlEventTouchUpInside];
    [rootview addSubview:_deleteButton];

    //全选文字
    _selectedLabel = [[UILabel alloc]  initWithFrame:CGRectMake(60, 10, 30, 30)];
    
    _selectedLabel.backgroundColor = [UIColor clearColor];
    _selectedLabel.font = [UIFont systemFontOfSize:15.f];
    _selectedLabel.textColor = kColor(128, 126, 126, 1);
    _selectedLabel.text = @"全选";
    UILabel*deletelable = [[UILabel alloc]  initWithFrame:CGRectMake(60, 50, 30, 30)];
    
    deletelable.backgroundColor = [UIColor clearColor];
    deletelable.font = [UIFont systemFontOfSize:15.f];
    deletelable.textColor = kColor(128, 126, 126, 1);
    deletelable.text = @"删除";
    [rootview addSubview:deletelable];

    if (isSelecteds) {
        
        [_selectedButton setBackgroundImage:kImageName(@"select_height") forState:UIControlStateNormal];
        _selectedLabel.textColor = [UIColor blackColor];
    }
    else {
        
        [_selectedButton setBackgroundImage:kImageName(@"select_normal") forState:UIControlStateNormal];
        _selectedLabel.textColor = kColor(128, 126, 126, 1);
    }

    _selectedLabel.userInteractionEnabled = YES;
    [rootview addSubview:_selectedLabel];
    
    _numbertotalLabel = [[UILabel alloc]  initWithFrame:CGRectMake(wide-140, 10, 120, 30)];
    
    _numbertotalLabel.font = [UIFont boldSystemFontOfSize:16.f];
    _numbertotalLabel.text = [NSString stringWithFormat:@"共计：￥%d件",sumall];

    [rootview addSubview:_numbertotalLabel];
    
    
    
    _totalLabel = [[UILabel alloc] initWithFrame:CGRectMake(wide-280, 70, 160, 25)];
    
    _totalLabel.backgroundColor = [UIColor clearColor];
    
    
    _totalLabel.font = [UIFont boldSystemFontOfSize:17.f];
    _totalLabel.textAlignment = NSTextAlignmentCenter;
    _totalLabel.text =[NSString stringWithFormat:@"合计：￥%.2f",summaryPrice];
    [rootview addSubview:_totalLabel];
    //文字
    UILabel *detailLabel = [[UILabel alloc] initWithFrame:CGRectMake(wide-240, 95, 100, 15)];
    detailLabel.backgroundColor = [UIColor clearColor];
    detailLabel.font = [UIFont systemFontOfSize:12.f];
    detailLabel.textAlignment = NSTextAlignmentRight;
    detailLabel.text = @"(不含配送费)";
    [rootview addSubview:detailLabel];
    return rootview;
    

}// custom view for footer. will be adjusted to default or specified footer height
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

- (void)deleteOrder
 {
     
     
     
}

- (void)selectedAll {
    NSLog(@"%hhd", _selectedButton.selected);
    
    isSelecteds = !isSelecteds;
    
        [self selectedAllShoppingCart:isSelecteds];

}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 60;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 120;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    ShoppingCartCell *cell = (ShoppingCartCell *)[tableView cellForRowAtIndexPath:indexPath];
    [cell selectedOrder:nil];
    //计算总价
    [self getSummaryPrice];
}


#pragma mark - ShoppingCartDelegate

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
    
    [_tableView reloadData];

    [self updateShoppingCartWithCart:cell.cartData
                            newCount:[cell.numberField.text intValue]];
}

- (void)addCountForCell:(ShoppingCartCell *)cell {
    

    [self updateShoppingCartWithCart:cell.cartData
                            newCount:[cell.numberField.text intValue]];
}

- (void)deleteOrderForCell:(ShoppingCartCell *)cell {
    
}

- (void)updateShoppingCartWithCart:(ShoppingCartModel *)cart
                          newCount:(int)count {
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
    hud.labelText = @"更新中...";
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

- (void)selectedAllShoppingCart:(BOOL)isSelected {
    for (ShoppingCartModel *model in _dataItem)
    {
        model.isSelected = isSelected;
    }
    [_tableView reloadData];
    [self getSummaryPrice];
}

@end
