//
//  GoodListViewController.m
//  iPadff
//
//  Created by comdosoft on 15/3/2.
//  Copyright (c) 2015年 LanTaiPro. All rights reserved.
//

#import "GoodListViewController.h"

@interface GoodListViewController ()

@end

@implementation GoodListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationController.navigationBarHidden = NO;
    
    UIView*vi=[[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_HEIGHT, SCREEN_WIDTH)];
    [self.view addSubview:vi];
    

    self.view.backgroundColor=[UIColor purpleColor];
    
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
