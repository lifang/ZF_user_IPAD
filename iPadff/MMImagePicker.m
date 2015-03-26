//
//  MMImagePicker.m

//
//  Created by wufei on 15/3/24.
//  Copyright (c) 2015年 LanTaiPro. All rights reserved.
//

#import "MMImagePicker.h"


@interface MMImagePicker()<UIActionSheetDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate,UIPickerViewDataSource,UIPickerViewDelegate,UIPopoverControllerDelegate,UIPopoverPresentationControllerDelegate>

@property(strong,nonatomic) UIDatePicker * datetime_picker;
@property(strong,nonatomic) UIButton * btn_cancle;
@property(strong,nonatomic)  UIButton * btn_confirm;
@property(strong,nonatomic)   UIView * view_head;

@property(nonatomic,strong) UIPopoverController *popViewController;
@property (nonatomic, assign) BOOL alreadyHasImage;

@end

@implementation MMImagePicker

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        [self setBackgroundColor:[[UIColor blackColor] colorWithAlphaComponent:0.6]];
        /*
        _view_head = [[UIView alloc] initWithFrame:CGRectMake(0,frame.size.height-320, ApplicationDelegate.window.frame.size.width,40)];
        [_view_head setBackgroundColor:[UIColor colorWithHexString:@"f2f2f2"]];
        _view_head.layer.borderColor = [UIColor colorWithHexString:LineColor].CGColor;
        _view_head.layer.borderWidth = 1.0f;
        [self addSubview:_view_head];
        _btn_cancle = [[UIButton alloc] initWithFrame:CGRectMake(10,5, 50, 30)];
        [_btn_cancle setBackgroundImage:[BaseApi imageWithColor:[UIColor whiteColor] size:CGSizeMake( _btn_cancle.frame.size.width, _btn_cancle.frame.size.height)] forState:UIControlStateNormal];
        //    [btn_cancle setBackgroundImage:[common imageWithColor:[UIColor ] size:CGRectMake(0, 0, btn_cancle.frame.size.width, btn_cancle.frame.size.height)] forState:UIControlStateHighlighted];
        _btn_cancle.layer.cornerRadius = 5.0f;
        _btn_cancle.layer.borderColor = [UIColor colorWithHexString:MainColor].CGColor;
        _btn_cancle.layer.borderWidth = 1.0f;
        _btn_cancle.clipsToBounds = YES;
        [_btn_cancle setTitle:@"取消" forState:UIControlStateNormal];
        [_btn_cancle setTitle:@"取消" forState:UIControlStateHighlighted];
        [_btn_cancle setTitleColor:[UIColor colorWithHexString:MainColor] forState:UIControlStateNormal];
        _btn_cancle.titleLabel.font = FONT14;
        [_btn_cancle addTarget:self action:@selector(CancleBtnPressed) forControlEvents:UIControlEventTouchUpInside];
        //    [btn_cancle setTitleColor:[UIColor colorWithHexString:MainColor] forState:UIControlStateHighlighted];
        [_view_head addSubview:_btn_cancle];
        
        
        _btn_confirm = [[UIButton alloc] initWithFrame:CGRectMake(ApplicationDelegate.window.frame.size.width-60, 5, 50, 30)];
        [_btn_confirm setBackgroundImage:[BaseApi imageWithColor:[UIColor whiteColor] size:CGSizeMake( _btn_confirm.frame.size.width, _btn_confirm.frame.size.height)] forState:UIControlStateNormal];
        //    [btn_confirm setBackgroundImage:[common imageWithColor:[UIColor whiteColor] size:CGRectMake(0, 0, btn_confirm.frame.size.width, btn_confirm.frame.size.height)] forState:UIControlStateHighlighted];
        _btn_confirm.layer.cornerRadius = 5.0f;
        _btn_confirm.layer.borderColor = [UIColor colorWithHexString:MainColor].CGColor;
        _btn_confirm.layer.borderWidth = 1.0f;
        _btn_confirm.clipsToBounds = YES;
        [_btn_confirm setTitle:@"确定" forState:UIControlStateNormal];
        //    [btn_confirm setTitle:@"确定" forState:UIControlStateHighlighted];
        [_btn_confirm setTitleColor:[UIColor colorWithHexString:MainColor] forState:UIControlStateNormal];
        _btn_confirm.titleLabel.font = FONT14;
        [_btn_confirm addTarget:self action:@selector(ConfirmBtnPressed) forControlEvents:UIControlEventTouchUpInside];
        //    [btn_confirm setTitleColor:[UIColor colorWithHexString:MainColor] forState:UIControlStateHighlighted];
        [_view_head addSubview:_btn_confirm];
        
        _datetime_picker = [[UIDatePicker alloc] initWithFrame:CGRectMake(0,self.frame.size.height-280, ApplicationDelegate.window.frame.size.width, 280)];
        _datetime_picker.datePickerMode = UIDatePickerModeDateAndTime;
        _datetime_picker.minuteInterval = 1;
        [_datetime_picker setBackgroundColor:[UIColor colorWithHexString:@"f2f2f2"]];
        [self addSubview:_datetime_picker];
         */
    }
    return self;
}


-(void) ConfirmBtnPressed
{
    NSDateFormatter *outputFormat = [[NSDateFormatter alloc] init];
    [outputFormat setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSString *localDate = [outputFormat stringFromDate:_datetime_picker.date];//本地时间
    // NSString * timeStamp =[NSString stringWithFormat:@"%f",[_datetime_picker.date timeIntervalSince1970]];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat: @"yyyy-MM-dd HH:mm:ss"];
    NSDate *destDate= [dateFormatter dateFromString:localDate];
    NSTimeInterval time = [destDate timeIntervalSince1970];
    long long dTime = [[NSNumber numberWithDouble:time] longLongValue]; // 将double转为long long型
    NSString *timeStamp = [NSString stringWithFormat:@"%llu",dTime]; // 输出long long型
    
    NSDictionary * dict = @{@"local":localDate,@"timeStamp":timeStamp};
    if (_delegate != nil && [_delegate respondsToSelector:@selector( ConfirmEvent:)]) {
        [_delegate performSelector:@selector( ConfirmEvent:) withObject:dict];
    }
}
-(void)CancleBtnPressed
{
    [_delegate performSelector:@selector(CancleEvent)];
}
-(void) dealloc
{
    _delegate = nil;
}





@end
