//
//  MessageChildViewController.m
//  iPadff
//
//  Created by 黄含章 on 15/3/3.
//  Copyright (c) 2015年 LanTaiPro. All rights reserved.
//

#import "MessageChildViewController.h"

@interface MessageChildViewController ()


@property(nonatomic,strong)UIScrollView *contentView;

@end

@implementation MessageChildViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupNavBar];
    [self initUI];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)initUI
{
    CGFloat topMargin = 16;
    CGFloat leftMargin = 16;
    
    //创建主view
    UIScrollView *contentView = [[UIScrollView alloc]init];
    contentView.frame = self.view.bounds;
    contentView.backgroundColor = [UIColor whiteColor];
    //创建标题Label
    UILabel *topLabel = [[UILabel alloc]init];
    topLabel.textColor = [UIColor blackColor];
    topLabel.backgroundColor = [UIColor clearColor];
    topLabel.font = [UIFont systemFontOfSize:20];
    NSString *topLabelStr = @"市总工会启动2015年工会保障工作重点研讨研讨研讨研讨研讨研讨研讨研讨研讨研讨研讨";
    topLabel.text = topLabelStr;
    CGSize topLabelSize = {0,0};
    topLabelSize = [topLabelStr sizeWithFont:[UIFont systemFontOfSize:20] constrainedToSize:CGSizeMake(200.0, 5000)];
    topLabel.numberOfLines = 0;
    topLabel.frame = CGRectMake(180, 40, SCREEN_WIDTH * 0.6, topLabelSize.height);
    [contentView addSubview:topLabel];
    //创建时间Label
    UILabel *timeLabel = [[UILabel alloc]init];
    NSString *timeStr = @"2014-10-12 10:08";
    timeLabel.text = timeStr;
    timeLabel.font = [UIFont systemFontOfSize:14];
    timeLabel.textColor = kColor(107, 107, 107, 1.0);
    timeLabel.frame = CGRectMake(topLabel.frame.origin.x, CGRectGetMaxY(topLabel.frame) - 10, 140, 20);
    [contentView addSubview:timeLabel];
    //创建分隔线
    UIView *lineView = [[UIView alloc]init];
    lineView.backgroundColor = [UIColor orangeColor];
    lineView.frame = CGRectMake(topLabel.frame.origin.x, CGRectGetMaxY(timeLabel.frame) + 10 , topLabel.frame.size.width, 1);
    [contentView addSubview:lineView];
    //创建正文Label
    UILabel *textLabel = [[UILabel alloc]init];
    textLabel.textColor = kColor(81, 81, 81, 1.0);
    textLabel.font = [UIFont systemFontOfSize:18];
    NSString *contentStr = @"在小组座谈会中，一群相互之间完全陌生的人集中到一起，而且要畅所欲言，是有相当的难度的。首要的就是要建立大家之间的信任感，特别是要建立主持人与参会人员之间的信任感。\n这就要求主持人一定是个有热情的人，是一个让大家一见就感到信赖和亲切的人，是一个有着高度亲和力的人.有亲和力的主持人通过这种友好表示,使得在座的人员合作在一起，有一种合作的意识和趋向意识，和共同作用的力量。\n有亲和力是促成合作的起因，只有具有了合作意向，才会使大家结合在一起共同合作,才能更好的达成会议目标.座谈会要让每个与会者都能真实的表达自己的意思.特别是遇到一些可能触及到个人价值观或判断能力的话题，小组成员往往有顾虑，或者看别人的眼色随波逐流随声附和。\n最好的办法莫过于让大家进入一种忘我的境界,全心全意的投入到讨论当中，这时候的人们更多的是感性的人们，而不是一个说话要斟酌再三的“理性”的人。对于主持人来说，就要很快进入会议主持状态，让小组成员放开思想包袱，在无论对错没有水平高低的担忧下充分讨论。附和。\n最好的办法莫过于让大家进入一种忘我的境界,全心全意的投入到讨论当中，这时候的人们更多的是感性的人们，而不是一个说话要斟酌再三的“理性”的人。对于主持人来说，就要很快进入会议主持状态，让小组成员放开思想包袱，在无论对错没有水平高低的担忧下充分讨论。";
    textLabel.text = contentStr;
    CGSize textLabelSize = {0,0};
    textLabelSize = [contentStr sizeWithFont:[UIFont systemFontOfSize:18] constrainedToSize:CGSizeMake(topLabel.frame.size.width, 5000)];
    textLabel.numberOfLines = 0;
    textLabel.frame = CGRectMake(topLabel.frame.origin.x, CGRectGetMaxY(lineView.frame) + 10 , topLabel.frame.size.width, textLabelSize.height);
    [contentView addSubview:textLabel];
    [self.view addSubview:contentView];
    contentView.contentSize = CGSizeMake(SCREEN_WIDTH, CGRectGetMaxY(textLabel.frame) + 70);
    self.contentView = contentView;


}

-(void)setupNavBar
{
    self.title = @"消息详情";
    self.view.backgroundColor = [UIColor whiteColor];
    
    UIButton *leftBtn = [[UIButton alloc]init];
    [leftBtn addTarget:self action:@selector(backHome) forControlEvents:UIControlEventTouchUpInside];
    leftBtn.frame = CGRectMake(0, 0, 50, 50);
    [leftBtn setImage:[UIImage imageNamed:@"back_btn_white"] forState:UIControlStateNormal];
    UIBarButtonItem *leftBar = [[UIBarButtonItem alloc]initWithCustomView:leftBtn];
    self.navigationItem.leftBarButtonItem = leftBar;
    
    UIButton *rightBtn = [[UIButton alloc]init];
    [rightBtn addTarget:self action:@selector(rightClicked:) forControlEvents:UIControlEventTouchUpInside];
    rightBtn.frame = CGRectMake(0, 0, 50, 50);
    [rightBtn setImage:[UIImage imageNamed:@"laji"] forState:UIControlStateNormal];
    UIBarButtonItem *rightBar = [[UIBarButtonItem alloc]initWithCustomView:rightBtn];
    self.navigationItem.rightBarButtonItem = rightBar;
}

-(void)rightClicked:(id)sender
{
    NSLog(@"点击了垃圾桶！");
}

-(void)backHome
{
    [self.navigationController popViewControllerAnimated:YES];
}

@end
