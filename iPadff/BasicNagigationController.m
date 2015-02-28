//
//  BasicNagigationController.m
//  StuApp
//
//  Created by xieyouwei on 14-8-11.
//  Copyright (c) 2014年 ncsdev. All rights reserved.
//

#import "BasicNagigationController.h"
#import "FontColorAndSize.h"
#define navBtnWidth 27
#define navBtnHeight 27
#define iOS7 ([UIDevice currentDevice].systemVersion.floatValue >= 7.0)
@interface BasicNagigationController ()

@end

@implementation BasicNagigationController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
       
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    //change all navigationbar color
    if (iOS7) {
        [[UINavigationBar appearance] setBarTintColor:[UIColor whiteColor]];
    }
    
    // Do any additional setup after loading the view.
}
// rewrite pushViewController method
- (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated

{
    
    [super pushViewController:viewController animated:animated];
    
    if (viewController.navigationItem.leftBarButtonItem== nil && [self.viewControllers count] > 1) {
        
        viewController.navigationItem.leftBarButtonItem =[self customLeftBackButton];
    }
//        viewController.navigationItem.titleView = [self customTitle:viewController.navigationItem];
}

//-(UIView *)customTitle:(UINavigationItem *)item
//{
//    UILabel *title = [[UILabel alloc] initWithFrame:item.titleView.frame];
//    title.font = [UIFont fontWithName:@"Heiti SC" size:HomeIphoneTiTleLabelSize];
//    title.textColor = HomeIphoneTitleLabelColor;
//    title.backgroundColor = [UIColor clearColor];
//    title.textAlignment = NSTextAlignmentCenter;
//    title.text = self.navigationItem.title;
//    return  title;
//}
-(UIBarButtonItem*)customLeftBackButton{
    
    UIImage *image=[UIImage imageNamed:@"优惠详细_03"];
    
    UIButton *btn=[UIButton buttonWithType:UIButtonTypeCustom];
    
    btn.frame=CGRectMake(0, 0, navBtnWidth, navBtnHeight);
    
    [btn setBackgroundImage:image forState:UIControlStateNormal];
    
    [btn addTarget:self action:@selector(popself) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem *backItem = [[UIBarButtonItem alloc] initWithCustomView:btn];
    
    return backItem;
    
}


-(void)popself

{
    
    [self popViewControllerAnimated:YES];
    
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
