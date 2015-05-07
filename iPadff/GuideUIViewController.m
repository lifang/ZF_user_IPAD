//
//  GuideUIViewController.m
//  iPadff
//
//  Created by wufei on 15/4/28.
//  Copyright (c) 2015年 LanTaiPro. All rights reserved.
//

#import "GuideUIViewController.h"

@interface GuideUIViewController ()

@end

@implementation GuideUIViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor=[UIColor whiteColor];
    
    
    float wide;
    float high;
    
    if (iOS7) {
        wide=SCREEN_HEIGHT;
        high=SCREEN_WIDTH;
        
    }
    else
    {
        wide=SCREEN_WIDTH;
        high=SCREEN_HEIGHT;
        
    }
    
    UIView *GuideView = [[UIView alloc]init];
    GuideView.frame = CGRectMake(0, 0, wide, high);
    GuideView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:GuideView];
    
    
    NSArray *arr=[NSArray arrayWithObjects:@"userpad1",@"userpad2",@"userpad3",@"userpad4", nil];
    //数组内存放的是我要显示的假引导页面图片
    UIScrollView *scrollView=[[UIScrollView alloc] initWithFrame:self.view.bounds];
    scrollView.contentSize=CGSizeMake(wide*arr.count, 0);
    scrollView.pagingEnabled=YES;
    scrollView.showsVerticalScrollIndicator = NO;
    scrollView.showsHorizontalScrollIndicator = NO;
    
    [GuideView addSubview:scrollView];
    for (int i=0; i<arr.count; i++) {
        UIImageView *img=[[UIImageView alloc] initWithFrame:CGRectMake(i*wide, 0, wide, high)];
        img.image=[UIImage imageNamed:arr[i]];
        [scrollView addSubview:img];
    }
    
    UIButton *useBtn=[[UIButton alloc] init];
    useBtn.frame=CGRectMake(wide*3, 0, wide,high);
    [useBtn setBackgroundColor:[UIColor clearColor]];
    [useBtn addTarget:self action:@selector(useBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [scrollView addSubview:useBtn];
    
}

-(void)useBtnClick:(id)sender
{
    [self dismissViewControllerAnimated:YES completion:nil];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"GuideUI" object:nil];
    
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
