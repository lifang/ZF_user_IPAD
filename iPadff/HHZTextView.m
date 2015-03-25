//
//  HHZTextView.m
//  微博
//
//  Created by Mr.h on 14/12/2.
//  Copyright (c) 2014年 gem. All rights reserved.
//

#import "HHZTextView.h"

@interface HHZTextView() <UITextViewDelegate>

@property(nonatomic,weak)UILabel *placehoderLabel;

@end

@implementation HHZTextView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        //添加一个显示提醒文字的label （占位文字的label）
        UILabel *placehoderLabel = [[UILabel alloc]init];
        placehoderLabel.numberOfLines = 0;
        placehoderLabel.backgroundColor = [UIColor clearColor];
        [self addSubview:placehoderLabel];
        self.placehoderLabel = placehoderLabel;
        
        //设置默认的占位文字颜色
        self.placehoderColor = [UIColor lightGrayColor];
        //设置默认字体
        self.font = [UIFont systemFontOfSize:20];
        
#warning 不要设置自己的代理为自己本身
        //监听内部文字的改变
//        self.delegate = self;
        
        /**
         监听控件的时间
         1.delegate
         2.addTarget：forEvent：需要继承自UIControl
         3.通知
         */
        //当self的文字发生改变，self就会自动发出一个UITextViewTextDidChangeNotification通知
        //一单发出上面的通知，就会调用self的textDidChange方法
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textDidChange) name:UITextViewTextDidChangeNotification object:self];
    }
    return self;
}

-(void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
}

#pragma mark - 监听文字的改变
//当用户通过键盘输入文字的时候调用
-(void)textDidChange
{
//    if (self.text.length == 0) {
//        self.placehoderLabel.hidden = NO;
//    }else{
//        self.placehoderLabel.hidden = YES;
//    }
    self.placehoderLabel.hidden = (self.text.length != 0);
}

#pragma mark - 代理方法
//-(void)textViewDidChange:(UITextView *)textView
//{
//    HHZLog(@"点击了");
//}

#pragma mark - 公共方法

-(void)setText:(NSString *)text
{
    [super setText:text];
    
    [self textDidChange];
}

- (void)setAttributedText:(NSAttributedString *)attributedText
{
    [super setAttributedText:attributedText];
    
    [self textDidChange];
}


-(void)setPlacehoder:(NSString *)placehoder
{
    //如果是copy策略，setter最好这么写
    _placehoder = [placehoder copy];
    
    //设置文字
    self.placehoderLabel.text = placehoder;
    
    //重新计算子控件的frame
    [self setNeedsLayout];
    
}

-(void)setPlacehoderColor:(UIColor *)placehoderColor
{
    _placehoderColor = placehoderColor;
    
    //设置颜色
    self.placehoderLabel.textColor = placehoderColor;
}

-(void)setFont:(UIFont *)font
{
    [super setFont:font];
    self.placehoderLabel.font = font;
    
    //重新计算子控件的frame
    [self setNeedsLayout];
}

-(void)layoutSubviews
{
    [super layoutSubviews];
    
    CGFloat placeY = 8.f;
    CGFloat placeX = 8.f;
    CGFloat placeWidth = self.frame.size.width - 2 * 8.f;
    CGSize maxSize = CGSizeMake(self.placehoderLabel.frame.size.width, MAXFLOAT);
    CGSize placehoderSize = [self.placehoder sizeWithFont:self.placehoderLabel.font constrainedToSize:maxSize];
    self.placehoderLabel.frame = CGRectMake(placeX, placeY, placeWidth, placehoderSize.height);

}



@end
