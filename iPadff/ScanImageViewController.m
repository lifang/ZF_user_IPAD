//
//  ScanImageViewController.m
//  ZFUB
//
//  Created by 徐宝桥 on 15/3/20.
//  Copyright (c) 2015年 ___MyCompanyName___. All rights reserved.
//

#import "ScanImageViewController.h"

@interface ScanImageViewController ()<ImageScrollViewDelegate>

//点击看大图
@property (nonatomic, strong) UIScrollView *imagesScrollView;

@property (nonatomic, strong) UIView *markView;
@property (nonatomic, strong) UIView *scrollPanel;

@end

@implementation ScanImageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self initImageScanView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UI

//查看大图
- (void)initImageScanView {
    CGFloat wide;
    CGFloat height;
    if(iOS7)
    {
        wide=SCREEN_HEIGHT;
        height=SCREEN_WIDTH;
        
        
    }
    else
    {  wide=SCREEN_WIDTH;
        height=SCREEN_HEIGHT;
        
    }
    _scrollPanel = [[UIView alloc] initWithFrame:CGRectMake(0, 0, wide, height)];
    _scrollPanel.backgroundColor = [UIColor clearColor];
    _scrollPanel.alpha = 0;
    [self.view addSubview:_scrollPanel];
    CGRect rect = _scrollPanel.bounds;
    rect.size.height += 64;
    _markView = [[UIView alloc] initWithFrame:rect];
    _markView.backgroundColor = [UIColor blackColor];
    _markView.alpha = 0.0;
    [_scrollPanel addSubview:_markView];
    
    _imagesScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, wide, height)];
    [_scrollPanel addSubview:_imagesScrollView];
    _imagesScrollView.pagingEnabled = YES;
}


#pragma mark - 图片点击

- (void)showDetailImageWithURL:(NSString *)urlString
                     imageRect:(CGRect)rect {
    //urlString = @"http://pic42.nipic.com/20140608/18347945_020920394000_2.jpg";
//    urlString=@"http://g.hiphotos.baidu.com/image/w%3D2048/sign=b7641b0f6509c93d07f209f7ab05f9dc/d50735fae6cd7b89e0226b820d2442a7d9330e60.jpg";
    [self.view bringSubviewToFront:self.scrollPanel];
    self.scrollPanel.alpha = 1.0;
    
    [self.imagesScrollView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:rect];
//    imageView.hidden = YES;
    imageView.contentMode=UIViewContentModeScaleAspectFit;
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
    hud.labelText = @"获取中...";
//    [self.view addSubview:imageView];
    [imageView sd_setImageWithURL:[NSURL URLWithString:urlString] placeholderImage:nil options:SDWebImageProgressiveDownload progress:nil completed:^(UIImage *image,NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
//        CGRect convertRect = [[imageView superview] convertRect:imageView.frame toView:self.view];
//        CGPoint contentOffset = self.imagesScrollView.contentOffset;
           hud.hidden = YES;
        CGFloat wide;
        CGFloat height;
        if(iOS7)
        {
            wide=SCREEN_HEIGHT;
            height=SCREEN_WIDTH;
            
            
        }
        else
        {  wide=SCREEN_WIDTH;
            height=SCREEN_HEIGHT;
            
        }
        
        

        ImageScrollView *imagescroll = [[ImageScrollView alloc] initWithFrame:CGRectMake(0, 0, wide, height)];
        [imagescroll setContentWithFrame:rect];
        
        [imagescroll setImage:imageView.image];
        [self.imagesScrollView addSubview:imagescroll];
        imagescroll.tapDelegate = self;
        [self performSelector:@selector(setOriginFrame:) withObject:imagescroll afterDelay:0.1f];
    }];
}

#pragma mark - 大图

- (void)setOriginFrame:(ImageScrollView *)sender {
    [UIView animateWithDuration:0.4 animations:^{
        self.navigationController.navigationBarHidden = YES;
        [sender setAnimationRect];
        self.markView.alpha = 1.0;
    }];
}

#pragma mark - ImageScrollViewDelegate

- (void)tapImageViewWithObject:(ImageScrollView *)sender {
    [UIView animateWithDuration:0.5 animations:^{
        self.navigationController.navigationBarHidden = NO;
        self.markView.alpha = 0;
        [sender rechangeInitRdct];
    } completion:^(BOOL finished) {
        self.scrollPanel.alpha = 0;
    }];
}
@end
