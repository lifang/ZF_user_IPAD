//
//  AddressViewController.m
//  iPadff
//
//  Created by 黄含章 on 15/3/13.
//  Copyright (c) 2015年 LanTaiPro. All rights reserved.
//

#import "AddressViewController.h"
#import "AddressCell.h"
#import "NetworkInterface.h"
#import "AddressModel.h"
#import "CityHandle.h"
#import "RegularFormat.h"

@interface AddressViewController ()<UITableViewDataSource,UITableViewDelegate,AddressCellDelegate,UIPickerViewDelegate,UIPickerViewDataSource,UITextFieldDelegate>

@property(nonatomic,strong)UITableView *addressTableView;

@property (nonatomic, strong) NSMutableArray *addressItems;

@property(nonatomic,strong)UIImageView *bigsview;

@property(nonatomic,strong)UIButton *cityField;

@property(nonatomic,strong)UIButton *deaultBtn;

@property (nonatomic, strong) UIToolbar *toolbar;

@property (nonatomic, strong) UIPickerView *pickerView;

@property(nonatomic,strong)NSMutableArray *cityArray;

@property(nonatomic,strong)NSString *selectedCityID;

@property(nonatomic,strong)NSString *cityID;

@property(nonatomic,strong)UITextField *nameField;
@property(nonatomic,strong)UITextField *telField;
@property(nonatomic,strong)UITextField *postcodeField;
@property(nonatomic,strong)UITextField *locationField;
@property(nonatomic,strong)UITextField *particularLocationField;


@property(nonatomic,assign)BOOL isDefault;


@end

@implementation AddressViewController

-(UITableView *)addressTableView
{
    if (!_addressTableView) {
        _addressTableView = [[UITableView alloc]initWithFrame:CGRectMake(160, 140, SCREEN_WIDTH - 160, SCREEN_HEIGHT - 140)];
 }
    return _addressTableView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.swithView setSelectedBtnAtIndex:3];
    NSLog(@"当前是~~~~~~~~~~~~%d",self.Index);
    [self.view addSubview:self.addressTableView];
    _addressTableView.frame = CGRectMake(160, 140, SCREEN_WIDTH - 160, SCREEN_HEIGHT - 140);
    NSLog(@"%@",NSStringFromCGRect(_addressTableView.frame));
//    if (iOS7) {
//        _addressTableView.frame = CGRectMake(160, 140, SCREEN_HEIGHT - 160,SCREEN_WIDTH - 140);
//    }

//    _addressTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _addressTableView.delegate = self;
    _addressTableView.dataSource = self;
    _addressItems = [[NSMutableArray alloc]init];
    [self setupFooterView];
    [self getAddressList];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)setupFooterView
{
    UIView *footView = [[UIView alloc]init];
    footView.backgroundColor = [UIColor whiteColor];
    footView.frame = CGRectMake(0, 0, 100, 60);
    UIView *line = [[UIView alloc]init];
    line.backgroundColor = kColor(239, 239, 239, 1.0);
    line.frame = CGRectMake(0, 0, SCREEN_WIDTH - 160, 1);
    if (iOS7) {
        line.frame = CGRectMake(0, 0, SCREEN_HEIGHT - 160, 1);
    }
    [footView addSubview:line];
    UIButton *addAddressBtn = [[UIButton alloc]init];
    [addAddressBtn addTarget:self action:@selector(addAddressD) forControlEvents:UIControlEventTouchUpInside];
    addAddressBtn.frame = CGRectMake(20, 10, 120, 40);
    [addAddressBtn setTitle:@"新增地址" forState:UIControlStateNormal];
    [addAddressBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [addAddressBtn setBackgroundColor:kColor(254, 79, 29, 1.0)];
    [footView addSubview:addAddressBtn];
    _addressTableView.tableFooterView = footView;
}

-(void)addAddressD
{
    [self createui];
}
#pragma mark - tableView DateSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0) {
        return 1;
    }else{
        return _addressItems.count;
    }
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        NSString *ID = @"AddressCell1";
        AddressCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
        if (cell==nil) {
            cell = [[AddressCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:ID];
        }
        cell.defaultLabel.hidden = YES;
        cell.changeBtn.hidden = YES;
        return cell;
    }else{
        AddressModel *model = [_addressItems objectAtIndex:indexPath.row];
        NSString *ID = @"AddressCell2";
        AddressCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
        if (cell == nil) {
            cell = [[AddressCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:ID];
        }
        cell.AddressCellDelegate = self;
        cell.consigneeLabel.text = model.addressReceiver;
        cell.areaLabel.text = [NSString stringWithFormat:@"%@%@",model.city_parent_name,model.city_name];
        cell.particularAddressLabel.text = model.address;
        cell.postcodeLabel.text = model.zipCode;
        cell.telLabel.text = model.addressPhone;
        cell.defaultLabel.hidden = YES;
        if ([model.isDefault isEqualToString:@"1"]) {
            cell.defaultLabel.hidden = NO;
        }
        return cell;

    }
    
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        return 25;
    }
    else
    {
        return 50;
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

#pragma mark - addressDelegate
-(void)changeBtnClicked:(NSString *)selectedID
{
    //点击的id和修改地址事件
}
#pragma mark - Request

- (void)getAddressList {
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
    hud.labelText = @"加载中...";
    AppDelegate *delegate = [AppDelegate shareAppDelegate];
    [NetworkInterface getAddressListWithToken:delegate.token usedID:delegate.userID finished:^(BOOL success, NSData *response) {
        NSLog(@"~~~~~~~~~~~~~~~~~~~~~~~~~~%@",[[NSString alloc] initWithData:response encoding:NSUTF8StringEncoding]);
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
                    [_addressItems removeAllObjects];
                    [self parseAddressListDataWithDict:object];
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

- (void)parseAddressListDataWithDict:(NSDictionary *)dict {
    if (![dict objectForKey:@"result"] || ![[dict objectForKey:@"result"] isKindOfClass:[NSArray class]]) {
        return;
    }
    NSArray *addressList = [dict objectForKey:@"result"];
    for (int i = 0; i < [addressList count]; i++) {
        NSDictionary *addressDict = [addressList objectAtIndex:i];
        AddressModel *model = [[AddressModel alloc] initWithParseDictionary:addressDict];
        [_addressItems addObject:model];
    }
    [_addressTableView reloadData];
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
    
    _bigsview=[[UIImageView alloc]initWithFrame:CGRectMake(0, 0, wide, height)];
    
    [self.view addSubview:_bigsview];
    _bigsview.image=[UIImage imageNamed:@"backimage"];
    _bigsview.userInteractionEnabled=YES;
    
    
    UIView*witeview=[[UIView alloc]initWithFrame:CGRectMake(0, 0, wide/2, wide/2)];
    witeview.backgroundColor=[UIColor whiteColor];
    witeview.center=CGPointMake(wide/2, height/2);
    witeview.alpha=1;
    
    [_bigsview addSubview:witeview];
    
    
    
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
            _cityField.contentEdgeInsets = UIEdgeInsetsMake(0,-40, 0, 0);
            _cityField.imageEdgeInsets = UIEdgeInsetsMake(0,270,0,0);//设置image在button上的位置（上top，左left，下bottom，右right）这里可以写负值，对上写－5，那么image就象上移动5个像素
            
            
            [_cityField addTarget:self action:@selector(cityclick) forControlEvents:UIControlEventTouchUpInside];
            [witeview addSubview:_cityField];
        }
        else
        {
            UITextField*neworiginaltextfield=[[UITextField alloc]initWithFrame:CGRectMake(140, i*50+60,280, 40)];
            neworiginaltextfield.leftViewMode = UITextFieldViewModeAlways;
            UIView *v = [[UIView alloc]init];
            v.frame = CGRectMake(0, 0, 10, 40);
            neworiginaltextfield.leftView = v;
            neworiginaltextfield.delegate = self;
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
    _deaultBtn= [UIButton buttonWithType:UIButtonTypeCustom];
    _deaultBtn.frame = CGRectMake(  35, 320, 30, 30);
    [_deaultBtn setImage:kImageName(@"select_normal") forState:UIControlStateNormal];
    [_deaultBtn addTarget:self action:@selector(setDefaultAddress) forControlEvents:UIControlEventTouchUpInside];
    [witeview addSubview:_deaultBtn];
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
    _nameField = [[UITextField alloc]init];
    _telField = [[UITextField alloc]init];
    _postcodeField = [[UITextField alloc]init];
    _locationField = [[UITextField alloc]init];
    _particularLocationField = [[UITextField alloc]init];
    _nameField=(UITextField*)[self.view viewWithTag:1056];
    _telField=(UITextField*)[self.view viewWithTag:1057];
    _postcodeField=(UITextField*)[self.view viewWithTag:1058];
    _locationField=(UITextField*)[self.view viewWithTag:1059];
    _particularLocationField=(UITextField*)[self.view viewWithTag:1060];
}

-(void)cancelclick
{
    [_bigsview removeFromSuperview];
}

-(void)cityclick
{
    [self initPickerView];
    [self pickerScrollIn];
}

//选择城市
- (void)initPickerView {
    //pickerView
    _toolbar = [[UIToolbar alloc] initWithFrame:CGRectMake(0, kScreenHeight, kScreenWidth, 44)];
    UIBarButtonItem *cancelItem = [[UIBarButtonItem alloc] initWithTitle:@"取消"
                                                                   style:UIBarButtonItemStyleDone
                                                                  target:self
                                                                  action:@selector(pickerScrollOut)];
    UIBarButtonItem *finishItem = [[UIBarButtonItem alloc] initWithTitle:@"完成"
                                                                   style:UIBarButtonItemStyleDone
                                                                  target:self
                                                                  action:@selector(modifyLocation:)];
    UIBarButtonItem *spaceItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace
                                                                               target:nil
                                                                               action:nil];
    spaceItem.width = 830.f;
    [_toolbar setItems:[NSArray arrayWithObjects:cancelItem,spaceItem,finishItem, nil]];
    [self.view addSubview:_toolbar];
    _pickerView = [[UIPickerView alloc] initWithFrame:CGRectMake(0, kScreenHeight, kScreenWidth, 216)];
    _pickerView.backgroundColor = kColor(244, 243, 243, 1);
    _pickerView.delegate = self;
    _pickerView.dataSource = self;
    
    [self.view addSubview:_pickerView];
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
    else {
        
        [_cityField setTitle:[[_cityArray objectAtIndex:row] objectForKey:@"name"] forState:UIControlStateNormal];
        _selectedCityID = [NSString stringWithFormat:@"%@",[[_cityArray objectAtIndex:row] objectForKey:@"id"]];
    }
}

- (void)pickerScrollIn {
    [UIView animateWithDuration:.3f animations:^{
        _toolbar.frame = CGRectMake(0, kScreenHeight - 260, kScreenWidth, 44);
        _pickerView.frame = CGRectMake(0, kScreenHeight - 216, kScreenWidth, 216);
    }];
}

- (void)pickerScrollOut {
    
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

- (void)modifyLocation:(id)sender {
    [self pickerScrollOut];
    NSInteger index = [self.pickerView selectedRowInComponent:1];
    self.selectedCityID = [NSString stringWithFormat:@"%@",[[self.cityArray objectAtIndex:index] objectForKey:@"id"]];
    NSString *cityName = [[self.cityArray objectAtIndex:index] objectForKey:@"name"];
    [_cityField setTitle:cityName forState:UIControlStateNormal];
    
}

- (void)setDefaultAddress {
    self.isDefault = !_isDefault;
    if(_isDefault)
    {
        [_deaultBtn setImage:kImageName(@"select_height") forState:UIControlStateNormal];
    }
    else
    {
        [_deaultBtn setImage:[UIImage imageNamed:@"select_normal"] forState:UIControlStateNormal];
        
    }
}

-(void)saveAddress
{
    if (!_nameField.text || [_nameField.text isEqualToString:@""]) {
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
        hud.customView = [[UIImageView alloc] init];
        hud.mode = MBProgressHUDModeCustomView;
        [hud hide:YES afterDelay:1.f];
        hud.labelText = @"请填写收件人姓名";
        return;
    }
    if (!_telField.text || [_telField.text isEqualToString:@""]) {
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
        hud.customView = [[UIImageView alloc] init];
        hud.mode = MBProgressHUDModeCustomView;
        [hud hide:YES afterDelay:1.f];
        hud.labelText = @"请填写收件人电话";
        return;
    }
    if (!_postcodeField.text || [_postcodeField.text isEqualToString:@""]) {
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
        hud.customView = [[UIImageView alloc] init];
        hud.mode = MBProgressHUDModeCustomView;
        [hud hide:YES afterDelay:1.f];
        hud.labelText = @"请填写邮编";
        return;
    }
    if (!_cityField.titleLabel.text || [_cityField.titleLabel.text isEqualToString:@""]) {
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
        hud.customView = [[UIImageView alloc] init];
        hud.mode = MBProgressHUDModeCustomView;
        [hud hide:YES afterDelay:1.f];
        hud.labelText = @"请选择城市";
        return;
    }
    if (!_particularLocationField.text || [_particularLocationField.text isEqualToString:@""]) {
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
    if (!([RegularFormat isMobileNumber:_telField.text] || [RegularFormat isTelephoneNumber:_telField.text])) {
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
        hud.customView = [[UIImageView alloc] init];
        hud.mode = MBProgressHUDModeCustomView;
        [hud hide:YES afterDelay:1.f];
        hud.labelText = @"请填写正确的电话";
        return;
    }
    [self saveAddressRequest];

}

-(void)saveAddressRequest
{
    AddressType isDefault = AddressOther;
    if (_isDefault) {
        isDefault = AddressDefault;
    }
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
    hud.labelText = @"提交中...";
    AppDelegate *delegate = [AppDelegate shareAppDelegate];
    [NetworkInterface addAddressWithToken:delegate.token userID:delegate.userID cityID:_selectedCityID receiverName:_nameField.text phoneNumber:_telField.text zipCode:_postcodeField.text address:_particularLocationField.text isDefault:isDefault finished:^(BOOL success, NSData *response) {
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


@end
