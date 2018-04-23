//
//  SREditionFeatures.m
//  SREditionFeaturesDemo
//
//  Created by https://github.com/guowilling on 2017/9/26.
//  Copyright © 2017年 SR. All rights reserved.
//

#import "SREditionFeaturesViewController.h"

@interface SREditionFeaturesViewController () <UIScrollViewDelegate>

@property (nonatomic, strong) UIViewController *rootVC;

@property (nonatomic, strong) NSArray *imageNames;

@property (nonatomic, strong) NSMutableArray<UIImageView *> *imageViews;

@property (nonatomic, strong) UIPageControl *pageControl;

@property (nonatomic, strong) UIButton *skipButton;

@property (nonatomic, copy) void (^completionBlock)(void);

@end

@implementation SREditionFeaturesViewController

- (BOOL)prefersStatusBarHidden {
    return YES;
}

- (NSMutableArray<UIImageView *> *)imageViews {
    if (!_imageViews) {
        _imageViews = [NSMutableArray array];
    }
    return _imageViews;
}

+ (BOOL)sr_shouldShowEditionFeatures {
    NSString *lastVersion = [[NSUserDefaults standardUserDefaults] stringForKey:@"CFBundleShortVersionString"];  // the app version in the sandbox
    NSString *currentVersion = [NSBundle mainBundle].infoDictionary[@"CFBundleShortVersionString"]; // the current app version
    if ([currentVersion isEqualToString:lastVersion]) {
        return NO;
    } else {
        [[NSUserDefaults standardUserDefaults] setObject:currentVersion forKey:@"CFBundleShortVersionString"];
        [[NSUserDefaults standardUserDefaults] synchronize];
        return YES;
    }
}

+ (instancetype)sr_editionFeaturesWithImageNames:(NSArray *)imageNames rootViewController:(UIViewController *)rootVC completion:(void (^)(void))completion {
    return [[self alloc] initWithImageNames:imageNames rootViewController:rootVC completion:completion];
}

- (instancetype)initWithImageNames:(NSArray *)imageNames rootViewController:(UIViewController *)rootVC completion:(void (^)(void))completion {
    if (self = [super init]) {
        self.view.backgroundColor = [UIColor clearColor];
        _imageNames = imageNames;
        _rootVC = rootVC;
        _completionBlock = completion;
        [self setupSubViews];
    }
    return self;
}

- (void)setupSubViews {
    CGFloat imageW = self.view.frame.size.width;
    CGFloat imageH = self.view.frame.size.height;
    
    UIScrollView *scrollView = [[UIScrollView alloc] init];
    scrollView.frame = self.view.bounds;
    scrollView.delegate = self;
    scrollView.pagingEnabled = YES;
    scrollView.showsHorizontalScrollIndicator = NO;
    [self.view addSubview:scrollView];
    
    for (int i = 0; i < self.imageNames.count; i++) {
        UIImageView *imageView = [[UIImageView alloc] init];
        [imageView setFrame:CGRectMake(imageW * i, 0, imageW, imageH)];
        [imageView setImage:[UIImage imageNamed:_imageNames[i]]];
        [scrollView addSubview:imageView];
        [self.imageViews addObject:imageView];
        if (i == self.imageNames.count - 1) {
            UIImageView *imageView = [[UIImageView alloc] init];
            [imageView setFrame:CGRectMake(imageW * (i + 1), 0, imageW, imageH)];
            [imageView setBackgroundColor:[UIColor clearColor]];
            [scrollView addSubview:imageView];
            scrollView.contentSize = CGSizeMake(imageW * (self.imageNames.count + 1), 0);
        }
    }
    
    _pageControl = [[UIPageControl alloc] init];
    _pageControl.frame = CGRectMake(0, imageH * 0.9, imageW, 20);
    _pageControl.hidesForSinglePage = YES;
    _pageControl.numberOfPages = self.imageNames.count;
    _pageControl.currentPageIndicatorTintColor = [UIColor colorWithWhite:1.0 alpha:1.0];
    _pageControl.pageIndicatorTintColor = [UIColor colorWithWhite:1.0 alpha:0.5];
    [self.view addSubview:_pageControl];
    
    [self.view addSubview:({
        CGFloat margin  = 12;
        CGFloat buttonW = 60;
        CGFloat buttonH = buttonW * 0.5;
        _skipButton = [[UIButton alloc] init];
        _skipButton.frame = CGRectMake(self.view.frame.size.width - margin - buttonW, margin, buttonW, buttonH);
        _skipButton.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.5];
        _skipButton.layer.cornerRadius = 15;
        _skipButton.layer.masksToBounds = YES;
        _skipButton.titleLabel.adjustsFontSizeToFitWidth = YES;
        _skipButton.titleLabel.font = [UIFont systemFontOfSize:16];
        _skipButton.hidden = YES;
        [_skipButton setTitle:@"跳过" forState:UIControlStateNormal];
        [_skipButton setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
        [_skipButton addTarget:self action:@selector(skipBtnAction) forControlEvents:UIControlEventTouchUpInside];
        _skipButton;
    })];
}

- (void)switchRootVC {
    [UIView transitionWithView:[UIApplication sharedApplication].keyWindow
                      duration:0.75
                       options:UIViewAnimationOptionTransitionFlipFromLeft
                    animations:^{
                        [UIApplication sharedApplication].keyWindow.rootViewController = self.rootVC;
                    } completion:^(BOOL finished) {
                        if (_completionBlock) {
                            _completionBlock();
                        }
                    }];
}

- (void)skipBtnAction {
    [self switchRootVC];
}

#pragma mark - Setters

- (void)setStartBtnImageName:(NSString *)startBtnImageName {
    UIImageView *imageView = self.imageViews.lastObject;
    imageView.userInteractionEnabled = YES;
    UIButton *switchBtn = [[UIButton alloc] init];
    UIImage *startBtnImage = [UIImage imageNamed:startBtnImageName];
    [switchBtn setBackgroundImage:startBtnImage forState:UIControlStateNormal];
    if (startBtnImage) {
        [switchBtn sizeToFit];
    } else {
        switchBtn.frame = CGRectMake(0, 0, 200, 200);
    }
    switchBtn.center = CGPointMake(self.view.center.x, self.view.frame.size.height * 0.8);
    [switchBtn addTarget:self action:@selector(switchRootVC) forControlEvents:UIControlEventTouchUpInside];
    [imageView addSubview:switchBtn];
}

- (void)setCurrentPageIndicatorTintColor:(UIColor *)currentPageIndicatorTintColor {
    _currentPageIndicatorTintColor = currentPageIndicatorTintColor;
    
    _pageControl.currentPageIndicatorTintColor = currentPageIndicatorTintColor;
}

- (void)setPageIndicatorTintColor:(UIColor *)pageIndicatorTintColor {
    _pageIndicatorTintColor = pageIndicatorTintColor;
    
    _pageControl.pageIndicatorTintColor = pageIndicatorTintColor;
}

- (void)setHidePageControl:(BOOL)hidePageControl {
    _hidePageControl = hidePageControl;
    
    _pageControl.hidden = hidePageControl;
}

- (void)setHideSkipButton:(BOOL)hideSkipButton {
    _hideSkipButton = hideSkipButton;
    
    _skipButton.hidden = hideSkipButton;
}

#pragma mark - UIScrollViewDelegate

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    NSInteger page = scrollView.contentOffset.x / scrollView.bounds.size.width;
    _pageControl.currentPage = page;
    
    if (page == self.imageNames.count) {
        [UIApplication sharedApplication].keyWindow.rootViewController = self.rootVC;
        if (_completionBlock) {
            _completionBlock();
        }
    }
}

@end
