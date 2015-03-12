//
//  ShoppingCartOrderController.m
//  ZFUB
//
//  Created by 徐宝桥 on 15/3/10.
//  Copyright (c) 2015年 ___MyCompanyName___. All rights reserved.
//

#import "ShoppingCartOrderController.h"
#import "PayWayViewController.h"
#import "AddressTableViewCell.h"
@interface ShoppingCartOrderController ()
@property (nonatomic, strong) UIButton *typeBtn;

@property (nonatomic, strong) UIView *detailFooterView;

@end

@implementation ShoppingCartOrderController

- (void)viewDidLoad {
    [super viewDidLoad];
   
    
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Request
#pragma mark - Request


- (void)createOrderForCart {
    //购物车数组
    NSMutableArray *cartsID = [[NSMutableArray alloc] init];
    for (ShoppingCartModel *model in _shoppingCartItem) {
        if (model.isSelected) {
            [cartsID addObject:[NSNumber numberWithInt:[model.cartID intValue]]];
        }
    }
    //是否需要发票
    int needInvoice = 0;
    if (self.billBtn.isSelected) {
        needInvoice = 1;
    }
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
    hud.labelText = @"加载中...";
    AppDelegate *delegate = [AppDelegate shareAppDelegate];
    [NetworkInterface createOrderFromCartWithToken:delegate.token userID:delegate.userID cartsID:cartsID addressID:self.defaultAddress.addressID comment:self.reviewField.text needInvoice:needInvoice invoiceType:self.billType invoiceInfo:self.billField.text finished:^(BOOL success, NSData *response) {
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
                    [[NSNotificationCenter defaultCenter] postNotificationName:RefreshShoppingCartNotification object:nil];
                    PayWayViewController *payWayC = [[PayWayViewController alloc] init];
                    payWayC.totalPrice = [self getSummaryPrice];
                    [self.navigationController pushViewController:payWayC animated:YES];
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

- (void)setContentsForControls {
    self.payLabel.text = [NSString stringWithFormat:@"实付：￥%.2f",[self getSummaryPrice]];
    self.deliveryLabel.text = [NSString stringWithFormat:@"(含配送费：￥%@)",@"123"];
}

//计算总价
- (CGFloat)getSummaryPrice {
    CGFloat summaryPrice = 0.f;
    for (ShoppingCartModel *model in _shoppingCartItem) {
        if (model.isSelected) {
            summaryPrice += (model.cartPrice + model.channelCost) * model.cartCount;
        }
    }
    return summaryPrice;
}

- (int)getSummaryCount {
    int count = 0;
    for (ShoppingCartModel *model in _shoppingCartItem) {
        if (model.isSelected) {
            count += model.cartCount;
        }
    }
    return count;
}

#pragma mark - Action

- (IBAction)ensureOrder:(id)sender {
    NSLog(@"!!");
    [self createOrderForCart];
}

#pragma mark - UITableView
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section

{
    if(section==0)
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
        CGFloat hearderHeight = 80.f;
        CGFloat blackViewHeight = 80.f;
        UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, wide, hearderHeight)];
        headerView.backgroundColor = [UIColor whiteColor];
        
        
        
        UILabel*addresslable=[[UILabel alloc]initWithFrame:CGRectMake(20, 10, 80, 30)];
        [headerView addSubview:addresslable];
        
        addresslable.text=@"选择地址";
        self.addressView = [[UIView alloc] initWithFrame:CGRectMake(20, 50, wide-40, 20)];
        self.addressView.backgroundColor = kColor(235, 233, 233, 1);
        [headerView addSubview: self.addressView];
        
        CGFloat topSpace = 15.f;
        CGFloat leftSpace = 20.f;
        CGFloat rightSpace = 20.f;
        self.nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(80, 0, 60, 20.f)];
        self.nameLabel.backgroundColor = [UIColor clearColor];
        self.nameLabel.font = [UIFont boldSystemFontOfSize:14.f];
        [self.addressView addSubview:self.nameLabel];
        self.nameLabel.text=@"收货人";
       self.nameLabel.textAlignment = NSTextAlignmentCenter;

        self.phoneLabel = [[UILabel alloc] initWithFrame:CGRectMake( 170, 0, 100, 20.f)];
        self.phoneLabel.backgroundColor = [UIColor clearColor];
        self.phoneLabel.font = [UIFont boldSystemFontOfSize:14.f];
        [self.addressView addSubview:self.phoneLabel];
        self.phoneLabel.text=@"所在地区";
        self.phoneLabel.textAlignment = NSTextAlignmentCenter;

        self.addressLabel = [[UILabel alloc] initWithFrame:CGRectMake(300, 0, 200, 20)];
        self.addressLabel.numberOfLines = 2;
        self.addressLabel.backgroundColor = [UIColor clearColor];
        self.addressLabel.font = [UIFont systemFontOfSize:14.f];
        [self.addressView addSubview:self.addressLabel];
        self.addressLabel.text=@"详细地址";
        UILabel*postlable=[[UILabel alloc]initWithFrame:CGRectMake(520, 0, 60, 20)];
        [self.addressView addSubview:postlable];
        postlable.textAlignment = NSTextAlignmentCenter;

          postlable.text=@"邮编";
        UILabel*phonelable=[[UILabel alloc]initWithFrame:CGRectMake(600, 0, 60, 20)];
        [self.addressView addSubview:phonelable];
        phonelable.textAlignment = NSTextAlignmentCenter;
        
        phonelable.text=@"电话";

        return headerView;

    
    }
    else
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
        CGFloat hearderHeight = 50.f;
        CGFloat blackViewHeight = 80.f;
        UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, wide, hearderHeight)];
        headerView.backgroundColor = [UIColor whiteColor];
        
        
        
        UILabel*addresslable=[[UILabel alloc]initWithFrame:CGRectMake(20, 0, 80, 30)];
        [headerView addSubview:addresslable];
        
        addresslable.text=@"商品信息";
      UIView*rootview  = [[UIView alloc] initWithFrame:CGRectMake(20, 30, wide-40, 20)];
        rootview.backgroundColor = kColor(235, 233, 233, 1);
        [headerView addSubview: rootview];
        
        
      UILabel*goodslable=[[UILabel alloc]initWithFrame:CGRectMake(100, 0, 60, 20)];
        [rootview addSubview:goodslable];
        goodslable.textAlignment = NSTextAlignmentCenter;
        
        goodslable.text=@"商品";
        
        UILabel*phonelable=[[UILabel alloc]initWithFrame:CGRectMake(600, 0, 60, 20)];
        [rootview addSubview:phonelable];
        phonelable.textAlignment = NSTextAlignmentCenter;
        
        phonelable.text=@"单价";
        UILabel*numberlable=[[UILabel alloc]initWithFrame:CGRectMake(900, 0, 60, 20)];
        [rootview addSubview:numberlable];
        numberlable.textAlignment = NSTextAlignmentCenter;
        
        numberlable.text=@"购买数量";
        
        return headerView;
        
    }
    

}
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section

{CGFloat wide;
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

if(section==0)
{
    
    UIView *footerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, wide, 60)];
    footerView.backgroundColor = [UIColor whiteColor];
    UIButton*addressmangerbutton = [UIButton buttonWithType:UIButtonTypeCustom];
    addressmangerbutton.frame = CGRectMake(wide-120, 10, 80, 40);
//    [addressmangerbutton addTarget:self action:@selector(needBill:) forControlEvents:UIControlEventTouchUpInside];
    [footerView addSubview:addressmangerbutton];
    addressmangerbutton.layer.cornerRadius = 4.f;
    addressmangerbutton.layer.masksToBounds = YES;
    [addressmangerbutton setBackgroundImage:kImageName(@"orange.png") forState:UIControlStateNormal];
    [addressmangerbutton setTitle:@"新增地址" forState:UIControlStateNormal];
    addressmangerbutton.titleLabel.font = [UIFont systemFontOfSize:16.f];
    
    UIButton*newaddressmangerbutton = [UIButton buttonWithType:UIButtonTypeCustom];
    newaddressmangerbutton.frame = CGRectMake(wide-220, 10, 80, 40);
    //    [addressmangerbutton addTarget:self action:@selector(needBill:) forControlEvents:UIControlEventTouchUpInside];
    [footerView addSubview:newaddressmangerbutton];
    newaddressmangerbutton.layer.cornerRadius = 4.f;
    newaddressmangerbutton.layer.masksToBounds = YES;
    [newaddressmangerbutton setBackgroundImage:kImageName(@"orange.png") forState:UIControlStateNormal];
    [newaddressmangerbutton setTitle:@"地址管理" forState:UIControlStateNormal];
    newaddressmangerbutton.titleLabel.font = [UIFont systemFontOfSize:16.f];
    UIView *grayview = [[UIView alloc] initWithFrame:CGRectMake(0, 59, wide, 1)];
    grayview.backgroundColor = [UIColor grayColor];
    [footerView addSubview:grayview];

    
    return footerView;


}else
{

    UIView *footerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 100.f)];
    footerView.backgroundColor = [UIColor clearColor];
    self.billBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    self.billBtn.frame = CGRectMake(20, 10, 18, 18);
    [self.billBtn setBackgroundImage:kImageName(@"btn_unselected.png") forState:UIControlStateNormal];
    [self.billBtn setBackgroundImage:kImageName(@"btn_selected.png") forState:UIControlStateHighlighted];
    [self.billBtn addTarget:self action:@selector(needBill:) forControlEvents:UIControlEventTouchUpInside];
    [footerView addSubview:self.billBtn];
    
    UILabel *billLabel = [[UILabel alloc] initWithFrame:CGRectMake(40, 10, kScreenWidth - 40, 20)];
    billLabel.backgroundColor = [UIColor clearColor];
    billLabel.font = [UIFont systemFontOfSize:13.f];
    billLabel.text = @"我要发票";
    billLabel.userInteractionEnabled = YES;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(needBill:)];
    [billLabel addGestureRecognizer:tap];
    [footerView addSubview:billLabel];
    
    UIView *billView = [self addBillView];
    [footerView addSubview:billView];
    return footerView;


}


   
}

- (UIView *)addBillView {
    CGFloat billHeight = 44.f;
    UIView *billView = [[UIView alloc] initWithFrame:CGRectMake(0, 40, kScreenWidth, billHeight)];
    billView.backgroundColor = [UIColor whiteColor];
    UIView *firstLine = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 0.5)];
    firstLine.backgroundColor = kColor(135, 135, 135, 1);
    [billView addSubview:firstLine];
    
    UIView *secondLine = [[UIView alloc] initWithFrame:CGRectMake(0, billHeight - 0.5, kScreenWidth, 0.5)];
    secondLine.backgroundColor = kColor(135, 135, 135, 1);
    [billView addSubview:secondLine];
    
    _typeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _typeBtn.frame = CGRectMake(10, 0, 60, 44);
    _typeBtn.titleLabel.font = [UIFont systemFontOfSize:13.f];
    [_typeBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [_typeBtn setTitle:@"公司" forState:UIControlStateNormal];
    [_typeBtn setImage:kImageName(@"arrow.png") forState:UIControlStateNormal];
    [_typeBtn addTarget:self action:@selector(billType:) forControlEvents:UIControlEventTouchUpInside];
    _typeBtn.imageEdgeInsets = UIEdgeInsetsMake(0, 50, 0, 0);
    _typeBtn.titleEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 10);
    [billView addSubview:_typeBtn];
    
    self.billField = [[UITextField alloc] initWithFrame:CGRectMake(80, 0, kScreenWidth - 90, billHeight)];
    self.billField .delegate = self;
    self.billField .placeholder = @"请输入发票抬头";
    self.billField .font = [UIFont systemFontOfSize:14.f];
    self.billField .clearButtonMode = UITextFieldViewModeWhileEditing;
    [billView addSubview:self.billField ];
    
    return billView;
}




- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if(section==0)
    {
        return  addressarry.count;
        
    
    }
    else
    {
        return [_shoppingCartItem count] + 1;

    
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    [self setContentsForControls];

    if(indexPath.section==0)
    {
        
        static NSString *cellIdentifier = @"Cell";
        
        AddressTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
        
        if (!cell)
        {
            cell = [[AddressTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier] ;
        }
        AddressModel *model =[addressarry objectAtIndex:indexPath.row];
        cell.namelabel.text=model.addressReceiver;
        cell.addresslable.text=model.address;
        cell.phonelable.text=model.addressPhone;
        cell.postlable.text=model.zipCode;

    
        return cell;

        
        
    }else
    {
    
        if (indexPath.row == [_shoppingCartItem count]) {
            //最后一行
            UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
            int count = [self getSummaryCount];
            CGFloat price = [self getSummaryPrice];
            UILabel *totalLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 10, 100, 20)];
            totalLabel.backgroundColor = [UIColor clearColor];
            totalLabel.font = [UIFont systemFontOfSize:11.f];
            totalLabel.adjustsFontSizeToFitWidth = YES;
            totalLabel.text = [NSString stringWithFormat:@"共计：%d件商品",count];
            [cell.contentView addSubview:totalLabel];
            
            UILabel *deliveryLabel = [[UILabel alloc] initWithFrame:CGRectMake(110, 10, 100, 20)];
            deliveryLabel.backgroundColor = [UIColor clearColor];
            deliveryLabel.font = [UIFont systemFontOfSize:11.f];
            deliveryLabel.adjustsFontSizeToFitWidth = YES;
            deliveryLabel.text = [NSString stringWithFormat:@"配送费：￥%@",@"123"];
            [cell.contentView addSubview:deliveryLabel];
            
            UILabel *priceLabel = [[UILabel alloc] initWithFrame:CGRectMake(210, 10, kScreenWidth - 220, 20)];
            priceLabel.backgroundColor = [UIColor clearColor];
            priceLabel.font = [UIFont boldSystemFontOfSize:12.f];
            priceLabel.adjustsFontSizeToFitWidth = YES;
            priceLabel.text = [NSString stringWithFormat:@"合计：￥%.2f",price];
            [cell.contentView addSubview:priceLabel];
            
            self.reviewField.frame = CGRectMake(10, 40, kScreenWidth - 20, 32);
            [cell.contentView addSubview:self.reviewField];
            return cell;
        }
        else {
            static NSString *orderIdentifier = @"orderIdentifier";
            OrderDetailCell *cell = [tableView dequeueReusableCellWithIdentifier:orderIdentifier];
            if (cell == nil) {
                cell = [[OrderDetailCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:orderIdentifier];
            }
            ShoppingCartModel *model = [_shoppingCartItem objectAtIndex:indexPath.row];
            cell.nameLabel.text = model.cartTitle;
            cell.priceLabel.text = [NSString stringWithFormat:@"￥%.2f",model.cartPrice];
            cell.numberLabel.text = [NSString stringWithFormat:@"X %d",model.cartCount];
            cell.brandLabel.text = [NSString stringWithFormat:@"品牌型号 %@",model.cartModel];
            cell.channelLabel.text = [NSString stringWithFormat:@"支付通道 %@",model.cartChannel];
            [cell.pictureView sd_setImageWithURL:[NSURL URLWithString:model.cartImagePath]
                                placeholderImage:kImageName(@"test1.png")];
            return cell;
        }

    
    }
    }
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if(section==0)
    {
        return 80;

    }else
    {
        return 50;

    
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    if(section==0)
    {
        return 60;
        
    }else
    {
        return 100;
        
        
    }}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if(indexPath.section==0)
    {return 40;
        
    
    }else
    {
        if (indexPath.row == [_shoppingCartItem count]) {
            return 90.f;
        }
        return kOrderDetailCellHeight;
    }
    
}


@end
