//
//  ChangeEmailController.h
//  iPadff
//
//  Created by 黄含章 on 15/3/17.
//  Copyright (c) 2015年 LanTaiPro. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol ChangeEmailSuccessDelegate <NSObject>

@optional
-(void)ChangeEmailSuccessWithEmail:(NSString *)newEmail;

@end

@interface ChangeEmailController : UIViewController

@property(nonatomic,assign)BOOL isAdd;

@property(nonatomic,strong)UILabel *newsEmail;

@property(nonatomic,strong)UITextField *newsEmailField;

@property(nonatomic,strong)NSString *oldEmail;

@property(nonatomic,strong)NSString *authCode;

@property(nonatomic,weak)id ChangeEmailSuccessDelegate;
@end
