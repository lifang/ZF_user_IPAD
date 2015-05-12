//
//  LoanViewController.m
//  iPadff
//
//  Created by comdosoft on 15/5/10.
//  Copyright (c) 2015年 LanTaiPro. All rights reserved.
//

#import "LoanViewController.h"

@interface LoanViewController ()

@end

@implementation LoanViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title=@"我要理财";
    self.view.backgroundColor=[UIColor whiteColor];
  [self.navigationController.navigationBar setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIColor whiteColor], NSForegroundColorAttributeName, NavTitle_FONT(NavTitle_FONTSIZE),NSFontAttributeName,nil]];
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
    UIImageView*bigimageview=[[UIImageView alloc]initWithFrame:CGRectMake(wide/2-20, 240, 24, 32)];
    [self.view addSubview:bigimageview];
    UILabel*lab=[[UILabel alloc]initWithFrame:CGRectMake(wide/2-60, 200, 120, 40)];
    lab.text=@"敬请期待";
    lab.font=[UIFont systemFontOfSize:26];
    
    [self.view addSubview:lab];
    UILabel*lab1=[[UILabel alloc]initWithFrame:CGRectMake(wide/2-50, 260, 100, 20)];
    lab1.text=@"马不停蹄的开发中...";
    lab1.font=[UIFont systemFontOfSize:14];
    [self.view addSubview:lab1];
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
