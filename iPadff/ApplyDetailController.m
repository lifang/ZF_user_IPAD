//
//  ApplyDetailController.m
//  ZFUB
//
//  Created by 徐宝桥 on 15/3/9.
//  Copyright (c) 2015年 ___MyCompanyName___. All rights reserved.
//

#import "ApplyDetailController.h"
#import "NetworkInterface.h"
#import "AppDelegate.h"
#import "ApplyOpenModel.h"
#import "CityHandle.h"
#import "ChannelSelectedController.h"
#import "BankSelectedController.h"
#import "MerchantDetailModel.h"
#import "RegularFormat.h"

#define kTextViewTag   111

@interface ApplyInfoCell : UITableViewCell

@property (nonatomic, strong) NSString *key;
@property (nonatomic, assign) MaterialType type;

@end

@implementation ApplyInfoCell

@end

@interface InputTextField : UITextField

@property (nonatomic, strong) NSString *key;

@end

@implementation InputTextField


@end

@interface ApplyDetailController ()<UITableViewDataSource,UITableViewDelegate,UITextFieldDelegate,UIActionSheetDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate,UIPopoverPresentationControllerDelegate,UIPickerViewDataSource,UIPickerViewDelegate,UIPopoverControllerDelegate,ChannelSelectedDelegate,BankSelectedDelegate>
@property(nonatomic,strong) UIPopoverController *popViewController;

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) UISegmentedControl *segmentControl;
@property(nonatomic,strong)NSString *startTime;

@property (nonatomic, assign) OpenApplyType applyType;  //对公 对私
@property(nonatomic,strong)UIButton *startSure;
@property (nonatomic, strong) NSMutableArray *channelItems;

@property (nonatomic, strong) ApplyOpenModel *applyData;
@property (nonatomic, strong) NSArray *secondArray;  //pickerView 第二列

@property (nonatomic, strong) NSMutableDictionary *infoDict;

@property (nonatomic, strong) UILabel *brandLabel;
@property (nonatomic, strong) UILabel *modelLabel;
@property (nonatomic, strong) UILabel *terminalLabel;
@property (nonatomic, strong) UILabel *channelLabel;
@property(nonatomic,strong)UIButton *publickBtn;
@property(nonatomic,strong)UIButton *privateBtn;
@property (nonatomic, strong) UIView *scrollView;
@property (nonatomic, strong) NSMutableArray *bankItems;//银行信息
@property (nonatomic, strong) NSMutableArray *textarrys;//银行信息

@property(nonatomic,assign)BOOL isChecked;
@property(nonatomic,assign)CGFloat publicX;
@property(nonatomic,assign)CGFloat privateX;
@property(nonatomic,assign)CGFloat privateY;
@property (nonatomic, assign) CGRect imageRect;

//用于记录点击的是哪一行
@property (nonatomic, strong) NSString *selectedKey;

@property (nonatomic, strong) UIPickerView *pickerView;
@property (nonatomic, strong) UIDatePicker *datePickerStart;


@property (nonatomic, strong) UIToolbar *toolbar;

@property (nonatomic, strong) NSArray *cityArray;  //pickerView 第二列
@property(nonatomic,strong)UITableView *terminalTableView;
@property (nonatomic, strong) NSString *bankTitleName; //银行名
@property (nonatomic, strong) NSString *bankTitleName2; //银行名
@property (nonatomic, strong) NSString *shanghuname; //银行名

@property (nonatomic, strong) NSString *merchantID;
@property (nonatomic, strong) NSString *bankID;  //银行代码
@property (nonatomic, strong) NSString *channelID; //支付通道ID
@property (nonatomic, strong) NSString *billID;    //结算日期ID

//无作用 就是用来去掉cell中输入框的输入状态
@property (nonatomic, strong) UITextField *tempField;

@end

@implementation ApplyDetailController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor=[UIColor whiteColor];
    _bankItems = [[NSMutableArray alloc] init];
    _channelItems = [[NSMutableArray alloc] init];
    _textarrys = [[NSMutableArray alloc] init];

    keynamesarry=[NSArray arrayWithObjects:@"key_name",@"key_merchantName",@"key_sex",@"key_birth",@"key_cardID",@"key_phone",@"key_email",@"key_location",@"key_bank",@"key_bankIDfdf",@"key_bankID",@"key_taxID",@"key_organID",@"key_channel", nil];
    // Do any additional setup after loading the view.
    self.title = @"开通申请";
    _applyType = OpenApplyPublic;
    _infoDict = [[NSMutableDictionary alloc] init];
    _tempField = [[UITextField alloc] init];
    _tempField.hidden = YES;
    [self.view addSubview:_tempField];
    
    
    if (iOS7)
        
    {    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 80, SCREEN_HEIGHT,
                                                                    SCREEN_WIDTH) style:UITableViewStyleGrouped];
        
      
    }
    else
    {    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 80, SCREEN_WIDTH,
                                                                    SCREEN_HEIGHT) style:UITableViewStyleGrouped];
        
   
        
        
    }
    _tableView.backgroundColor=[UIColor whiteColor];
    
    _tableView.delegate = self;
    _tableView.dataSource = self;
    [self.view addSubview:_tableView];
    [self beginApply];
    [self getBankList];

}
//选择终端tableView懒加载
-(UITableView *)terminalTableView
{
    if (!_terminalTableView) {
        _terminalTableView = [[UITableView alloc]init];
        _terminalTableView.tag = 1111;
        _terminalTableView.delegate = self;
        _terminalTableView.dataSource = self;
    }
    return _terminalTableView;
}
//创建选择终端tableView
-(void)setupTerminalTableView
{
    if(sexint==102)
    {
        self.terminalTableView.frame = CGRectMake(_cityField.frame.origin.x, _cityField.frame.origin.y+_cityField.frame.size.height, 280, 80);
        NSLog(@"%f%f",_cityField.frame.origin.x,_cityField.frame.origin.y );
        
    }
    
    else
    {
        
//        isopen=!isopen;
//        if(isopen)
//        {
//            self.terminalTableView.hidden=NO;
//            
//        }
//        else
//        {
//            self.terminalTableView.hidden=YES;
//
//        }
//        
        
        NSInteger numberrow;
        numberrow=_applyData.merchantList.count;
        if(numberrow>5)
        {
            self.terminalTableView.frame = CGRectMake(accountnamebutton.frame.origin.x, 90, 280, 5*45);

        }else
        {
            self.terminalTableView.frame = CGRectMake(accountnamebutton.frame.origin.x, 90, 280, numberrow*45);

        
        }
        
        
    }
    
    [_scrollView addSubview:_terminalTableView];
    if (_applyData.merchantList.count != 0) {
        [_terminalTableView reloadData];
    }
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(sexint==102)
    {
        isopens=!isopens;

        [_infoDict setObject:[NSNumber numberWithInt:indexPath.row] forKey:key_sex];
        NSString*accountname=[NSString stringWithFormat:@"%@",[_infoDict objectForKey:key_sex]];
        
        if([accountname isEqualToString:@"0"])
        {
            [_cityField setTitle:@"女" forState:UIControlStateNormal];
            
            
        }else
        {
            
            [_cityField setTitle:@"男" forState:UIControlStateNormal];
            
            
        }
        
        
    }
    else
    {
        MerchantModel *model = [_applyData.merchantList objectAtIndex:indexPath.row];
        
//        [_infoDict setObject:model.merchantName forKey:key_selected];
        [self getMerchantDetailWithMerchant:model];
        _shanghuname=model.merchantName;
        
//        isopen=!isopen;

        
//        [self beginApply];
        
    }
    
    
    //终端选择跳转
    if (tableView==_terminalTableView) {
        
        [_terminalTableView removeFromSuperview];
    }
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section

{

    NSInteger lastheightY;
    lastheightY=_applyData.materialList.count-2;
  
        lastheightY=_applyData.materialList.count/3;
        

 
    
    
    _scrollView = [[UIView alloc]init];
    
    if (iOS7)
        
    {
        
        _scrollView.frame = CGRectMake(0, 0, SCREEN_HEIGHT,
                                       700+lastheightY*70);
    }
    else
    {
        
        _scrollView.frame = CGRectMake(0, 0, SCREEN_WIDTH,
                                       500+lastheightY*70);
        
        
    }
if(_applyType==OpenApplyPublic)
{
namesarry=[NSArray arrayWithObjects:@"姓              名",@"店   铺  名   称",@"性              别",@"选   择   生  日",@"身  份  证  号",@"联   系  电  话",@"邮              箱",@"所      在     地",@"结算银行账户名",@"结算银行名称",@"结算银行账户",@"税务登记证号",@"组 织 机 构 号",@"支  付   通  道", nil];


}else
{


namesarry=[NSArray arrayWithObjects:@"姓              名",@"店   铺  名   称",@"性              别",@"选   择   生  日",@"身  份  证  号",@"联   系  电  话",@"邮              箱",@"所      在     地",@"结算银行账户名",@"结算银行名称",@"结算银行账户",@"支  付   通  道", nil];

}
    
    
    
    CGFloat borderSpace = 40.f;
    CGFloat topSpace = 10.f;
    CGFloat labelHeight = 20.f;
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
    
    
    _brandLabel = [[UILabel alloc] initWithFrame:CGRectMake(borderSpace+18, topSpace+20, wide/2 - borderSpace , labelHeight)];
    _brandLabel.backgroundColor = [UIColor clearColor];
    //    _brandLabel.textColor = kColor(142, 141, 141, 1);
    _brandLabel.font = [UIFont systemFontOfSize:18.f];
    [_scrollView addSubview:_brandLabel];
    
    _modelLabel = [[UILabel alloc] initWithFrame:CGRectMake(borderSpace+18, topSpace + labelHeight+20, wide/2 - borderSpace, labelHeight)];
    _modelLabel.backgroundColor = [UIColor clearColor];
    //    _modelLabel.textColor = kColor(142, 141, 141, 1);
    _modelLabel.font = [UIFont systemFontOfSize:18.f];
    [_scrollView addSubview:_modelLabel];
    
    _terminalLabel = [[UILabel alloc] initWithFrame:CGRectMake(borderSpace+18, topSpace + labelHeight * 2+20, wide/2 - borderSpace, labelHeight)];
    _terminalLabel.backgroundColor = [UIColor clearColor];
    //    _terminalLabel.textColor = kColor(142, 141, 141, 1);
    _terminalLabel.font = [UIFont systemFontOfSize:18.f];
    [_scrollView addSubview:_terminalLabel];
    
    UILabel*accountnamelable=[[UILabel alloc]initWithFrame:CGRectMake(wide/2-20,topSpace + labelHeight * 2,160, 40)];
    [_scrollView addSubview:accountnamelable];
    accountnamelable.textAlignment = NSTextAlignmentCenter;
    accountnamelable.font=[UIFont systemFontOfSize:19];
    
    accountnamelable.text=@"可选择的常用商户";
    
    accountnamebutton= [UIButton buttonWithType:UIButtonTypeCustom];
    accountnamebutton.frame = CGRectMake(150+wide/2,  topSpace + labelHeight * 2,280, 40);
    
//    NSString*accountname=[_infoDict objectForKey:key_selected];
    if(_shanghuname)
    {
        [accountnamebutton setTitle:_shanghuname forState:UIControlStateNormal];

    
    }
    [accountnamebutton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    accountnamebutton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    [accountnamebutton setImage:kImageName(@"arrow_line1") forState:UIControlStateNormal];
    CALayer *layer=[accountnamebutton  layer];
    //是否设置边框以及是否可见
    [layer setMasksToBounds:YES];
    //设置边框圆角的弧度
    
    //设置边框线的宽
    //
    [layer setBorderWidth:1];
    //设置边框线的颜色
    [layer setBorderColor:[[UIColor grayColor] CGColor]];
    accountnamebutton.contentEdgeInsets = UIEdgeInsetsMake(0,-40, 0,0);
    accountnamebutton.imageEdgeInsets = UIEdgeInsetsMake(0,270,0,0);//设置image在button上的位置（上top，左left，下bottom，右right）这里可以写负值，对上写－5，那么image就象上移动5个像素
    
    
    [accountnamebutton addTarget:self action:@selector(accountnamebuttonclick) forControlEvents:UIControlEventTouchUpInside];
    [_scrollView addSubview:accountnamebutton];
    
    _brandLabel.text = [NSString stringWithFormat:@"POS品牌   %@",_applyData.brandName];
    _modelLabel.text = [NSString stringWithFormat:@"POS型号   %@",_applyData.modelNumber];
    _terminalLabel.text = [NSString stringWithFormat:@"终  端  号   %@",_applyData.terminalNumber];
    _channelLabel.text = [NSString stringWithFormat:@"支付通道   %@",_applyData.channelName];
    
    UILabel*firestline = [[UILabel alloc] initWithFrame:CGRectMake(borderSpace+18, topSpace + labelHeight * 4+30, wide - 138, 1)];
    firestline.backgroundColor = [UIColor grayColor];
    [_scrollView addSubview:firestline];
    
    
    for(int i=0;i<namesarry.count;i++)
    {
        NSInteger row;
        row=i%2;
        NSInteger height;
        
        height=i/2;
        if(i>7)
        {
            topSpace=40;
            
            
        }
        UILabel*newaddress=[[UILabel alloc]initWithFrame:CGRectMake(40+(wide/2-40)*row, height*70+topSpace + labelHeight * 7,140, 40)];
        [_scrollView addSubview:newaddress];
        newaddress.textAlignment = NSTextAlignmentCenter;
        newaddress.font=[UIFont systemFontOfSize:18];
        
        newaddress.text=[namesarry objectAtIndex:i];
        
        if(i==2)
        {
            _cityField = [UIButton buttonWithType:UIButtonTypeCustom];
            _cityField.frame = CGRectMake(190+(wide/2-40)*row,  height*70+topSpace + labelHeight * 7,280, 40);
            NSString*accountname=[NSString stringWithFormat:@"%@",[_infoDict objectForKey:[keynamesarry objectAtIndex:i]]];
            
            if([accountname isEqualToString:@"0"])
            {
                [_cityField setTitle:@"女" forState:UIControlStateNormal];
                
                
            }else
            {
                
                [_cityField setTitle:@"男" forState:UIControlStateNormal];
                
                
            }
            
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
            
            
            [_cityField addTarget:self action:@selector(sexclick) forControlEvents:UIControlEventTouchUpInside];
            [_scrollView addSubview:_cityField];
        }
        else if(i==3)
        {
            birthdaybutton = [UIButton buttonWithType:UIButtonTypeCustom];
            birthdaybutton.frame = CGRectMake(190+(wide/2-40)*row,  height*70+topSpace + labelHeight * 7,280, 40);
            NSString*accountname=[NSString stringWithFormat:@"%@",[_infoDict objectForKey:[keynamesarry objectAtIndex:i]]];
            if([self isBlankString:accountname])
            {
                [birthdaybutton setTitle:@"" forState:UIControlStateNormal];
                
            }else
            {
                [birthdaybutton setTitle:accountname forState:UIControlStateNormal];
                
            }

            [birthdaybutton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            birthdaybutton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
            [birthdaybutton setImage:kImageName(@"arrow_line1") forState:UIControlStateNormal];
            CALayer *layer=[birthdaybutton  layer];
            //是否设置边框以及是否可见
            [layer setMasksToBounds:YES];
            //设置边框圆角的弧度
            
            //设置边框线的宽
            //
            [layer setBorderWidth:1];
            //设置边框线的颜色
            [layer setBorderColor:[[UIColor grayColor] CGColor]];
            birthdaybutton.contentEdgeInsets = UIEdgeInsetsMake(0,-40, 0, 0);
            birthdaybutton.imageEdgeInsets = UIEdgeInsetsMake(0,270,0,0);//设置image在button上的位置（上top，左left，下bottom，右right）这里可以写负值，对上写－5，那么image就象上移动5个像素
            
            
            [birthdaybutton addTarget:self action:@selector(birthdaybuttonclick) forControlEvents:UIControlEventTouchUpInside];
            [_scrollView addSubview:birthdaybutton];
        }
        else if(i==7)
        {
            locationbutton = [UIButton buttonWithType:UIButtonTypeCustom];
            locationbutton.frame = CGRectMake(190+(wide/2-40)*row,  height*70+topSpace + labelHeight * 7,280, 40);
            
            NSString*strId=[_infoDict objectForKey:[keynamesarry objectAtIndex:i]];
            
            NSString*accountname= [CityHandle getCityNameWithCityID:strId];
            
            [locationbutton setTitle:accountname forState:UIControlStateNormal];
            [locationbutton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            locationbutton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
            [locationbutton setImage:kImageName(@"arrow_line1") forState:UIControlStateNormal];
            CALayer *layer=[locationbutton  layer];
            //是否设置边框以及是否可见
            [layer setMasksToBounds:YES];
            //设置边框圆角的弧度
            
            //设置边框线的宽
            //
            [layer setBorderWidth:1];
            //设置边框线的颜色
            [layer setBorderColor:[[UIColor grayColor] CGColor]];
            locationbutton.contentEdgeInsets = UIEdgeInsetsMake(0,-40, 0, 0);
            locationbutton.imageEdgeInsets = UIEdgeInsetsMake(0,270,0,0);//设置image在button上的位置（上top，左left，下bottom，右right）这里可以写负值，对上写－5，那么image就象上移动5个像素
            
            
            [locationbutton addTarget:self action:@selector(locationbuttonclick) forControlEvents:UIControlEventTouchUpInside];
            [_scrollView addSubview:locationbutton];
        }
        
        else if(i==13&&_applyType==OpenApplyPublic)
        {
         
            zhifubutton = [UIButton buttonWithType:UIButtonTypeCustom];
            [zhifubutton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            zhifubutton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
            [zhifubutton setImage:kImageName(@"arrow_line1") forState:UIControlStateNormal];
            CALayer *layer=[zhifubutton  layer];
            //是否设置边框以及是否可见
            [layer setMasksToBounds:YES];
            //设置边框圆角的弧度
            
            //设置边框线的宽
            //
            [layer setBorderWidth:1];
            //设置边框线的颜色
            [layer setBorderColor:[[UIColor grayColor] CGColor]];
            zhifubutton.contentEdgeInsets = UIEdgeInsetsMake(0,-40, 0, 0);
            zhifubutton.imageEdgeInsets = UIEdgeInsetsMake(0,270,0,0);//设置image在button上的位置（上top，左left，下bottom，右right）这里可以写负值，对上写－5，那么image就象上移动5个像素
           
                zhifubutton.frame = CGRectMake(190+(wide/2-40)*row,  height*70+topSpace + labelHeight * 7,280, 40);
                NSString*accountname=[NSString stringWithFormat:@"%@",[_infoDict objectForKey:[keynamesarry objectAtIndex:i]]];
            if([self isBlankString:accountname])
            {
                [zhifubutton setTitle:@"" forState:UIControlStateNormal];
                
            }else
            {
                [zhifubutton setTitle:accountname forState:UIControlStateNormal];
                
            }


                
            
            [zhifubutton addTarget:self action:@selector(zhifuclick) forControlEvents:UIControlEventTouchUpInside];
            [_scrollView addSubview:zhifubutton];
        }
        
        else if(i==9)
        {
            
//            UITextField *neworiginaltextfield=[[UITextField alloc]init];
//            neworiginaltextfield.frame = CGRectMake(190+(wide/2-40)*row,  height*70+topSpace + labelHeight * 7,280, 40);
//            UIView *leftView = [[UIView alloc]init];
//            leftView.frame = CGRectMake(0, 0, 10, 40);
//            neworiginaltextfield.leftView =leftView;
//            neworiginaltextfield.delegate=self;
//            neworiginaltextfield.leftViewMode = UITextFieldViewModeAlways;
//            neworiginaltextfield.rightViewMode = UITextFieldViewModeAlways;
//            
////            neworiginaltextfield.clearButtonMode = UITextFieldViewModeWhileEditing;
//            neworiginaltextfield.tag=i+1056;
//            
//            [_scrollView addSubview:neworiginaltextfield];
//            neworiginaltextfield.layer.masksToBounds=YES;
//            neworiginaltextfield.layer.borderWidth=1.0;
//            neworiginaltextfield.layer.borderColor=[UIColor grayColor].CGColor;
//            
            blankseclectbutton = [UIButton buttonWithType:UIButtonTypeCustom];
            blankseclectbutton.frame = CGRectMake(190+(wide/2-40)*row,  height*70+topSpace + labelHeight * 7,280, 40);
//            neworiginaltextfield.rightView =blankseclectbutton;
//
//            neworiginaltextfield.userInteractionEnabled=NO;
//            neworiginaltextfield.rightView.userInteractionEnabled=YES;
//            [neworiginaltextfield sendSubviewToBack:blankseclectbutton];
//            
//            blankseclectbutton.userInteractionEnabled=YES;
            
            
            if(_bankTitleName)
     
            {

//                neworiginaltextfield.text=_bankTitleName;
                NSDictionary *attr = [NSDictionary dictionaryWithObjectsAndKeys:
                                      [UIFont systemFontOfSize:18.f],NSFontAttributeName,
                                      nil];
                CGRect rect = [_bankTitleName boundingRectWithSize:CGSizeMake(CGFLOAT_MAX, 40.0)
                                                              options:NSStringDrawingUsesLineFragmentOrigin
                                                           attributes:attr
                                                              context:nil];
                if(rect.size.width>280)
                {
                
                    
                    [blankseclectbutton setTitle:[NSString stringWithFormat:@"%@         ",_bankTitleName] forState:UIControlStateNormal];

                }else
                {
                   [blankseclectbutton setTitle:[self serectString:_bankTitleName] forState:UIControlStateNormal];

                }

                
     
            }
            
            

            [blankseclectbutton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            blankseclectbutton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
            [blankseclectbutton setImage:kImageName(@"arrow_line1") forState:UIControlStateNormal];
            CALayer *layer=[blankseclectbutton  layer];
            //是否设置边框以及是否可见
            [layer setMasksToBounds:YES];
            //设置边框圆角的弧度
            
            //设置边框线的宽
            //
            [layer setBorderWidth:1];
            //设置边框线的颜色
            [layer setBorderColor:[[UIColor grayColor] CGColor]];
            blankseclectbutton.contentEdgeInsets = UIEdgeInsetsMake(0,-40, 0, 0);
            blankseclectbutton.imageEdgeInsets = UIEdgeInsetsMake(0,270,0,0);//设置image在button上的位置（上top，左left，下bottom，右right）这里可以写负值，对上写－5，那么image就象上移动5个像素
//
            blankseclectbutton.tag=14055;

            [blankseclectbutton addTarget:self action:@selector(blankclick:) forControlEvents:UIControlEventTouchUpInside];
            [_scrollView addSubview:blankseclectbutton];
        }

        else if(i==11&&_applyType==OpenApplyPrivate)
        {
            zhifubutton = [UIButton buttonWithType:UIButtonTypeCustom];
            [zhifubutton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            zhifubutton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
            [zhifubutton setImage:kImageName(@"arrow_line1") forState:UIControlStateNormal];
            CALayer *layer=[zhifubutton  layer];
            //是否设置边框以及是否可见
            [layer setMasksToBounds:YES];
            //设置边框圆角的弧度
            
            //设置边框线的宽
            //
            [layer setBorderWidth:1];
            //设置边框线的颜色
            [layer setBorderColor:[[UIColor grayColor] CGColor]];
            zhifubutton.contentEdgeInsets = UIEdgeInsetsMake(0,-40, 0, 0);
            zhifubutton.imageEdgeInsets = UIEdgeInsetsMake(0,270,0,0);//设置image在button上的位置（上top，左left，下bottom，右right）这里可以写负值，对上写－5，那么image就象上移动5个像素
            
            zhifubutton.frame = CGRectMake(190+(wide/2-40)*row,  height*70+topSpace + labelHeight * 6+20,280, 40);
  
            NSString*accountname=[NSString stringWithFormat:@"%@",[_infoDict objectForKey:@"key_channel"]];
            if([self isBlankString:accountname])
            {
                [zhifubutton setTitle:@"" forState:UIControlStateNormal];
                
            }else
            {
                [zhifubutton setTitle:accountname forState:UIControlStateNormal];

            }
           
            [zhifubutton addTarget:self action:@selector(zhifuclick) forControlEvents:UIControlEventTouchUpInside];
            [_scrollView addSubview:zhifubutton];

        
        
        }

        else
        {
            UITextField*neworiginaltextfield=[[UITextField alloc]initWithFrame:CGRectMake(190+(wide/2-40)*row,  height*70+topSpace + labelHeight * 7,280, 40)];
            neworiginaltextfield.delegate=self;
            neworiginaltextfield.leftViewMode = UITextFieldViewModeAlways;
            UIView *leftView = [[UIView alloc]init];
            leftView.frame = CGRectMake(0, 0, 10, 40);
            neworiginaltextfield.leftView =leftView;
            neworiginaltextfield.tag=i+1056;
            
            if([self isBlankString:[NSString stringWithFormat:@"%@",[_infoDict objectForKey:[keynamesarry objectAtIndex:i]]]])
            {
                neworiginaltextfield.text=@"";
                
            }else
            {
                NSString*accountname=[NSString stringWithFormat:@"%@",[_infoDict objectForKey:[keynamesarry objectAtIndex:i]]];
                neworiginaltextfield.text=[NSString stringWithFormat:@"%@",accountname];

            
            }
          
            neworiginaltextfield.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
            
           
            [_scrollView addSubview:neworiginaltextfield];
            
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
            if(i==1)
            {
                
                UILabel*newaddress=[[UILabel alloc]initWithFrame:CGRectMake(200+(wide/2-40)*row,  height*70+topSpace + labelHeight * 7+45,280, 20)];
                [_scrollView addSubview:newaddress];
                newaddress.textAlignment = NSTextAlignmentLeft;
                newaddress.font=[UIFont systemFontOfSize:12];
                
                newaddress.text=@"例：上海好乐迪KTV";
            }
            
            if(i==8)
            {
                neworiginaltextfield.userInteractionEnabled=NO;
                
            }
        }
        
        
    }
    
  
    UILabel*twoline = [[UILabel alloc] initWithFrame:CGRectMake(borderSpace+18,  4*70+topSpace + labelHeight *5+10, wide - 138, 1)];
    twoline.backgroundColor = [UIColor grayColor];
    [_scrollView addSubview:twoline];
    UILabel*threeline = [[UILabel alloc] initWithFrame:CGRectMake(borderSpace+18,  670, wide - 138, 1)];
    threeline.backgroundColor = [UIColor grayColor];
    [_scrollView addSubview:threeline];
    NSInteger imageint;
    imageint=0;
    NSInteger imagerow;
    NSInteger imageheight;
    
    NSInteger textCount;
    textCount=0;
    NSInteger textrow;
    NSInteger textheight = 0 ;
    
    
    NSMutableArray *textArray=[[NSMutableArray alloc] initWithCapacity:0];
    NSMutableArray *imageArray=[[NSMutableArray alloc] initWithCapacity:0];
    for(int i=0;i<_applyData.materialList.count;i++)
    {
        MaterialModel *model = [_applyData.materialList objectAtIndex:i];
        
        if (model.materialType == MaterialList||model.materialType==MaterialText) {
            
            [textArray addObject:model];
            
        }
        else if (model.materialType == MaterialImage) {
            //图片
            [imageArray addObject:model];
            
        }

    }
    textint =0;
    [_textarrys removeAllObjects];
    
    for(int i=0;i<textArray.count;i++)
    {
        
        MaterialModel *model = [textArray objectAtIndex:i];
        
        textrow =i%2;
        textheight = i/2;
        
        if (model.materialType == MaterialList) {
            
            UILabel *listLB=[[UILabel alloc]initWithFrame:CGRectMake(40+(wide/2-40)*textrow,80+710+ textheight*70,140, 40)];
            [_scrollView addSubview:listLB];
            listLB.textAlignment = NSTextAlignmentCenter;
            listLB.font=[UIFont systemFontOfSize:18];
            listLB.text=model.materialName;
            
            UIButton *listBtn = [UIButton buttonWithType:UIButtonTypeCustom];
            listBtn.frame = CGRectMake(190+(wide/2-40)*textrow,80+ 710+ textheight*70,280, 40);
            [listBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            listBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
            [listBtn setImage:kImageName(@"arrow_line") forState:UIControlStateNormal];
            listBtn.layer.masksToBounds=YES;
            listBtn.layer.borderWidth=1.0;
            listBtn.layer.borderColor=[UIColor grayColor].CGColor;
            listBtn.contentEdgeInsets = UIEdgeInsetsMake(0,10, 0, 0);
            listBtn.imageEdgeInsets = UIEdgeInsetsMake(0,220,0,0);
            listBtn.tag=[model.materialID integerValue];
            [listBtn addTarget:self action:@selector(blankclick:) forControlEvents:UIControlEventTouchUpInside];
            [_scrollView addSubview:listBtn];
        }
        else if (model.materialType == MaterialText)
        {
            textint++;
            [_textarrys addObject:model.materialID];
            
            //文本
            UILabel *textLB=[[UILabel alloc]initWithFrame:CGRectMake(40+(wide/2-40)*textrow,710+ textheight*70,140, 40)];
            
            [_scrollView addSubview:textLB];
            textLB.textAlignment = NSTextAlignmentCenter;
            textLB.font=[UIFont systemFontOfSize:18];
            textLB.text=model.materialName;
            
            UITextField *textTF=[[UITextField alloc] init];
            textTF.frame=CGRectMake(190+(wide/2-40)*textrow, 710+ textheight*70,280, 40);
            textTF.tag=[model.materialID integerValue]+999656;
            if([_infoDict objectForKey:[_textarrys objectAtIndex:textint-1]])
            {
                textTF.text=[_infoDict objectForKey:[_textarrys objectAtIndex:textint-1]];
            }
            [_scrollView addSubview:textTF];
            textTF.leftViewMode = UITextFieldViewModeAlways;
            UIView *leftView = [[UIView alloc]init];
            leftView.frame = CGRectMake(0, 0, 10, 40);
            textTF.leftView =leftView;
            textTF.delegate=self;
            textTF.layer.masksToBounds=YES;
            textTF.layer.borderWidth=1.0;
            textTF.layer.borderColor=[UIColor grayColor].CGColor;
        }
        
    }
    
    NSInteger textH=0;
    if (textArray.count%2==0) {
        textH=textArray.count/2;
    }
    else
    {
        textH=textArray.count/2+1;
    }
    for(int i=0;i<imageArray.count;i++)
    {
        MaterialModel *model = [imageArray objectAtIndex:i];
        imagerow =i%2;
        imageheight = i/2;
        
        UILabel *imageLB=[[UILabel alloc]initWithFrame:CGRectMake(40+(wide/2-40)*imagerow,710+ imageheight*70+textH*70,250, 40)];
        [_scrollView addSubview:imageLB];
        imageLB.textAlignment = NSTextAlignmentCenter;
        imageLB.font=[UIFont systemFontOfSize:18];
        imageLB.text=model.materialName;
        
        UIButton *imageBtn= [UIButton buttonWithType:UIButtonTypeCustom];
        imageBtn.frame=CGRectMake(300+(wide/2-40)*imagerow, 710+ imageheight*70+textH*70,170, 40);
        imageBtn.titleLabel.font = [UIFont systemFontOfSize:16.f];
        [imageBtn addTarget:self action:@selector(imageclick:) forControlEvents:UIControlEventTouchUpInside];
        imageBtn.tag=[model.materialID integerValue];
        [self getApplyValueForKey:model.materialID];
        if ([_infoDict objectForKey:model.materialID] && ![[_infoDict objectForKey:model.materialID] isEqualToString:@""])
        {    [imageBtn setImage:[UIImage imageNamed:@"haveImage.png"] forState:UIControlStateNormal];
            
        }
        else {
            [imageBtn setTitle:@"上传图片" forState:UIControlStateNormal];
            imageBtn.backgroundColor=kColor(233, 91, 38, 1);
            
        }
        
        [_scrollView addSubview:imageBtn];
        
    }
    
    NSInteger imageH = 0;
    if (imageArray.count%2==0) {
        imageH=imageArray.count/2;
    }
    else
    {
        imageH=imageArray.count/2+1;
    }
    if (textArray.count>0||imageArray.count>0) {
        UILabel *fourline = [[UILabel alloc] initWithFrame:CGRectMake(borderSpace+18, 80+ 710+ imageH*70+textH*70, wide - 138, 1)];
        fourline.backgroundColor = [UIColor grayColor];
        [_scrollView addSubview:fourline];
        
    }
    int llastint;
    llastint=_applyData.materialList.count/2;

submitBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    submitBtn.frame = CGRectMake(80,80+ 700+(textH +imageH)*70+80, 160, 40);
    submitBtn.center=CGPointMake(wide/2, 700+(textH +imageH)*70+150);
    
    submitBtn.titleLabel.font = [UIFont systemFontOfSize:16.f];
    [submitBtn setTitle:@"提交" forState:UIControlStateNormal];
    [submitBtn setBackgroundImage:[UIImage imageNamed:@"orange.png"] forState:UIControlStateNormal];
    [submitBtn addTarget:self action:@selector(submitApply:) forControlEvents:UIControlEventTouchUpInside];
    [_scrollView addSubview:submitBtn];
    _scrollView.userInteractionEnabled=YES;
    return _scrollView;
    

}
//加密位数
- (NSString *)serectString:(NSString *)string {
    //倒数5-8位星号
    NSInteger length = [string length];
    if (length < 12) {
        return string;
    }
    NSMutableString *encryptString = [NSMutableString stringWithString:string];
    [encryptString replaceCharactersInRange:NSMakeRange(7, 5) withString:@"..."];
    return encryptString;
}

#pragma mark - UI
#pragma mark - 点击事件
//-(void)bankclick:(UIButton*)send
//{
//    BankSelectedController *BnakSC=[[BankSelectedController alloc] init];
//    BnakSC.delegate=self;
//    BnakSC.terminalID=_terminalID;
//    BnakSC.hidesBottomBarWhenPushed=YES;
//    [self.navigationController pushViewController:BnakSC animated:YES];
//    
//}

- (BOOL) isBlankString:(NSString *)string {
    if (string == nil || string == NULL) {
        return YES;
    }
    if ([string isEqualToString:@"(null)"])
    {
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

//上传图片
-(void)imageclick:(UIButton*)send

{
    _imageRect = [[send superview] convertRect:send.frame toView:self.view];
    
    _selectedKey =[NSString stringWithFormat:@"%d", send.tag];
    
    [self showImageOption];
    
}
-(void)zhifuclick
{
    [self.editingField resignFirstResponder];
    zhifuint=105;
    [self getChannelList];
    [self pickerDisplay:zhifubutton];
    //选择支付通道
//    ChannelSelectedController *channelC = [[ChannelSelectedController alloc] init];
//    channelC.delegate = self;
//    channelC.hidesBottomBarWhenPushed = YES;
//    channelC.channelID = _applyData.terminalChannelID;
//    
//    [self.navigationController pushViewController:channelC animated:YES];
//    
    
    
}
- (void)getChannelList {
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
    hud.labelText = @"加载中...";
    AppDelegate *delegate = [AppDelegate shareAppDelegate];
    [NetworkInterface selectedChannelWithToken:delegate.token finished:^(BOOL success, NSData *response) {
        NSLog(@"!!!!%@",[[NSString alloc] initWithData:response encoding:NSUTF8StringEncoding]);
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
                    [self parseChannelListWithDictionary:object];
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

- (void)parseChannelListWithDictionary:(NSDictionary *)dict {
    if (![dict objectForKey:@"result"] || ![[dict objectForKey:@"result"] isKindOfClass:[NSArray class]]) {
        return;
    }
    [_channelItems removeAllObjects];
    
    NSArray *list = [dict objectForKey:@"result"];
    for (int i = 0; i < [list count]; i++) {
        NSDictionary *channelDict = [list objectAtIndex:i];
        ChannelListModel *model = [[ChannelListModel alloc] initWithParseDictionary:channelDict];
        if ([model.channelID isEqualToString:_applyData.terminalChannelID]) {
            [_channelItems addObject:model];
        }
    }
    [_pickerView reloadAllComponents];
}

-(void)blankclick:(UIButton*)send
{
    
    [self.editingField resignFirstResponder];

    BankSelectedController *bankC = [[BankSelectedController alloc] init];
    bankC.delegate = self;
    bankC.terminalID = _terminalID;
    bankC.hidesBottomBarWhenPushed = YES;
    
    if(send.tag==14055)
    {
        _selectedKey=[keynamesarry objectAtIndex:9];
        
    
    }else
    {
        _selectedKey =[NSString stringWithFormat:@"%ld",(long)send.tag] ;

    
    }

    [self.navigationController pushViewController:bankC animated:YES];




}
- (void)pickerHide
{
    
    [_popViewController dismissPopoverAnimated:NO];
    
}


//选择所在地

-(void)locationbuttonclick
{
    [self.editingField resignFirstResponder];
    zhifuint=106;

    _selectedKey = key_location;
    [self pickerDisplay:locationbutton];

//    [self pickerScrollIn];
    
    
}
- (void)pickerDisplay:(id)sender {
    
    NSLog(@"pickerDiplay");
    
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
    
    _pickerView = [[UIPickerView alloc] initWithFrame:CGRectMake(0, 60, 320, 216)];
    _pickerView.delegate = self;
    _pickerView.dataSource = self;
    _pickerView.showsSelectionIndicator = YES;
    [theView addSubview:_pickerView];
    
    sortViewController.view = theView;
    
    _popViewController = [[UIPopoverController alloc] initWithContentViewController:sortViewController];
    [_popViewController setPopoverContentSize:CGSizeMake(320, 300) animated:YES];
    [_popViewController presentPopoverFromRect:CGRectMake(120, 0, 0, 42) inView:sender permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
    _popViewController.delegate = self;
    
    
}

//选择生日

-(void)birthdaybuttonclick
{
    [self.editingField resignFirstResponder];

//    birthdaybutton.userInteractionEnabled=NO;
    
    [self setupStartDate ];
    
    
}
//性别

-(void)sexclick
{
    sexint=102;
    
    
    [self setupTerminalTableView];
    isopens=!isopens;

    if(!isopens)
    {
        [_terminalTableView removeFromSuperview];
        
    }

    
}

-(void)accountnamebuttonclick
{
    sexint=103;
    
     isopen=!isopen;

    [self setupTerminalTableView];
    if(!isopen)
    {
        [_terminalTableView removeFromSuperview];

    }
    
    
    
}

-(void)setupHeaderView
{
    //创建头部View
    UIView *headerView = [[UIView alloc]init];
    headerView.backgroundColor = kColor(226, 226, 226, 1.0);
    headerView.frame = CGRectMake(0, 0, SCREEN_WIDTH, 80);
    if (iOS7) {
        headerView.frame = CGRectMake(0, 0, SCREEN_HEIGHT, 80);
    }
    //创建头部按钮
    UIButton *publicBtn = [[UIButton alloc]init];
    self.isChecked = YES;
    self.publickBtn = publicBtn;
    [publicBtn addTarget:self action:@selector(publicClicked) forControlEvents:UIControlEventTouchUpInside];
    publicBtn.backgroundColor = [UIColor clearColor];
    [publicBtn setBackgroundImage:[UIImage imageNamed:@"chose_Btn"] forState:UIControlStateNormal];
    publicBtn.titleLabel.font = [UIFont systemFontOfSize:22];
    [publicBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [publicBtn setTitle:@"对公" forState:UIControlStateNormal];
    publicBtn.frame = CGRectMake(headerView.frame.size.width * 0.4 , 40, 140, 40);
    self.privateY = 40;
    self.publicX = headerView.frame.size.width * 0.4;
    [headerView addSubview:publicBtn];
    
    UIButton *privateBtn = [[UIButton alloc]init];
    self.privateBtn = privateBtn;
    [privateBtn addTarget:self action:@selector(privateClicked) forControlEvents:UIControlEventTouchUpInside];
    privateBtn.backgroundColor = [UIColor clearColor];
    privateBtn.titleLabel.font = [UIFont systemFontOfSize:20];
    [privateBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [privateBtn setTitle:@"对私" forState:UIControlStateNormal];
    privateBtn.frame = CGRectMake(CGRectGetMaxX(publicBtn.frame), 44, 120, 36);
    self.privateX = CGRectGetMaxX(publicBtn.frame);
    [headerView addSubview:privateBtn];
    
    
    
    
    [self.view addSubview:headerView];
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
    if (_applyData.openType == OpenTypeNone) {
        
        [_privateBtn setHidden:YES];
        [_publickBtn setHidden:YES];
        
    }
    else
    {
        switch (_applyData.openType) {
            case OpenTypePrivate: {
                [_privateBtn setBackgroundImage:[UIImage imageNamed:@"chose_Btn"] forState:UIControlStateNormal];
                _privateBtn.titleLabel.font = [UIFont systemFontOfSize:22];
                _privateBtn.frame = CGRectMake(_privateX, _privateY, 140, 40);
                _privateBtn.center=CGPointMake(wide/2, _privateY);
                
                //            [_publickBtn setBackgroundImage:nil forState:UIControlStateNormal];
                //            _publickBtn.titleLabel.font = [UIFont systemFontOfSize:20];
                _publickBtn.frame = CGRectMake(_publicX + 210, _privateY, 120, 36);
                _publickBtn.hidden=YES;
                _applyType = OpenApplyPrivate;
            }
                break;
            case OpenTypePublic: {
                [_publickBtn setBackgroundImage:[UIImage imageNamed:@"chose_Btn"] forState:UIControlStateNormal];
                _publickBtn.titleLabel.font = [UIFont systemFontOfSize:22];
                _publickBtn.frame = CGRectMake(_publicX, _privateY, 140, 40);
                _publickBtn.center=CGPointMake(wide/2, _privateY);
                
                //            [_privateBtn setBackgroundImage:nil forState:UIControlStateNormal];
                //            _privateBtn.titleLabel.font = [UIFont systemFontOfSize:20];
                _privateBtn.frame = CGRectMake(_privateX + 210, _privateY, 120, 36);
                _applyType = OpenApplyPublic;
                _privateBtn.hidden=YES;
                
                
                
                
            }
                break;
            case OpenTypeAll: {
                if(_applyType==OpenApplyPublic)
                {
                    [_publickBtn setBackgroundImage:[UIImage imageNamed:@"chose_Btn"] forState:UIControlStateNormal];
                    _publickBtn.titleLabel.font = [UIFont systemFontOfSize:22];
                    _publickBtn.frame = CGRectMake(_publicX, _privateY, 140, 40);
                    
                    [_privateBtn setBackgroundImage:nil forState:UIControlStateNormal];
                    _privateBtn.titleLabel.font = [UIFont systemFontOfSize:20];
                    _privateBtn.frame = CGRectMake(_privateX + 10, _privateY, 120, 36);
                }else
                {
                    [_privateBtn setBackgroundImage:[UIImage imageNamed:@"chose_Btn"] forState:UIControlStateNormal];
                    _privateBtn.titleLabel.font = [UIFont systemFontOfSize:22];
                    _privateBtn.frame = CGRectMake(_privateX, _privateY, 140, 40);
                    
                    [_publickBtn setBackgroundImage:nil forState:UIControlStateNormal];
                    _publickBtn.titleLabel.font = [UIFont systemFontOfSize:20];
                    _publickBtn.frame = CGRectMake(_publicX + 10, _privateY, 120, 36);
                    
                }
                
                //            _applyType = OpenApplyPublic;
            }
                break;
            default:
                break;
        }

    }
    
    
    
    
    
}
#pragma mark - Request


-(void)publicClicked
{
    _applyType = OpenApplyPublic;
    
     keynamesarry=[NSArray arrayWithObjects:@"key_name",@"key_merchantName",@"key_sex",@"key_birth",@"key_cardID",@"key_phone",@"key_email",@"key_location",@"key_bank",@"key_bankID",@"key_bankID",@"key_taxID",@"key_organID",@"key_channel", nil];
    [self beginApply];
}

-(void)privateClicked
{
    _applyType = OpenApplyPrivate;
    
    _isChecked = NO;
     keynamesarry=[NSArray arrayWithObjects:@"key_name",@"key_merchantName",@"key_sex",@"key_birth",@"key_cardID",@"key_phone",@"key_email",@"key_location",@"key_bank",@"key_bankID",@"key_bankID",@"key_channel", nil];
    
    [self beginApply];
    
}

-(void)setupNavBar
{
    self.title = @"申请开通";
    self.view.backgroundColor = [UIColor whiteColor];
}

-(void)backHome
{
    [self.navigationController popViewControllerAnimated:YES];
}


- (void)initAndLayoutUI {
    [self setupNavBar];
    [self setupHeaderView];
//    [self initUIScrollView];
    
    [self initPickerView];
}


- (void)setTextFieldAttr:(InputTextField *)textField {
    textField.borderStyle = UITextBorderStyleNone;
    textField.textAlignment = NSTextAlignmentRight;
    textField.font = [UIFont systemFontOfSize:14.f];
    textField.tag = kTextViewTag;
    textField.delegate = self;
    textField.textColor = kColor(108, 108, 108, 1);
    textField.clearButtonMode = UITextFieldViewModeWhileEditing;
    textField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
}
#pragma mark - Request

- (void)getMerchantDetailWithMerchant:(MerchantModel *)model {
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
    hud.labelText = @"提交中...";
    AppDelegate *delegate = [AppDelegate shareAppDelegate];
    [NetworkInterface selectedMerchantWithToken:delegate.token merchantID:model.merchantID finished:^(BOOL success, NSData *response) {
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
                    [self parseMerchantDetaiDataWithDictionary:object
                                           withSelectedMerchat:model];
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

- (void)parseMerchantDetaiDataWithDictionary:(NSDictionary *)dict
                         withSelectedMerchat:(MerchantModel *)selected {
    if (![dict objectForKey:@"result"] || ![[dict objectForKey:@"result"] isKindOfClass:[NSDictionary class]]) {
        return;
    }
    NSDictionary *infoDict = [dict objectForKey:@"result"];
    MerchantDetailModel *model = [[MerchantDetailModel alloc] initWithParseDictionary:infoDict];
    if (model.merchantPersonName && ![model.merchantPersonName isEqualToString:@""]) {
        [_infoDict setObject:model.merchantPersonName forKey:key_selected];
        [_infoDict setObject:model.merchantPersonName forKey:key_name];
    }
    if (model.merchantName && ![model.merchantName isEqualToString:@""]) {
        [_infoDict setObject:model.merchantName forKey:key_merchantName];
        [_infoDict setObject:model.merchantName forKey:key_bank];
    }
    if (model.merchantPersonID && ![model.merchantPersonID isEqualToString:@""]) {
        [_infoDict setObject:model.merchantPersonID forKey:key_cardID];
    }
    if (model.merchantCityID && ![model.merchantCityID isEqualToString:@""]) {
        [_infoDict setObject:model.merchantCityID forKey:key_location];
    }
    if (model.merchantTaxID && ![model.merchantTaxID isEqualToString:@""]) {
        [_infoDict setObject:model.merchantTaxID forKey:key_taxID];
    }
    if (model.merchantOrganizationID && ![model.merchantOrganizationID isEqualToString:@""]) {
        [_infoDict setObject:model.merchantOrganizationID forKey:key_organID];
    }
    [_tableView reloadData];

}

#pragma mark - Request
//银行信息
- (void)getBankList {
    AppDelegate *delegate = [AppDelegate shareAppDelegate];
    [NetworkInterface selectedBankWithToken:delegate.token finished:^(BOOL success, NSData *response) {
        NSLog(@"!!!!%@",[[NSString alloc] initWithData:response encoding:NSUTF8StringEncoding]);
        if (success) {
            id object = [NSJSONSerialization JSONObjectWithData:response options:NSJSONReadingMutableLeaves error:nil];
            if ([object isKindOfClass:[NSDictionary class]]) {
                NSString *errorCode = [NSString stringWithFormat:@"%@",[object objectForKey:@"code"]];
                if ([errorCode intValue] == RequestFail) {
                    //返回错误代码
                }
                else if ([errorCode intValue] == RequestSuccess) {
                    [self parseBankListWithDictionary:object];
                }
            }
            else {
                //返回错误数据
            }
        }
        else {
        }
    }];
}

- (NSString *)getBankNameWithBankCode:(NSString *)bankCode {
    for (BankModel *model in _bankItems) {
        if ([model.bankCode isEqualToString:bankCode]) {
            return model.bankName;
        }
    }
    return nil;
}

- (void)parseBankListWithDictionary:(NSDictionary *)dict {
    if (![dict objectForKey:@"result"] || ![[dict objectForKey:@"result"] isKindOfClass:[NSArray class]]) {
        return;
    }
    NSArray *bankList = [dict objectForKey:@"result"];
    for (int i = 0; i < [bankList count]; i++) {
        id bankDict = [bankList objectAtIndex:i];
        if ([bankDict isKindOfClass:[NSDictionary class]]) {
            BankModel *model = [[BankModel alloc] initWithParseDictionary:bankDict];
            [_bankItems addObject:model];
        }
    }
}
- (void)beginApply {
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
    hud.labelText = @"加载中...";
    
    
    AppDelegate *delegate = [AppDelegate shareAppDelegate];
    NSLog(@"%@%@",delegate.token,delegate.userID);

    [NetworkInterface beginToApplyWithToken:delegate.token userID:delegate.userID applyStatus:_applyType terminalID:_terminalID finished:^(BOOL success, NSData *response) {
        NSLog(@"!!!!%@",[[NSString alloc] initWithData:response encoding:NSUTF8StringEncoding]);
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
                    [self parseApplyDataWithDictionary:object];
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

- (void)submitApplyInfoWithArray:(NSArray *)params {
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
    hud.labelText = @"提交中...";
    AppDelegate *delegate = [AppDelegate shareAppDelegate];
    [NetworkInterface submitApplyWithToken:delegate.token params:params finished:^(BOOL success, NSData *response) {
        NSLog(@"!!!!%@",[[NSString alloc] initWithData:response encoding:NSUTF8StringEncoding]);
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
                    hud.labelText = @"添加成功";
                    [[NSNotificationCenter defaultCenter] postNotificationName:@"SQlist" object:nil userInfo:nil];

                    [self.navigationController popViewControllerAnimated:YES];

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

- (void)parseApplyDataWithDictionary:(NSDictionary *)dict {
    if (![dict objectForKey:@"result"] || ![[dict objectForKey:@"result"] isKindOfClass:[NSDictionary class]]) {
        return;
    }
    NSDictionary *applyDict = [dict objectForKey:@"result"];
    
    ApplyOpenModel *model = [[ApplyOpenModel alloc] initWithParseDictionary:applyDict];
    _applyData = model;
    [self setPrimaryData];
    
    [self initAndLayoutUI];
    
    
}
//保存获取的内容
- (void)setPrimaryData {
    if (_applyData.personName) {
        [_infoDict setObject:_applyData.personName forKey:key_name];
    }
    if (_applyData.merchantName) {
        [_infoDict setObject:_applyData.merchantName forKey:key_merchantName];
    }
    if (_applyData.birthday) {
        [_infoDict setObject:_applyData.birthday forKey:key_birth];
    }
    if (_applyData.cardID) {
        [_infoDict setObject:_applyData.cardID forKey:key_cardID];
    }
    if (_applyData.phoneNumber) {
        [_infoDict setObject:_applyData.phoneNumber forKey:key_phone];
    }
    if (_applyData.email) {
        [_infoDict setObject:_applyData.email forKey:key_email];
    }
    if (_applyData.cityID) {
        [_infoDict setObject:_applyData.cityID forKey:key_location];
    }
    if (_applyData.bankName) {
        [_infoDict setObject:_applyData.bankName forKey:key_bank];
    }
    if (_applyData.bankNumber) {
        [_infoDict setObject:_applyData.bankNumber forKey:key_bankID];
    }
    if (_applyData.bankAccount) {
        [_infoDict setObject:_applyData.bankAccount forKey:key_bankAccount];
    }
    if (_applyData.taxID) {
        [_infoDict setObject:_applyData.taxID forKey:key_taxID];
    }
    if (_applyData.organID) {
        [_infoDict setObject:_applyData.organID forKey:key_organID];
    }
    if (_applyData.channelOpenName && _applyData.billingName) {
        [_infoDict setObject:[NSString stringWithFormat:@"%@ %@",_applyData.channelOpenName,_applyData.billingName] forKey:key_channel];
    }
    _channelID = _applyData.channelID;
    _billID = _applyData.billingID;
    
    [_infoDict setObject:[NSNumber numberWithInt:_applyData.sex] forKey:key_sex];
    _merchantID = _applyData.merchantID;
    _bankTitleName = _applyData.bankTitleName;

    /*之前上传过对公对私资料 保存*/
    for (ApplyInfoModel *model in _applyData.applyList) {
        if (model.value && ![model.value isEqualToString:@""]) {
            [_infoDict setObject:model.value forKey:model.targetID];
        }
    }
    [self.tableView reloadData];

}




//根据对公对私材料的id找到是否已经提交过材料
- (NSString *)getApplyValueForKey:(NSString *)key {
    NSLog(@"!!%@,key = %@",[_infoDict objectForKey:key],key);
    if ([_infoDict objectForKey:key] && ![[_infoDict objectForKey:key] isEqualToString:@""]) {
        //setPrimaryData方法中已经保存此值， 若修改则返回修改的值
        return [_infoDict objectForKey:key];
    }
    //    else {
    //        //是否之前提交过
    //        if ([_applyData.applyList count] <= 0) {
    //            return nil;
    //        }
    //        for (ApplyInfoModel *model in _applyData.applyList) {
    //            if ([model.targetID isEqualToString:key]) {
    //                if (model.value && ![model.value isEqualToString:@""]) {
    //                    [_infoDict setObject:model.value forKey:key];
    //                }
    //                return model.value;
    //            }
    //        }
    //    }
    return nil;
}


- (void)parseImageUploadInfo:(NSDictionary *)dict {
    if (![dict objectForKey:@"result"] || ![[dict objectForKey:@"result"] isKindOfClass:[NSString class]]) {
        return;
    }
    NSString *urlString = [dict objectForKey:@"result"];
    if (urlString && ![urlString isEqualToString:@""]) {
        [_infoDict setObject:urlString forKey:_selectedKey];
    }
    [_tableView reloadData];
}

#pragma mark - 上传图片

- (void)uploadPictureWithImage:(UIImage *)image {
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
    hud.labelText = @"上传中...";
    [NetworkInterface uploadImageWithImage:image terminalID:_terminalID finished:^(BOOL success, NSData *response) {
        NSLog(@"!!!!%@",[[NSString alloc] initWithData:response encoding:NSUTF8StringEncoding]);
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
                    hud.labelText = @"上传成功";
                    [self parseImageUploadInfo:object];
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

//点击图片行调用
- (void)showImageOption {
    UIActionSheet *sheet = nil;
    NSString *value = [_infoDict objectForKey:_selectedKey];
    if (value && ![value isEqualToString:@""]) {
        sheet = [[UIActionSheet alloc] initWithTitle:@""
                                            delegate:self
                                   cancelButtonTitle:@"取消"
                              destructiveButtonTitle:nil
                                   otherButtonTitles:@"查看照片",@"相册上传",@"拍照上传",nil];
    }
    else {
        sheet = [[UIActionSheet alloc] initWithTitle:@""
                                            delegate:self
                                   cancelButtonTitle:@"取消"
                              destructiveButtonTitle:nil
                                   otherButtonTitles:@"相册上传",@"拍照上传",nil];
    }
    [sheet showInView:self.view];
}
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingImage:(UIImage *)image editingInfo:(NSDictionary *)editingInfo
{
    
    //[picker dismissViewControllerAnimated:YES completion:nil];
    [self.popViewController dismissPopoverAnimated:NO];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    [self.popViewController dismissPopoverAnimated:NO];
}
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    NSInteger sourceType = UIImagePickerControllerSourceTypeCamera;
    NSString *value = [_infoDict objectForKey:_selectedKey];
    if (value && ![value isEqualToString:@""]) {
        if (buttonIndex == 0) {
            //查看大图
            [self scanBigImage];

            return;
        }
        else if (buttonIndex == 1) {
            //相册
            sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        }
        else if (buttonIndex == 2) {
            //拍照
            sourceType = UIImagePickerControllerSourceTypeCamera;
        }
    }
    else {
        if (buttonIndex == 0) {
            //相册
            sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        }
        else if (buttonIndex == 1) {
            //拍照
            sourceType = UIImagePickerControllerSourceTypeCamera;
        }
    }
    if ([UIImagePickerController isSourceTypeAvailable:sourceType]&&
        buttonIndex != actionSheet.cancelButtonIndex) {
        UIImagePickerController *imagePickerController = [[UIImagePickerController alloc] init];
        imagePickerController.delegate = self;
        imagePickerController.allowsEditing = YES;
        imagePickerController.sourceType = sourceType;
        
        UIPopoverController *popover = [[UIPopoverController alloc] initWithContentViewController:imagePickerController];
        popover.delegate = self;
        self.popViewController = popover;//对局部UIPopoverController对象popover我们赋给了一个全局的UIPopoverController对象popoverController
        // popover.popoverContentSize = CGSizeMake(SCREEN_WIDTH, SCREEN_HEIGHT);
        
        if([[[UIDevice currentDevice] systemVersion] floatValue]>=8.0)
        {
            
            [[NSOperationQueue mainQueue] addOperationWithBlock:^{
                
                [self.popViewController presentPopoverFromRect:CGRectMake(100, 100, 200, 300) inView:self.view permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
                
            }];
            
        }
        else
        {
            
            [self.popViewController presentPopoverFromRect:CGRectMake(100, 100, 200, 300) inView:self.view permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
        }
        
    }
}

#pragma mark - UIImagePickerDelegate
- (void)scanBigImage {
    NSString *urlString = [_infoDict objectForKey:_selectedKey];
    [self showDetailImageWithURL:urlString imageRect:self.imageRect];
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    //[picker dismissViewControllerAnimated:YES completion:nil];
    [self.popViewController dismissPopoverAnimated:NO];
    UIImage *editImage = [info objectForKey:UIImagePickerControllerEditedImage];
    [self uploadPictureWithImage:editImage];
}

#pragma mark - UITableView
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    NSInteger section = 1;
    
    return section;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    
    if(tableView==_terminalTableView)
    {
        if(sexint==102)
        {
            
            
            return 2;
            
        }
        
        else if (sexint==103)
        {
            return _applyData.merchantList.count;
            
        }

    
    }
    
   
        
        return 0;
        

}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSString *cellIdentifier =@"cellIdentifier";
    
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    if (!cell)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier] ;
    }
    if(tableView==_terminalTableView)
    {
        NSLog(@"%@",_applyData.merchantList);
        NSArray*arry=[NSArray arrayWithObjects:@"女", @"男",nil];
        if(sexint==102)
        {
            
            
            cell.textLabel.text =[arry objectAtIndex:indexPath.row];
            
            cell.backgroundColor = kColor(214, 214, 214, 1.0);
            
        }else
        {
            MerchantModel *model = [_applyData.merchantList objectAtIndex:indexPath.row];
            cell.textLabel.text = model.merchantName;
            cell.backgroundColor = kColor(214, 214, 214, 1.0);
        }
        
        
        
        
    }
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if(tableView==_terminalTableView)
    {
        return 0;
        
    }
    else
    {
        
        NSInteger lastheightY;
        //lastheightY=_applyData.materialList.count-2;
        if(lastheightY%2==0)
        {
            lastheightY=_applyData.materialList.count/2;
            
        }
        else
        {
            
            lastheightY=_applyData.materialList.count/2+1;
            
        }
        
        //return    1000+lastheightY*70;
        return    1200+lastheightY*70;
        


        
    }
}
//创建开始日期选择器
-(void)setupStartDate
{
    
    UIViewController *sortViewController = [[UIViewController alloc] init];
    UIView *theView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 276)];
    
    _toolbar = [[UIToolbar alloc] initWithFrame:CGRectMake(0, 0, 320, 60)];
    UIBarButtonItem *cancelItem = [[UIBarButtonItem alloc] initWithTitle:@"取消" style:UIBarButtonItemStyleDone target:self action:@selector(caneClick)];
    UIBarButtonItem *finishItem = [[UIBarButtonItem alloc] initWithTitle:@"完成"
                                                                   style:UIBarButtonItemStyleDone
                                                                  target:self
                                                                  action:@selector(makeSureClick:)];
    UIBarButtonItem *spaceItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace
                                                                               target:nil action:nil];
    [_toolbar setItems:[NSArray arrayWithObjects:cancelItem,spaceItem,finishItem, nil]];
    [theView addSubview:_toolbar];
    
    
    
    datePicker = [[UIDatePicker alloc]init];
    //    datePicker.backgroundColor = kColor(212, 212, 212, 1.0);
    datePicker.datePickerMode = UIDatePickerModeDate;
    datePicker.frame = CGRectMake(0, 60, 320, 216);
    
    
    
    
//    [datePicker addTarget:self action:@selector(startPick) forControlEvents:UIControlEventValueChanged];
    [theView addSubview:datePicker];
    
    //    datepickview=[[UIView alloc]initWithFrame:CGRectMake(datePicker.frame.origin.x  , CGRectGetMaxY(datePicker.frame), datePicker.frame.size.width, 30)];
    //    [theView addSubview:datePicker];
    //    datepickview.backgroundColor=kColor(212, 212, 212, 1.0);
    //    makeSureBtn = [[UIButton alloc]init];
    //    makeSureBtn.tag = 1112;
    //    [makeSureBtn addTarget:self action:@selector(makeSureClick:) forControlEvents:UIControlEventTouchUpInside];
    //    [makeSureBtn setBackgroundColor:kColor(156, 156, 156, 1.0)];
    //    [makeSureBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    //    [makeSureBtn setTitle:@"确认" forState:UIControlStateNormal];
    //    makeSureBtn.titleLabel.font = [UIFont systemFontOfSize:20];
    //    makeSureBtn.frame = CGRectMake(datePicker.frame.origin.x + datePicker.frame.size.width * 0.6, CGRectGetMaxY(datePicker.frame), datePicker.frame.size.width * 0.4, 30);
    //
    //    self.startSure = makeSureBtn;
    self.datePickerStart = datePicker;
    
    
    sortViewController.view = theView;
    
    _popViewController = [[UIPopoverController alloc] initWithContentViewController:sortViewController];
    [_popViewController setPopoverContentSize:CGSizeMake(320, 300) animated:YES];
    [_popViewController presentPopoverFromRect:CGRectMake(120, 0, 0, 42) inView:birthdaybutton permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
    _popViewController.delegate = self;
}
-(void)caneClick
{
    [self pickerHide];
    

}
-(void)makeSureClick:(UIButton *)button
{
    birthdaybutton.userInteractionEnabled=YES;
   
        [self startPick];
        
        [_infoDict setObject: self.startTime forKey:key_birth];
        NSString*accountname=[NSString stringWithFormat:@"%@",[_infoDict objectForKey:key_birth]];
        
        
        [birthdaybutton setTitle:accountname forState:UIControlStateNormal];
   
//    [cancelBtn removeFromSuperview];
//    [datepickview removeFromSuperview];
//    [makeSureBtn removeFromSuperview];
//    [datePicker removeFromSuperview];
  
    
    [self pickerHide];

    
    
}

-(void)startPick
{
    self.startTime = [self stringFromDate:datePicker.date];
    
    NSLog(@"%@",self.startTime);
    
}

//将日期转化成字符串yyyy-MM-dd格式
- (NSString *)stringFromDate:(NSDate *)date {
    NSDateFormatter *format = [[NSDateFormatter alloc] init];
    [format setDateFormat:@"yyyy-MM-dd"];
    NSString *dateString = [format stringFromDate:date];
    if ([dateString length] >= 10) {
        return [dateString substringToIndex:10];
    }
    return dateString;
}

//将yyyy-MM-dd格式字符串转化成日期
- (NSDate *)dateFromString:(NSString *)string {
    NSDateFormatter *format = [[NSDateFormatter alloc] init];
    [format setDateFormat:@"yyyy-MM-dd"];
    return [format dateFromString:string];
}







#pragma mark - UIPickerView
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return 2;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    
    if (zhifuint==106)
    
    
    {
        
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
else
{

    
    if (component == 0)
    {
        return [_channelItems count];;
    }
    else
    {
        NSInteger channelIndex = [pickerView selectedRowInComponent:0];
        if ([_channelItems count] > 0)
        {
            ChannelListModel *channel = [_channelItems objectAtIndex:channelIndex];
            _secondArray = channel.children;
            return [_secondArray count];
        }
        return 0;
    }





}
   }

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    
    
    if (zhifuint==106)

    {
        if (component == 0) {
            //省
            NSDictionary *provinceDict = [[CityHandle shareProvinceList] objectAtIndex:row];
            return [provinceDict objectForKey:@"name"];
        }
        else {
            //市
            return [[_cityArray objectAtIndex:row] objectForKey:@"name"];
        }

    
    }else{
    
    
        if (component == 0) {
            //通道
            ChannelListModel *model = [_channelItems objectAtIndex:row];
            return model.channelName;
        }
        else {
            //结算时间
            if ([_secondArray count] > 0) {
                BillingModel *model = [_secondArray objectAtIndex:row];
                return model.billName;
            }
            return @"";
        }

    
    
    
    }
    
   }

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    if (component == 0) {
        //省
        [_pickerView reloadComponent:1];
    }
}


#pragma mark - UIPickerView
- (void)initPickerView {
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
    
    _toolbar = [[UIToolbar alloc] initWithFrame:CGRectMake(0, height, wide, 44)];
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
    _pickerView = [[UIPickerView alloc] initWithFrame:CGRectMake(0, height, wide, 216)];
    _pickerView.backgroundColor = kColor(244, 243, 243, 1);
    _pickerView.delegate = self;
    _pickerView.dataSource = self;
    
    [self.view addSubview:_pickerView];
}

- (IBAction)modifyLocation:(id)sender {
//    [self pickerScrollOut];
    
    
    if (zhifuint==106)
    {
        NSInteger index = [_pickerView selectedRowInComponent:1];
        NSString *cityID = [NSString stringWithFormat:@"%@",[[_cityArray objectAtIndex:index] objectForKey:@"id"]];
        NSString *cityName = [[_cityArray objectAtIndex:index] objectForKey:@"name"];
        [locationbutton setTitle:cityName forState:UIControlStateNormal];
        [_infoDict setObject:cityID forKey:key_location];
        

    }else
    {
        
        NSInteger firstIndex = [_pickerView selectedRowInComponent:0];
        NSInteger secondIndex = [_pickerView selectedRowInComponent:1];
        ChannelListModel *channel = nil;
        BillingModel *model = nil;
        if (firstIndex < [_channelItems count]) {
            channel = [_channelItems objectAtIndex:firstIndex];
        }
        if (secondIndex < [_secondArray count]) {
            model = [_secondArray objectAtIndex:secondIndex];
        }
        
        NSString *channelInfo = [NSString stringWithFormat:@"%@ %@",channel.channelName,model.billName];
        
        
        
        
        
        
        //        NSString *channelInfo = [NSString stringWithFormat:@"%@ %@",model.channelName,billModel.billName];
        [_infoDict setObject:channelInfo forKey:key_channel];
        _channelID = channel.channelID;
        _billID = model.billID;
        [zhifubutton setTitle:channelInfo forState:UIControlStateNormal];
        
        [_tableView reloadData];
    }

    
    
    
    
    [self pickerHide];

}

- (void)pickerScrollIn {
    [UIView animateWithDuration:.3f animations:^{
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
        
        
        _toolbar.frame = CGRectMake(0, height - 260, wide, 44);
        _pickerView.frame = CGRectMake(0, height - 216, wide, 216);
    }];
}

- (void)pickerScrollOut {
    [UIView animateWithDuration:.3f animations:^{
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
        
        _toolbar.frame = CGRectMake(0, height, wide, 44);
        _pickerView.frame = CGRectMake(0, height, wide, 216);
    }];
}



#pragma mark - Action

- (IBAction)typeChanged:(id)sender {
    if (_segmentControl.selectedSegmentIndex == 1) {
        _applyType = OpenApplyPrivate;
    }
    else {
        _applyType = OpenApplyPublic;
    }
    [self beginApply];
    NSLog(@"%d",_applyType);
}



- (IBAction)submitApply:(id)sender {
    [_tempField becomeFirstResponder];
    
    [_tempField resignFirstResponder];
    if (_applyData.openType == OpenTypeNone) {
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
        hud.customView = [[UIImageView alloc] init];
        hud.mode = MBProgressHUDModeCustomView;
        [hud hide:YES afterDelay:1.f];
        hud.labelText = @"未获取到终端开通类型";
        return;
    }
    if (![_infoDict objectForKey:key_name]) {
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
        hud.customView = [[UIImageView alloc] init];
        hud.mode = MBProgressHUDModeCustomView;
        [hud hide:YES afterDelay:1.f];
        hud.labelText = @"请填写姓名";
        return;
    }
    if (![_infoDict objectForKey:key_merchantName]) {
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
        hud.customView = [[UIImageView alloc] init];
        hud.mode = MBProgressHUDModeCustomView;
        [hud hide:YES afterDelay:1.f];
        hud.labelText = @"请填写店铺名称";
        return;
    }
    if (![_infoDict objectForKey:key_sex]) {
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
        hud.customView = [[UIImageView alloc] init];
        hud.mode = MBProgressHUDModeCustomView;
        [hud hide:YES afterDelay:1.f];
        hud.labelText = @"请选择性别";
        return;
    }
    if (![_infoDict objectForKey:key_birth]) {
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
        hud.customView = [[UIImageView alloc] init];
        hud.mode = MBProgressHUDModeCustomView;
        [hud hide:YES afterDelay:1.f];
        hud.labelText = @"请选择生日";
        return;
    }
    if (![_infoDict objectForKey:key_cardID]) {
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
        hud.customView = [[UIImageView alloc] init];
        hud.mode = MBProgressHUDModeCustomView;
        [hud hide:YES afterDelay:1.f];
        hud.labelText = @"请填写身份证号";
        return;
    }
    if (![RegularFormat isCorrectIdentificationCard:[_infoDict objectForKey:key_cardID]]) {
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
        hud.customView = [[UIImageView alloc] init];
        hud.mode = MBProgressHUDModeCustomView;
        [hud hide:YES afterDelay:1.f];
        hud.labelText = @"请填写正确的身份证号";
        return;
    }
    if (![_infoDict objectForKey:key_phone]) {
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
        hud.customView = [[UIImageView alloc] init];
        hud.mode = MBProgressHUDModeCustomView;
        [hud hide:YES afterDelay:1.f];
        hud.labelText = @"请填写电话";
        return;
    }
    if (!([RegularFormat isMobileNumber:[_infoDict objectForKey:key_phone]] ||
          [RegularFormat isTelephoneNumber:[_infoDict objectForKey:key_phone]])) {
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
        hud.customView = [[UIImageView alloc] init];
        hud.mode = MBProgressHUDModeCustomView;
        [hud hide:YES afterDelay:1.f];
        hud.labelText = @"请填写正确的电话";
        return;
    }
    if (![_infoDict objectForKey:key_email]) {
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
        hud.customView = [[UIImageView alloc] init];
        hud.mode = MBProgressHUDModeCustomView;
        [hud hide:YES afterDelay:1.f];
        hud.labelText = @"请填写邮箱";
        return;
    }
    if (![RegularFormat isCorrectEmail:[_infoDict objectForKey:key_email]]) {
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
        hud.customView = [[UIImageView alloc] init];
        hud.mode = MBProgressHUDModeCustomView;
        [hud hide:YES afterDelay:1.f];
        hud.labelText = @"请填写正确的邮箱";
        return;
    }
    if (![_infoDict objectForKey:key_location]) {
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
        hud.customView = [[UIImageView alloc] init];
        hud.mode = MBProgressHUDModeCustomView;
        [hud hide:YES afterDelay:1.f];
        hud.labelText = @"请选择所在地";
        return;
    }
    if (![_infoDict objectForKey:key_bank]) {
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
        hud.customView = [[UIImageView alloc] init];
        hud.mode = MBProgressHUDModeCustomView;
        [hud hide:YES afterDelay:1.f];
        hud.labelText = @"请填写结算银行账户名";
        return;
    }
    if (![_infoDict objectForKey:key_bankID]) {
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
        hud.customView = [[UIImageView alloc] init];
        hud.mode = MBProgressHUDModeCustomView;
        [hud hide:YES afterDelay:1.f];
        hud.labelText = @"请填写结算银行卡号";
        return;
    }
    if ( !_bankTitleName) {
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
        hud.customView = [[UIImageView alloc] init];
        hud.mode = MBProgressHUDModeCustomView;
        [hud hide:YES afterDelay:1.f];
        hud.labelText = @"请填写结算银行名称";
        return;
    }
    if (_applyType == OpenTypePublic) {
        if (![_infoDict objectForKey:key_taxID]) {
            MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
            hud.customView = [[UIImageView alloc] init];
            hud.mode = MBProgressHUDModeCustomView;
            [hud hide:YES afterDelay:1.f];
            hud.labelText = @"请填写税务登记证号";
            return;
        }
        if (![_infoDict objectForKey:key_organID]) {
            MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
            hud.customView = [[UIImageView alloc] init];
            hud.mode = MBProgressHUDModeCustomView;
            [hud hide:YES afterDelay:1.f];
            hud.labelText = @"请填写组织机构号";
            return;
        }
    }
    if (!_channelID || !_billID) {
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
        hud.customView = [[UIImageView alloc] init];
        hud.mode = MBProgressHUDModeCustomView;
        [hud hide:YES afterDelay:1.f];
        hud.labelText = @"请选择支付通道";
        return;
    }
    for (MaterialModel *model in _applyData.materialList) {
        
        if ( [self isBlankString:[_infoDict objectForKey:model.materialID]]) {
            NSString *infoString = nil;
            if (model.materialType == MaterialText) {
                infoString = [NSString stringWithFormat:@"请填写%@",model.materialName];
            }
            else if (model.materialType == MaterialList) {
                infoString = [NSString stringWithFormat:@"请选择%@",model.materialName];
            }
            else if (model.materialType == MaterialImage) {
                infoString = [NSString stringWithFormat:@"请上传%@",model.materialName];
            }
            MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
            hud.customView = [[UIImageView alloc] init];
            hud.mode = MBProgressHUDModeCustomView;
            [hud hide:YES afterDelay:1.f];
            hud.labelText = infoString;
            return;
        }
    }
    NSMutableArray *paramList = [[NSMutableArray alloc] init];
    AppDelegate *delegate = [AppDelegate shareAppDelegate];
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    [params setObject:[NSNumber numberWithInt:[_terminalID intValue]] forKey:@"terminalId"];
    [params setObject:[NSNumber numberWithInt:_openStatus] forKey:@"status"];
    [params setObject:[NSNumber numberWithInt:[delegate.userID intValue]] forKey:@"applyCustomerId"];
    [params setObject:[NSNumber numberWithInt:_applyType] forKey:@"publicPrivateStatus"];
    
    
    if (_merchantID) {
        [params setObject:[NSNumber numberWithInt:[_merchantID intValue]] forKey:@"merchantId"];
    }
    [params setObject:[_infoDict objectForKey:key_merchantName] forKey:@"merchantName"];
    [params setObject:[_infoDict objectForKey:key_sex] forKey:@"sex"];
    [params setObject:[_infoDict objectForKey:key_birth] forKey:@"birthday"];
    [params setObject:[_infoDict objectForKey:key_cardID] forKey:@"cardId"];
    [params setObject:[_infoDict objectForKey:key_phone] forKey:@"phone"];
    [params setObject:[_infoDict objectForKey:key_name] forKey:@"name"];
    [params setObject:[_infoDict objectForKey:key_email] forKey:@"email"];
    
    [params setObject:[NSNumber numberWithInt:[[_infoDict objectForKey:key_location] intValue]] forKey:@"cityId"];
    
    [params setObject:[NSNumber numberWithInt:[_channelID intValue]] forKey:@"channel"];
    [params setObject:[NSNumber numberWithInt:[_billID intValue]] forKey:@"billingId"];
    
    [params setObject:[_infoDict objectForKey:key_bankID] forKey:@"bankNum"];
    [params setObject:[_infoDict objectForKey:key_bank] forKey:@"bankName"];
    
    if ([self isBlankString:[_infoDict objectForKey:@"key_bankIDfdf"]]) {
        [params setObject:@"" forKey:@"bankCode"];

    }
    else
    {
        [params setObject:[_infoDict objectForKey:@"key_bankIDfdf"] forKey:@"bankCode"];

    
    
    }
    if (_bankTitleName) {
        [params setObject:_bankTitleName forKey:@"bank_name"];
    }
    if (_applyType == OpenApplyPublic) {
        [params setObject:[_infoDict objectForKey:key_organID] forKey:@"organizationNo"];
        [params setObject:[_infoDict objectForKey:key_taxID] forKey:@"registeredNo"];
    }

    
    [paramList addObject:params];
    for (MaterialModel *model in _applyData.materialList) {
        NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
        NSString *value = nil;
        value = [_infoDict objectForKey:model.materialID];
        if (model.materialName) {
            [dict setObject:model.materialName forKey:@"key"];
        }
        if (value) {
            [dict setObject:value forKey:@"value"];
        }

      
        [dict setObject:[NSNumber numberWithInt:model.materialType] forKey:@"types"];
        [dict setObject:[NSNumber numberWithInt:[model.materialID intValue]] forKey:@"targetId"];
        [dict setObject:[NSNumber numberWithInt:[model.levelID intValue]] forKey:@"openingRequirementId"];
        [paramList addObject:dict];
    }
    [self submitApplyInfoWithArray:paramList];
}

#pragma mark - UITextFieldDelegate


- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    self.editingField=textField;
    
    if(textField.tag==1056+9)
    {
        
        
        _bankTitleName=textField.text;
    }

    //    CGRect keyboardRect = [[[paramNotification userInfo] objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue];
    CGRect fieldRect = [[self.editingField superview] convertRect:self.editingField.frame toView:self.view];
    CGFloat topHeight = self.navigationController.navigationBar.frame.size.height + [[UIApplication sharedApplication] statusBarFrame].size.height;
    CGFloat offsetY = 400 - (kScreenHeight - topHeight - fieldRect.origin.y - fieldRect.size.height);
    if (offsetY > 0 ) {
        self.primaryPoint = self.tableView.contentOffset;
        self.offset = offsetY;
        [self.tableView setContentOffset:CGPointMake(0, self.primaryPoint.y + self.offset) animated:YES];
    }


    return YES;


}// return NO to disallow editing.

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    if (self.offset != 0) {
        [self.tableView setContentOffset:CGPointMake(0, self.primaryPoint.y) animated:YES];
        self.offset = 0;
    }
    self.editingField = nil;
    [textField resignFirstResponder];
    return YES;
}

- (void)textFieldDidBeginEditing:(UITextField *)textField {
    [self pickerScrollOut];
}

- (void)textFieldDidEndEditing:(UITextField *)textField {
    
    
    if(textField.tag==1056+9)
    {
        
        
        _bankTitleName=textField.text;
    }
    
    
    if (textField.tag>=999656) {
        for (int i=0; i<_textarrys.count; i++) {
            if (textField.tag==[[_textarrys objectAtIndex:i] integerValue]+999656)
            {
                [_infoDict setObject:textField.text forKey:[_textarrys objectAtIndex:i]];
                
            }
        }
        
    }
    else
    {
        if (textField.text && ![textField.text isEqualToString:@""])
        {
            
            
            [_infoDict setObject:textField.text forKey:[keynamesarry objectAtIndex:textField.tag-1056]];
            
            if ([[keynamesarry objectAtIndex:textField.tag-1056] isEqualToString:key_merchantName])
            {
                [_infoDict setObject:textField.text forKey:key_bank];
                [_tableView reloadData];
            }
            
        }

        
    }
    
}
#pragma mark - ChannelSelectedDelegate
- (void)getSelectedBank:(BankModel *)model {
    if (model) {
        NSLog(@"%@%@",model.bankName,_selectedKey);
        if([_selectedKey isEqualToString: @"key_bankIDfdf"])
        {
            _bankTitleName=model.bankName;

        }else
        {
        
            _bankTitleName2=model.bankName;

        }
        if(model.bankCode)
        {
            [_infoDict setObject:model.bankCode forKey:_selectedKey];

        
        }
        
        //此处没有保存对象 因为infoDict的值都为NSString，防止报错
        [_tableView reloadData];
    }
}

- (void)getChannelList:(ChannelListModel *)model billModel:(BillingModel *)billModel {
    
}

@end
