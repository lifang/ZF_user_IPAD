//
//  BaseInformationViewController.m
//  iPadff
//
//  Created by 黄含章 on 15/3/13.
//  Copyright (c) 2015年 LanTaiPro. All rights reserved.
//

#import "BaseInformationViewController.h"

@interface BaseInformationViewController ()<UITextFieldDelegate>

@property(nonatomic,strong)UITextField *nameField;

@property(nonatomic,strong)UITextField *locatonField;

@property(nonatomic,strong)UITextField *particularLocatonField;

@property(nonatomic,strong)UITextField *phoneField;

@property(nonatomic,strong)UITextField *emailField;

@end

@implementation BaseInformationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.swithView setSelectedBtnAtIndex:1];
    NSLog(@"当前是~~~~~~~~~~~~%d",self.Index);
    self.view.backgroundColor = kColor(251, 251, 251, 1.0);
    [self initAndLayoutUI];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)initAndLayoutUI
{
    UILabel *nameLabel = [[UILabel alloc]init];
    nameLabel.text = @"姓       名";
    [self setLabel:nameLabel withTopView:self.swithView middleSpace:20 labelTag:1];
    
    UILabel *phoneLabel = [[UILabel alloc]init];
    phoneLabel.text = @"手       机";
    [self setLabel:phoneLabel withTopView:nameLabel middleSpace:12 labelTag:1];
    
    UILabel *emailLabel = [[UILabel alloc]init];
    emailLabel.text = @"邮       箱";
    [self setLabel:emailLabel withTopView:phoneLabel middleSpace:12 labelTag:1];
    
    UILabel *locationLabel = [[UILabel alloc]init];
    locationLabel.text = @"所  在  地";
    [self setLabel:locationLabel withTopView:emailLabel middleSpace:12 labelTag:1];
    
    UILabel *particularLocationLabel = [[UILabel alloc]init];
    particularLocationLabel.text = @"详细地址";
    [self setLabel:particularLocationLabel withTopView:locationLabel middleSpace:12 labelTag:1];
    
    CGFloat btnWidth = 240.f;
    CGFloat btnHeight = 40.f;
    CGFloat leftSpace = 310.f;
    
    _nameField = [[UITextField alloc]init];
    _nameField.translatesAutoresizingMaskIntoConstraints = NO;
    _nameField.borderStyle = UITextBorderStyleLine;
    _nameField.clearButtonMode = UITextFieldViewModeWhileEditing;
    _nameField.placeholder = @"王小小";
    [_nameField setValue:[UIFont systemFontOfSize:20] forKeyPath:@"_placeholderLabel.font"];
    [_nameField setValue:kColor(111, 111, 111, 1.0) forKeyPath:@"_placeholderLabel.color"];
    _nameField.delegate = self;
    _nameField.leftViewMode = UITextFieldViewModeAlways;
    UIView *placeholderV = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 15, 10)];
    _nameField.leftView = placeholderV;
    CALayer *readBtnLayer = [_nameField layer];
    [readBtnLayer setMasksToBounds:YES];
    [readBtnLayer setCornerRadius:2.0];
    [readBtnLayer setBorderWidth:1.0];
    [readBtnLayer setBorderColor:[kColor(163, 163, 163, 1.0) CGColor]];
    [self.view addSubview:_nameField];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:_nameField
                                                          attribute:NSLayoutAttributeTop
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:self.swithView
                                                          attribute:NSLayoutAttributeBottom
                                                         multiplier:1.0
                                                           constant:46.f]];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:_nameField
                                                          attribute:NSLayoutAttributeLeft
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:self.view
                                                          attribute:NSLayoutAttributeLeft
                                                         multiplier:1.0
                                                           constant:leftSpace]];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:_nameField
                                                          attribute:NSLayoutAttributeWidth
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:nil
                                                          attribute:NSLayoutAttributeNotAnAttribute
                                                         multiplier:1.0
                                                           constant:btnWidth]];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:_nameField
                                                          attribute:NSLayoutAttributeHeight
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:nil
                                                          attribute:NSLayoutAttributeNotAnAttribute
                                                         multiplier:1.0
                                                           constant:btnHeight]];
    
    _phoneField = [[UITextField alloc]init];
    _phoneField.translatesAutoresizingMaskIntoConstraints = NO;
    _phoneField.borderStyle = UITextBorderStyleNone;
    _phoneField.clearButtonMode = UITextFieldViewModeWhileEditing;
    _phoneField.placeholder = @"123456789876";
    [_phoneField setValue:[UIFont systemFontOfSize:20] forKeyPath:@"_placeholderLabel.font"];
    [_phoneField setValue:kColor(111, 111, 111, 1.0) forKeyPath:@"_placeholderLabel.color"];
    _phoneField.delegate = self;
    _phoneField.leftViewMode = UITextFieldViewModeAlways;
    UIView *placeholderV1 = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 15, 10)];
    _phoneField.leftView = placeholderV1;
    CALayer *readBtnLayer1 = [_phoneField layer];
    [readBtnLayer1 setMasksToBounds:YES];
    [readBtnLayer1 setCornerRadius:2.0];
    [readBtnLayer1 setBorderWidth:1.0];
    [readBtnLayer1 setBorderColor:[[UIColor clearColor] CGColor]];
    [self.view addSubview:_phoneField];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:_phoneField
                                                          attribute:NSLayoutAttributeTop
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:_nameField
                                                          attribute:NSLayoutAttributeBottom
                                                         multiplier:1.0
                                                           constant:18.f]];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:_phoneField
                                                          attribute:NSLayoutAttributeLeft
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:self.view
                                                          attribute:NSLayoutAttributeLeft
                                                         multiplier:1.0
                                                           constant:leftSpace]];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:_phoneField
                                                          attribute:NSLayoutAttributeWidth
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:nil
                                                          attribute:NSLayoutAttributeNotAnAttribute
                                                         multiplier:1.0
                                                           constant:btnWidth - 40.f]];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:_phoneField
                                                          attribute:NSLayoutAttributeHeight
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:nil
                                                          attribute:NSLayoutAttributeNotAnAttribute
                                                         multiplier:1.0
                                                           constant:btnHeight]];


    
    
}

- (void)setLabel:(UILabel *)label
     withTopView:(UIView *)topView
     middleSpace:(CGFloat)space
        labelTag:(int)LabelTag{
    CGFloat labelHeight = 30.f;
    CGFloat labelWidth = 100.f;
    CGFloat leftSpace = 200.f;
    label.translatesAutoresizingMaskIntoConstraints = NO;
    label.backgroundColor = [UIColor clearColor];
    label.font = [UIFont boldSystemFontOfSize:22.f];
    label.textColor = kColor(38, 38, 38, 1.0);
    [self.view addSubview:label];
    if (LabelTag == 1) {
        [self.view addConstraint:[NSLayoutConstraint constraintWithItem:label
                                                              attribute:NSLayoutAttributeTop
                                                              relatedBy:NSLayoutRelationEqual
                                                                 toItem:topView
                                                              attribute:NSLayoutAttributeBottom
                                                             multiplier:1.0
                                                               constant:space * 2.5]];
        [self.view addConstraint:[NSLayoutConstraint constraintWithItem:label
                                                              attribute:NSLayoutAttributeLeft
                                                              relatedBy:NSLayoutRelationEqual
                                                                 toItem:self.view
                                                              attribute:NSLayoutAttributeLeft
                                                             multiplier:1.0
                                                               constant:leftSpace]];
        [self.view addConstraint:[NSLayoutConstraint constraintWithItem:label
                                                              attribute:NSLayoutAttributeWidth
                                                              relatedBy:NSLayoutRelationEqual
                                                                 toItem:nil
                                                              attribute:NSLayoutAttributeNotAnAttribute
                                                             multiplier:1.0
                                                               constant:labelWidth]];
        [self.view addConstraint:[NSLayoutConstraint constraintWithItem:label
                                                              attribute:NSLayoutAttributeHeight
                                                              relatedBy:NSLayoutRelationEqual
                                                                 toItem:nil
                                                              attribute:NSLayoutAttributeNotAnAttribute
                                                             multiplier:1.0
                                                               constant:labelHeight]];
        
    }
}



@end
