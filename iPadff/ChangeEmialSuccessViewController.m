//
//  ChangeEmialSuccessViewController.m
//  iPadff
//
//  Created by 黄含章 on 15/3/17.
//  Copyright (c) 2015年 LanTaiPro. All rights reserved.
//

#import "ChangeEmialSuccessViewController.h"

@interface ChangeEmialSuccessViewController ()

@end

@implementation ChangeEmialSuccessViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.title = @"修改邮箱";
    self.navigationController.navigationItem.leftBarButtonItem = nil;
    [self initAndLayoutUI];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)initAndLayoutUI
{
    UIFont *mainFont = [UIFont systemFontOfSize:20];
    CGFloat mainHeight = 30.f;
    UIColor *mainColor = kColor(59, 59, 59, 1.0);
    
    UILabel *label1 = [[UILabel alloc]init];
    label1.textColor = mainColor;
    label1.font = mainFont;
    label1.text = @"请至";
    label1.frame = CGRectMake(SCREEN_WIDTH / 2 - 160, 120, 40, mainHeight);
    if (iOS7) {
        label1.frame = CGRectMake(SCREEN_HEIGHT / 2 - 160, 120, 40, mainHeight);
    }
    [self.view addSubview:label1];
    
    
    UILabel *label2 = [[UILabel alloc]init];
    label2.textColor = [UIColor orangeColor];
    label2.font = mainFont;
    CGSize labelSize = [self labelAutoCalculateRectWith:_email FontSize:20 MaxSize:CGSizeMake(300, mainHeight)];
    label2.text = _email;
    label2.frame = CGRectMake(CGRectGetMaxX(label1.frame), label1.frame.origin.y, labelSize.width, mainHeight);
    [self.view addSubview:label2];
    
    UILabel *label3 = [[UILabel alloc]init];
    label3.textColor = mainColor;
    label3.font = mainFont;
    label3.text = @"获取激活邮件";
    label3.frame = CGRectMake(CGRectGetMaxX(label2.frame), label1.frame.origin.y, 120, mainHeight);
    [self.view addSubview:label3];
    
    UILabel *label4 = [[UILabel alloc]init];
    label4.textColor = mainColor;
    label4.font = mainFont;
    label4.text = @"激活成功后原邮箱号将被更新!";
    label4.frame = CGRectMake(label1.frame.origin.x + 20, CGRectGetMaxY(label1.frame), 300, mainHeight);
    [self.view addSubview:label4];
    
    UIView *line = [[UIView alloc]init];
    line.backgroundColor = kColor(225, 225, 225, 1.0);
    line.frame = CGRectMake(40, CGRectGetMaxY(label4.frame) + 20, SCREEN_WIDTH - 80, 1);
    [self.view addSubview:line];
    
    UIButton *backBtn = [[UIButton alloc]init];
    backBtn.frame = CGRectMake(label4.frame.origin.x + 10, CGRectGetMaxY(line.frame) + 40, label4.frame.size.width - 20, 40);
    [backBtn addTarget:self action:@selector(backClicked) forControlEvents:UIControlEventTouchUpInside];
    [backBtn setBackgroundColor:kColor(254, 79, 29, 1.0)];
    [backBtn setTitle:@"返回" forState:UIControlStateNormal];
    [backBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.view addSubview:backBtn];
    
    

}

-(void)backClicked
{
    [self.navigationController popViewControllerAnimated:YES];
}

//自动更具文字算长度
- (CGSize)labelAutoCalculateRectWith:(NSString*)text FontSize:(CGFloat)fontSize MaxSize:(CGSize)maxSize
{
    NSMutableParagraphStyle* paragraphStyle = [[NSMutableParagraphStyle alloc]init];
    
    paragraphStyle.lineBreakMode=NSLineBreakByWordWrapping;
    
    NSDictionary* attributes =@{NSFontAttributeName:[UIFont systemFontOfSize:fontSize],NSParagraphStyleAttributeName:paragraphStyle.copy};
    
    CGSize labelSize = [text boundingRectWithSize:maxSize options:NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading|NSStringDrawingTruncatesLastVisibleLine attributes:attributes context:nil].size;
    
    labelSize.height=ceil(labelSize.height);
    
    labelSize.width=ceil(labelSize.width);
    
    return labelSize;
    
}

@end
