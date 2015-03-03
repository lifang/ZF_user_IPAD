//
//  PollingView.m
//  ZFUB
//
//  Created by 徐宝桥 on 15/1/23.
//  Copyright (c) 2015年 ___MyCompanyName___. All rights reserved.
//

#import "PollingView.h"
#import "UIImageView+WebCache.h"

@implementation PollingView

- (id)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self initAndLayoutUI];
    }
    return self;
}

#pragma mark - UI

- (void)initAndLayoutUI {
    _scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, self.bounds.size.width, self.bounds.size.height)];
    _scrollView.showsHorizontalScrollIndicator = NO;
    _scrollView.showsVerticalScrollIndicator = NO;
    _scrollView.pagingEnabled = YES;
    _scrollView.delegate = self;
    _scrollView.backgroundColor = [UIColor blackColor];
    [self addSubview:_scrollView];
    
    _pageControl = [[UIPageControl alloc] initWithFrame:CGRectMake(0, self.bounds.size.height - 20, self.bounds.size.width, 20)];
    _pageControl.userInteractionEnabled = NO;
    [self addSubview:_pageControl];
}

- (void)downloadImageWithURLs:(NSArray *)urlArray
                       target:(id)target
                       action:(SEL)action {
    NSInteger count = [urlArray count];
    _totalPage = count;
    _pageControl.numberOfPages = _totalPage;
    _scrollView.contentSize = CGSizeMake(self.bounds.size.width * count, self.bounds.size.height);
    
    CGRect rect = self.bounds;
    for (int i = 0; i < count; i++) {
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:rect];
        imageView.tag = i + 1;
        imageView.userInteractionEnabled = YES;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:target action:action];
        [imageView addGestureRecognizer:tap];
        //loading...
        NSString *urlString = [urlArray objectAtIndex:i];
        [imageView sd_setImageWithURL:[NSURL URLWithString:urlString]];
        [self addSubview:imageView];
        rect.origin.x += self.bounds.size.width;
    }
}


#pragma mark - UIScrollView

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if (scrollView == _scrollView) {
        _pageControl.currentPage = scrollView.contentOffset.x / scrollView.frame.size.width;
    }
}

@end
