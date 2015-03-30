//
//  AfterSellViewController.m
//  iPadff
//
//  Created by 黄含章 on 15/3/11.
//  Copyright (c) 2015年 LanTaiPro. All rights reserved.
//

#import "AfterSellViewController.h"
#import "AfterTitleCell.h"
#import "ServiceCell.h"
#import "CancelCell.h"
#import "SalesReturnCell.h"
#import "ChangeGoodCell.h"
#import "UpdateCell.h"
#import "RentBackCell.h"
#import "RefreshView.h"
#import "AppDelegate.h"
#import "NetworkInterface.h"
#import "CustomerServiceModel.h"
#import "SubmitLogisticsController.h"
#import "RepairDetailController.h"
#import "CancelDetailController.h"
#import "ReturnDetailController.h"
#import "ChangeDetailController.h"
#import "UpdateDetailController.h"
#import "RentDetailController.h"
#import "PayWayViewController.h"
#import "LoginViewController.h"
#import "AccountTool.h"

@interface AfterSellViewController ()<UITableViewDataSource,UITableViewDelegate,ServiceBtnClickDelegate,CancelCellBtnClickDelegate,SalesReturnCellBtnClickDelegate,ChangeGoodCellBtnClickDelegate,UpdateCellBtnClickDelegate,RentBackCellBtnClickDelegate,RefreshDelegate,UIAlertViewDelegate,SubmitLogisticsClickWithDataDelegate,LoginSuccessDelegate>

@property(nonatomic,strong)UIButton *serviceBtn;

@property(nonatomic,strong)UIButton *cancelBtn;

@property(nonatomic,strong)UIButton *salesReturnBtn;

@property(nonatomic,strong)UIButton *changeBtn;

@property(nonatomic,strong)UIButton *updateDataBtn;

@property(nonatomic,strong)UIButton *alterationBtn;

@property(nonatomic,assign)BOOL isChecked;

@property(nonatomic,assign)CGFloat serviceBtnX;
@property(nonatomic,assign)CGFloat serviceBtnY;
@property(nonatomic,assign)CGFloat cancelBtnX;
@property(nonatomic,assign)CGFloat salesReturnBtnX;
@property(nonatomic,assign)CGFloat changeBtnX;
@property(nonatomic,assign)CGFloat updateDataBtnX;
@property(nonatomic,assign)CGFloat alterationBtnX;

@property(nonatomic,assign)int buttonIndex;

@property(nonatomic,strong)UITableView *tableView;

@property(nonatomic,strong)NSMutableArray *dateArray;

@property(nonatomic,assign)BOOL isFirst;

@property(nonatomic,assign)CSType csType;

/***************上下拉刷新**********/
@property (nonatomic, strong) RefreshView *topRefreshView;
@property (nonatomic, strong) RefreshView *bottomRefreshView;

@property (nonatomic, assign) BOOL reloading;
@property (nonatomic, assign) CGFloat primaryOffsetY;
@property (nonatomic, assign) int page;
/**********************************/

@property(nonatomic,strong)NSMutableArray *AfterSelldateArray;

@property(nonatomic,strong)NSString *selectedId;

@property(nonatomic,strong)NSString *companyName;
@property(nonatomic,strong)NSString *submitNum;

@property(nonatomic,strong)NSString *repair_price;

@property(nonatomic,assign)BOOL isPush;

@end

@implementation AfterSellViewController

-(void)ShowLoginVC
{
    AccountModel *account = [AccountTool userModel];
    NSLog(@"%@",account);
    if (account.password) {
        [self setupHeaderView];
        [self firstLoadData];
        [self.view addSubview:self.tableView];
    }
    else
    {
        LoginViewController *loginC = [[LoginViewController alloc]init];
        loginC.LoginSuccessDelegate = self;
        loginC.view.frame = CGRectMake(0, 0, 320, 320);
        UINavigationController *nav = [[UINavigationController alloc]initWithRootViewController:loginC];
        nav.navigationBarHidden = YES;
        nav.modalPresentationStyle = UIModalPresentationCustom;
        nav.modalTransitionStyle = UIModalTransitionStyleCoverVertical;
        [self presentViewController:nav animated:YES completion:nil];
    }
}

-(void)LoginSuccess
{
    [self setupHeaderView];
    [self firstLoadData];
    [self.view addSubview:self.tableView];
}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    if (_isPush) {
        [self ShowLoginVC];
    }
}

-(UITableView *)tableView
{
    if (!_tableView) {
        _tableView = [[UITableView alloc]init];
//        _tableView.backgroundColor = kColor(214, 214, 214, 1.0);
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.frame = CGRectMake(160, 80, SCREEN_WIDTH - 160, SCREEN_HEIGHT - 80);
        if (iOS7) {
            _tableView.frame = CGRectMake(160, 80, SCREEN_HEIGHT - 160, SCREEN_WIDTH - 100);
        }
        
        [self setupRefreshView];
    }
    return _tableView;
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    _isPush = YES;
    self.isFirst = YES;
    self.view.backgroundColor = kColor(251, 251, 251, 1.0);
    self.buttonIndex = 1;
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshList:) name:RefreshCSListNotification object:nil];
    _AfterSelldateArray = [[NSMutableArray alloc]init];
    _dateArray = [[NSMutableArray alloc]init];
    NSArray *arr = [NSArray arrayWithObjects:@"1",@"2",@"3",@"4",@"5",nil];
    [_dateArray addObjectsFromArray:arr];
    [self setLeftViewWith:ChooseViewAfterSell];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)refreshList:(NSNotification *)notification {
    [self performSelector:@selector(firstLoadData) withObject:nil afterDelay:0.1f];
}

#pragma mark 创建顶部5个BTN View
-(void)setupHeaderView
{
    //创建头部View
    UIView *headerView = [[UIView alloc]init];
    headerView.backgroundColor = kColor(226, 226, 226, 1.0);
    headerView.frame = CGRectMake(160, 0, SCREEN_WIDTH - 160.f, 80);
    if (iOS7) {
        headerView.frame = CGRectMake(160, 0, SCREEN_HEIGHT - 160.f, 80);
    }
    //创建头部按钮
    UIButton *serviceBtn = [[UIButton alloc]init];
    self.isChecked = YES;
    self.serviceBtn = serviceBtn;
    serviceBtn.tag = 20001;
    [serviceBtn addTarget:self action:@selector(btnClicked:) forControlEvents:UIControlEventTouchUpInside];
    serviceBtn.backgroundColor = [UIColor clearColor];
    [serviceBtn setBackgroundImage:[UIImage imageNamed:@"chose_Btn"] forState:UIControlStateNormal];
    serviceBtn.titleLabel.font = [UIFont systemFontOfSize:20];
    [serviceBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [serviceBtn setTitle:@"维修" forState:UIControlStateNormal];
    serviceBtn.frame = CGRectMake(headerView.frame.size.width * 0.05 , 40, 110, 40);
    self.serviceBtnX = serviceBtn.frame.origin.x;
    self.serviceBtnY = serviceBtn.frame.origin.y;
    [headerView addSubview:serviceBtn];
    
    UIButton *cancelBtn = [[UIButton alloc]init];
    self.cancelBtn = cancelBtn;
    cancelBtn.tag = 20002;
    [cancelBtn addTarget:self action:@selector(btnClicked:) forControlEvents:UIControlEventTouchUpInside];
    cancelBtn.backgroundColor = [UIColor clearColor];
    cancelBtn.titleLabel.font = [UIFont systemFontOfSize:18];
    [cancelBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [cancelBtn setTitle:@"注销" forState:UIControlStateNormal];
    cancelBtn.frame = CGRectMake(CGRectGetMaxX(serviceBtn.frame), 45, 90, 36);
    self.cancelBtnX = cancelBtn.frame.origin.x;
    [headerView addSubview:cancelBtn];
    
    UIButton *salesReturnBtn = [[UIButton alloc]init];
    self.salesReturnBtn = salesReturnBtn;
    salesReturnBtn.tag = 20003;
    [salesReturnBtn addTarget:self action:@selector(btnClicked:) forControlEvents:UIControlEventTouchUpInside];
    salesReturnBtn.backgroundColor = [UIColor clearColor];
    salesReturnBtn.titleLabel.font = [UIFont systemFontOfSize:18];
    [salesReturnBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [salesReturnBtn setTitle:@"退货" forState:UIControlStateNormal];
    salesReturnBtn.frame = CGRectMake(CGRectGetMaxX(cancelBtn.frame), 45, 90, 36);
    self.salesReturnBtnX = salesReturnBtn.frame.origin.x;
    [headerView addSubview:salesReturnBtn];
    
    UIButton *changeBtn = [[UIButton alloc]init];
    self.changeBtn = changeBtn;
    changeBtn.tag = 20004;
    [changeBtn addTarget:self action:@selector(btnClicked:) forControlEvents:UIControlEventTouchUpInside];
    changeBtn.backgroundColor = [UIColor clearColor];
    changeBtn.titleLabel.font = [UIFont systemFontOfSize:18];
    [changeBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [changeBtn setTitle:@"换货" forState:UIControlStateNormal];
    changeBtn.frame = CGRectMake(CGRectGetMaxX(salesReturnBtn.frame), 45, 90, 36);
    self.changeBtnX = changeBtn.frame.origin.x;
    [headerView addSubview:changeBtn];
    
    UIButton *updateDataBtn = [[UIButton alloc]init];
    self.updateDataBtn = updateDataBtn;
    updateDataBtn.tag = 20005;
    [updateDataBtn addTarget:self action:@selector(btnClicked:) forControlEvents:UIControlEventTouchUpInside];
    updateDataBtn.backgroundColor = [UIColor clearColor];
    updateDataBtn.titleLabel.font = [UIFont systemFontOfSize:18];
    [updateDataBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [updateDataBtn setTitle:@"更新资料" forState:UIControlStateNormal];
    updateDataBtn.frame = CGRectMake(CGRectGetMaxX(changeBtn.frame), 45, 90, 36);
    self.updateDataBtnX = updateDataBtn.frame.origin.x;
    [headerView addSubview:updateDataBtn];
    
    UIButton *alterationBtn = [[UIButton alloc]init];
    self.alterationBtn = alterationBtn;
    alterationBtn.tag = 20006;
    [alterationBtn addTarget:self action:@selector(btnClicked:) forControlEvents:UIControlEventTouchUpInside];
    alterationBtn.backgroundColor = [UIColor clearColor];
    alterationBtn.titleLabel.font = [UIFont systemFontOfSize:18];
    [alterationBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [alterationBtn setTitle:@"租凭退还" forState:UIControlStateNormal];
    alterationBtn.frame = CGRectMake(CGRectGetMaxX(updateDataBtn.frame) + 18, 45, 90, 36);
    self.alterationBtnX = alterationBtn.frame.origin.x;
    [headerView addSubview:alterationBtn];
    
    [self.view addSubview:headerView];
    
}

-(void)setupRefreshView
{
    _topRefreshView = [[RefreshView alloc] initWithFrame:CGRectMake(-120, -80, self.view.frame.size.width, 80)];
    _topRefreshView.direction = PullFromTop;
    _topRefreshView.delegate = self;
    [_tableView addSubview:_topRefreshView];
    
    _bottomRefreshView = [[RefreshView alloc] initWithFrame:CGRectMake(-120, -80, self.view.frame.size.width,80)];
    _bottomRefreshView.direction = PullFromBottom;
    _bottomRefreshView.delegate = self;
    _bottomRefreshView.hidden = YES;
    [_tableView addSubview:_bottomRefreshView];

}

#pragma mark 顶部BTN的点击切换
-(void)btnClicked:(UIButton *)button
{
    //维修
    if (button.tag == 20001) {
        if (_isChecked == YES) {
            //什么都不做
        }
        else{
            _buttonIndex = 1;
//            [self tradeTypeFromIndex:1];
//            [self downloadDataWithPage:1 isMore:NO];
            [_tableView scrollsToTop];
            [self firstLoadData];
            [_serviceBtn setBackgroundImage:[UIImage imageNamed:@"chose_Btn"] forState:UIControlStateNormal];
            _serviceBtn.titleLabel.font = [UIFont systemFontOfSize:20];
            _serviceBtn.frame = CGRectMake(_serviceBtnX, _serviceBtnY, 110, 40);
            
            [_cancelBtn setBackgroundImage:nil forState:UIControlStateNormal];
            _cancelBtn.titleLabel.font = [UIFont systemFontOfSize:18];
            _cancelBtn.frame = CGRectMake(_cancelBtnX + 4, _serviceBtnY + 5, 90, 36);
            
            [_salesReturnBtn setBackgroundImage:nil forState:UIControlStateNormal];
            _salesReturnBtn.titleLabel.font = [UIFont systemFontOfSize:18];
            _salesReturnBtn.frame = CGRectMake(_salesReturnBtnX + 4, _serviceBtnY + 5, 90, 36);
            
            [_changeBtn setBackgroundImage:nil forState:UIControlStateNormal];
            _changeBtn.titleLabel.font = [UIFont systemFontOfSize:18];
            _changeBtn.frame = CGRectMake(_changeBtnX + 4, _serviceBtnY + 5, 90, 36);
            
            [_updateDataBtn setBackgroundImage:nil forState:UIControlStateNormal];
            _updateDataBtn.titleLabel.font = [UIFont systemFontOfSize:18];
            _updateDataBtn.frame = CGRectMake(_updateDataBtnX + 4, _serviceBtnY + 5, 90, 36);
            
            [_alterationBtn setBackgroundImage:nil forState:UIControlStateNormal];
            _alterationBtn.titleLabel.font = [UIFont systemFontOfSize:18];
            _alterationBtn.frame = CGRectMake(_alterationBtnX + 4, _serviceBtnY + 5, 90, 36);
            
            _isChecked = YES;
        }
    }
    //注销
    if (button.tag == 20002) {
        _buttonIndex = 2;
        [_tableView scrollsToTop];
         [self firstLoadData];
        [_cancelBtn setBackgroundImage:[UIImage imageNamed:@"chose_Btn"] forState:UIControlStateNormal];
        _cancelBtn.titleLabel.font = [UIFont systemFontOfSize:20];
        _cancelBtn.frame = CGRectMake(_cancelBtnX - 10, _serviceBtnY, 110, 40);
        
        [_serviceBtn setBackgroundImage:nil forState:UIControlStateNormal];
        _serviceBtn.titleLabel.font = [UIFont systemFontOfSize:18];
        _serviceBtn.frame = CGRectMake(_serviceBtnX + 4, _serviceBtnY + 5, 90, 36);
        
        [_salesReturnBtn setBackgroundImage:nil forState:UIControlStateNormal];
        _salesReturnBtn.titleLabel.font = [UIFont systemFontOfSize:18];
        _salesReturnBtn.frame = CGRectMake(_salesReturnBtnX + 4, _serviceBtnY + 5, 90, 36);
        
        [_changeBtn setBackgroundImage:nil forState:UIControlStateNormal];
        _changeBtn.titleLabel.font = [UIFont systemFontOfSize:18];
        _changeBtn.frame = CGRectMake(_changeBtnX + 4, _serviceBtnY + 5, 90, 36);
        
        [_updateDataBtn setBackgroundImage:nil forState:UIControlStateNormal];
        _updateDataBtn.titleLabel.font = [UIFont systemFontOfSize:18];
        _updateDataBtn.frame = CGRectMake(_updateDataBtnX + 4, _serviceBtnY + 5, 90, 36);
        
        [_alterationBtn setBackgroundImage:nil forState:UIControlStateNormal];
        _alterationBtn.titleLabel.font = [UIFont systemFontOfSize:18];
        _alterationBtn.frame = CGRectMake(_alterationBtnX + 4, _serviceBtnY + 5, 90, 36);
        
        _isChecked = NO;
    }
    //退货
    if (button.tag == 20003) {
        _buttonIndex = 3;
        [_tableView scrollsToTop];
        [self firstLoadData];
        [_salesReturnBtn setBackgroundImage:[UIImage imageNamed:@"chose_Btn"] forState:UIControlStateNormal];
        _salesReturnBtn.titleLabel.font = [UIFont systemFontOfSize:20];
        _salesReturnBtn.frame = CGRectMake(_salesReturnBtnX - 10, _serviceBtnY, 110, 40);
        
        [_serviceBtn setBackgroundImage:nil forState:UIControlStateNormal];
        _serviceBtn.titleLabel.font = [UIFont systemFontOfSize:18];
        _serviceBtn.frame = CGRectMake(_serviceBtnX + 4, _serviceBtnY + 5, 90, 36);
        
        [_cancelBtn setBackgroundImage:nil forState:UIControlStateNormal];
        _cancelBtn.titleLabel.font = [UIFont systemFontOfSize:18];
        _cancelBtn.frame = CGRectMake(_cancelBtnX + 4, _serviceBtnY + 5, 90, 36);
        
        [_changeBtn setBackgroundImage:nil forState:UIControlStateNormal];
        _changeBtn.titleLabel.font = [UIFont systemFontOfSize:18];
        _changeBtn.frame = CGRectMake(_changeBtnX + 4, _serviceBtnY + 5, 90, 36);
        
        [_updateDataBtn setBackgroundImage:nil forState:UIControlStateNormal];
        _updateDataBtn.titleLabel.font = [UIFont systemFontOfSize:18];
        _updateDataBtn.frame = CGRectMake(_updateDataBtnX + 4, _serviceBtnY + 5, 90, 36);
        
        [_alterationBtn setBackgroundImage:nil forState:UIControlStateNormal];
        _alterationBtn.titleLabel.font = [UIFont systemFontOfSize:18];
        _alterationBtn.frame = CGRectMake(_alterationBtnX + 4, _serviceBtnY + 5, 90, 36);
        
        _isChecked = NO;
    }
    //换货
    if (button.tag == 20004) {
        _buttonIndex = 4;
        [_tableView scrollsToTop];
         [self firstLoadData];
        [_changeBtn setBackgroundImage:[UIImage imageNamed:@"chose_Btn"] forState:UIControlStateNormal];
        _changeBtn.titleLabel.font = [UIFont systemFontOfSize:20];
        _changeBtn.frame = CGRectMake(_changeBtnX - 10, _serviceBtnY, 110, 40);
        
        [_serviceBtn setBackgroundImage:nil forState:UIControlStateNormal];
        _serviceBtn.titleLabel.font = [UIFont systemFontOfSize:18];
        _serviceBtn.frame = CGRectMake(_serviceBtnX + 4, _serviceBtnY + 5, 90, 36);
        
        [_cancelBtn setBackgroundImage:nil forState:UIControlStateNormal];
        _cancelBtn.titleLabel.font = [UIFont systemFontOfSize:18];
        _cancelBtn.frame = CGRectMake(_cancelBtnX + 4, _serviceBtnY + 5, 90, 36);
        
        [_salesReturnBtn setBackgroundImage:nil forState:UIControlStateNormal];
        _salesReturnBtn.titleLabel.font = [UIFont systemFontOfSize:18];
        _salesReturnBtn.frame = CGRectMake(_salesReturnBtnX + 4, _serviceBtnY + 5, 90, 36);
        
        [_updateDataBtn setBackgroundImage:nil forState:UIControlStateNormal];
        _updateDataBtn.titleLabel.font = [UIFont systemFontOfSize:18];
        _updateDataBtn.frame = CGRectMake(_updateDataBtnX + 4, _serviceBtnY + 5, 90, 36);
        
        [_alterationBtn setBackgroundImage:nil forState:UIControlStateNormal];
        _alterationBtn.titleLabel.font = [UIFont systemFontOfSize:18];
        _alterationBtn.frame = CGRectMake(_alterationBtnX + 4, _serviceBtnY + 5, 90, 36);
        
        _isChecked = NO;
    }
    
    //换货
    if (button.tag == 20004) {
        _buttonIndex = 4;
        [_tableView scrollsToTop];
         [self firstLoadData];
        [_changeBtn setBackgroundImage:[UIImage imageNamed:@"chose_Btn"] forState:UIControlStateNormal];
        _changeBtn.titleLabel.font = [UIFont systemFontOfSize:20];
        _changeBtn.frame = CGRectMake(_changeBtnX - 10, _serviceBtnY, 110, 40);
        
        [_serviceBtn setBackgroundImage:nil forState:UIControlStateNormal];
        _serviceBtn.titleLabel.font = [UIFont systemFontOfSize:18];
        _serviceBtn.frame = CGRectMake(_serviceBtnX + 4, _serviceBtnY + 5, 90, 36);
        
        [_cancelBtn setBackgroundImage:nil forState:UIControlStateNormal];
        _cancelBtn.titleLabel.font = [UIFont systemFontOfSize:18];
        _cancelBtn.frame = CGRectMake(_cancelBtnX + 4, _serviceBtnY + 5, 90, 36);
        
        [_salesReturnBtn setBackgroundImage:nil forState:UIControlStateNormal];
        _salesReturnBtn.titleLabel.font = [UIFont systemFontOfSize:18];
        _salesReturnBtn.frame = CGRectMake(_salesReturnBtnX - 10, _serviceBtnY + 5, 90, 36);
        
        [_updateDataBtn setBackgroundImage:nil forState:UIControlStateNormal];
        _updateDataBtn.titleLabel.font = [UIFont systemFontOfSize:18];
        _updateDataBtn.frame = CGRectMake(_updateDataBtnX + 4, _serviceBtnY + 5, 90, 36);
        
        [_alterationBtn setBackgroundImage:nil forState:UIControlStateNormal];
        _alterationBtn.titleLabel.font = [UIFont systemFontOfSize:18];
        _alterationBtn.frame = CGRectMake(_alterationBtnX + 4, _serviceBtnY + 5, 90, 36);
        
        _isChecked = NO;
    }
    //更新资料
    if (button.tag == 20005) {
        _buttonIndex = 5;
        [_tableView scrollsToTop];
         [self firstLoadData];
        _isChecked = NO;
        [_updateDataBtn setBackgroundImage:[UIImage imageNamed:@"chose_Btn"] forState:UIControlStateNormal];
        _updateDataBtn.titleLabel.font = [UIFont systemFontOfSize:20];
        _updateDataBtn.frame = CGRectMake(_updateDataBtnX - 10, _serviceBtnY, 110, 40);
        
        [_serviceBtn setBackgroundImage:nil forState:UIControlStateNormal];
        _serviceBtn.titleLabel.font = [UIFont systemFontOfSize:18];
        _serviceBtn.frame = CGRectMake(_serviceBtnX + 4, _serviceBtnY + 5, 90, 36);
        
        [_cancelBtn setBackgroundImage:nil forState:UIControlStateNormal];
        _cancelBtn.titleLabel.font = [UIFont systemFontOfSize:18];
        _cancelBtn.frame = CGRectMake(_cancelBtnX + 4, _serviceBtnY + 5, 90, 36);
        
        [_salesReturnBtn setBackgroundImage:nil forState:UIControlStateNormal];
        _salesReturnBtn.titleLabel.font = [UIFont systemFontOfSize:18];
        _salesReturnBtn.frame = CGRectMake(_salesReturnBtnX + 4, _serviceBtnY + 5, 90, 36);
        
        [_changeBtn setBackgroundImage:nil forState:UIControlStateNormal];
        _changeBtn.titleLabel.font = [UIFont systemFontOfSize:18];
        _changeBtn.frame = CGRectMake(_changeBtnX + 4, _serviceBtnY + 5, 90, 36);
        
        [_alterationBtn setBackgroundImage:nil forState:UIControlStateNormal];
        _alterationBtn.titleLabel.font = [UIFont systemFontOfSize:18];
        _alterationBtn.frame = CGRectMake(_alterationBtnX + 4, _serviceBtnY + 5, 90, 36);
    }
    
    //租凭退还
    if (button.tag == 20006) {
        _buttonIndex = 6;
        [_tableView scrollsToTop];
         [self firstLoadData];
        _isChecked = NO;
        [_alterationBtn setBackgroundImage:[UIImage imageNamed:@"chose_Btn"] forState:UIControlStateNormal];
        _alterationBtn.titleLabel.font = [UIFont systemFontOfSize:20];
        _alterationBtn.frame = CGRectMake(_alterationBtnX - 10, _serviceBtnY, 110, 40);
        
        [_serviceBtn setBackgroundImage:nil forState:UIControlStateNormal];
        _serviceBtn.titleLabel.font = [UIFont systemFontOfSize:18];
        _serviceBtn.frame = CGRectMake(_serviceBtnX + 4, _serviceBtnY + 5, 90, 36);
        
        [_cancelBtn setBackgroundImage:nil forState:UIControlStateNormal];
        _cancelBtn.titleLabel.font = [UIFont systemFontOfSize:18];
        _cancelBtn.frame = CGRectMake(_cancelBtnX + 4, _serviceBtnY + 5, 90, 36);
        
        [_salesReturnBtn setBackgroundImage:nil forState:UIControlStateNormal];
        _salesReturnBtn.titleLabel.font = [UIFont systemFontOfSize:18];
        _salesReturnBtn.frame = CGRectMake(_salesReturnBtnX + 4, _serviceBtnY + 5, 90, 36);
        
        [_changeBtn setBackgroundImage:nil forState:UIControlStateNormal];
        _changeBtn.titleLabel.font = [UIFont systemFontOfSize:18];
        _changeBtn.frame = CGRectMake(_changeBtnX + 4, _serviceBtnY + 5, 90, 36);
        
        [_updateDataBtn setBackgroundImage:nil forState:UIControlStateNormal];
        _updateDataBtn.titleLabel.font = [UIFont systemFontOfSize:18];
        _updateDataBtn.frame = CGRectMake(_updateDataBtnX + 4, _serviceBtnY + 5, 90, 36);
    }
    
}

-(void)csTypeWithButtonIdex:(int)buttonIndex
{
    switch (_buttonIndex) {
        case 1:
            self.csType = CSTypeRepair;
            break;
        case 2:
            self.csType = CSTypeCancel;
            break;
        case 3:
            self.csType = CSTypeReturn;
            break;
        case 4:
            self.csType = CSTypeChange;
            break;
        case 5:
            self.csType = CSTypeUpdate;
            break;
        case 6:
            self.csType = CSTypeLease;
            break;
            
        default:
            break;
    }
}

#pragma mark - Requst

-(void)firstLoadData
{
    _page = 1;
    [self downloadDataWithPage:_page isMore:NO];
}

- (void)downloadDataWithPage:(int)page isMore:(BOOL)isMore {
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
    hud.labelText = @"加载中...";
    AppDelegate *delegate = [AppDelegate shareAppDelegate];
    [self csTypeWithButtonIdex:_buttonIndex];
    [NetworkInterface getCSListWithToken:delegate.token userID:delegate.userID csType:_csType page:page rows:kPageSize finished:^(BOOL success, NSData *response) {
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
                        [_AfterSelldateArray removeAllObjects];
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
                    [self parseCSDataWithDictionary:object];
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

- (void)parseCSDataWithDictionary:(NSDictionary *)dict {
    if (![dict objectForKey:@"result"] || ![[dict objectForKey:@"result"] isKindOfClass:[NSDictionary class]]) {
        return;
    }
    NSArray *csList = [[dict objectForKey:@"result"] objectForKey:@"content"];
    for (int i = 0; i < [csList count]; i++) {
        CustomerServiceModel *model = [[CustomerServiceModel alloc] initWithParseDictionary:[csList objectAtIndex:i]];
        [_AfterSelldateArray addObject:model];
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
        _bottomRefreshView.frame = CGRectMake(-120, _tableView.contentSize.height , _tableView.bounds.size.width, 60);
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
    _bottomRefreshView.frame = CGRectMake(-120, _tableView.contentSize.height , _tableView.bounds.size.width, 60);
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


#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return 2;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0) {
        return 1;
    }else{
        return _AfterSelldateArray.count;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    //标题Cell
    if (indexPath.section == 0)
    {
    NSString *ID = [NSString stringWithFormat:@"cell%d",_buttonIndex];
    AfterTitleCell *cell = [[AfterTitleCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:ID];
    return cell;
    }
    else
    //内容Cell
    {
        //维修
        if (_buttonIndex == 1 && _AfterSelldateArray.count!=0) {
            CustomerServiceModel *model = [_AfterSelldateArray objectAtIndex:indexPath.row];
            _isFirst = YES;
            NSString *ID = [NSString stringWithFormat:@"ServiceCell%@",model.status];
            ServiceCell *serviceCell = [tableView dequeueReusableCellWithIdentifier:ID];
            if (serviceCell == nil) {
                serviceCell = [[ServiceCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:ID];
            }
            serviceCell.ServieceBtnDelgete = self;
            serviceCell.repair_price = model.repair_price;
            serviceCell.seviceNum.text = model.applyNum;
            serviceCell.terminalLabel.text = model.terminalNum;
            serviceCell.seviceTime.text = model.createTime;
            serviceCell.selectedID = model.csID;
            return serviceCell;
        }
        //退货
        if (_buttonIndex == 3&& _AfterSelldateArray.count!=0) {
            CustomerServiceModel *model = [_AfterSelldateArray objectAtIndex:indexPath.row];
            _isFirst = NO;
            NSString *ID = [NSString stringWithFormat:@"SalesReturnCell%@",model.status];
            SalesReturnCell *salesReturnCell = [tableView dequeueReusableCellWithIdentifier:ID];
            if (salesReturnCell == nil) {
                salesReturnCell = [[SalesReturnCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:ID];
            }
            salesReturnCell.SalesReturnCellBtnDelegate = self;
            salesReturnCell.SalesReturnNum.text = model.applyNum;
            salesReturnCell.terminalLabel.text = model.terminalNum;
            salesReturnCell.SalesReturnTime.text = model.createTime;
            salesReturnCell.selectedID = model.csID;

            return salesReturnCell;
        }
        //换货
        if (_buttonIndex == 4&& _AfterSelldateArray.count!=0) {
            CustomerServiceModel *model = [_AfterSelldateArray objectAtIndex:indexPath.row];
            _isFirst = NO;
            NSString *ID = [NSString stringWithFormat:@"ChangeGoodCell%@",model.status];
            ChangeGoodCell *changeGoodCell = [tableView dequeueReusableCellWithIdentifier:ID];
            if (changeGoodCell == nil) {
                changeGoodCell = [[ChangeGoodCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:ID];
            }
            changeGoodCell.ChangeGoodCellBtnDelegate = self;
            changeGoodCell.ChangeGoodNum.text = model.applyNum;
            changeGoodCell.terminalLabel.text = model.terminalNum;
            changeGoodCell.ChangeGoodTime.text = model.createTime;
            changeGoodCell.selectedID = model.csID;
            return changeGoodCell;
        }
        //更新资料
        if (_buttonIndex == 5&& _AfterSelldateArray.count!=0) {
            CustomerServiceModel *model = [_AfterSelldateArray objectAtIndex:indexPath.row];
            _isFirst = NO;
            NSString *ID = [NSString stringWithFormat:@"UpdateCell%@",model.status];
            UpdateCell *updateCell = [tableView dequeueReusableCellWithIdentifier:ID];
            if (updateCell == nil) {
                updateCell = [[UpdateCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:ID];
            }
            updateCell.UpdateCellBtnDelegate = self;
            updateCell.UpdateNum.text = model.applyNum;
            updateCell.terminalLabel.text = model.terminalNum;
            updateCell.UpdateTime.text = model.createTime;
            updateCell.selectedID = model.csID;
            return updateCell;
        }
        //租凭退还
        if (_buttonIndex == 6&& _AfterSelldateArray.count!=0) {
            CustomerServiceModel *model = [_AfterSelldateArray objectAtIndex:indexPath.row];
            _isFirst = NO;
            NSString *ID = [NSString stringWithFormat:@"RentBackCell%@",model.status];
            RentBackCell *rentbackCell = [tableView dequeueReusableCellWithIdentifier:ID];
            if (rentbackCell == nil) {
                rentbackCell = [[RentBackCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:ID];
            }
            rentbackCell.RentBackCellBtnDelegate = self;
            rentbackCell.RentBackNum.text = model.applyNum;
            rentbackCell.terminalLabel.text = model.terminalNum;
            rentbackCell.RentBackTime.text = model.createTime;
            rentbackCell.selectedID = model.csID;
            return rentbackCell;
        }
        //注销
        if (_buttonIndex == 2&& _AfterSelldateArray.count!=0){
            CustomerServiceModel *model = [_AfterSelldateArray objectAtIndex:indexPath.row];
            NSString *ID = [NSString stringWithFormat:@"CancelCell%@",model.status];
            CancelCell *cancelCell = [tableView dequeueReusableCellWithIdentifier:ID];
            _isFirst = NO;
            if (cancelCell == nil) {
                cancelCell = [[CancelCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:ID];
            }
            cancelCell.CancelCellBtndelegate = self;
            cancelCell.CancelNum.text = model.applyNum;
            cancelCell.terminalLabel.text = model.terminalNum;
            cancelCell.CancelTime.text = model.createTime;
            cancelCell.selectedID = model.csID;
            return cancelCell;
        }
        else{
            NSString *ID = @"kong";
            CancelCell *cancelCell = [tableView dequeueReusableCellWithIdentifier:ID];
            _isFirst = NO;
            if (cancelCell == nil) {
                cancelCell = [[CancelCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:ID];
            }
            return cancelCell;
        }
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        return 60;
    }else{
        CustomerServiceModel *model = [_AfterSelldateArray objectAtIndex:indexPath.row];
        if ([model.status isEqualToString:@"1"]) {
            if (_isFirst) {
                return 120;
            }else{
                return 80;
            }
            
        }else{
            
            return 80;
        }
    }
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    self.isPush = NO;
    CustomerServiceModel *model = [_AfterSelldateArray objectAtIndex:indexPath.row];
    self.selectedId = model.csID;
    self.repair_price = model.repair_price;
    switch (_csType) {
        case CSTypeRepair:
            [self pushRepairDetailWithcsID:_selectedId AndCsType:_csType];
            break;
            
            case CSTypeCancel:
            [self pushCancelDetailWithcsID:_selectedId AndCsType:_csType];
            break;
            
            case CSTypeReturn:
            [self pushReturnDetailWithcsID:_selectedId AndCsType:_csType];
            break;
            
            case CSTypeChange:
            [self pushChangeDetailWithcsID:_selectedId AndCsType:_csType];
            break;
            
        case CSTypeUpdate:
            [self pushUpdateDetailWithcsID:_selectedId AndCsType:_csType];
            break;
            
        case CSTypeLease:
            [self pushRentDetailWithcsID:_selectedId AndCsType:_csType];
            break;
            
        default:
            break;
    }
}

-(void)pushRepairDetailWithcsID:(NSString *)csId AndCsType:(CSType)csType
{
    RepairDetailController *repairVC = [[RepairDetailController alloc]init];
    repairVC.hidesBottomBarWhenPushed = YES;
    repairVC.totalMoney = [_repair_price intValue];
    repairVC.csType = csType;
    repairVC.csID = csId;
    [self.navigationController pushViewController:repairVC animated:YES];
}

-(void)pushCancelDetailWithcsID:(NSString *)csId AndCsType:(CSType)csType
{
    CancelDetailController *cancelVC = [[CancelDetailController alloc]init];
    cancelVC.hidesBottomBarWhenPushed = YES;
    cancelVC.csType = csType;
    cancelVC.csID = csId;
    [self.navigationController pushViewController:cancelVC animated:YES];
}

-(void)pushReturnDetailWithcsID:(NSString *)csId AndCsType:(CSType)csType
{
    ReturnDetailController *returnVC = [[ReturnDetailController alloc]init];
    returnVC.hidesBottomBarWhenPushed = YES;
    returnVC.csType = csType;
    returnVC.csID = csId;
    [self.navigationController pushViewController:returnVC animated:YES];
}

-(void)pushChangeDetailWithcsID:(NSString *)csId AndCsType:(CSType)csType
{
    ChangeDetailController *changeVC = [[ChangeDetailController alloc]init];
    changeVC.hidesBottomBarWhenPushed = YES;
    changeVC.csType = csType;
    changeVC.csID = csId;
    [self.navigationController pushViewController:changeVC animated:YES];
}

-(void)pushUpdateDetailWithcsID:(NSString *)csId AndCsType:(CSType)csType
{
    UpdateDetailController *updateVC = [[UpdateDetailController alloc]init];
    updateVC.hidesBottomBarWhenPushed = YES;
    updateVC.csType = csType;
    updateVC.csID = csId;
    [self.navigationController pushViewController:updateVC animated:YES];
}

-(void)pushRentDetailWithcsID:(NSString *)csId AndCsType:(CSType)csType
{
    RentDetailController *rentVC = [[RentDetailController alloc]init];
    rentVC.hidesBottomBarWhenPushed = YES;
    rentVC.csType = csType;
    rentVC.csID = csId;
    [self.navigationController pushViewController:rentVC animated:YES];
}


//- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
//    if ([tableView respondsToSelector:@selector(setSeparatorInset:)]) {
//        [tableView setSeparatorInset:UIEdgeInsetsZero];
//    }
//    if ([tableView respondsToSelector:@selector(setLayoutMargins:)]) {
//        [tableView setLayoutMargins:UIEdgeInsetsZero];
//    }
//    if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
//        [cell setLayoutMargins:UIEdgeInsetsZero];
//    }
//}

#pragma mark - 维修页面Btn点击事件
-(void)serviceBtnClick:(int)btnTag WithSelectedID:(NSString *)selectedID WithRepair_price:(NSString *)repair_price
{
    self.selectedId = selectedID;
    switch (btnTag) {
        case 111:
            NSLog(@"点击了支付维修费 id为%@",selectedID);
            [self setPayWayWithPrice:repair_price];
            break;
        case 112:
            NSLog(@"点击了取消申请");
            [self setAlertView];
            break;
        case 113:
            NSLog(@"点击了提交物流信息");
            [self submitRepair];
            break;
        default:
            break;
    }
}

-(void)setPayWayWithPrice:(NSString *)repair_price
{
    PayWayViewController *payVC = [[PayWayViewController alloc]init];
    payVC.orderID = _selectedId;
    payVC.totalPrice = [repair_price intValue];
    payVC.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:payVC animated:YES];
}

#pragma mark - 注销页面Btn点击事件
-(void)CancelCellBtnClick:(int)btnTag WithSelectedID:(NSString *)selectedID
{
    self.selectedId = selectedID;
    switch (btnTag) {
        case 222:
            NSLog(@"点击了取消申请 id为%@",selectedID);
            [self setAlertView];
            break;
        case 223:
            NSLog(@"点击了重新提交注销");
            [self submitCanncelApply];
            break;
        default:
            break;
    }
}

#pragma mark - 退货页面Btn点击事件
-(void)SalesReturnCellBtnClick:(int)btnTag WithSelectedID:(NSString *)selectedID
{
    self.selectedId = selectedID;
    switch (btnTag) {
        case 224:
            NSLog(@"点击了取消申请 id为%@",selectedID);
            [self setAlertView];
            break;
        case 225:
            NSLog(@"点击了提交物流信息");
            [self submitRepair];
            break;
        default:
            break;
    }
}

#pragma mark - 换货页面Btn点击事件
-(void)ChangeGoodCellBtnClick:(int)btnTag WithSelectedID:(NSString *)selectedID
{
    self.selectedId = selectedID;
    switch (btnTag) {
        case 226:
            NSLog(@"点击了取消申请 id为%@",selectedID);
            [self setAlertView];
            break;
        case 227:
            NSLog(@"点击了提交物流信息");
            [self submitRepair];
            break;
        default:
            break;
    }
}

#pragma mark - 更新资料页面Btn点击事件
-(void)UpdateCellBtnClick:(int)btnTag WithSelectedID:(NSString *)selectedID
{
    self.selectedId = selectedID;
    switch (btnTag) {
        case 228:
            NSLog(@"点击了取消申请 id为%@",selectedID);
            [self setAlertView];
            break;
        default:
            break;
    }
}

#pragma mark - 租凭退还页面Btn点击事件
-(void)RentBackCellBtnClick:(int)btnTag WithSelectedID:(NSString *)selectedID
{
    self.selectedId = selectedID;
    switch (btnTag) {
        case 229:
            NSLog(@"点击了取消申请 id为%@",selectedID);
            [self setAlertView];
            break;
        default:
            break;
    }
}

-(void)setAlertView
{
    UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"提示信息" message:@"确定取消申请?" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:@"取消", nil];
    [alertView show];
}

-(void)submitRepair
{
    SubmitLogisticsController *submitLogisticsVC = [[SubmitLogisticsController alloc]init];
    submitLogisticsVC.SubmitLogisticsClickWithDataDelegate = self;
    submitLogisticsVC.isChild = NO;
    
    UINavigationController *nav = [[UINavigationController alloc]initWithRootViewController:submitLogisticsVC];
    
    nav.navigationBarHidden = YES;
    
    nav.modalPresentationStyle = UIModalPresentationCustom;
    
    nav.modalTransitionStyle = UIModalTransitionStyleCoverVertical;
    
    [self presentViewController:nav animated:YES completion:nil];
}

-(void)SubmitLogisticsClickedWithName:(NSString *)companyName AndNum:(NSString *)logisticsNum
{
    self.companyName = companyName;
    self.submitNum = logisticsNum;
    [self submitLogisticInfo];
}

#pragma mark - 按钮事件请求
//取消申请
- (void)cancelApply {
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
    hud.labelText = @"加载中...";
    AppDelegate *delegate = [AppDelegate shareAppDelegate];
    [NetworkInterface csCancelWithToken:delegate.token csID:_selectedId csType:_csType finished:^(BOOL success, NSData *response) {
        NSLog(@"%@",[[NSString alloc] initWithData:response encoding:NSUTF8StringEncoding]);
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
                    hud.labelText = @"取消申请成功";
                    [self firstLoadData];
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

//重新提交注销申请
- (void)submitCanncelApply {
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
    hud.labelText = @"加载中...";
    AppDelegate *delegate = [AppDelegate shareAppDelegate];
    [NetworkInterface submitCancelInfoWithToken:delegate.token csID:_selectedId finished:^(BOOL success, NSData *response) {
        NSLog(@"%@",[[NSString alloc] initWithData:response encoding:NSUTF8StringEncoding]);
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
                    hud.labelText = @"提交成功";
                    [self firstLoadData];
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

#pragma mark - Request

- (void)submitLogisticInfo {
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
    hud.labelText = @"加载中...";
    AppDelegate *delegate = [AppDelegate shareAppDelegate];
    [NetworkInterface csLogisticWithToken:delegate.token userID:delegate.userID csID:_selectedId csType:_csType logisticCompany:_companyName logisticNumber:_submitNum finished:^(BOOL success, NSData *response) {
        NSLog(@"%@",[[NSString alloc] initWithData:response encoding:NSUTF8StringEncoding]);
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
                    hud.labelText = @"提交物流信息成功";
                    [self firstLoadData];
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




-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 0) {
        [self cancelApply];
    }
}


@end
