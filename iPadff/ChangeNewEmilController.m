//
//  ChangeNewEmilController.m
//  iPadff
//
//  Created by 黄含章 on 15/5/18.
//  Copyright (c) 2015年 LanTaiPro. All rights reserved.
//

#import "ChangeNewEmilController.h"

@interface ChangeNewEmilController ()<UITextFieldDelegate>

@property(nonatomic,strong)UITextField *newsEmailField;

@property(nonatomic,strong)UITextField *oldEmailField;

@property(nonatomic,strong)UITextField *newsAuthCodeField;

@property(nonatomic,strong)UITextField *oldAuthCodeField;

@property(nonatomic,strong)NSString *newsAuthCode;
@property(nonatomic,strong)NSString *oldAuthCode;

@end

@implementation ChangeNewEmilController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self initAndLayoutUI];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)initAndLayoutUI
{
    CGFloat mainWidth = 280.f;
    CGFloat mainHeight = 40.f;
    
    UILabel *oldEmail = [[UILabel alloc]init];
    oldEmail.text = @"原 邮 箱 号";
    [self setLabel:oldEmail withTopView:self.view middleSpace:120.f labelTag:1];
    
    UILabel *oldAuth = [[UILabel alloc]init];
    oldAuth.text = @"验  证  码";
    [self setLabel:oldAuth withTopView:oldEmail middleSpace:30.f labelTag:2];
    
    UILabel *newEmail = [[UILabel alloc]init];
    newEmail.text = @"新 邮 箱 号";
    [self setLabel:newEmail withTopView:oldAuth middleSpace:30.f labelTag:2];
    
    UILabel *newAuth = [[UILabel alloc]init];
    [self setLabel:newAuth withTopView:newEmail middleSpace:30.f labelTag:2];
    
    _oldEmailField = [[UITextField alloc]init];
    _oldEmailField.userInteractionEnabled = NO;
    _oldEmailField.translatesAutoresizingMaskIntoConstraints = NO;
    _oldEmailField.borderStyle = UITextBorderStyleNone;
    _oldEmailField.clearButtonMode = UITextFieldViewModeWhileEditing;
    _oldEmailField.font = [UIFont systemFontOfSize:20];
    _oldEmailField.text = _oldEmail;
    //    _newsPhoneField.placeholder = @"13919022222";
    //    [_oldPhoneField setValue:[UIFont systemFontOfSize:20] forKeyPath:@"_placeholderLabel.font"];
    _oldEmailField.delegate = self;
    _oldEmailField.leftViewMode = UITextFieldViewModeAlways;
    UIView *placeholderV2 = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 15, 10)];
    _oldEmailField.leftView = placeholderV2;
    [self.view addSubview:_oldEmailField];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:_oldEmailField
                                                          attribute:NSLayoutAttributeTop
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:_newsEmailField
                                                          attribute:NSLayoutAttributeBottom
                                                         multiplier:1.0
                                                           constant:20.f]];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:_oldEmailField
                                                          attribute:NSLayoutAttributeLeft
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:oldEmail
                                                          attribute:NSLayoutAttributeLeft
                                                         multiplier:1.0
                                                           constant:120.f]];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:_oldEmailField
                                                          attribute:NSLayoutAttributeWidth
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:nil
                                                          attribute:NSLayoutAttributeNotAnAttribute
                                                         multiplier:1.0
                                                           constant:mainWidth]];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:_oldEmailField
                                                          attribute:NSLayoutAttributeHeight
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:nil
                                                          attribute:NSLayoutAttributeNotAnAttribute
                                                         multiplier:1.0
                                                           constant:mainHeight]];
    
    
}

- (void)setLabel:(UILabel *)label
     withTopView:(UIView *)topView
     middleSpace:(CGFloat)space
        labelTag:(int)LabelTag{
    CGFloat labelHeight = 30.f;
    CGFloat labelWidth = 200.f;
    CGFloat leftSpace = 260.f;
    label.translatesAutoresizingMaskIntoConstraints = NO;
    label.backgroundColor = [UIColor clearColor];
    label.font = [UIFont boldSystemFontOfSize:20.f];
    label.textColor = kColor(38, 38, 38, 1.0);
    [self.view addSubview:label];
    if (LabelTag == 2)
    {
        [self.view addConstraint:[NSLayoutConstraint constraintWithItem:label
                                                              attribute:NSLayoutAttributeTop
                                                              relatedBy:NSLayoutRelationEqual
                                                                 toItem:topView
                                                              attribute:NSLayoutAttributeBottom
                                                             multiplier:1.0
                                                               constant:space]];
    }else{
        [self.view addConstraint:[NSLayoutConstraint constraintWithItem:label
                                                              attribute:NSLayoutAttributeTop
                                                              relatedBy:NSLayoutRelationEqual
                                                                 toItem:topView
                                                              attribute:NSLayoutAttributeTop
                                                             multiplier:1.0
                                                               constant:space]];
    }
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

@end
