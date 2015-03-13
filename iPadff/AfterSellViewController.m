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

@interface AfterSellViewController ()<UITableViewDataSource,UITableViewDelegate,ServiceBtnClickDelegate,CancelCellBtnClickDelegate,SalesReturnCellBtnClickDelegate,ChangeGoodCellBtnClickDelegate,UpdateCellBtnClickDelegate,RentBackCellBtnClickDelegate>

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

@end

@implementation AfterSellViewController

-(UITableView *)tableView
{
    if (!_tableView) {
        _tableView = [[UITableView alloc]init];
//        _tableView.backgroundColor = kColor(214, 214, 214, 1.0);
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.frame = CGRectMake(160, 80, SCREEN_WIDTH - 160, SCREEN_HEIGHT);
        if (iOS7) {
            _tableView.frame = CGRectMake(160, 80, SCREEN_HEIGHT - 160, SCREEN_WIDTH);
        }
    }
    return _tableView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = kColor(251, 251, 251, 1.0);
    self.buttonIndex = 1;
    _dateArray = [[NSMutableArray alloc]init];
    NSArray *arr = [NSArray arrayWithObjects:@"1",@"2",@"3",@"4",@"5",nil];
    [_dateArray addObjectsFromArray:arr];
    [self setLeftViewWith:ChooseViewAfterSell];
    [self setupHeaderView];
    [self.view addSubview:self.tableView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
            [_tableView reloadData];
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
         [_tableView reloadData];
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
         [_tableView reloadData];
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
         [_tableView reloadData];
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
         [_tableView reloadData];
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
         [_tableView reloadData];
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
         [_tableView reloadData];
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

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return 2;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0) {
        return 1;
    }else{
        return 5;
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
        if (_buttonIndex == 1) {
            self.isFirst = YES;
            NSString *ID = [NSString stringWithFormat:@"ServiceCell%@",[_dateArray objectAtIndex:indexPath.row]];
            ServiceCell *serviceCell = [tableView dequeueReusableCellWithIdentifier:ID];
            if (serviceCell == nil) {
                serviceCell = [[ServiceCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:ID];
            }
            serviceCell.ServieceBtnDelgete = self;
            if (indexPath.row == 0) {
                serviceCell.seviceNum.text = @"12312312312312";
                serviceCell.terminalLabel.text = @"123131313131313";
                serviceCell.seviceTime.text = @"2014-09-10 20:22:22";
            }
            
            if (indexPath.row == 1) {
                serviceCell.seviceNum.text = @"12312312312312";
                serviceCell.terminalLabel.text = @"123131313131313";
                serviceCell.seviceTime.text = @"2014-09-10 20:22:22";
            }
            return serviceCell;
        }
        //退货
        if (_buttonIndex == 3) {
            self.isFirst = NO;
            NSString *ID = [NSString stringWithFormat:@"SalesReturnCell%@",[_dateArray objectAtIndex:indexPath.row]];
            SalesReturnCell *salesReturnCell = [tableView dequeueReusableCellWithIdentifier:ID];
            if (salesReturnCell == nil) {
                salesReturnCell = [[SalesReturnCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:ID];
            }
            salesReturnCell.SalesReturnCellBtnDelegate = self;
            if (indexPath.row == 0) {
                salesReturnCell.SalesReturnNum.text = @"12312312312312";
                salesReturnCell.terminalLabel.text = @"123131313131313";
                salesReturnCell.SalesReturnTime.text = @"2014-09-10 20:22:22";
            }
            
            if (indexPath.row == 1) {
                salesReturnCell.SalesReturnNum.text = @"12312312312312";
                salesReturnCell.terminalLabel.text = @"123131313131313";
                salesReturnCell.SalesReturnTime.text = @"2014-09-10 20:22:22";
            }
            return salesReturnCell;
        }
        //换货
        if (_buttonIndex == 4) {
            self.isFirst = NO;
            NSString *ID = [NSString stringWithFormat:@"ChangeGoodCell%@",[_dateArray objectAtIndex:indexPath.row]];
            ChangeGoodCell *changeGoodCell = [tableView dequeueReusableCellWithIdentifier:ID];
            if (changeGoodCell == nil) {
                changeGoodCell = [[ChangeGoodCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:ID];
            }
            changeGoodCell.ChangeGoodCellBtnDelegate = self;
            if (indexPath.row == 0) {
                changeGoodCell.ChangeGoodNum.text = @"12312312312312";
                changeGoodCell.terminalLabel.text = @"123131313131313";
                changeGoodCell.ChangeGoodTime.text = @"2014-09-10 20:22:22";
            }
            
            if (indexPath.row == 1) {
                changeGoodCell.ChangeGoodNum.text = @"12312312312312";
                changeGoodCell.terminalLabel.text = @"123131313131313";
                changeGoodCell.ChangeGoodTime.text = @"2014-09-10 20:22:22";
            }
            return changeGoodCell;
        }
        //更新资料
        if (_buttonIndex == 5) {
            self.isFirst = NO;
            NSString *ID = [NSString stringWithFormat:@"UpdateCell%@",[_dateArray objectAtIndex:indexPath.row]];
            UpdateCell *updateCell = [tableView dequeueReusableCellWithIdentifier:ID];
            if (updateCell == nil) {
                updateCell = [[UpdateCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:ID];
            }
            updateCell.UpdateCellBtnDelegate = self;
            if (indexPath.row == 0) {
                updateCell.UpdateNum.text = @"12312312312312";
                updateCell.terminalLabel.text = @"123131313131313";
                updateCell.UpdateTime.text = @"2014-09-10 20:22:22";
            }
            
            if (indexPath.row == 1) {
                updateCell.UpdateNum.text = @"12312312312312";
                updateCell.terminalLabel.text = @"123131313131313";
                updateCell.UpdateTime.text = @"2014-09-10 20:22:22";
            }
            return updateCell;
        }
        //租凭退还
        if (_buttonIndex == 6) {
            self.isFirst = NO;
            NSString *ID = [NSString stringWithFormat:@"RentBackCell%@",[_dateArray objectAtIndex:indexPath.row]];
            RentBackCell *rentbackCell = [tableView dequeueReusableCellWithIdentifier:ID];
            if (rentbackCell == nil) {
                rentbackCell = [[RentBackCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:ID];
            }
            rentbackCell.RentBackCellBtnDelegate = self;
            if (indexPath.row == 0) {
                rentbackCell.RentBackNum.text = @"12312312312312";
                rentbackCell.terminalLabel.text = @"123131313131313";
                rentbackCell.RentBackTime.text = @"2014-09-10 20:22:22";
            }
            
            if (indexPath.row == 1) {
                rentbackCell.RentBackNum.text = @"12312312312312";
                rentbackCell.terminalLabel.text = @"123131313131313";
                rentbackCell.RentBackTime.text = @"2014-09-10 20:22:22";
            }
            return rentbackCell;
        }
        //注销
        else{
            NSString *ID = [NSString stringWithFormat:@"CancelCell%@",[_dateArray objectAtIndex:indexPath.row]];
            CancelCell *cancelCell = [tableView dequeueReusableCellWithIdentifier:ID];
            _isFirst = NO;
            if (cancelCell == nil) {
                cancelCell = [[CancelCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:ID];
            }
            cancelCell.CancelCellBtndelegate = self;
            if (indexPath.row == 0) {
                cancelCell.CancelNum.text = @"12312312312312";
                cancelCell.terminalLabel.text = @"123131313131313";
                cancelCell.CancelTime.text = @"2014-09-10 20:22:22";
            }
            
            if (indexPath.row == 1) {
                cancelCell.CancelNum.text = @"12312312312312";
                cancelCell.terminalLabel.text = @"123131313131313";
                cancelCell.CancelTime.text = @"2014-09-10 20:22:22";
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
        NSString *str = [_dateArray objectAtIndex:indexPath.row];
        if ([str isEqualToString:@"1"]) {
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
-(void)serviceBtnClick:(int)btnTag
{
    switch (btnTag) {
        case 111:
            NSLog(@"点击了支付维修费");
            break;
        case 112:
            NSLog(@"点击了取消申请");
            break;
        case 113:
            NSLog(@"点击了提交物流信息");
            break;
        default:
            break;
    }
}

#pragma mark - 注销页面Btn点击事件
-(void)CancelCellBtnClick:(int)btnTag
{
    switch (btnTag) {
        case 222:
            NSLog(@"点击了取消申请");
            break;
        case 223:
            NSLog(@"点击了重新提交注销");
            break;
        default:
            break;
    }
}

#pragma mark - 退货页面Btn点击事件
-(void)SalesReturnCellBtnClick:(int)btnTag
{
    switch (btnTag) {
        case 224:
            NSLog(@"点击了取消申请");
            break;
        case 225:
            NSLog(@"点击了提交物流信息");
            break;
        default:
            break;
    }
}

#pragma mark - 换货页面Btn点击事件
-(void)ChangeGoodCellBtnClick:(int)btnTag
{
    switch (btnTag) {
        case 226:
            NSLog(@"点击了取消申请");
            break;
        case 227:
            NSLog(@"点击了提交物流信息");
            break;
        default:
            break;
    }
}

#pragma mark - 更新资料页面Btn点击事件
-(void)UpdateCellBtnClick:(int)btnTag
{
    switch (btnTag) {
        case 228:
            NSLog(@"点击了取消申请");
            break;
        default:
            break;
    }
}

#pragma mark - 租凭退还页面Btn点击事件
-(void)RentBackCellBtnClick:(int)btnTag
{
    switch (btnTag) {
        case 229:
            NSLog(@"点击了取消申请");
            break;
        default:
            break;
    }
}


@end
