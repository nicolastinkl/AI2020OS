//
//  AIWebViewController.m
//  AI2020OS
//
//  Created by 王坜 on 15/8/14.
//  Copyright (c) 2015年 ___ASIAINFO___. All rights reserved.
//

#import "AIWebViewController.h"

@implementation AIWebViewController


- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.webView.backgroundColor = [UIColor whiteColor];
    self.navigationController.navigationBarHidden = self.shouldHideNavigationBar;
    
    self.navigationController.interactivePopGestureRecognizer.enabled = YES;
    __weak typeof (self) weakSelf = self;
    self.navigationController.interactivePopGestureRecognizer.delegate = weakSelf;
}


- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    self.navigationController.navigationBarHidden = self.shouldHideNavigationBar;;
}

/*

#pragma mark - NavigationDelegate

- (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated
{
    // fix 'nested pop animation can result in corrupted navigation bar'
    if ([self respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
        self.interactivePopGestureRecognizer.enabled = NO;
    }
    
    [super pushViewController:viewController animated:animated];
}

[cpp] view plaincopy在CODE上查看代码片派生到我的代码片
- (void)navigationController:(UINavigationController *)navigationController
       didShowViewController:(UIViewController *)viewController
                    animated:(BOOL)animated
{
    if ([navigationController respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
        navigationController.interactivePopGestureRecognizer.enabled = YES;
    }
}
*/

@end
