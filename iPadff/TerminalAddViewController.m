//
//  TerminalAddViewController.m
//  iPadff
//
//  Created by 黄含章 on 15/3/9.
//  Copyright (c) 2015年 LanTaiPro. All rights reserved.
//

#import "TerminalAddViewController.h"
#import "NetworkInterface.h"
#import "AppDelegate.h"
#import "InstitutionModel.h"
#import "TerminalChoseCell.h"

@interface TerminalAddViewController ()<UITableViewDelegate,UITableViewDataSource,UIAlertViewDelegate>

@property(nonatomic,strong)UITextField *acceptField;
@property(nonatomic,strong)UITextField *terminalField;
@property(nonatomic,strong)UITextField *goodsField;

@property (nonatomic,strong) NSMutableArray *institutionItems;  //收单机构

@property (nonatomic, strong) InstitutionModel *selectedModel;

@property(nonatomic,strong)UITableView *InstitutionTableView;

@property(nonatomic,strong)UIView *contentView;

@end

@implementation TerminalAddViewController

-(UITableView *)InstitutionTableView
{
    if (!_InstitutionTableView) {
        _InstitutionTableView = [[UITableView alloc]init];
        _InstitutionTableView.backgroundColor = kColor(202, 202, 202, 1.0);
    }
    return _InstitutionTableView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = kColor(144, 144, 144, 0.7);
    _institutionItems = [NSMutableArray array];
    [self setAddViewController];
    [self downloadAcceptInstitutionData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)setAddViewController
{
    //添加其它终端View
    UIView *terminalAddView = [[UIView alloc]init];
    terminalAddView.frame = CGRectMake(300, 140, 450, 400);
    terminalAddView.backgroundColor = [UIColor whiteColor];
    
    UIButton *exitBtn = [[UIButton alloc]init];
    [exitBtn setBackgroundImage:[UIImage imageNamed:@"X_black"] forState:UIControlStateNormal];
    [exitBtn addTarget:self action:@selector(exitClick) forControlEvents:UIControlEventTouchUpInside];
    exitBtn.frame = CGRectMake(10, 15, 25, 25);
    [terminalAddView addSubview:exitBtn];
    
    UILabel *addLabel = [[UILabel alloc]init];
    addLabel.text = @"添加其它终端";
    addLabel.font = [UIFont boldSystemFontOfSize:22];
    addLabel.tintColor = [UIColor blackColor];
    addLabel.frame = CGRectMake(terminalAddView.frame.origin.x - 140, 15, 200, 25);
    [terminalAddView addSubview:addLabel];
    
    UIView *line = [[UIView alloc]init];
    line.backgroundColor = [UIColor blackColor];
    line.frame = CGRectMake(0, CGRectGetMaxY(addLabel.frame) + 10,terminalAddView.frame.size.width , 0.7);
    [terminalAddView addSubview:line];
    
    UILabel *firstLabel = [[UILabel alloc]init];
    firstLabel.text = @"收单机构";
    firstLabel.font = [UIFont systemFontOfSize:20];
    firstLabel.frame = CGRectMake(40, CGRectGetMaxY(line.frame) + 50, 80, 40);
    [terminalAddView addSubview:firstLabel];
    
    UILabel *secondLabel = [[UILabel alloc]init];
    secondLabel.text = @" 终 端 号";
    secondLabel.font = [UIFont systemFontOfSize:20];
    secondLabel.frame = CGRectMake(40, CGRectGetMaxY(firstLabel.frame) + 20, 80, 40);
    [terminalAddView addSubview:secondLabel];
    
    UILabel *thirdLabel = [[UILabel alloc]init];
    thirdLabel.text = @"商品名称";
    thirdLabel.font = [UIFont systemFontOfSize:20];
    thirdLabel.frame = CGRectMake(40, CGRectGetMaxY(secondLabel.frame) + 20, 80, 40);
    [terminalAddView addSubview:thirdLabel];
    
    _acceptField = [[UITextField alloc]init];
    _acceptField.userInteractionEnabled = NO;
    _acceptField.placeholder = @"请选择收单机构";
    [_acceptField setValue:[UIFont systemFontOfSize:20] forKeyPath:@"_placeholderLabel.font"];
    _acceptField.leftViewMode = UITextFieldViewModeAlways;
    UIView *v = [[UIView alloc]init];
    v.frame = CGRectMake(0, 0, 10, 40);
    _acceptField.leftView = v;
    _acceptField.frame = CGRectMake(CGRectGetMaxX(firstLabel.frame) + 20, firstLabel.frame.origin.y, 240, 40);
    CALayer *readBtnLayer = [_acceptField layer];
    [readBtnLayer setMasksToBounds:YES];
    [readBtnLayer setBorderWidth:1.0];
    [readBtnLayer setBorderColor:[kColor(163, 163, 163, 1.0) CGColor]];
    
    UIButton *acceptChoose = [[UIButton alloc]init];
    [acceptChoose addTarget:self action:@selector(acceptClick) forControlEvents:UIControlEventTouchUpInside];
    [acceptChoose setBackgroundImage:[UIImage imageNamed:@"arrow_line"] forState:UIControlStateNormal];
    acceptChoose.frame = CGRectMake(CGRectGetMaxX(_acceptField.frame) - 50, _acceptField.frame.origin.y, 50, 40);
    [terminalAddView addSubview:acceptChoose];
    [terminalAddView addSubview:_acceptField];
    
    _terminalField = [[UITextField alloc]init];
    _terminalField.leftViewMode = UITextFieldViewModeAlways;
    UIView *v1 = [[UIView alloc]init];
    v1.frame = CGRectMake(0, 0, 10, 40);
    _terminalField.leftView = v1;
    _terminalField.frame = CGRectMake(CGRectGetMaxX(firstLabel.frame) + 20, secondLabel.frame.origin.y, 240, 40);
    CALayer *readBtnLayer1 = [_terminalField layer];
    [readBtnLayer1 setMasksToBounds:YES];
    [readBtnLayer1 setBorderWidth:1.0];
    [readBtnLayer1 setBorderColor:[kColor(163, 163, 163, 1.0) CGColor]];
    [terminalAddView addSubview:_terminalField];
    
    _goodsField = [[UITextField alloc]init];
    _goodsField.leftViewMode = UITextFieldViewModeAlways;
    UIView *v2 = [[UIView alloc]init];
    v2.frame = CGRectMake(0, 0, 10, 40);
    _goodsField.leftView = v2;
    _goodsField.frame = CGRectMake(CGRectGetMaxX(firstLabel.frame) + 20, thirdLabel.frame.origin.y, 240, 40);
    CALayer *readBtnLayer2 = [_goodsField layer];
    [readBtnLayer2 setMasksToBounds:YES];
    [readBtnLayer2 setBorderWidth:1.0];
    [readBtnLayer2 setBorderColor:[kColor(163, 163, 163, 1.0) CGColor]];
    [terminalAddView addSubview:_goodsField];
    
    UIButton *submitBtn = [[UIButton alloc]init];
    [submitBtn setBackgroundColor:kColor(241, 81, 8, 1.0)];
    [submitBtn setTitle:@"提交" forState:UIControlStateNormal];
    [submitBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [submitBtn addTarget:self action:@selector(submitClick) forControlEvents:UIControlEventTouchUpInside];
    submitBtn.frame = CGRectMake(_goodsField.frame.origin.x + 30, CGRectGetMaxY(_goodsField.frame) + 40, 120, 40);
    [terminalAddView addSubview:submitBtn];
    self.contentView = terminalAddView;
    [self.view addSubview:terminalAddView];
    
}

-(void)exitClick
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

-(void)acceptClick
{
    //选择收单机构
    self.InstitutionTableView.delegate = self;
    self.InstitutionTableView.dataSource = self;
    _InstitutionTableView.frame = CGRectMake(_acceptField.frame.origin.x, CGRectGetMaxY(_acceptField.frame), _acceptField.frame.size.width, 200);
    

    [_contentView addSubview:_InstitutionTableView];
}

-(void)submitClick
{
    //提交
    if (!_acceptField.text || [_acceptField.text isEqualToString:@"请选择收单机构"]) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示信息"
                                                        message:@"请选择收单机构"
                                                       delegate:nil
                                              cancelButtonTitle:@"确定"
                                              otherButtonTitles:nil];
        [alert show];
        return;
    }
    if (!_terminalField.text || [_terminalField.text isEqualToString:@""]) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示信息"
                                                        message:@"请填写终端号"
                                                       delegate:nil
                                              cancelButtonTitle:@"确定"
                                              otherButtonTitles:nil];
        [alert show];
        return;
    }
    if (!_goodsField.text || [_goodsField.text isEqualToString:@""]) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示信息"
                                                        message:@"请填写商户名称"
                                                       delegate:nil
                                              cancelButtonTitle:@"确定"
                                              otherButtonTitles:nil];
        [alert show];
        return;
    }
    [self addTerminal];
    
}

#pragma mark - Request
//获取收单机构
- (void)downloadAcceptInstitutionData {
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
    hud.labelText = @"加载中...";
    AppDelegate *delegate = [AppDelegate shareAppDelegate];
    [NetworkInterface getCollectionChannelWithToken:delegate.token finished:^(BOOL success, NSData *response) {
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
                    [self parseInstitutionDataWithDictionary:object];
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

- (void)addTerminal {
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
    hud.labelText = @"提交中...";
    AppDelegate *delegate = [AppDelegate shareAppDelegate];
    [NetworkInterface addTerminalWithToken:delegate.token userID:delegate.userID institutionID:_selectedModel.ID terminalNumber:_terminalField.text merchantName:_goodsField.text finished:^(BOOL success, NSData *response) {
        hud.customView = [[UIImageView alloc] init];
        hud.mode = MBProgressHUDModeCustomView;
        [hud hide:YES afterDelay:0.5f];
        if (success) {
            id object = [NSJSONSerialization JSONObjectWithData:response options:NSJSONReadingMutableLeaves error:nil];
            if ([object isKindOfClass:[NSDictionary class]]) {
                NSString *errorCode = [NSString stringWithFormat:@"%@",[object objectForKey:@"code"]];
                if ([errorCode intValue] == RequestFail) {
                    //返回错误代码
                    hud.labelText = [NSString stringWithFormat:@"%@",[object objectForKey:@"message"]];
                }
                else if ([errorCode intValue] == RequestSuccess) {
                    [hud hide:YES];
                    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示信息"
                                                                    message:@"添加成功"
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



#pragma mark - Data
//收单机构
- (void)parseInstitutionDataWithDictionary:(NSDictionary *)dict {
    if (![dict objectForKey:@"result"] || ![[dict objectForKey:@"result"] isKindOfClass:[NSArray class]]) {
        return;
    }
    NSArray *institutionList = [dict objectForKey:@"result"];
    for (int i = 0; i < [institutionList count]; i++) {
        InstitutionModel *model = [[InstitutionModel alloc] initWithParseDictionary:[institutionList objectAtIndex:i]];
        [_institutionItems addObject:model];
    }
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return _institutionItems.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    //终端选择Cell
    TerminalChoseCell *cell = [TerminalChoseCell cellWithTableView:tableView];
    InstitutionModel *model = [_institutionItems objectAtIndex:indexPath.row];
    cell.textLabel.text = model.name;
    return cell;
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

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    InstitutionModel *model = [_institutionItems objectAtIndex:indexPath.row];
    self.selectedModel = model;
    _acceptField.text = model.name;
    [_InstitutionTableView removeFromSuperview];
}

#pragma mark - UIAlertView

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (buttonIndex == alertView.cancelButtonIndex) {
        [self dismissViewControllerAnimated:YES completion:nil];
        [self.TerminalDelegates addTerminalSuccess];
    }
}

@end
