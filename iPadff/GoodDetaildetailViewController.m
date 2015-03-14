//
//  GoodDetaildetailViewController.m
//  iPadff
//
//  Created by comdosoft on 15/3/9.
//  Copyright (c) 2015年 LanTaiPro. All rights reserved.
//

#import "GoodDetaildetailViewController.h"
#import "NetworkInterface.h"
#import "AppDelegate.h"
#import "GoodDetialModel.h"
#import "GoodButton.h"
#import "UIImageView+WebCache.h"
#import "FormView.h"

@interface GoodDetaildetailViewController ()
@property (nonatomic, strong) GoodDetialModel *detailModel;

@end

@implementation GoodDetaildetailViewController
- (void)viewWillAppear:(BOOL)animated
{
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title=@"商品详情";
    self.view.backgroundColor=[UIColor whiteColor];
    
    self.navigationController.navigationBarHidden = NO;

    if(iOS7)
    {
        
        _mainScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_HEIGHT, SCREEN_WIDTH)];
        
        
    }
    else
    {
        _mainScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
        
        
    }
    
    _mainScrollView.backgroundColor = [UIColor whiteColor];
    
    [self.view addSubview:_mainScrollView];

    
    [self downloadGoodDetail];
    
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)initAndLayoutUI {
    
    
    UIView *handleView = [self handleViewWithOriginY:0];
    [_mainScrollView addSubview:handleView];
    UIView *handleViewfrdef= [self  handleViewWithOriginYs: 70];
    [_mainScrollView addSubview:handleViewfrdef];


}
- (void)downloadGoodDetail {
    AppDelegate *delegate = [AppDelegate shareAppDelegate];
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
    hud.labelText = @"加载中...";
    [NetworkInterface getGoodDetailWithCityID:delegate.cityID goodID:_goodID finished:^(BOOL success, NSData *response) {
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
                    [self parseGoodDetailDateWithDictionary:object];
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

- (void)parseGoodDetailDateWithDictionary:(NSDictionary *)dict {
    if (![dict objectForKey:@"result"] || ![[dict objectForKey:@"result"] isKindOfClass:[NSDictionary class]]) {
        return;
    }
    NSDictionary *detailDict = [dict objectForKey:@"result"];
    _detailModel = [[GoodDetialModel alloc] initWithParseDictionary:detailDict];
    [self initAndLayoutUI];
}
- (UIView *)handleViewWithOriginYs:(CGFloat)originY1
{
     view = [[UIView alloc] init];

    if(iOS7)
    {
        view.frame=CGRectMake(0, originY1, SCREEN_HEIGHT, SCREEN_WIDTH-originY1);

    
    }
    else
    {
        view.frame=CGRectMake(0, originY1, SCREEN_WIDTH, SCREEN_HEIGHT-originY1);

    
    }
    view.backgroundColor = [UIColor whiteColor];
    
     CGFloat   leftSpace = 20;  //左侧间距
        
        
  
    
        
 
    
    CGFloat rightSpace = 25.f; //右侧间距
    CGFloat labelHeight = 20.f; //label 高度
    CGFloat firstSpace = 5.f;
    CGFloat vSpace = 12.f;  //label 垂直间距
    CGFloat hSpace = 10.f;
    CGFloat leftLabelWidth = 60.f;  //左侧标题label宽度
    CGFloat btnHeight = 20.f;  //支付通道 和 购买方式 按钮高度
    CGFloat btnWidth = (kScreenWidth - leftSpace - rightSpace - leftLabelWidth - firstSpace - 2 * hSpace) / 3;
    CGFloat originY =10;

    //pos信息
    originY +=  10;
    UILabel *posTitleLabel = [[UILabel alloc] initWithFrame:CGRectMake(leftSpace, originY, kScreenWidth - leftSpace - rightSpace, labelHeight)];
    
    [self setLabels:posTitleLabel withTitle:@"POS信息" font:[UIFont systemFontOfSize:14.f]];
    [view addSubview:posTitleLabel];

    //划线
    originY += labelHeight + vSpace;
    UIView *secondLine = [[UIView alloc] initWithFrame:CGRectMake(10, originY, kScreenWidth - 20, 1)];
    secondLine.backgroundColor = kColor(255, 102, 36, 1);
    [view addSubview:secondLine];
    
    //品牌型号
    originY += vSpace + 1;
    NSString *brandModel = [NSString stringWithFormat:@"%@%@",_detailModel.goodBrand,_detailModel.goodModel];
    [self addLabelWithTitle:@"品牌型号" content:brandModel offsetY:originY];

    //外壳
    originY += vSpace + labelHeight;
    [self addLabelWithTitle:@"外壳类型" content:_detailModel.goodMaterial offsetY:originY];
    //电池
    originY += vSpace + labelHeight;
    [self addLabelWithTitle:@"电池信息" content:_detailModel.goodBattery offsetY:originY];
    //签购单
    originY += vSpace +labelHeight;
    [self addLabelWithTitle:@"签购单打印方式" content:_detailModel.goodSignWay offsetY:originY];
    //加密卡
    originY += vSpace + labelHeight;
    [self addLabelWithTitle:@"加密卡方式" content:_detailModel.goodEncryptWay offsetY:originY];
    
    //支付通道信息
    originY += labelHeight + 10;
    UILabel *cTitleLabel = [[UILabel alloc] initWithFrame:CGRectMake(leftSpace, originY, kScreenWidth - leftSpace - rightSpace, labelHeight)];
    [self setLabels:cTitleLabel withTitle:@"支付通道信息" font:[UIFont systemFontOfSize:13.f]];
     [view addSubview:cTitleLabel];

    //划线
    originY += labelHeight + vSpace;
    UIView *thirdLine = [[UIView alloc] initWithFrame:CGRectMake(10, originY, kScreenWidth - 20, 1)];
    thirdLine.backgroundColor = kColor(255, 102, 36, 1);
    [view addSubview:thirdLine];
    
    //支持区域
    originY += vSpace + 1;
    NSString *area = [_detailModel.defaultChannel.supportAreaItem componentsJoinedByString:@" "];
    [self addLabelWithTitle:@"支持支付区域" content:area offsetY:originY];
    //注销
    originY += vSpace +labelHeight;
    NSString *cancelString = nil;
    if (_detailModel.defaultChannel.canCanceled) {
        cancelString = @"支持";
    }
    else {
        cancelString = @"不支持";
    }
    [self addLabelWithTitle:@"是否支持注销" content:cancelString offsetY:originY];
    
    //标准手续费
    originY += labelHeight + 10;
    CGFloat standFormHeight = [FormView heightWithRowCount:[_detailModel.defaultChannel.standRateItem count]
                                                  hasTitle:YES];
    FormView *standForm = [[FormView alloc] initWithFrame:CGRectMake(0, originY, kScreenWidth, standFormHeight)];
    [standForm setGoodDetailDataWithFormTitle:@"刷卡交易标准手续费"
                                      content:_detailModel.defaultChannel.standRateItem
                                   titleArray:[NSArray arrayWithObjects:@"商户类",@"费率",@"说明",nil]];
    [view addSubview:standForm];
    
    //资金服务费
    originY += standFormHeight + 10;
    CGFloat dateFormHeight = [FormView heightWithRowCount:[_detailModel.defaultChannel.dateRateItem count]
                                                 hasTitle:YES];
    FormView *dateForm = [[FormView alloc] initWithFrame:CGRectMake(0, originY, kScreenWidth, dateFormHeight)];
    [dateForm setGoodDetailDataWithFormTitle:@"资金服务费"
                                     content:_detailModel.defaultChannel.dateRateItem
                                  titleArray:[NSArray arrayWithObjects:@"结算周",@"费率",@"说明", nil]];
    [view addSubview:dateForm];
    
    //其它交易费率
    originY += dateFormHeight + 10;
    CGFloat otherFormHeight = [FormView heightWithRowCount:[_detailModel.defaultChannel.otherRateItem count]
                                                  hasTitle:YES];
    FormView *otherForm = [[FormView alloc] initWithFrame:CGRectMake(0, originY, kScreenWidth, otherFormHeight)];
    [otherForm setGoodDetailDataWithFormTitle:@"其它交易费率"
                                      content:_detailModel.defaultChannel.otherRateItem
                                   titleArray:[NSArray arrayWithObjects:@"交易类",@"费率",@"说明", nil]];
    [view addSubview:otherForm];

      _mainScrollView.contentSize = CGSizeMake(0, otherForm.frame.size.height+otherForm.frame.origin.y+160);
    [self setSeletedIndex:self.secletA];

    
    return view;
    
}
- (void)addLabelWithTitle:(NSString *)title
                  content:(NSString *)content
                  offsetY:(CGFloat)offsetY {
    CGFloat leftSpace = 20.f;
    CGFloat titleLabelWidth = 100.f;
    CGFloat labelHeight = 20.f;
    CGFloat middleLeftSpace = leftSpace + titleLabelWidth + 5;
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(leftSpace, offsetY, titleLabelWidth, labelHeight)];
    [self setLabels:titleLabel withTitle:title font:[UIFont systemFontOfSize:14.f]];
    
    [view addSubview:titleLabel];
    
    
    UILabel *contentLabel = [[UILabel alloc] initWithFrame:CGRectMake(middleLeftSpace, offsetY, kScreenWidth - middleLeftSpace, labelHeight)];
    [self setLabels:contentLabel withTitle:content font:[UIFont systemFontOfSize:14.f]];
    
}
- (void)setLabels:(UILabel *)label withTitle:(NSString *)title font:(UIFont *)font{
    label.backgroundColor = [UIColor clearColor];
    label.font = font;
    label.text = title;
   [view addSubview:label];
}
- (UIView *)handleViewWithOriginY:(CGFloat)originY {
    
    UIView *viewgf = [[UIView alloc] init];
    
    if(iOS7)
    {
        viewgf.frame=CGRectMake(0, originY, SCREEN_HEIGHT , 65 );
        
    }else
    {
        viewgf.frame=CGRectMake(0, originY, SCREEN_WIDTH , 65 );
        
        
        
    }
    viewgf.backgroundColor = [UIColor whiteColor];
    if (_detailModel.canRent)
    {
        NSString*str=[NSString stringWithFormat:@"评论(%d)",[_detailModel.goodComment intValue]];
        
        NSArray*arry=[NSArray arrayWithObjects:@"商品描述",@"开通所需材料",str,@"租赁说明",@"交易费率", nil];
        
        
        for (int i = 0; i < 5; i++ ) {
            
            UIButton *rentButton = [UIButton buttonWithType:UIButtonTypeCustom];
            rentButton.tag=i+1024;

            rentButton.frame = CGRectMake(viewgf.frame.size.width / 11*(2*i +1), 22, viewgf.frame.size.width / 11, 45);
            [rentButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            [rentButton setTitle:[arry objectAtIndex:i] forState:UIControlStateNormal];
            rentButton.titleLabel.font = [UIFont systemFontOfSize: 15.0];
            [rentButton addTarget:self action:@selector(scanRent:) forControlEvents:UIControlEventTouchUpInside];
            [viewgf addSubview:rentButton];
            UIView *line = [[UIView alloc] initWithFrame:CGRectMake(viewgf.frame.size.width / 5*(i+1), 30, 1, 30)];
            line.backgroundColor = [UIColor grayColor];
            [viewgf addSubview:line];
        }
        
    }
    else
    {
        NSString*str=[NSString stringWithFormat:@"评论(%d)",[_detailModel.goodComment intValue]];
        
        NSArray*arry=[NSArray arrayWithObjects:@"商品描述",@"开通所需材料",str,@"交易费率", nil];
        
        
        for (int i = 0; i < 4; i++ ) {
            
            UIButton *rentButton = [UIButton buttonWithType:UIButtonTypeCustom];
            rentButton.frame = CGRectMake(viewgf.frame.size.width / 9*(2*i +1), 22, viewgf.frame.size.width / 9, 45);
            [rentButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            [rentButton setTitleColor:[UIColor lightGrayColor] forState:UIControlStateHighlighted];
            [rentButton setTitle:[arry objectAtIndex:i] forState:UIControlStateNormal];
            rentButton.titleLabel.font = [UIFont systemFontOfSize: 15.0];
            [rentButton addTarget:self action:@selector(scanRent:) forControlEvents:UIControlEventTouchUpInside];
            [viewgf addSubview:rentButton];
            rentButton.tag=i+1024;
            
            UIView *line = [[UIView alloc] initWithFrame:CGRectMake(viewgf.frame.size.width / 4*(i+1), 30, 1, 30)];
            line.backgroundColor = [UIColor grayColor];
            [viewgf addSubview:line];
        }
        
        
        
    }
    //竖线
    //    UIView *firstLine = [[UIView alloc] initWithFrame:CGRectMake(kScreenWidth / 2, 10, 0.5f, 25)];
    //    firstLine.backgroundColor = kColor(201, 201, 201, 1);
    //    [view addSubview:firstLine];
    //    UIView *secondLine = [[UIView alloc] initWithFrame:CGRectMake(kScreenWidth / 2, 55, 0.5f, 25)];
    //    secondLine.backgroundColor = kColor(201, 201, 201, 1);
    //    [view addSubview:secondLine];
    return viewgf;
}
-(void)scanRent:(UIButton*)sender
{
    NSLog(@"%d",sender.tag);
    
    [self setSeletedIndex:sender.tag];
    

}
- (void)setSeletedIndex:(int)aIndex
{
    NSLog(@"%d",aIndex);

    UIButton *previousButton = (UIButton *)[self.view viewWithTag:self.secletA];
    [previousButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    self.secletA = aIndex;
    
    //设置为正常状态下的图片
    UIButton *currentButton = (UIButton *)[self.view viewWithTag:(aIndex )];
    [currentButton setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
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
