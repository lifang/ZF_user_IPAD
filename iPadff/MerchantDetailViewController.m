//
//  MerchantDetailViewController.m
//  iPadff
//
//  Created by wufei on 15/3/13.
//  Copyright (c) 2015年 LanTaiPro. All rights reserved.
//

#import "MerchantDetailViewController.h"
#import "MerchantDetailModel.h"
#import "CityHandle.h"
#import "AppDelegate.h"
#import "NetworkInterface.h"
#import "EditMerchantViewController.h"

#define kImageTag   20

@interface MerchantDetailViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic, strong) MerchantDetailModel *merchantDetail;
@property (nonatomic, strong) UITableView *tableView;

@end

@implementation MerchantDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = _merchant.merchantLegal;
    [self initAndLayoutUI];
    [self downloadDetail];
    
}

#pragma mark - UI

- (void)setHeaderAndFooterView {
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 0.001)];
    headerView.backgroundColor = [UIColor clearColor];
    _tableView.tableHeaderView = headerView;
    
    UIView *footerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 100)];
    footerView.backgroundColor = [UIColor clearColor];
    UIButton *modifyButton = [UIButton buttonWithType:UIButtonTypeCustom];
    modifyButton.frame = CGRectMake(80, 20, kScreenWidth - 160, 40);
    modifyButton.layer.cornerRadius = 4;
    modifyButton.layer.masksToBounds = YES;
    modifyButton.titleLabel.font = [UIFont systemFontOfSize:16.f];
    [modifyButton setTitle:@"保存" forState:UIControlStateNormal];
    [modifyButton setBackgroundImage:[UIImage imageNamed:@"orange.png"] forState:UIControlStateNormal];
    [modifyButton addTarget:self action:@selector(modifyMerchant:) forControlEvents:UIControlEventTouchUpInside];
    [footerView addSubview:modifyButton];
    _tableView.tableFooterView = footerView;
}

- (void)initAndLayoutUI {
    _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
    _tableView.translatesAutoresizingMaskIntoConstraints = NO;
    _tableView.backgroundColor = kColor(244, 243, 243, 1);
    _tableView.delegate = self;
    _tableView.dataSource = self;
    [self setHeaderAndFooterView];
    [self.view addSubview:_tableView];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:_tableView
                                                          attribute:NSLayoutAttributeTop
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:self.view
                                                          attribute:NSLayoutAttributeTop
                                                         multiplier:1.0
                                                           constant:0]];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:_tableView
                                                          attribute:NSLayoutAttributeLeft
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:self.view
                                                          attribute:NSLayoutAttributeLeft
                                                         multiplier:1.0
                                                           constant:0]];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:_tableView
                                                          attribute:NSLayoutAttributeRight
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:self.view
                                                          attribute:NSLayoutAttributeRight
                                                         multiplier:1.0
                                                           constant:0]];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:_tableView
                                                          attribute:NSLayoutAttributeBottom
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:self.view
                                                          attribute:NSLayoutAttributeBottom
                                                         multiplier:1.0
                                                           constant:0]];
    [self initPickerView];
}

#pragma mark - Request

- (void)downloadDetail {
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
    hud.labelText = @"加载中...";
    AppDelegate *delegate = [AppDelegate shareAppDelegate];
    [NetworkInterface getMerchantDetailWithToken:delegate.token merchantID:_merchant.merchantID finished:^(BOOL success, NSData *response) {
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
                    [self parsemerchantDetaiDataWithDictionary:object];
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


- (void)modifyMerchantWithMerchant:(MerchantDetailModel *)model
                  isModifyLocation:(BOOL)flag {
    
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
    hud.labelText = @"提交中...";
    AppDelegate *delegate = [AppDelegate shareAppDelegate];
    [NetworkInterface modifyMerchantWithToken:delegate.token merchantDetail:model finished:^(BOOL success, NSData *response) {
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
                    hud.labelText = @"修改商户成功";
                    if (flag) {
                        _merchantDetail.merchantCityID = model.merchantCityID;
                    }
                    [[NSNotificationCenter defaultCenter] postNotificationName:EditMerchantInfoNotification object:nil];
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

- (void)parsemerchantDetaiDataWithDictionary:(NSDictionary *)dict {
    if (![dict objectForKey:@"result"] || ![[dict objectForKey:@"result"] isKindOfClass:[NSDictionary class]]) {
        return;
    }
    NSDictionary *infoDict = [dict objectForKey:@"result"];
    _merchantDetail = [[MerchantDetailModel alloc] initWithParseDictionary:infoDict];
    [self.pickerView selectRow:[CityHandle getProvinceIndexWithCityID:_merchantDetail.merchantCityID] inComponent:0 animated:NO];
    [self.pickerView reloadAllComponents];
    [self.pickerView selectRow:[CityHandle getCityIndexWithCityID:_merchantDetail.merchantCityID] inComponent:1 animated:NO];
    [_tableView reloadData];
}


#pragma mark - 重写
- (void)saveWithURLString:(NSString *)urlString {
    if ([self.selectedImageKey isEqualToString:key_frontImage]) {
        _merchantDetail.frontPath = urlString;
    }
    else if ([self.selectedImageKey isEqualToString:key_backImage]) {
        _merchantDetail.bankPath = urlString;
    }
    else if ([self.selectedImageKey isEqualToString:key_bodyImage]) {
        _merchantDetail.bodyPath = urlString;
    }
    else if ([self.selectedImageKey isEqualToString:key_licenseImage]) {
        _merchantDetail.licensePath = urlString;
    }
    else if ([self.selectedImageKey isEqualToString:key_taxImage]) {
        _merchantDetail.taxPath = urlString;
    }
    else if ([self.selectedImageKey isEqualToString:key_organizationImage]) {
        _merchantDetail.organizationPath = urlString;
    }
    else if ([self.selectedImageKey isEqualToString:key_bankImage]) {
        _merchantDetail.bankPath = urlString;
    }
    [_tableView reloadData];
}


#pragma mark - Action

- (void)modifyMerchant:(id)sender {
    [self modifyMerchantWithMerchant:_merchantDetail isModifyLocation:NO];
}


- (void)modifyLocation:(id)sender {
    [self pickerScrollOut];
    NSInteger index = [self.pickerView selectedRowInComponent:1];
    NSString *cityID = [NSString stringWithFormat:@"%@",[[self.cityArray objectAtIndex:index] objectForKey:@"id"]];
    MerchantDetailModel *model = [[MerchantDetailModel alloc] init];
    model.merchantID = _merchantDetail.merchantID;
    model.merchantCityID = cityID;
    [self modifyMerchantWithMerchant:model isModifyLocation:YES];
}


#pragma mark - UITableView

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSInteger row = 0;
    switch (section) {
        case 0:
            row = 7;
            break;
        case 1:
            row = 2;
            break;
        case 2:
            row = 7;
            break;
        default:
            break;
    }
    return row;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = nil;
    NSString *titleName = nil;
    if (indexPath.section == 0 || indexPath.section == 1) {
        NSString *detailName = nil;
        static NSString *textIdentifier = @"textIdentifier";
        cell = [tableView dequeueReusableCellWithIdentifier:textIdentifier];
        if (cell == nil) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:textIdentifier];
        }
        switch (indexPath.section) {
            case 0: {
                switch (indexPath.row) {
                    case 0:
                        titleName = @"店铺名称（商户名）";
                        detailName = _merchantDetail.merchantName;
                        break;
                    case 1:
                        titleName = @"商户法人姓名";
                        detailName = _merchantDetail.merchantPersonName;
                        break;
                    case 2:
                        titleName = @"商户法人身份证号";
                        detailName = _merchantDetail.merchantPersonID;
                        break;
                    case 3:
                        titleName = @"营业执照登记号";
                        detailName = _merchantDetail.merchantBusinessID;
                        break;
                    case 4:
                        titleName = @"税务证号";
                        detailName = _merchantDetail.merchantTaxID;
                        break;
                    case 5:
                        titleName = @"组织机构代码证号";
                        detailName = _merchantDetail.merchantOrganizationID;
                        break;
                    case 6:
                        titleName = @"商户所在地";
                        detailName = [CityHandle getCityNameWithCityID:_merchantDetail.merchantCityID];
                        break;
                    default:
                        break;
                }
            }
                break;
            case 1: {
                switch (indexPath.row) {
                    case 0:
                        titleName = @"开户银行";
                        detailName = _merchantDetail.merchantBank;
                        break;
                    case 1:
                        titleName = @"银行开户许可证号";
                        detailName = _merchantDetail.merchantBankID;
                    default:
                        break;
                }
            }
            default:
                break;
        }
        cell.detailTextLabel.text = detailName;
        cell.detailTextLabel.font = [UIFont systemFontOfSize:14.f];
    }
    else {
        NSString *detailName = @"上传照片";
        static NSString *imageIdentifier = @"imageIdentifier";
        cell = [tableView dequeueReusableCellWithIdentifier:imageIdentifier];
        if (cell == nil) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:imageIdentifier];
            CGRect rect = CGRectMake(cell.frame.size.width - 50, (cell.frame.size.height - 20) / 2, 20, 20);
            UIImageView *imageView = [[UIImageView alloc] initWithFrame:rect];
            imageView.image = kImageName(@"upload.png");
            imageView.tag = kImageTag;
            imageView.hidden = YES;
            [cell.contentView addSubview:imageView];
        }
        cell.detailTextLabel.textColor = kColor(255, 102, 36, 1);
        cell.detailTextLabel.font = [UIFont systemFontOfSize:14.f];
        UIImageView *imageView = (UIImageView *)[cell.contentView viewWithTag:kImageTag];
        switch (indexPath.row) {
            case 0: {
                titleName = @"商户法人身份证照片正面";
                if (_merchantDetail.frontPath && ![_merchantDetail.frontPath isEqualToString:@""]) {
                    detailName = nil;
                }
            }
                break;
            case 1: {
                titleName = @"商户法人身份证照片背面";
                if (_merchantDetail.backPath && ![_merchantDetail.backPath isEqualToString:@""]) {
                    detailName = nil;
                }
            }
                break;
            case 2: {
                titleName = @"商户法人上半身照片";
                if (_merchantDetail.bodyPath && ![_merchantDetail.bodyPath isEqualToString:@""]) {
                    detailName = nil;
                }
            }
                break;
            case 3: {
                titleName = @"营业执照照片";
                if (_merchantDetail.licensePath && ![_merchantDetail.licensePath isEqualToString:@""]) {
                    detailName = nil;
                }
            }
                break;
            case 4: {
                titleName = @"税务证照片";
                if (_merchantDetail.taxPath && ![_merchantDetail.taxPath isEqualToString:@""]) {
                    detailName = nil;
                }
            }
                break;
            case 5: {
                titleName = @"组织机构代码证照片";
                if (_merchantDetail.organizationPath && ![_merchantDetail.organizationPath isEqualToString:@""]) {
                    detailName = nil;
                }
            }
                break;
            case 6: {
                titleName = @"银行开户许可证照片";
                if (_merchantDetail.bankPath && ![_merchantDetail.bankPath isEqualToString:@""]) {
                    detailName = nil;
                }
            }
                break;
            default:
                break;
        }
        if (detailName) {
            cell.detailTextLabel.text = detailName;
            imageView.hidden = YES;
        }
        else {
            cell.detailTextLabel.text = nil;
            imageView.hidden = NO;
        }
    }
    cell.textLabel.text = titleName;
    cell.textLabel.font = [UIFont systemFontOfSize:15.f];
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if ((indexPath.section == 0 && indexPath.row != 6) || indexPath.section == 1) {
        EditMerchantViewController *editVC = [[EditMerchantViewController alloc] init];
        editVC.merchant = _merchantDetail;
        editVC.editType = (MerchantEditType)(indexPath.section * 10 + indexPath.row);
         editVC.hidesBottomBarWhenPushed=YES;
        [self.navigationController pushViewController:editVC animated:YES];
    }
    else if (indexPath.section == 0 && indexPath.row == 6) {
        //所在地
        [self pickerScrollIn];
    }
    else if (indexPath.section == 2) {
        
        //上传图片
        NSString *key = nil;
        BOOL hasImage = NO;
        switch (indexPath.row) {
            case 0:
                key = key_frontImage;
                hasImage = (_merchantDetail.frontPath && ![_merchantDetail.frontPath isEqualToString:@""]);
                break;
            case 1:
                key = key_backImage;
                hasImage = (_merchantDetail.backPath && ![_merchantDetail.backPath isEqualToString:@""]);
                break;
            case 2:
                key = key_bodyImage;
                hasImage = (_merchantDetail.bodyPath && ![_merchantDetail.bodyPath isEqualToString:@""]);
                break;
            case 3:
                key = key_licenseImage;
                hasImage = (_merchantDetail.licensePath && ![_merchantDetail.licensePath isEqualToString:@""]);
                break;
            case 4:
                key = key_taxImage;
                hasImage = (_merchantDetail.taxPath && ![_merchantDetail.taxPath isEqualToString:@""]);
                break;
            case 5:
                key = key_organizationImage;
                hasImage = (_merchantDetail.organizationPath && ![_merchantDetail.organizationPath isEqualToString:@""]);
                break;
            case 6:
                key = key_bankImage;
                hasImage = (_merchantDetail.bankPath && ![_merchantDetail.bankPath isEqualToString:@""]);
                break;
            default:
                break;
         
        }
        [self selectedKey:key hasImage:hasImage];
    
    }
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 0.001f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 20.f;
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



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
