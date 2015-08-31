//
//  WKBaseViewController.m
//  WokWok
//
//  Created by 王坜 on 15/8/13.
//  Copyright (c) 2015年 王坜. All rights reserved.
//

#import "WKBaseViewController.h"
#import "GMDCircleLoader.h"

#define kCustomNavigationBarHeight 64

@interface WKBaseViewController ()
{
    UIButton *_backButton;
    GMDCircleLoader *_loader;
    
}

@end


@implementation WKBaseViewController


- (void)viewDidLoad
{
    [super viewDidLoad];
    [self makeBaseProperties];
    [self makeCustomNavigationBar];
    [self addBackButton];
    [self makeContentView];
}

// 修改状态栏的字体为白色
- (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}

// 构造基础属性
- (void)makeBaseProperties
{
    self.view.backgroundColor = [UIColor whiteColor];
    self.customNavigationBarHeight = kCustomNavigationBarHeight;
    self.contentWidth = CGRectGetWidth([UIScreen mainScreen].bounds);
    self.contentHeight = CGRectGetHeight([UIScreen mainScreen].bounds) - kCustomNavigationBarHeight;
    
    
}

#pragma mark - 自定义内容区域

- (void)makeContentView
{
    self.contentView = ({
        self.contentOriginalFrame = CGRectMake(0, self.customNavigationBarHeight, self.contentWidth, self.contentHeight);
        UIScrollView *scrollView = [[UIScrollView alloc] initWithFrame:self.contentOriginalFrame];
        
        scrollView;
    });
}


#pragma mark - 自定义导航栏
- (void)makeCustomNavigationBar
{
    self.customNavigationBar = ({
        UIView *barView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.contentWidth, self.customNavigationBarHeight)];
        
        UIImage *barImage = [UIImage imageNamed:@"NaviBar"];
        UIImageView *barImageView = [[UIImageView alloc] initWithImage:barImage];
        barImageView.frame = CGRectMake(0, 0, CGRectGetWidth(barView.frame), CGRectGetHeight(barView.frame));
        [barView addSubview:barImageView];
        
        
        barView;
    });
    
    [self.view addSubview:self.customNavigationBar];
}

#pragma mark - 隐藏自定义导航栏
- (void)setCustomNavigationBarHidden:(BOOL)hidden
{
    [self.customNavigationBar removeFromSuperview];
    self.customNavigationBar = nil;
    
}


#pragma mark - 返回按钮

- (void)backAction:(UIButton *)backButton
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)addBackButton
{
    _backButton = [AIViews baseButtonWithFrame:CGRectMake(kMargin_15, UtilStatusBarHeight, 80, kNavigationBarHeight) normalTitle:nil];
    UIImage *normalImage =  [UIImage imageNamed:@"Navi_Back_Normal"];
    CGFloat top = (kNavigationBarHeight - normalImage.size.height)/2;
    CGFloat right = (80-normalImage.size.width);
    
    [_backButton setImage:normalImage forState:UIControlStateNormal];
    _backButton.imageEdgeInsets = UIEdgeInsetsMake(top, 0, top, right);
    [_backButton addTarget:self action:@selector(backAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.customNavigationBar addSubview:_backButton];
    
    
    
}


#pragma mark - Member Method

- (void)showLoadingMessage:(NSString *)message
{
    [self dismissLoading];
    _loader = [GMDCircleLoader setOnView:self.tabBarController.view withTitle:message animated:YES];
}

- (void)dismissLoading
{
    [_loader stop];
    UtilRemoveView(_loader);
}


@end
