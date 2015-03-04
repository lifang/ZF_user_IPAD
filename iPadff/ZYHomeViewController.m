//
//  ZYHomeViewController.m
//  iPadff
//
//  Created by comdosoft on 15/2/26.
//  Copyright (c) 2015年 LanTaiPro. All rights reserved.
//

#import "ZYHomeViewController.h"
#import "LocationButton.h"
#import "PollingView.h"
#import "GoodListViewController.h"
#import "BasicNagigationController.h"
@interface ZYHomeViewController ()
@property(nonatomic,strong)PollingView *pollingView;
@end

@implementation ZYHomeViewController
- (void)viewWillAppear:(BOOL)animated
{
    self.navigationController.navigationBarHidden = YES;

}
- (void)viewDidLoad {
    [super viewDidLoad];

    UIView*vei=[[UIView alloc]initWithFrame:CGRectMake(0, 0,SCREEN_WIDTH -60, SCREEN_HEIGHT )];
    [self.view addSubview:vei];
    if(iOS8)
    {
        rootview=[[UIView alloc]initWithFrame:CGRectMake(0, 0,SCREEN_WIDTH -60, SCREEN_HEIGHT )];
        [self.view addSubview:rootview];
    
        
        rootview.backgroundColor=[UIColor whiteColor];
        
    }
    
    else
        
    {
        rootview=[[UIView alloc]initWithFrame:CGRectMake(0, 0,SCREEN_HEIGHT -60, SCREEN_WIDTH )];
        [self.view addSubview:rootview];
        NSLog(@"%f",SCREEN_WIDTH);
        
        rootview.backgroundColor=[UIColor whiteColor];
        
        
    }

   
    [self initNavigationView];
    [self initPollingView];
    [self initModuleView];
}

-(void)initPollingView
{
    //图片比例 40:17
    
    if(iOS7)
    {
        _pollingView = [[PollingView alloc] initWithFrame:CGRectMake(0, 65, SCREEN_HEIGHT, SCREEN_WIDTH*0.4)];

    }
    else
    {
        _pollingView = [[PollingView alloc] initWithFrame:CGRectMake(0, 65, SCREEN_WIDTH, SCREEN_HEIGHT*0.4)];

    
    }
    [self.view addSubview:_pollingView];
}
- (void)initNavigationView {

//    UIImageView *topView = [[UIImageView alloc] initWithFrame:CGRectMake(SCREEN_HEIGHT/2-47, 20, 134, 38)];
 
    

    UIImageView *topView = [[UIImageView alloc] init ];
    topView.image = kImageName(@"home_logo.png");
    [rootview addSubview:topView];
    
    UIImageView *itemImageView = [[UIImageView alloc]init ];
    itemImageView.image = kImageName(@"home_right.png");
    [self.view addSubview:itemImageView];
    
    
    
    LocationButton *rightBtn = [[LocationButton alloc]init];
    
    if(iOS7)
    {
        topView.frame = CGRectMake(SCREEN_HEIGHT/2-67-60, 20, 134, 38);
        itemImageView.frame = CGRectMake(SCREEN_HEIGHT/2+15, 25, 119, 30);
               rightBtn.frame = CGRectMake(SCREEN_HEIGHT-160, itemImageView.frame.origin.y, 60, 30);
        
    }
    else
    {
        topView.frame = CGRectMake(SCREEN_WIDTH/2-67-60, 20, 134, 38);
        itemImageView.frame = CGRectMake(SCREEN_WIDTH/2+15, 25, 119, 30);
        

        rightBtn.frame = CGRectMake(SCREEN_WIDTH-160, itemImageView.frame.origin.y, 60, 30);
        
        
    }
    [self.view addSubview:rightBtn];
    
    [rootview addSubview:itemImageView];
    [self initModuleView];

}
- (void)initModuleView {
       NSArray *nameArray = [NSArray arrayWithObjects:
                          @"买POS机",
                          @"开通认证",
                          @"终端管理",
                          @"交易流水",
                          @"我要贷款",
                          @"我要理财",
                          @"系统公告",
                          @"联系我们",
                          nil];
    
    
    
    
    for(NSInteger i=0;i<8;i++)
    {
    
    
        UIButton*button=[UIButton buttonWithType:UIButtonTypeCustom];
    
        button.tag=i+1000;
        
        [self.view addSubview:button];
        [button setImage:[UIImage imageNamed:[NSString stringWithFormat:@"home%d",i+1]] forState:UIControlStateNormal];
        [button addTarget:self action:@selector(tarbarClicked:) forControlEvents:UIControlEventTouchUpInside];
        [button.imageView setContentMode:UIViewContentModeScaleAspectFit];
        [button setContentEdgeInsets:UIEdgeInsetsMake(0,0,10,0)];
        UILabel*lable=[[UILabel alloc]init];
        
        
        lable.text=[nameArray objectAtIndex:i];
        lable.textColor=[UIColor grayColor];
        
        
        
        if(i<4)
        {
//            button.frame=CGRectMake((SCREEN_WIDTH-60)/8*(2*i+1)-32,SCREEN_HEIGHT/2+50,  64, 64);
//            lable.frame=CGRectMake((2*i+1)*(SCREEN_WIDTH-60)/8-32,SCREEN_HEIGHT/2+110,  80, 54);
            
            if(iOS7)
            {
                
                button.frame=CGRectMake((SCREEN_HEIGHT-60)/8*(2*i+1)-32,SCREEN_WIDTH/2+50,  64, 64);
                lable.frame=CGRectMake((2*i+1)*(SCREEN_HEIGHT-60)/8-32,SCREEN_WIDTH/2+110,  80, 54);
                
                if (button.tag==1000) {
                    
                    UIView *line1 = [[UIView alloc]initWithFrame:CGRectMake(CGRectGetMaxX(button.frame)* 1.6, button.frame.origin.y -10, 2, 2 * button.frame.size.height*2)];
                    line1.backgroundColor = kColor(242, 242, 242, 1.0);
                    [self.view addSubview:line1];
                    
                    UIView *line2 = [[UIView alloc]initWithFrame:CGRectMake(button.frame.origin.x-40, CGRectGetMaxY(button.frame)+50, SCREEN_HEIGHT-156, 2)];
                    line2.backgroundColor = kColor(242, 242, 242, 1.0);
                    [self.view addSubview:line2];
                    
                }
                if (button.tag==1001) {
                    UIView *line1 = [[UIView alloc]initWithFrame:CGRectMake(CGRectGetMaxX(button.frame)*1.2, button.frame.origin.y -10, 2, 2 * button.frame.size.height*2)];
                    line1.backgroundColor = kColor(242, 242, 242, 1.0);
                    [self.view addSubview:line1];
                }
                if (button.tag==1002) {
                    UIView *line1 = [[UIView alloc]initWithFrame:CGRectMake(CGRectGetMaxX(button.frame)*1.15, button.frame.origin.y -10, 2, 2 * button.frame.size.height*2)];
                    line1.backgroundColor = kColor(242, 242, 242, 1.0);
                    [self.view addSubview:line1];
                }

                

               
            }
        
            else
                
            {
                button.frame=CGRectMake((SCREEN_WIDTH-60)/8*(2*i+1)-32,SCREEN_HEIGHT/2+50,  64, 64);
                lable.frame=CGRectMake((2*i+1)*(SCREEN_WIDTH-60)/8-32,SCREEN_HEIGHT/2+110,  80, 54);
                if (button.tag==1000) {
                    
                    UIView *line1 = [[UIView alloc]initWithFrame:CGRectMake(CGRectGetMaxX(button.frame)* 1.6, button.frame.origin.y -10, 2, 2 * button.frame.size.height*2)];
                    line1.backgroundColor = kColor(242, 242, 242, 1.0);
                    [self.view addSubview:line1];
                    UIView *line2 = [[UIView alloc]initWithFrame:CGRectMake(button.frame.origin.x-40, CGRectGetMaxY(button.frame)+50, SCREEN_WIDTH -156, 2)];
                    line2.backgroundColor = kColor(242, 242, 242, 1.0);
                    [self.view addSubview:line2];
                    
                }
                if (button.tag==1001) {
                    UIView *line1 = [[UIView alloc]initWithFrame:CGRectMake(CGRectGetMaxX(button.frame)*1.2, button.frame.origin.y -10, 2, 2 * button.frame.size.height*2)];
                    line1.backgroundColor = kColor(242, 242, 242, 1.0);
                    [self.view addSubview:line1];
                }
                if (button.tag==1002) {
                    UIView *line1 = [[UIView alloc]initWithFrame:CGRectMake(CGRectGetMaxX(button.frame)*1.15, button.frame.origin.y -10, 2, 2 * button.frame.size.height*2)];
                    line1.backgroundColor = kColor(242, 242, 242, 1.0);
                    [self.view addSubview:line1];
                }

            }

            
            
        }
        
        else
            
        {
            
            
            if(iOS7)
            {
                lable.frame=CGRectMake((2*i-7)*(SCREEN_HEIGHT-60)/8-32,SCREEN_WIDTH/2+250,  80, 54);
                
                
                button.frame=CGRectMake((SCREEN_HEIGHT-60)/8*(2*i-7)-32,SCREEN_WIDTH/2+200,  64, 64);
                

                
                
                
                
            }
            
            else
                
            {
                
                
                lable.frame=CGRectMake((2*i-7)*(SCREEN_WIDTH-60)/8-32,SCREEN_HEIGHT/2+250,  80, 54);
                
                
                button.frame=CGRectMake((SCREEN_WIDTH-60)/8*(2*i-7)-32,SCREEN_HEIGHT/2+200,  64, 64);
                
                

                
            }
        }
        
        [self.view addSubview:lable];
    }
    
}

#pragma mark - Action

- (void)tarbarClicked:(UIButton *)sender {
    switch (sender.tag) {
        case 1000: {
            //选择POS机
            GoodListViewController *listC = [[GoodListViewController alloc] init];
            
            listC.hidesBottomBarWhenPushed =  YES ;
           [self.navigationController pushViewController:listC animated:YES];
        }
            break;
        case 1001: {
            //开通认证
        }
            break;
        case 1002: {
            //终端管理
//            TerminalManagerController *managerC = [[TerminalManagerController alloc] init];
//            managerC.hidesBottomBarWhenPushed = YES;
//            [self.navigationController pushViewController:managerC animated:YES];
        }
            break;
        case 1003: {
            //交易流水
//            DealFlowViewController *dealFlowC = [[DealFlowViewController alloc] init];
//            dealFlowC.hidesBottomBarWhenPushed = YES;
//            [self.navigationController pushViewController:dealFlowC animated:YES];
        }
            break;
        case 1004: {
            //我要贷款
        }
            break;
        case 1005: {
            //我要理财
        }
            break;
        case 1006: {
            //系统公告
        }
            break;
        case 1007: {
            //联系我们
        }
            break;
        default:
            break;
    }
}


@end
