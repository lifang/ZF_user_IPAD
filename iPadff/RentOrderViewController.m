//
//  RentOrderViewController.m
//  ZFUB
//
//  Created by 徐宝桥 on 15/3/18.
//  Copyright (c) 2015年 ___MyCompanyName___. All rights reserved.
//

#import "RentOrderViewController.h"
#import "PayWayViewController.h"
//#import "AddressTableViewCell.h"
#import "KxMenu.h"
#import "RegularFormat.h"
#import "CityHandle.h"
#import "NetworkInterface.h"
#import "AppDelegate.h"
#import "RentDescriptionController.h"
#import "POSAddressTableViewCell.h"
@interface RentOrderViewController ()<UITextFieldDelegate,UIPickerViewDataSource,UIPopoverPresentationControllerDelegate,UIPickerViewDelegate,UIAlertViewDelegate,UIActionSheetDelegate,UIPopoverControllerDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate>



@property (nonatomic, strong) UIButton *typeBtn;

@property (nonatomic, strong) UIView *detailFooterView;
@property (nonatomic, strong) UIPickerView *pickerView;

@property (nonatomic, strong) UIToolbar *toolbar;

@property (nonatomic, strong) NSArray *cityArray;  //pickerView 第二列

@property (nonatomic, strong) NSString *selectedCityID;


@property(nonatomic,strong) UIPopoverController *popViewController;



@property (nonatomic, assign) int count;

@property (nonatomic, strong) UITextField *numberField;

@property (nonatomic, strong) UIButton *addButton;
@property (nonatomic, strong) UIButton *minusButton;

@end

@implementation RentOrderViewController
@synthesize addressLabel;

@synthesize addressView;
@synthesize nameLabel;
@synthesize phoneLabel;
@synthesize billBtn;
@synthesize billField;
@synthesize billType;
@synthesize pushWay;
@synthesize reviewField;
- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"租赁订单确认";
    [self updatPrice];

    // Do any additional setup after loading the view.
    _count = 1;
    [self initSubView];
    
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
    [self.navigationController popViewControllerAnimated:YES];
    
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)needBill:(id)sender {
    isneedpp = !isneedpp;
    [self.tableView reloadData];
    NSLog(@"%d",self.billBtn.selected);
    
    
}
//- (void)btnSetSelected {
//    if ( self.billBtn.selected) {
//        [ self.billBtn setBackgroundImage:kImageName(@"btn_selected.png") forState:UIControlStateNormal];
//    }
//    else {
//        [self.billBtn setBackgroundImage:kImageName(@"btn_unselected.png") forState:UIControlStateNormal];
//    }
//}
- (IBAction)billType:(id)sender {
    NSMutableArray *listArray = [NSMutableArray arrayWithObjects:
                                 [KxMenuItem menuItem:@"公司"
                                                image:nil
                                               target:self
                                               action:@selector(selectBillType:)
                                        selectedTitle:nil
                                                  tag:1],
                                 [KxMenuItem menuItem:@"个人"
                                                image:nil
                                               target:self
                                               action:@selector(selectBillType:)
                                        selectedTitle:nil
                                                  tag:2],
                                 nil];
    CGRect factRect = [[_typeBtn superview] convertRect:_typeBtn.frame toView:self.view];
    CGRect rect = CGRectMake(factRect.origin.x + factRect.size.width / 2, factRect.origin.y+20, 0, 0);
    [KxMenu showMenuInView:self.view fromRect:rect menuItems:listArray];
}

- (IBAction)selectBillType:(KxMenuItem *)sender {
    if (sender.tag == 1) {
        self.billType = BillTypeCompany;
        [_typeBtn setTitle:@"公司" forState:UIControlStateNormal];
    }
    else {
        self.billType = BillTypePerson;
        [_typeBtn setTitle:@"个人" forState:UIControlStateNormal];
    }
}



- (void)initSubView {
    _numberField = [[UITextField alloc] init];
    _numberField.delegate = self;
    _numberField.layer.borderWidth = 1;
    _numberField.layer.borderColor = kColor(193, 192, 192, 1).CGColor;
    _numberField.borderStyle = UITextBorderStyleNone;
    _numberField.font = [UIFont systemFontOfSize:12.f];
    _numberField.textAlignment = NSTextAlignmentCenter;
    _numberField.leftViewMode = UITextFieldViewModeAlways;
    _numberField.rightViewMode = UITextFieldViewModeAlways;
    
    _minusButton = [UIButton buttonWithType:UIButtonTypeCustom];
    _minusButton.backgroundColor = [UIColor redColor];
    _minusButton.frame = CGRectMake(0, 0, 40, 40);
    [_minusButton setBackgroundImage:kImageName(@"numberback.png") forState:UIControlStateNormal];
    [_minusButton setTitle:@"-" forState:UIControlStateNormal];
    [_minusButton addTarget:self action:@selector(countMinus:) forControlEvents:UIControlEventTouchUpInside];
    [_minusButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    _numberField.leftView = _minusButton;
    
    _addButton = [UIButton buttonWithType:UIButtonTypeCustom];
    _addButton.frame = CGRectMake(0, 0, 40, 40);
    [_addButton setBackgroundImage:kImageName(@"numberback.png") forState:UIControlStateNormal];
    [_addButton setTitle:@"+" forState:UIControlStateNormal];
    [_addButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [_addButton addTarget:self action:@selector(countAdd:) forControlEvents:UIControlEventTouchUpInside];
    _numberField.rightView = _addButton;
}

#pragma mark - Request
- (BOOL) isBlankString:(NSString *)string {
    if (string == nil || string == NULL) {
        return YES;
    }
    if ([string isKindOfClass:[NSNull class]]) {
        return YES;
    }
    if ([[string stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]] length]==0) {
        return YES;
    }
    return NO;
}

- (void)createOrderForBuy {
    
    //是否需要发票
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
    hud.labelText = @"加载中...";
    AppDelegate *delegate = [AppDelegate shareAppDelegate];
    NSString*addressID;
    if(B==0)
    {
        if(self.ishaveaddress)
        {
            for (int i = 0; i < [addressarry count]; i++) {
                AddressModel *model =[addressarry objectAtIndex:i];
                
                if ([model.isDefault intValue] == AddressDefault) {
                    addressID=model.addressID;
                    
                    break;
                }
            }
            
            
        }
        else
        {
            if(addressarry.count>0)
            {
                AddressModel *model =[addressarry objectAtIndex:0];
                
                addressID=model.addressID;
            }
            
            
            
            
        }
        

       
    
    }
    else
    {
        AddressModel *model =[addressarry objectAtIndex:B-1];

        addressID=model.addressID;
        
    
    }
    if(!addressID)
    {
        
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
        hud.customView = [[UIImageView alloc] init];
        hud.mode = MBProgressHUDModeCustomView;
        [hud hide:YES afterDelay:1.f];
        hud.labelText = @"请选择地址";
        return;
        
        
    }


    [NetworkInterface createOrderFromGoodRentWithToken:delegate.token userID:delegate.userID goodID:_goodDetail.goodID channelID:_goodDetail.defaultChannel.channelID count:_count addressID:addressID comment:self.reviewField.text needInvoice:0 invoiceType:0 invoiceInfo:nil finished:^(BOOL success, NSData *response) {
        hud.customView = [[UIImageView alloc] init];
        hud.mode = MBProgressHUDModeCustomView;
        [hud hide:YES afterDelay:0.3f];
        if (success)
          {
            NSLog(@"!!%@",[[NSString alloc] initWithData:response encoding:NSUTF8StringEncoding]);
            id object = [NSJSONSerialization JSONObjectWithData:response options:NSJSONReadingMutableLeaves error:nil];
            if ([object isKindOfClass:[NSDictionary class]])
            {
                NSString *errorCode = [object objectForKey:@"code"];
                if ([errorCode intValue] == RequestFail) {
                    //返回错误代码
                    hud.labelText = [NSString stringWithFormat:@"%@",[object objectForKey:@"message"]];
                }
                else if ([errorCode intValue] == RequestSuccess)
                {
                    [hud hide:YES];
                    NSString *orderID = [NSString stringWithFormat:@"%@",[object objectForKey:@"result"]];

                    [[NSNotificationCenter defaultCenter] postNotificationName:RefreshShoppingCartNotification object:nil];
                    PayWayViewController *payWayC = [[PayWayViewController alloc] init];
                    payWayC.totalPrice = [self getSummaryPrice];
                    payWayC.hidesBottomBarWhenPushed =  YES ;
                    payWayC.orderID = orderID;
                    payWayC.goodName = _goodDetail.goodName;
                    payWayC.fromType = PayWayFromGood;
                    payWayC.ordertype=2;

                    [self.navigationController pushViewController:payWayC animated:YES];
                }
                else if ([errorCode intValue] == -2)
                {
                
                    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
                    hud.customView = [[UIImageView alloc] init];
                    hud.mode = MBProgressHUDModeCustomView;
                    [hud hide:YES afterDelay:1.f];
                    hud.labelText = [object objectForKey:@"message"];
                    
                
                
                }
            }
            else
            {
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

- (CGFloat)getSummaryPrice {
    return (_goodDetail.defaultChannel.openCost + _goodDetail.deposit) * _count;
}

#pragma mark - Data

- (void)updatPrice {
    self.payLabel.text = [NSString stringWithFormat:@"实付：￥%.2f",[self getSummaryPrice]];
    self.deliveryLabel.text = [NSString stringWithFormat:@"(含开通费：￥%.2f)",_goodDetail.defaultChannel.openCost*_count];
}

//计算总价




#pragma mark - Action
- (IBAction)scanProtocol:(id)sender {
    RentDescriptionController *descC = [[RentDescriptionController alloc] init];
    descC.goodDetail = _goodDetail;
    descC.hidesBottomBarWhenPushed =  YES ;

    [self.navigationController pushViewController:descC animated:YES];
}
- (IBAction)ensureOrder:(id)sender {
    if (!isneedpp) {
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
        hud.customView = [[UIImageView alloc] init];
        hud.mode = MBProgressHUDModeCustomView;
        [hud hide:YES afterDelay:1.f];
        hud.labelText = @"请同意租赁协议";
        return;
    }
    [self createOrderForBuy];
}
- (IBAction)countMinus:(id)sender {
    BOOL isNumber = [RegularFormat isNumber:_numberField.text];
    if (isNumber) {
        int currentCount = [_numberField.text intValue];
        if (currentCount > 1) {
            currentCount--;
            _numberField.text = [NSString stringWithFormat:@"%d",currentCount];
            _count = currentCount;
            [self updatPrice];
            [self.tableView reloadData];
        }
        else {
            
        }
    }
    else {
        _numberField.text = [NSString stringWithFormat:@"%d",_count];
    }
}

- (IBAction)countAdd:(id)sender {
    BOOL isNumber = [RegularFormat isNumber:_numberField.text];
    if (isNumber) {
        int currentCount = [_numberField.text intValue];
        currentCount++;
        _numberField.text = [NSString stringWithFormat:@"%d",currentCount];
        _count = currentCount;
        [self updatPrice];
        [self.tableView reloadData];
    }
    else {
        _numberField.text = [NSString stringWithFormat:@"%d",_count];
    }
}

#pragma mark - UITextField
#pragma mark - UITextField
-(void)textFieldDidEndEditing:(UITextField *)textField
{
    
    if(textField==self.billField )
    {
        
        
    }
    if(textField==self.reviewField)
    {
        textnsstring=textField.text;
        
        
    }
    
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    
    
    BOOL isNumber = [RegularFormat isNumber:_numberField.text];
    if (isNumber && [_numberField.text intValue] > 0) {
        int currentCount = [_numberField.text intValue];
        _numberField.text = [NSString stringWithFormat:@"%d",currentCount];
        _count = currentCount;
        [self updatPrice];
        [self.tableView reloadData];
    }
    else {
        _numberField.text = [NSString stringWithFormat:@"%d",_count];
    }
    return YES;
}

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
    self.editingField = textField;
    return YES;
}
- (void)handleKeyboardDidShow:(NSNotification *)paramNotification {
    //获取键盘高度
    CGRect keyboardRect = [[[paramNotification userInfo] objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue];
    CGRect fieldRect = [[self.editingField superview] convertRect:self.editingField.frame toView:self.view];
    CGFloat topHeight = self.navigationController.navigationBar.frame.size.height + [[UIApplication sharedApplication] statusBarFrame].size.height;
    CGFloat offsetY = keyboardRect.size.height - (kScreenHeight - topHeight - fieldRect.origin.y - fieldRect.size.height);
    self.primaryPoint = self.tableView.contentOffset;
    if (offsetY > 0 && self.offset == 0) {
        self.offset = offsetY;
        [self.tableView setContentOffset:CGPointMake(0, self.primaryPoint.y + self.offset) animated:YES];
    }
}

- (void)handleKeyboardDidHidden {
    if (self.offset != 0) {
        [self.tableView setContentOffset:CGPointMake(0, self.primaryPoint.y) animated:YES];
        self.offset = 0;
    }
}

- (void)scrollViewWillBeginDecelerating:(UIScrollView *)scrollView {
    if (self.editingField) {
        self.offset = 0;
        [self.editingField resignFirstResponder];
    }
}


#pragma mark - UITableView
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.section==0)
    {
        
        
        
        B=indexPath.row+1;
        
        
        
        
    }
    [self.tableView reloadData];
    
}
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
        
        UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, wide, hearderHeight)];
        headerView.backgroundColor = [UIColor whiteColor];
        
        
        
        UILabel*addresslable=[[UILabel alloc]initWithFrame:CGRectMake(20, 10, 80, 30)];
        [headerView addSubview:addresslable];
        
        addresslable.text=@"选择地址";
        self.addressView = [[UIView alloc] initWithFrame:CGRectMake(20, 50, wide-40, 20)];
        self.addressView.backgroundColor = kColor(235, 233, 233, 1);
        [headerView addSubview: self.addressView];
        
        
        self.nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(70, 0, 60, 20.f)];
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
        
        self.addressLabel = [[UILabel alloc] initWithFrame:CGRectMake(400, 0, 300, 20)];
        self.addressLabel.numberOfLines = 2;
        self.addressLabel.backgroundColor = [UIColor clearColor];
        self.addressLabel.font = [UIFont systemFontOfSize:14.f];
        [self.addressView addSubview:self.addressLabel];
        self.addressLabel.text=@"详细地址";
        UILabel*postlable=[[UILabel alloc]initWithFrame:CGRectMake(wide-120-140, 0, 60, 20)];
        [self.addressView addSubview:postlable];
        postlable.textAlignment = NSTextAlignmentCenter;
        
        postlable.text=@"邮编";
        UILabel*phonelable=[[UILabel alloc]initWithFrame:CGRectMake(wide-140, 0, 60, 20)];
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
//        CGFloat blackViewHeight = 80.f;
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
        
        UILabel*phonelable=[[UILabel alloc]initWithFrame:CGRectMake(wide/2-40, 0, 100, 20)];
        [rootview addSubview:phonelable];
        phonelable.textAlignment = NSTextAlignmentCenter;
        
        phonelable.text=@"押金";
        UILabel*numberlable=[[UILabel alloc]initWithFrame:CGRectMake(wide-120, 0, 80, 20)];
        [rootview addSubview:numberlable];
        numberlable.textAlignment = NSTextAlignmentCenter;
        
        numberlable.text=@"租赁数量";
        
        return headerView;
        
    }
    
    
}
-(void)createui
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
    
    bigsview=[[UIImageView alloc]initWithFrame:CGRectMake(0, 0, wide, height)];
    
    [self.view addSubview:bigsview];
    bigsview.image=[UIImage imageNamed:@"backimage"];
    bigsview.userInteractionEnabled=YES;
    
    
    UIView*witeview=[[UIView alloc]initWithFrame:CGRectMake(0, 0, wide/2, wide/2)];
    witeview.backgroundColor=[UIColor whiteColor];
    witeview.center=CGPointMake(wide/2, height/2-120);
    witeview.alpha=1;
    
    [bigsview addSubview:witeview];
    
    
    
    UIButton *okButton = [UIButton buttonWithType:UIButtonTypeCustom];
    okButton.frame = CGRectMake(  10, 10, 30, 30);
    [okButton setImage:kImageName(@"xx.png") forState:UIControlStateNormal];
    [okButton addTarget:self action:@selector(cancelclick) forControlEvents:UIControlEventTouchUpInside];
    [witeview addSubview:okButton];
    
    UILabel*newaddress=[[UILabel alloc]initWithFrame:CGRectMake(0, 10,wide/2, 30)];
    [witeview addSubview:newaddress];
    newaddress.textAlignment = NSTextAlignmentCenter;
    
    newaddress.text=@"新增加地址";
    newaddress .font = [UIFont systemFontOfSize:20.f];
    
    UIView*lineview=[[UIView alloc]initWithFrame:CGRectMake(0, 50, wide/2, 1)];
    lineview.backgroundColor=[UIColor grayColor];
    
    [witeview addSubview:lineview];
    
    NSArray*arry=[NSArray arrayWithObjects:@"收  件  人",@"联系电话",@"邮政编码",@"所  在  地",@"详细地址", nil];
    
    for(int i=0;i<5;i++)
    {
        
        
        UILabel*newaddress=[[UILabel alloc]initWithFrame:CGRectMake(20, i*50+60,100, 40)];
        [witeview addSubview:newaddress];
        newaddress.textAlignment = NSTextAlignmentCenter;
        
        newaddress.text=[arry objectAtIndex:i];
        
        if(i==3)
        {
            _cityField = [UIButton buttonWithType:UIButtonTypeCustom];
            _cityField.frame = CGRectMake(140, i*50+60,280, 40);
            
            //            [_cityField setTitle:@"123" forState:UIControlStateNormal];
            [_cityField setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            _cityField.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
            [_cityField setImage:kImageName(@"arrow_line1") forState:UIControlStateNormal];
            CALayer *layer=[_cityField  layer];
            //是否设置边框以及是否可见
            [layer setMasksToBounds:YES];
            //设置边框圆角的弧度
            
            //设置边框线的宽
            //
            [layer setBorderWidth:1];
            //设置边框线的颜色
            [layer setBorderColor:[[UIColor grayColor] CGColor]];
            _cityField.contentEdgeInsets = UIEdgeInsetsMake(0,10, 0, 0);
            _cityField.imageEdgeInsets = UIEdgeInsetsMake(0,220,0,0);//设置image在button上的位置（上top，左left，下bottom，右right）这里可以写负值，对上写－5，那么image就象上移动5个像素
            
            
            [_cityField addTarget:self action:@selector(cityclick) forControlEvents:UIControlEventTouchUpInside];
            [witeview addSubview:_cityField];
        }
        else
        {
            UITextField*neworiginaltextfield=[[UITextField alloc]initWithFrame:CGRectMake(140, i*50+60,280, 40)];
            neworiginaltextfield.tag=i+1056;
            
            [witeview addSubview:neworiginaltextfield];
            //        neworiginaltextfield.delegate=self;
            
            CALayer *layer=[neworiginaltextfield layer];
            //是否设置边框以及是否可见
            [layer setMasksToBounds:YES];
            //设置边框圆角的弧度
            
            //设置边框线的宽
            //
            [layer setBorderWidth:1];
            //设置边框线的颜色
            [layer setBorderColor:[[UIColor grayColor] CGColor]];
            
        }
        
        
    }
    
    defaultbutton = [UIButton buttonWithType:UIButtonTypeCustom];
    defaultbutton.frame = CGRectMake(  35, 320, 30, 30);
    [defaultbutton setImage:kImageName(@"select_normal") forState:UIControlStateNormal];
    [defaultbutton addTarget:self action:@selector(setDefaultAddress) forControlEvents:UIControlEventTouchUpInside];
    [witeview addSubview:defaultbutton];
    UILabel*defaultlable=[[UILabel alloc]initWithFrame:CGRectMake(60, 320,100, 30)];
    [witeview addSubview:defaultlable];
    defaultlable.textAlignment = NSTextAlignmentCenter;
    defaultlable .font = [UIFont systemFontOfSize:14.f];
    
    defaultlable.text=@"设为默认地址";
    
    UIButton*savebutton = [UIButton buttonWithType:UIButtonTypeCustom];
    savebutton.frame = CGRectMake(  40, 400, 100, 30);
    savebutton.center=CGPointMake(wide/4, 420);
    //    savebutton.layer.cornerRadius=10;
    
    [savebutton setBackgroundImage:kImageName(@"orange.png") forState:UIControlStateNormal];
    [savebutton setTitle:@"保存" forState:UIControlStateNormal];
    [savebutton addTarget:self action:@selector(saveAddress) forControlEvents:UIControlEventTouchUpInside];
    [witeview addSubview:savebutton];
}
-(void)cityclick
{
//    _cityField.userInteractionEnabled=NO;
    UITextField*textfield=(UITextField*)[self.view viewWithTag:1056];
    
    UITextField*textfield1=(UITextField*)[self.view viewWithTag:1057];
    UITextField*textfield2=(UITextField*)[self.view viewWithTag:1058];
    UITextField*textfield3=(UITextField*)[self.view viewWithTag:1060];
    
    [textfield1 resignFirstResponder];
    [textfield2 resignFirstResponder];
    
    [textfield3 resignFirstResponder];
    
    [textfield resignFirstResponder];

    [self pickerDisplay:_cityField];
    
    
}
- (void)setDefaultAddress {
    defaultbool = !defaultbool;
    if(defaultbool)
    {
        
        [defaultbutton setImage:kImageName(@"select_height") forState:UIControlStateNormal];
        
    }
    else
    {
        [defaultbutton setImage:[UIImage imageNamed:@"select_normal"] forState:UIControlStateNormal];
        
    }
    
    
}
- (void)saveAddress {
    
    UITextField*_nameField=(UITextField*)[self.view viewWithTag:1056];
    UITextField*_phoneField=(UITextField*)[self.view viewWithTag:1057];
    UITextField*_zipField=(UITextField*)[self.view viewWithTag:1058];
    //    UITextField*_cityField=(UITextField*)[self.view viewWithTag:1059];
    
    UITextField*_detailField=(UITextField*)[self.view viewWithTag:1060];
    
    
    if (!_nameField.text || [_nameField.text isEqualToString:@""])
    {
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
        hud.customView = [[UIImageView alloc] init];
        hud.mode = MBProgressHUDModeCustomView;
        [hud hide:YES afterDelay:1.f];
        hud.labelText = @"请填写收件人姓名";
        return;
    }
    if (!_phoneField.text || [_phoneField.text isEqualToString:@""]) {
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
        hud.customView = [[UIImageView alloc] init];
        hud.mode = MBProgressHUDModeCustomView;
        [hud hide:YES afterDelay:1.f];
        hud.labelText = @"请填写收件人电话";
        return;
    }
    if (!_zipField.text || [_zipField.text isEqualToString:@""]) {
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
        hud.customView = [[UIImageView alloc] init];
        hud.mode = MBProgressHUDModeCustomView;
        [hud hide:YES afterDelay:1.f];
        hud.labelText = @"请填写邮编";
        return;
    }
    if (!_cityField.currentTitle  || [_cityField.currentTitle isEqualToString:@""]) {
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
        hud.customView = [[UIImageView alloc] init];
        hud.mode = MBProgressHUDModeCustomView;
        [hud hide:YES afterDelay:1.f];
        hud.labelText = @"请选择城市";
        return;
    }
    if (!_detailField.text || [_detailField.text isEqualToString:@""]) {
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
        hud.customView = [[UIImageView alloc] init];
        hud.mode = MBProgressHUDModeCustomView;
        [hud hide:YES afterDelay:1.f];
        hud.labelText = @"请填写详细地址";
        return;
    }
    if (!_nameField.text || [_nameField.text isEqualToString:@""]) {
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
        hud.customView = [[UIImageView alloc] init];
        hud.mode = MBProgressHUDModeCustomView;
        [hud hide:YES afterDelay:1.f];
        hud.labelText = @"修改信息不能为空";
        return;
    }
    if (!([RegularFormat isZipCode:_zipField.text])) {
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
        hud.customView = [[UIImageView alloc] init];
        hud.mode = MBProgressHUDModeCustomView;
        [hud hide:YES afterDelay:1.f];
        hud.labelText = @"请填写正确的邮编";
        return;
    }


    
    [self addAddress];
    
}

- (void)pickerDisplay:(id)sender {
    //pickerView
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
    UIViewController *sortViewController = [[UIViewController alloc] init];
    UIView *theView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 276)];
    
    _toolbar = [[UIToolbar alloc] initWithFrame:CGRectMake(0, 0, 320, 60)];
    UIBarButtonItem *cancelItem = [[UIBarButtonItem alloc] initWithTitle:@"取消" style:UIBarButtonItemStyleDone target:self action:@selector(pickerHide)];
    UIBarButtonItem *finishItem = [[UIBarButtonItem alloc] initWithTitle:@"完成"
                                                                   style:UIBarButtonItemStyleDone
                                                                  target:self
                                                                  action:@selector(modifyLocation:)];
    UIBarButtonItem *spaceItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace
                                                                               target:nil action:nil];
    [_toolbar setItems:[NSArray arrayWithObjects:cancelItem,spaceItem,finishItem, nil]];
    [theView addSubview:_toolbar];
    
    
    //    _toolbar = [[UIToolbar alloc] initWithFrame:CGRectMake(0, height - 340, wide, 44)];
    //    UIBarButtonItem *cancelItem = [[UIBarButtonItem alloc] initWithTitle:@"取消"
    //                                                                   style:UIBarButtonItemStyleDone
    //                                                                  target:self
    //                                                                  action:@selector(pickerScrollOut)];
    //    UIBarButtonItem *finishItem = [[UIBarButtonItem alloc] initWithTitle:@"完成"
    //                                                                   style:UIBarButtonItemStyleDone
    //                                                                  target:self
    //                                                                  action:@selector(modifyLocation:)];
    //    UIBarButtonItem *spaceItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace
    //                                                                               target:nil
    //                                                                               action:nil];
    //    [_toolbar setItems:[NSArray arrayWithObjects:cancelItem,spaceItem,finishItem, nil]];
    //    [self.view addSubview:_toolbar];
    _pickerView = [[UIPickerView alloc] initWithFrame:CGRectMake(0, 60, 320, 216)];
    
    //    _pickerView.backgroundColor = kColor(244, 243, 243, 1);
    _pickerView.delegate = self;
    _pickerView.dataSource = self;
    
    [theView addSubview:_pickerView];
    
    sortViewController.view = theView;
    
    _popViewController = [[UIPopoverController alloc] initWithContentViewController:sortViewController];
    [_popViewController setPopoverContentSize:CGSizeMake(320, 300) animated:YES];
    [_popViewController presentPopoverFromRect:CGRectMake(120, 0, 0, 42) inView:_cityField permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
    _popViewController.delegate = self;
    
}
- (void)pickerHide
{
    
    [_popViewController dismissPopoverAnimated:NO];
    
}

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return 2;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    if (component == 0) {
        return [[CityHandle shareProvinceList] count];
    }
    else {
        NSInteger provinceIndex = [pickerView selectedRowInComponent:0];
        NSDictionary *provinceDict = [[CityHandle shareProvinceList] objectAtIndex:provinceIndex];
        _cityArray = [provinceDict objectForKey:@"cities"];
        return [_cityArray count];
    }
}
- (IBAction)modifyLocation:(id)sender {
    
    _cityField.userInteractionEnabled=YES;

//    [self pickerScrollOut];
    NSInteger index = [_pickerView selectedRowInComponent:1];
    NSString *cityName = [[_cityArray objectAtIndex:index] objectForKey:@"name"];
    [_cityField setTitle:cityName forState:UIControlStateNormal];
    _selectedCityID = [NSString stringWithFormat:@"%@",[[_cityArray objectAtIndex:index] objectForKey:@"id"]];
    [self pickerHide];

}
- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    if (component == 0) {
        //省
        NSDictionary *provinceDict = [[CityHandle shareProvinceList] objectAtIndex:row];
        return [provinceDict objectForKey:@"name"];
    }
    else {
        //市
        return [[_cityArray objectAtIndex:row] objectForKey:@"name"];
    }
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    if (component == 0) {
        //省
        [_pickerView reloadComponent:1];
    }
}



- (void)pickerScrollOut {
    _cityField.userInteractionEnabled=YES;

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
    
    [UIView animateWithDuration:.3f animations:^{
        _toolbar.frame = CGRectMake(0, kScreenHeight, wide, 44);
        _pickerView.frame = CGRectMake(0, kScreenHeight, wide, 216);
    }];
}
- (void)addAddress {
    
    UITextField*_nameField=(UITextField*)[self.view viewWithTag:1056];
    UITextField*_phoneField=(UITextField*)[self.view viewWithTag:1057];
    UITextField*_zipField=(UITextField*)[self.view viewWithTag:1058];
    
    UITextField*_detailField=(UITextField*)[self.view viewWithTag:1060];
    
    
    AddressType isDefault = AddressOther;
    if (defaultbool) {
        isDefault = AddressDefault;
    }
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
    hud.labelText = @"提交中...";
    AppDelegate *delegate = [AppDelegate shareAppDelegate];
    [NetworkInterface addAddressWithToken:delegate.token userID:delegate.userID cityID:_selectedCityID receiverName:_nameField.text phoneNumber:_phoneField.text zipCode:_zipField.text address:_detailField.text isDefault:isDefault finished:^(BOOL success, NSData *response) {
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
                    resultint=1256956;
                    resultint=[[object objectForKey:@"result"] integerValue];
                    [hud hide:YES];
                    //                    [[NSNotificationCenter defaultCenter] postNotificationName:RefreshAddressListNotification object:nil];
                    [self  getAddressLists];
                    
                    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示信息"
                                                                    message:@"新增地址成功"
                                                                   delegate:self
                                                          cancelButtonTitle:@"确定"
                                                          otherButtonTitles:nil];
                    [alert show];
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
-(void)cancelclick
{
    
    
    [bigsview removeFromSuperview];
    
    
    
    
}
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (buttonIndex == alertView.cancelButtonIndex) {
        [bigsview removeFromSuperview];
        
    }
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section

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
    
    if(section==0)
    {
        
        UIView *footerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, wide, 60)];
        footerView.backgroundColor = [UIColor whiteColor];
        UIButton *newaddressmangerbutton = [UIButton buttonWithType:UIButtonTypeCustom];
        newaddressmangerbutton.frame = CGRectMake(wide-140, 10, 100, 40);
        [newaddressmangerbutton addTarget:self action:@selector(newbuttonclick) forControlEvents:UIControlEventTouchUpInside];
        [footerView addSubview:newaddressmangerbutton];
        //newaddressmangerbutton.layer.cornerRadius = 4.f;
        newaddressmangerbutton.layer.masksToBounds = YES;
        [newaddressmangerbutton setBackgroundImage:kImageName(@"orange.png") forState:UIControlStateNormal];
        [newaddressmangerbutton setTitle:@"新增地址" forState:UIControlStateNormal];
        newaddressmangerbutton.titleLabel.font = [UIFont systemFontOfSize:16.f];
        //此处取消地址管理
        /*
        UIButton *addressmangerbutton = [UIButton buttonWithType:UIButtonTypeCustom];
        addressmangerbutton.frame = CGRectMake(wide-260, 10, 100, 40);
        [addressmangerbutton addTarget:self action:@selector(addressbuttonclick) forControlEvents:UIControlEventTouchUpInside];
        [footerView addSubview:addressmangerbutton];
        //addressmangerbutton.layer.cornerRadius = 4.f;
        addressmangerbutton.layer.masksToBounds = YES;
        [addressmangerbutton setBackgroundImage:kImageName(@"orange.png") forState:UIControlStateNormal];
        [addressmangerbutton setTitle:@"地址管理" forState:UIControlStateNormal];
        addressmangerbutton.titleLabel.font = [UIFont systemFontOfSize:16.f];
         */
        UIView *grayview = [[UIView alloc] initWithFrame:CGRectMake(0, 59, wide, 1)];
        grayview.backgroundColor = [UIColor grayColor];
        [footerView addSubview:grayview];
        
        
        return footerView;
        
        
    }else
    {
        
        UIView *footerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, wide, 200.f)];
        footerView.backgroundColor = [UIColor whiteColor];
        
        
        UILabel *liuyanlable = [[UILabel alloc] initWithFrame:CGRectMake(20, 10,40, 30)];
        liuyanlable.font = [UIFont systemFontOfSize:16.f];
        liuyanlable.text=@"留言";
        [footerView addSubview:liuyanlable];
        
        
        self.reviewField  = [[UITextField alloc] initWithFrame:CGRectMake(60, 5,wide-160, 40)];
//        self.reviewField .borderStyle = UITextBorderStyleLine;
        self.reviewField .delegate = self;
        self.reviewField .placeholder = @"留言";
        self.reviewField .font = [UIFont systemFontOfSize:14.f];
        reviewField.text=textnsstring;
        self.reviewField.layer.cornerRadius=1.0f;
        self.reviewField.layer.masksToBounds=YES;
        self.reviewField.layer.borderColor=[[UIColor grayColor]CGColor];
        self.reviewField.layer.borderWidth= 1.0f;
        [footerView addSubview:self.reviewField ];
        self.reviewField.leftViewMode = UITextFieldViewModeAlways;
        
        UIView *v = [[UIView alloc]init];
        v.frame = CGRectMake(0, 0, 10, 44);
        self.reviewField.leftView = v;


        self.billBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        self.billBtn.frame = CGRectMake(20, 70, 28, 28);
        
        
        if ( isneedpp) {
            [ self.billBtn setBackgroundImage:kImageName(@"btn_selected.png") forState:UIControlStateNormal];
        }
        else {
            [self.billBtn setBackgroundImage:kImageName(@"btn_unselected.png") forState:UIControlStateNormal];
        }
        
        [self.billBtn addTarget:self action:@selector(needBill:) forControlEvents:UIControlEventTouchUpInside];
        [footerView addSubview:self.billBtn];
        
        UILabel *billLabel = [[UILabel alloc] initWithFrame:CGRectMake(50, 75, wide - 40, 20)];
        billLabel.backgroundColor = [UIColor clearColor];
        billLabel.font = [UIFont systemFontOfSize:16.f];
        NSString *rentInfo = @"我同意《租赁协议》";
        NSMutableAttributedString *attrString = [[NSMutableAttributedString alloc] initWithString:rentInfo];
        NSDictionary *rentAttr = [NSDictionary dictionaryWithObjectsAndKeys:
                                  [UIFont boldSystemFontOfSize:16.f],NSFontAttributeName,
                                  kColor(255, 102, 36, 1),NSForegroundColorAttributeName,
                                  nil];
        [attrString addAttributes:rentAttr range:NSMakeRange(3, [rentInfo length] - 3)];
        billLabel.attributedText = attrString;

        billLabel.userInteractionEnabled = YES;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(scanProtocol:)];
        [billLabel addGestureRecognizer:tap];
        [footerView addSubview:billLabel];
        
//        UIView *billView = [self addBillView];
//        [footerView addSubview:billView];
        return footerView;
        
        
    }
    
    
    
}

-(void)addressbuttonclick
{
    [[NSNotificationCenter defaultCenter] postNotificationName:@"addressmanger" object:self userInfo:nil];

}

-(void)newbuttonclick
{
    
    
    [self createui];
    
    
    
}

- (void)getAddressLists {
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
    hud.labelText = @"加载中...";
    AppDelegate *delegate = [AppDelegate shareAppDelegate];
    [NetworkInterface getAddressListWithToken:delegate.token usedID:delegate.userID finished:^(BOOL success, NSData *response) {
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
                    [addressarry removeAllObjects];
                    
                    [self parseAddressListDataWithDicts:object];
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

- (void)parseAddressListDataWithDicts:(NSDictionary *)dict {
    if (![dict objectForKey:@"result"] || ![[dict objectForKey:@"result"] isKindOfClass:[NSArray class]]) {
        return;
    }
    NSArray *addressList = [dict objectForKey:@"result"];
    
    for (int i = 0; i < [addressList count]; i++) {
        NSDictionary *addressDict = [addressList objectAtIndex:i];
        
        
        AddressModel *model = [[AddressModel alloc] initWithParseDictionary:addressDict];
        [addressarry addObject:model];
        
        
        if ([model.addressID integerValue]==resultint)
            
        {
            
            B=i+1;
            
            
            
            
            
            
            
        }
        if([model.addressID isEqualToString:@"1"])
            
        {
            
            B=i+1;
            
            
            
            
            
            
            
        }
        else
        {
            
            
        }
        
        
    }
    if(B==0)
    {
        B=1;
        
        
    }

    [self.tableView reloadData];
    
}
- (UIView *)addBillView {
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
    
    CGFloat billHeight = 44.f;
    UIView *billView = [[UIView alloc] initWithFrame:CGRectMake(0, 40, wide, billHeight)];
    billView.backgroundColor = [UIColor whiteColor];
    //    UIView *firstLine = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 0.5)];
    //    firstLine.backgroundColor = kColor(135, 135, 135, 1);
    //    [billView addSubview:firstLine];
    //
    //    UIView *secondLine = [[UIView alloc] initWithFrame:CGRectMake(0, billHeight - 0.5, kScreenWidth, 0.5)];
    //    secondLine.backgroundColor = kColor(135, 135, 135, 1);
    //    [billView addSubview:secondLine];
    //
    UILabel *typebillLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 20, 80, 40)];
    //    billLabel.font = [UIFont systemFontOfSize:13.f];
    typebillLabel.text = @"发票类型";
    [billView addSubview:typebillLabel];
    _typeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _typeBtn.frame = CGRectMake(100, 20, 120, 44);
    _typeBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    _typeBtn.contentEdgeInsets = UIEdgeInsetsMake(0,10, 0, 0);
    
    _typeBtn.titleLabel.font = [UIFont systemFontOfSize:16.f];
    [_typeBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [_typeBtn setTitle:@"公司" forState:UIControlStateNormal];
    [_typeBtn setBackgroundImage:kImageName(@"typekill") forState:UIControlStateNormal];
    [_typeBtn addTarget:self action:@selector(billType:) forControlEvents:UIControlEventTouchUpInside];
    //    _typeBtn.imageEdgeInsets = UIEdgeInsetsMake(0, 50, 0, 0);
    //    _typeBtn.titleEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 10);
    [billView addSubview:_typeBtn];
    
    
    UILabel *billLabel = [[UILabel alloc] initWithFrame:CGRectMake(wide/2, 20, 80, 44)];
    billLabel.backgroundColor = [UIColor clearColor];
    billLabel.font = [UIFont systemFontOfSize:16.f];
    billLabel.text = @"发票抬头";
    billLabel.userInteractionEnabled = YES;
    [billView addSubview:billLabel];
    self.billField = [[UITextField alloc] initWithFrame:CGRectMake(wide/2+90, 20, wide/2 - 120, billHeight)];
    self.billField .delegate = self;
    self.billField .placeholder = @"     请输入发票抬头";
    
    //  self.billField.textInputMode= UIEdgeInsetsMake(0, 0, 0, 10);
    
    self.billField .font = [UIFont systemFontOfSize:16.f];
    self.billField .clearButtonMode = UITextFieldViewModeWhileEditing;
    [billView addSubview:self.billField ];
    CALayer *layer=[self.billField  layer];
    //是否设置边框以及是否可见
    [layer setMasksToBounds:YES];
    //设置边框圆角的弧度
    
    //设置边框线的宽
    //
    [layer setBorderWidth:1];
    //设置边框线的颜色
    [layer setBorderColor:[[UIColor grayColor] CGColor]];
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
        return 2;
        
        
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    [self updatPrice];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    if(indexPath.section==0)
    {
        
        static NSString *cellIdentifier = @"Cell";
        
       // AddressTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
        POSAddressTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];

        if (!cell)
        {
           // cell = [[AddressTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier] ;
             cell = [[POSAddressTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier] ;
        }
        AddressModel *model =[addressarry objectAtIndex:indexPath.row];
        
        cell.namelabel.text=model.addressReceiver;
        cell.addresslable.text=model.address;
        cell.phonelable.text=model.addressPhone;
        cell.postlable.text=model.zipCode;
        cell.citylable.text=[CityHandle getCityNameWithCityID:model.cityID];
        
        
        if(B>0)
        {
            if(indexPath.row==B-1)
        {
            cell.logoImageView.image=kImageName(@"select_height") ;
            cell.logoabel.text=@"";
            
            
        }
        else
        {
            cell.logoImageView.image=kImageName(@"") ;
            cell.logoabel.text=@"";
            
            
        }
            
            
        }
        
        else
        {
            if(self.ishaveaddress)
            {
                if([model.isDefault isEqualToString:@"1"])
                {
                    cell.logoabel.text=@"默认";
                    cell.logoImageView.image=kImageName(@"select_height") ;
                    
                    
                }
                else
                {
                    cell.logoabel.text=@"";
                    
                    cell.logoImageView.image=kImageName(@"") ;
                    
                }
                
                
            }else
            {
                
                if(indexPath.row==0)
                {
                    cell.logoabel.text=@"";
                    cell.logoImageView.image=kImageName(@"select_height") ;
                    
                    
                }
                else
                {
                    cell.logoabel.text=@"";
                    
                    cell.logoImageView.image=kImageName(@"") ;
                    
                }
                
                
            }
            
            
            
        }
        
        
        return cell;
        
        
        
    }else
    {
        
        if (indexPath.row == 1) {
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
            
            UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
            //            int count = [self getSummaryCount];
            CGFloat price = [self getSummaryPrice];
            UILabel *totalLabels = [[UILabel alloc] initWithFrame:CGRectMake(20, 20, wide-40, 60)];
            totalLabels.backgroundColor = kColor(235, 233, 233, 1);
            //            totalLabel.font = [UIFont systemFontOfSize:11.f];
            [cell.contentView addSubview:totalLabels];
            
            UILabel *maxLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 20, 130, 30)];
            maxLabel.backgroundColor = [UIColor clearColor];
            maxLabel.font = [UIFont systemFontOfSize:16.f];
            maxLabel.adjustsFontSizeToFitWidth = YES;
            maxLabel.text = [NSString stringWithFormat:@"最长租赁时间：%@月",_goodDetail.maxTime];
            [cell.contentView addSubview:maxLabel];
            
            UILabel *minLabel = [[UILabel alloc] initWithFrame:CGRectMake(160, 20, 130, 30)];
            minLabel.backgroundColor = [UIColor clearColor];
            minLabel.font = [UIFont systemFontOfSize:16.f];
            minLabel.adjustsFontSizeToFitWidth = YES;
            minLabel.text = [NSString stringWithFormat:@"最短租赁时间：%@月",_goodDetail.minTime];
            [cell.contentView addSubview:minLabel];

          
            UILabel *totalLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 50, 130, 30)];
            totalLabel.backgroundColor = [UIColor clearColor];
                   totalLabel.font = [UIFont systemFontOfSize:16.f];
            totalLabel.adjustsFontSizeToFitWidth = YES;
            totalLabel.text = [NSString stringWithFormat:@"共计：%d件商品",_count];
            [cell.contentView addSubview:totalLabel];
            
            UILabel *deliveryLabel = [[UILabel alloc] initWithFrame:CGRectMake(160, 50, 130, 30)];
            deliveryLabel.backgroundColor = [UIColor clearColor];
                     deliveryLabel.font = [UIFont systemFontOfSize:16.f];
            deliveryLabel.adjustsFontSizeToFitWidth = YES;
            deliveryLabel.text = [NSString stringWithFormat:@"开通费：￥%.2f",_goodDetail.defaultChannel.openCost*_count];
            [cell.contentView addSubview:deliveryLabel];
            
            
            
            UILabel *priceLabel = [[UILabel alloc] initWithFrame:CGRectMake(wide-200, 50,180, 30)];
            priceLabel.backgroundColor = [UIColor clearColor];
                     priceLabel.font = [UIFont boldSystemFontOfSize:16.f];
            priceLabel.adjustsFontSizeToFitWidth = YES;
            priceLabel.text = [NSString stringWithFormat:@"合计：￥%.2f",price];
            [cell.contentView addSubview:priceLabel];
            priceLabel.textAlignment = NSTextAlignmentRight;
            
//            self.reviewField.frame = CGRectMake(10, 40, wide - 20, 32);
//            [cell.contentView addSubview:self.reviewField];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            
            return cell;
        }
        else {
            static NSString *orderIdentifier = @"orderIdentifier";
            OrderDetailCell *cell = [tableView dequeueReusableCellWithIdentifier:orderIdentifier];
            if (cell == nil) {
                cell = [[OrderDetailCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:orderIdentifier];
            }
            cell.nameLabel.text = _goodDetail.goodName;
            cell.priceLabel.text = [NSString stringWithFormat:@"￥%.2f",_goodDetail.deposit];
            //            cell.numberLabel.text = [NSString stringWithFormat:@"X %d",_count];
            cell.brandLabel.text = [NSString stringWithFormat:@"品牌型号 %@%@",_goodDetail.goodBrand,_goodDetail.goodModel];
            cell.channelLabel.text = [NSString stringWithFormat:@"支付通道 %@",_goodDetail.defaultChannel.channelName];
            if ([_goodDetail.goodImageList count] > 0) {
                [cell.pictureView sd_setImageWithURL:[NSURL URLWithString:[_goodDetail.goodImageList objectAtIndex:0]]
                                    placeholderImage:kImageName(@"test1.png")];
            }
            if(iOS7)
            {
                _numberField.frame = CGRectMake(SCREEN_HEIGHT - 170, 30, 140, 40);
                
            }else
            {
                
                _numberField.frame = CGRectMake(SCREEN_WIDTH - 170, 30, 140, 40);
                
            }
            
            cell.linlable.hidden=YES;
            
            [cell.contentView addSubview:_numberField];
            _numberField.text = [NSString stringWithFormat:@"%d",_count];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            
            
            
            
            
            
            
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
        return 200;
        
        
    }}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if(indexPath.section==0)
    {return 40;
        
        
    }else
    {
        if (indexPath.row == 1) {
            return 130.f;
        }
        return kOrderDetailCellHeight;
    }
    
}


@end
