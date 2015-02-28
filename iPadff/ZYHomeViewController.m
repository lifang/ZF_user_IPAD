//
//  ZYHomeViewController.m
//  iPadff
//
//  Created by comdosoft on 15/2/26.
//  Copyright (c) 2015年 LanTaiPro. All rights reserved.
//

#import "ZYHomeViewController.h"
#import "LocationButton.h"
@interface ZYHomeViewController ()

@end

@implementation ZYHomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UIView*vei=[[UIView alloc]initWithFrame:CGRectMake(0, 0,SCREEN_HEIGHT , SCREEN_WIDTH+100 )];
    [self.view addSubview:vei];
    
   vei.backgroundColor=[UIColor whiteColor];
    self.navigationController.navigationBarHidden = YES;
    [self initNavigationView];
    [self initModuleView];

    // Do any additional setup after loading the view.
}
- (void)initNavigationView {
    
    
    
        UIImageView *topView = [[UIImageView alloc] initWithFrame:CGRectMake(SCREEN_HEIGHT/2-67-60, 20, 134, 38)];
    topView.image = kImageName(@"home_logo.png");
    [self.view addSubview:topView];
    
    UIImageView *itemImageView = [[UIImageView alloc] initWithFrame:CGRectMake(SCREEN_HEIGHT/2+20, 25, 119, 30)];
    itemImageView.image = kImageName(@"home_right.png");
    [self.view addSubview:itemImageView];
    
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
        [button addTarget:self action:@selector(tabBarButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
        [button.imageView setContentMode:UIViewContentModeScaleAspectFit];
        [button setContentEdgeInsets:UIEdgeInsetsMake(0,0,10,0)];
        UILabel*lable=[[UILabel alloc]init];
        
        
        lable.text=[nameArray objectAtIndex:i];
        lable.textColor=[UIColor grayColor];
        
        
        
        if(i<4)
        {
            button.frame=CGRectMake((SCREEN_HEIGHT-60)/8*(2*i+1)-32,SCREEN_WIDTH/2+50,  64, 64);
            lable.frame=CGRectMake((2*i+1)*(SCREEN_HEIGHT-60)/8-32,SCREEN_WIDTH/2+110,  80, 54);

            
        }
        
        else
            
        {
            
            lable.frame=CGRectMake((2*i-7)*(SCREEN_HEIGHT-60)/8-32,SCREEN_WIDTH/2+250,  80, 54);

            
            button.frame=CGRectMake((SCREEN_HEIGHT-60)/8*(2*i-7)-32,SCREEN_WIDTH/2+200,  64, 64);
            
            
            
        }
        [self.view addSubview:lable];
        
    
    }
    
    }

#pragma mark - Action

- (void)tabBarButtonClicked:(UIButton*)sender {
    switch (sender.tag) {
        case 1000: {
            //选择POS机
//            GoodListViewController *listC = [[GoodListViewController alloc] init];
//            listC.hidesBottomBarWhenPushed = YES;
//            [self.navigationController pushViewController:listC animated:YES];
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
