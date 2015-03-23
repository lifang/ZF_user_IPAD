//
//  ApplyPlanViewController.m
//  iPadff
//
//  Created by 黄含章 on 15/3/11.
//  Copyright (c) 2015年 LanTaiPro. All rights reserved.
//

#import "ApplyPlanViewController.h"
#import "ProgressCell.h"
#import "ProgressModel.h"
#import "NetworkInterface.h"
#import "RegularFormat.h"

@interface ApplyPlanViewController ()<UITextFieldDelegate,UITableViewDataSource,UITableViewDelegate>

@property(nonatomic,strong)UITextField *phoneField;

@property(nonatomic,strong)UITableView *tableView;

@property (nonatomic, strong) NSMutableArray *dataItem;

@end

@implementation ApplyPlanViewController

-(UITableView *)tableView
{
    if (!_tableView) {
        _tableView = [[UITableView alloc]init];
        _tableView.translatesAutoresizingMaskIntoConstraints = NO;
        _tableView.delegate = self;
        _tableView.dataSource = self;
    }
    return _tableView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    _dataItem = [[NSMutableArray alloc]init];
    [self setLeftViewWith:ChooseViewApplyplan];
    [self initAndLayoutUI];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)initAndLayoutUI
{
    UILabel *applyPlan = [[UILabel alloc]init];
    applyPlan.text = @"申请进度查询";
    applyPlan.font = [UIFont boldSystemFontOfSize:20];
    applyPlan.translatesAutoresizingMaskIntoConstraints = NO;
    [self.view addSubview:applyPlan];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:applyPlan
                                                          attribute:NSLayoutAttributeTop
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:self.view
                                                          attribute:NSLayoutAttributeTop
                                                         multiplier:1.0
                                                           constant:100.f]];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:applyPlan
                                                          attribute:NSLayoutAttributeLeft
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:self.view
                                                          attribute:NSLayoutAttributeLeft
                                                         multiplier:1.0
                                                           constant:460.f]];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:applyPlan
                                                          attribute:NSLayoutAttributeWidth
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:nil
                                                          attribute:NSLayoutAttributeNotAnAttribute
                                                         multiplier:1.0
                                                           constant:200.f]];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:applyPlan
                                                          attribute:NSLayoutAttributeHeight
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:nil
                                                          attribute:NSLayoutAttributeNotAnAttribute
                                                         multiplier:1.0
                                                           constant:40.f]];
    
    _phoneField = [[UITextField alloc]init];
    _phoneField.translatesAutoresizingMaskIntoConstraints = NO;
    _phoneField.delegate = self;
    _phoneField.leftViewMode = UITextFieldViewModeAlways;
    UIView *v = [[UIView alloc]init];
    v.frame = CGRectMake(0, 0, 10, 40);
    _phoneField.leftView = v;
    _phoneField.font = [UIFont systemFontOfSize:20];
    _phoneField.placeholder = @"请输入手机号";
    [_phoneField setValue:[UIFont systemFontOfSize:20] forKeyPath:@"_placeholderLabel.font"];
    [_phoneField setValue:kColor(199, 199, 199, 1.0) forKeyPath:@"_placeholderLabel.color"];
    CALayer *layer=[_phoneField layer];
    [layer setMasksToBounds:YES];
    [layer setBorderWidth:1];
    [layer setBorderColor:[kColor(188, 188, 188, 1.0) CGColor]];
    [self.view addSubview:_phoneField];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:_phoneField
                                                          attribute:NSLayoutAttributeTop
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:applyPlan
                                                          attribute:NSLayoutAttributeBottom
                                                         multiplier:1.0
                                                           constant:5.f]];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:_phoneField
                                                          attribute:NSLayoutAttributeLeft
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:self.view
                                                          attribute:NSLayoutAttributeLeft
                                                         multiplier:1.0
                                                           constant:280.f]];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:_phoneField
                                                          attribute:NSLayoutAttributeWidth
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:nil
                                                          attribute:NSLayoutAttributeNotAnAttribute
                                                         multiplier:1.0
                                                           constant:460.f]];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:_phoneField
                                                          attribute:NSLayoutAttributeHeight
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:nil
                                                          attribute:NSLayoutAttributeNotAnAttribute
                                                         multiplier:1.0
                                                           constant:40.f]];
    
    UIButton *findBtn = [[UIButton alloc]init];
    [findBtn addTarget:self action:@selector(findClicked) forControlEvents:UIControlEventTouchUpInside];
    findBtn.translatesAutoresizingMaskIntoConstraints = NO;
    [findBtn setTitle:@"查询" forState:UIControlStateNormal];
    [findBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [findBtn setBackgroundColor:kColor(254, 79, 29, 1.0)];
    [self.view addSubview:findBtn];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:findBtn
                                                          attribute:NSLayoutAttributeTop
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:applyPlan
                                                          attribute:NSLayoutAttributeBottom
                                                         multiplier:1.0
                                                           constant:5.f]];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:findBtn
                                                          attribute:NSLayoutAttributeLeft
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:_phoneField
                                                          attribute:NSLayoutAttributeRight
                                                         multiplier:1.0
                                                           constant:5.f]];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:findBtn
                                                          attribute:NSLayoutAttributeWidth
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:nil
                                                          attribute:NSLayoutAttributeNotAnAttribute
                                                         multiplier:1.0
                                                           constant:120.f]];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:findBtn
                                                          attribute:NSLayoutAttributeHeight
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:nil
                                                          attribute:NSLayoutAttributeNotAnAttribute
                                                         multiplier:1.0
                                                           constant:40.f]];
    
}

-(void)initTableView
{
    //布局TableView
    [self.view addSubview:self.tableView];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:_tableView
                                                          attribute:NSLayoutAttributeTop
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:self.view
                                                          attribute:NSLayoutAttributeTop
                                                         multiplier:1.0
                                                           constant:260.f]];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:_tableView
                                                          attribute:NSLayoutAttributeLeft
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:self.view
                                                          attribute:NSLayoutAttributeLeft
                                                         multiplier:1.0
                                                           constant:160.f]];
    
    if (iOS7) {
        [self.view addConstraint:[NSLayoutConstraint constraintWithItem:_tableView
                                                              attribute:NSLayoutAttributeWidth
                                                              relatedBy:NSLayoutRelationEqual
                                                                 toItem:nil
                                                              attribute:NSLayoutAttributeNotAnAttribute
                                                             multiplier:1.0
                                                               constant:SCREEN_HEIGHT - 160.f]];

    }
    else{
        [self.view addConstraint:[NSLayoutConstraint constraintWithItem:_tableView
                                                              attribute:NSLayoutAttributeWidth
                                                              relatedBy:NSLayoutRelationEqual
                                                                 toItem:nil
                                                              attribute:NSLayoutAttributeNotAnAttribute
                                                             multiplier:1.0
                                                               constant:SCREEN_WIDTH - 160.f]];
    }
    if (iOS7) {
        [self.view addConstraint:[NSLayoutConstraint constraintWithItem:_tableView
                                                              attribute:NSLayoutAttributeHeight
                                                              relatedBy:NSLayoutRelationEqual
                                                                 toItem:nil
                                                              attribute:NSLayoutAttributeNotAnAttribute
                                                             multiplier:1.0
                                                               constant:SCREEN_WIDTH - 200.f]];
    }else{
        [self.view addConstraint:[NSLayoutConstraint constraintWithItem:_tableView
                                                              attribute:NSLayoutAttributeHeight
                                                              relatedBy:NSLayoutRelationEqual
                                                                 toItem:nil
                                                              attribute:NSLayoutAttributeNotAnAttribute
                                                             multiplier:1.0
                                                               constant:SCREEN_HEIGHT - 200.f]];
    }
    UIView *line = [[UIView alloc]init];
    line.backgroundColor = kColor(145, 145, 145, 1.0);
    line.frame = CGRectMake(20, 0, SCREEN_WIDTH - 160, 1);
    _tableView.tableHeaderView = line;
    
    UIView *v = [[UIView alloc]init];
    v.frame = CGRectMake(0, 0, 1, 1);
    _tableView.tableFooterView = v;
    
}

-(void)findClicked
{
    if (!_phoneField.text || [_phoneField.text isEqualToString:@""]) {
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
        hud.customView = [[UIImageView alloc] init];
        hud.mode = MBProgressHUDModeCustomView;
        [hud hide:YES afterDelay:1.f];
        hud.labelText = @"请输入手机号";
        return;
    }
    if (!([RegularFormat isMobileNumber:_phoneField.text] || [RegularFormat isTelephoneNumber:_phoneField.text])) {
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
        hud.customView = [[UIImageView alloc] init];
        hud.mode = MBProgressHUDModeCustomView;
        [hud hide:YES afterDelay:1.f];
        hud.labelText = @"请填写正确的手机号";
        return;
    }
    [self initTableView];
    [self getApplyProgress];
    
}

#pragma mark - Request

- (void)getApplyProgress {
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
    hud.labelText = @"加载中...";
    AppDelegate *delegate = [AppDelegate shareAppDelegate];
    [NetworkInterface searchTerminalStatusWithToken:delegate.token userID:delegate.userID phoneNumber:_phoneField.text finished:^(BOOL success, NSData *response) {
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
                    [self parseProgressDataWithDictionary:object];
                    if ([[object objectForKey:@"result"] isKindOfClass:[NSArray class]] &&
                        [[object objectForKey:@"result"] count] <= 0) {
                        hud.labelText = @"未查到相关数据";
                    }
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

- (void)parseProgressDataWithDictionary:(NSDictionary *)dict {
    if (![dict objectForKey:@"result"] || ![[dict objectForKey:@"result"] isKindOfClass:[NSArray class]]) {
        return;
    }
    [_dataItem removeAllObjects];
    NSArray *infoList = [dict objectForKey:@"result"];
    for (int i = 0; i < [infoList count]; i++) {
        id progressDict = [infoList objectAtIndex:i];
        if ([progressDict isKindOfClass:[NSDictionary class]]) {
            ProgressModel *model = [[ProgressModel alloc] initWithParseDictionary:progressDict];
            [_dataItem addObject:model];
        }
    }
    [_tableView reloadData];
}



#pragma mark - tableView dateSource Delegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _dataItem.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    ProgressCell *cell = [[ProgressCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
    ProgressModel *model = [_dataItem objectAtIndex:indexPath.row];
    [cell setContentsWithData:model];
    return cell;
}


-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    ProgressModel *model = [_dataItem objectAtIndex:indexPath.row];
    return kProgressPrimaryHeight + [model.openList count] * 20;
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

@end
