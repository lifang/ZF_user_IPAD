//
//  IntegralViewController.m
//  iPadff
//
//  Created by 黄含章 on 15/3/13.
//  Copyright (c) 2015年 LanTaiPro. All rights reserved.
//

#import "IntegralViewController.h"
#import "IntegralCell.h"
#import "AppDelegate.h"
#import "RefreshView.h"
#import "NetworkInterface.h"
#import "ScoreModel.h"
#import "RegularFormat.h"

@interface IntegralViewController ()<UITableViewDataSource,UITableViewDelegate,RefreshDelegate,UITextFieldDelegate>

@property(nonatomic,strong)UITableView *tableView;

@property(nonatomic,strong)UIImageView *darkbackgroundImageView;

/***************上下拉刷新**********/
@property (nonatomic, strong) RefreshView *topRefreshView;
@property (nonatomic, strong) RefreshView *bottomRefreshView;

@property (nonatomic, assign) BOOL reloading;
@property (nonatomic, assign) CGFloat primaryOffsetY;
@property (nonatomic, assign) int page;
/**********************************/

@property (nonatomic, strong) UILabel *totalLabel;  //总积分label
//请求获取
@property (nonatomic, strong) NSString *totalScore; //总积分
@property (nonatomic, strong) NSString *totalMoney; //总金额

@property (nonatomic, strong) NSMutableArray *scoreItems;
@property (nonatomic, strong) NSString *intergaralType;

@property(nonatomic,strong)UITextField *nameField;
@property(nonatomic,strong)UITextField *telField;
@property(nonatomic,strong)UITextField *moneyField;

@end

@implementation IntegralViewController

-(UITableView *)tableView
{
    if (!_tableView) {
        _tableView = [[UITableView alloc]init];
        _tableView.translatesAutoresizingMaskIntoConstraints = NO;
        _tableView.delegate = self;
        _tableView.dataSource = self;
        
        UIView *v = [[UIView alloc]init];
        v.backgroundColor = kColor(199, 197, 204, 1.0);
        v.frame = CGRectMake(0, 0, SCREEN_WIDTH - 160, 0.7);
        if (iOS7) {
            v.frame = CGRectMake(0, 0, SCREEN_HEIGHT - 160, 0.7);
        }
        _tableView.tableFooterView = v;
    }
    return _tableView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.swithView setSelectedBtnAtIndex:4];
    NSLog(@"当前是~~~~~~~~~~~~%d",self.Index);
    self.view.backgroundColor = [UIColor whiteColor];
    _scoreItems = [[NSMutableArray alloc]init];
    [self initAndLaoutUI];
    [self getAllScore];
    self.swithView.hidden = NO;
    //加载数据
    [self firstLoadData];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)initAndLaoutUI
{
    _totalLabel = [[UILabel alloc]init];
    _totalLabel.translatesAutoresizingMaskIntoConstraints = NO;
    _totalLabel.font = [UIFont systemFontOfSize:22];
    _totalLabel.textColor = kColor(51, 51, 51, 1.0);
    [self.view addSubview:_totalLabel];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:_totalLabel
                                                          attribute:NSLayoutAttributeTop
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:self.view
                                                          attribute:NSLayoutAttributeTop
                                                         multiplier:1.0
                                                           constant:130.f]];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:_totalLabel
                                                          attribute:NSLayoutAttributeLeft
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:self.view
                                                          attribute:NSLayoutAttributeLeft
                                                         multiplier:1.0
                                                           constant:220.f]];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:_totalLabel
                                                          attribute:NSLayoutAttributeWidth
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:nil
                                                          attribute:NSLayoutAttributeNotAnAttribute
                                                         multiplier:1.0
                                                           constant:300.f]];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:_totalLabel
                                                          attribute:NSLayoutAttributeHeight
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:nil
                                                          attribute:NSLayoutAttributeNotAnAttribute
                                                         multiplier:1.0
                                                           constant:50.f]];
    
    UIButton *integralBtn = [[UIButton alloc]init];
    [integralBtn addTarget:self action:@selector(exchange) forControlEvents:UIControlEventTouchUpInside];
    integralBtn.translatesAutoresizingMaskIntoConstraints = NO;
    [integralBtn setTitle:@"积分兑换" forState:UIControlStateNormal];
    [integralBtn setBackgroundColor:kColor(254, 79, 29, 1.0)];
    integralBtn.titleLabel.font = [UIFont systemFontOfSize:20];
    [self.view addSubview:integralBtn];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:integralBtn
                                                          attribute:NSLayoutAttributeTop
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:self.view
                                                          attribute:NSLayoutAttributeTop
                                                         multiplier:1.0
                                                           constant:140.f]];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:integralBtn
                                                          attribute:NSLayoutAttributeLeft
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:_totalLabel
                                                          attribute:NSLayoutAttributeLeft
                                                         multiplier:1.0
                                                           constant:580.f]];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:integralBtn
                                                          attribute:NSLayoutAttributeWidth
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:nil
                                                          attribute:NSLayoutAttributeNotAnAttribute
                                                         multiplier:1.0
                                                           constant:120.f]];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:integralBtn
                                                          attribute:NSLayoutAttributeHeight
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:nil
                                                          attribute:NSLayoutAttributeNotAnAttribute
                                                         multiplier:1.0
                                                           constant:40.f]];
    
    //添加tableView
    [self.view addSubview:self.tableView];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:_tableView
                                                          attribute:NSLayoutAttributeTop
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:integralBtn
                                                          attribute:NSLayoutAttributeTop
                                                         multiplier:1.0
                                                           constant:70.f]];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:_tableView
                                                          attribute:NSLayoutAttributeLeft
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:self.view
                                                          attribute:NSLayoutAttributeLeft
                                                         multiplier:1.0
                                                           constant:160.f]];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:_tableView
                                                          attribute:NSLayoutAttributeRight
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:self.view
                                                          attribute:NSLayoutAttributeRight
                                                         multiplier:1.0
                                                           constant:0.f]];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:_tableView
                                                          attribute:NSLayoutAttributeHeight
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:nil
                                                          attribute:NSLayoutAttributeNotAnAttribute
                                                         multiplier:1.0
                                                           constant:SCREEN_HEIGHT - 210.f]];
    if (iOS7) {
        [self.view addConstraint:[NSLayoutConstraint constraintWithItem:_tableView
                                                              attribute:NSLayoutAttributeHeight
                                                              relatedBy:NSLayoutRelationEqual
                                                                 toItem:nil
                                                              attribute:NSLayoutAttributeNotAnAttribute
                                                             multiplier:1.0
                                                               constant:SCREEN_WIDTH - 210.f]];
    }
    
    _topRefreshView = [[RefreshView alloc] initWithFrame:CGRectMake(0, -80, self.view.bounds.size.width - 160, 80)];
    _topRefreshView.direction = PullFromTop;
    _topRefreshView.delegate = self;
    [_tableView addSubview:_topRefreshView];
    
    _bottomRefreshView = [[RefreshView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width - 160, 60)];
    _bottomRefreshView.direction = PullFromBottom;
    _bottomRefreshView.delegate = self;
    _bottomRefreshView.hidden = YES;
    [_tableView addSubview:_bottomRefreshView];
    
}


#pragma mark - 积分兑换
-(void)exchange
{
    [self initSubmiteIntegralView];
}

-(void)initSubmiteIntegralView
{
    CGFloat width;
    CGFloat height;
    if(iOS7)
    {
        width = SCREEN_HEIGHT;
        height = SCREEN_WIDTH;
    }
    else
    {
        width = SCREEN_WIDTH;
        height = SCREEN_HEIGHT;
    }
    
    _darkbackgroundImageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, width, height)];
    _darkbackgroundImageView.image = [UIImage imageNamed:@"backimage"];
    _darkbackgroundImageView.userInteractionEnabled = YES;
    [self.view addSubview:_darkbackgroundImageView];
    
    UIView *backView = [[UIView alloc]init];
    backView.backgroundColor = kColor(254, 254, 254, 1.0);
    backView.frame = CGRectMake(0, 0, width/2, width/2);
    backView.center = CGPointMake(width/2 , height/2);
    [_darkbackgroundImageView addSubview:backView];
    
    UIButton *okButton = [UIButton buttonWithType:UIButtonTypeCustom];
    okButton.frame = CGRectMake(  10, 10, 30, 30);
    [okButton setImage:kImageName(@"xx.png") forState:UIControlStateNormal];
    [okButton addTarget:self action:@selector(cancelclick) forControlEvents:UIControlEventTouchUpInside];
    [backView addSubview:okButton];
    
    UILabel *newaddress=[[UILabel alloc]initWithFrame:CGRectMake(0, 10,width/2, 30)];
    [backView addSubview:newaddress];
    newaddress.textAlignment = NSTextAlignmentCenter;
    newaddress.text=@"积分兑换";
    newaddress .font = [UIFont boldSystemFontOfSize:22.f];
    
    UIView *lineview=[[UIView alloc]initWithFrame:CGRectMake(0, 50, width/2, 1)];
    lineview.backgroundColor=[UIColor grayColor];
    [backView addSubview:lineview];
    
    CGFloat mainX = 40.f;
    CGFloat mainHeight = 40.f;
    UIFont *mainFont = [UIFont systemFontOfSize:20];
    
    UILabel *integralNowNumLabel = [[UILabel alloc]init];
    integralNowNumLabel.font = mainFont;
    integralNowNumLabel.text = [NSString stringWithFormat:@"现有积分：%@",_totalScore];
    integralNowNumLabel.frame = CGRectMake(mainX, CGRectGetMaxY(lineview.frame) + 30, 400, mainHeight);
    [backView addSubview:integralNowNumLabel];
    
    UILabel *heightestIntegralNumLable = [[UILabel alloc]init];
    heightestIntegralNumLable.text = [NSString stringWithFormat:@"最高可兑换手续费：¥ %@",_totalMoney];
    heightestIntegralNumLable.font = mainFont;
    heightestIntegralNumLable.frame = CGRectMake(mainX, CGRectGetMaxY(integralNowNumLabel.frame), 400, mainHeight);
    [backView addSubview:heightestIntegralNumLable];
    
    for (int i = 0; i < 3; i++) {
        UILabel *label = [[UILabel alloc]init];
        label.font = mainFont;
        label.tag = 9898 + i;
        label.frame = CGRectMake(mainX, CGRectGetMaxY(heightestIntegralNumLable.frame) + 20 + i * 50, 100, mainHeight);
        [backView addSubview:label];
        switch (label.tag) {
            case 9898:
                label.text = @"您的姓名";
                break;
            case 9899:
                label.text = @"联系电话";
                break;
            case 9900:
                label.text = @"兑换金额";
                break;
            default:
                break;
        }
    }
    
    for (int i = 0; i < 3; i++) {
        UITextField *textField = [[UITextField alloc]init];
        textField.tag = 8787 + i;
        textField.frame = CGRectMake(mainX + 100,  CGRectGetMaxY(heightestIntegralNumLable.frame) + 20 + i * 50, 280,40);
        textField.delegate = self;
        textField.leftViewMode = UITextFieldViewModeAlways;
        textField.rightViewMode = UITextFieldViewModeAlways;
        UIView *v = [[UIView alloc]init];
        v.frame = CGRectMake(0, 0, 10, mainHeight);
        textField.leftView = v;
        CALayer *layer=[textField layer];
        //是否设置边框以及是否可见
        [layer setMasksToBounds:YES];
        [layer setBorderWidth:1];
        [layer setBorderColor:[kColor(188, 188, 188, 1.0) CGColor]];
        [backView addSubview:textField];
        
        if (textField.tag == 8787) {
            _nameField = textField;
        }
        if (textField.tag == 8788) {
            _telField = textField;
        }
        if (textField.tag == 8789) {
            UILabel *yuanLabel = [[UILabel alloc]init];
            yuanLabel.text = @"元";
            yuanLabel.textColor = kColor(131, 131, 131, 1.0);
            yuanLabel.textAlignment = NSTextAlignmentLeft;
            yuanLabel.font = mainFont;
            yuanLabel.frame = CGRectMake(0, 0, 30, 40);
            yuanLabel.backgroundColor = [UIColor clearColor];
            textField.rightView = yuanLabel;
            _moneyField = textField;
        }
    }
    
    UIButton *submit = [[UIButton alloc]init];
    [submit addTarget:self action:@selector(submitClicked) forControlEvents:UIControlEventTouchUpInside];
    [submit setBackgroundColor:kColor(254, 79, 29, 1.0)];
    [submit setTitle:@"提交" forState:UIControlStateNormal];
    [submit setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    submit.frame = CGRectMake(_telField.frame.origin.x + 50, CGRectGetMaxY(_moneyField.frame) + 80, 120, 40);
    [backView addSubview:submit];

}

#pragma mark - 提交积分兑换
-(void)submitClicked
{
    if (!_nameField.text || [_nameField.text isEqualToString:@""]) {
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
        hud.customView = [[UIImageView alloc] init];
        hud.mode = MBProgressHUDModeCustomView;
        [hud hide:YES afterDelay:1.f];
        hud.labelText = @"请填写姓名";
        return;
    }
    if (!_telField.text || [_telField.text isEqualToString:@""]) {
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
        hud.customView = [[UIImageView alloc] init];
        hud.mode = MBProgressHUDModeCustomView;
        [hud hide:YES afterDelay:1.f];
        hud.labelText = @"请填写联系电话";
        return;
    }
    if (!_moneyField.text || [_moneyField.text isEqualToString:@""]) {
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
        hud.customView = [[UIImageView alloc] init];
        hud.mode = MBProgressHUDModeCustomView;
        [hud hide:YES afterDelay:1.f];
        hud.labelText = @"请填写兑换金额";
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
    if (![RegularFormat isInt:_moneyField.text]) {
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
        hud.customView = [[UIImageView alloc] init];
        hud.mode = MBProgressHUDModeCustomView;
        [hud hide:YES afterDelay:1.f];
        hud.labelText = @"兑换金额必须为整数";
        return;
    }
    if ([_moneyField.text intValue] > [_totalMoney intValue]) {
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
        hud.customView = [[UIImageView alloc] init];
        hud.mode = MBProgressHUDModeCustomView;
        [hud hide:YES afterDelay:1.f];
        hud.labelText = @"兑换金额超过最高限度";
        return;
    }
    int money = [_moneyField.text intValue];
    _moneyField.text = [NSString stringWithFormat:@"%d",money];
    [_nameField becomeFirstResponder];
    [_nameField resignFirstResponder];
    [self exchangeScore];

}

#pragma mark - Request

- (void)exchangeScore {
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
    hud.labelText = @"加载中...";
    AppDelegate *delegate = [AppDelegate shareAppDelegate];
    [NetworkInterface exchangeScoreWithToken:delegate.token userID:delegate.userID handlerName:_nameField.text handlerPhoneNumber:_telField.text money:[_moneyField.text intValue] finished:^(BOOL success, NSData *response) {
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
                    hud.labelText = @"兑换成功";
                    [_darkbackgroundImageView removeFromSuperview];
                    [self getAllScore];
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
    _nameField.text = nil;
    _telField.text = nil;
    _moneyField.text = nil;
    [_darkbackgroundImageView removeFromSuperview];
}

#pragma mark - tableview dateSource


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _scoreItems.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *ID = @"IntegralCell2";
    IntegralCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (cell == nil) {
        cell = [[IntegralCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:ID];
    }
    if (_scoreItems.count!=0) {
        ScoreModel *model = [_scoreItems objectAtIndex:indexPath.row];
        cell.orderNumLabel.text = model.orderNumber;
        cell.tradeTimeLabel.text = model.payedTime;
        NSString *tipString = [model tipsString];
        cell.intergralLabel.text = [NSString stringWithFormat:@"%@%@",tipString,model.score];
        cell.intergralType.text = [self intergaralTypeWithNum:model.scoreType];
    }
    return cell;
}

-(NSString *)intergaralTypeWithNum:(NSString *)intergralStates
{
    self.intergaralType = nil;
    if ([intergralStates isEqualToString:@"1"]) {
        _intergaralType = @"收入";
    }
    if ([intergralStates isEqualToString:@"2"]) {
        _intergaralType = @"支出";
    }
    return _intergaralType;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    static NSString *ID = @"IntegralCell1";
    IntegralCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (cell == nil) {
        cell = [[IntegralCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:ID];
    }
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 30;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 50;
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


#pragma mark - Request
- (void)getAllScore {
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
    hud.labelText = @"加载中...";
    AppDelegate *delegate = [AppDelegate shareAppDelegate];
    [NetworkInterface getScoreTotalWithToken:delegate.token userID:delegate.userID finished:^(BOOL success, NSData *response) {
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
                    NSDictionary *dict = [object objectForKey:@"result"];
                    _totalScore = [NSString stringWithFormat:@"%@",[dict objectForKey:@"quantityTotal"]];
                    int money = [[dict objectForKey:@"moneyTotal"] intValue];
                    NSString *totalM = [NSString stringWithFormat:@"%d",money/100];
                    _totalMoney = totalM;
                    _totalLabel.text = [NSString stringWithFormat:@"总积分：%@",_totalScore];
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


- (void)firstLoadData {
    _page = 1;
    [self downloadDataWithPage:_page isMore:NO];
}

- (void)downloadDataWithPage:(int)page isMore:(BOOL)isMore {
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
    hud.labelText = @"加载中...";
    AppDelegate *delegate = [AppDelegate shareAppDelegate];
    [NetworkInterface getScoreListWithToken:delegate.token userID:delegate.userID page:page rows:kPageSize finished:^(BOOL success, NSData *response) {
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
                    if (!isMore) {
                        [_scoreItems removeAllObjects];
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
                    [self parseScoreListDataWithDictionary:object];
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

#pragma mark - Data

- (void)parseScoreListDataWithDictionary:(NSDictionary *)dict {
    if (![dict objectForKey:@"result"] || ![[dict objectForKey:@"result"] isKindOfClass:[NSDictionary class]]) {
        return;
    }
    NSArray *scoreList = [[dict objectForKey:@"result"] objectForKey:@"list"];
    for (int i = 0; i < [scoreList count]; i++) {
        ScoreModel *model = [[ScoreModel alloc] initWithParseDictionary:[scoreList objectAtIndex:i]];
        [_scoreItems addObject:model];
    }
    [_tableView reloadData];
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

//处理键盘
-(void)textFieldDidBeginEditing:(UITextField *)textField
{
    if (textField == _moneyField || textField == _telField) {
        CGRect frame = CGRectMake(textField.frame.origin.x, textField.frame.origin.y + 330, textField.frame.size.width, textField.frame.size.height);
        NSLog(@"%@",NSStringFromCGRect(frame));
        int offset = frame.origin.y + 32 - (self.view.frame.size.height - 216.0);
        NSTimeInterval animationDuration = 0.30f;
        [UIView beginAnimations:@"ResizeForKeyboard" context:nil];
        [UIView setAnimationDuration:animationDuration];
        
        if (offset > 0) {
            self.view.frame = CGRectMake(0.0f, -offset, self.view.frame.size.width, self.view.frame.size.height);
            [UIView commitAnimations];
        }
    }
}

-(void)textFieldDidEndEditing:(UITextField *)textField
{
    self.view.frame =CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
}

@end
