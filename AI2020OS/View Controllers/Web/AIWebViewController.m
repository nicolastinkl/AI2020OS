//
//  AIWebViewController.m
//  AI2020OS
//
//  Created by 王坜 on 15/8/14.
//  Copyright (c) 2015年 ___ASIAINFO___. All rights reserved.
//

#import "AIWebViewController.h"
#import <AVOSCloud/AVOSCloud.h>
#import "GMDCircleLoader.h"
#import "WKMacroUtils.h"

@interface AICDWebViewController ()
{
    GMDCircleLoader *_loader;
    
    BOOL _isFirstLoaded;
}

@end

@implementation AICDWebViewController


- (id)init
{
    self = [super init];
    if (self) {
        self.shouldShowLoading = YES;
        _isFirstLoaded = YES;
    }
    
    return self;
}

- (void)viewDidLoad
{
    
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.webView.backgroundColor = [UIColor whiteColor];
    self.navigationController.navigationBarHidden = self.shouldHideNavigationBar;
    self.navigationController.interactivePopGestureRecognizer.enabled = YES;
    
    if (self.shouldHideNavigationBar) {
        CGFloat barHeight = [UIApplication sharedApplication].statusBarFrame.size.height;
        
        CGRect webFrame = self.webView.frame;
        webFrame.origin.y = barHeight;
        webFrame.size.height -= barHeight;
        self.webView.frame = webFrame;
    }

    __weak typeof (self) weakSelf = self;
    self.navigationController.interactivePopGestureRecognizer.delegate = weakSelf;
    
    if (self.shouldShowDismissButton) {
        UIBarButtonItem *button = [[UIBarButtonItem alloc] initWithTitle:@"返回" style:UIBarButtonItemStylePlain target:self action:@selector(dismissSelf)];
        self.navigationItem.leftBarButtonItem = button;
    }
    

}


- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    self.webView.delegate = self;
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

- (void)dismissSelf
{
    [self dismissViewControllerAnimated:YES completion:nil];
}


- (void)parsePushNotification:(NSString *)notification
{
    NSArray *array = [notification componentsSeparatedByString:@"&"];
    
    NSString *myName = [array objectAtIndex:0];
    NSString *providerID = [array objectAtIndex:1];
    NSString *url = [array objectAtIndex:2];
    
    
    NSString *message = [NSString stringWithFormat:@"%@ 给你发送了一条消息，请注意查收~", myName?:@""];
    // Create our Installation query
    AVQuery *pushQuery = [AVInstallation query];
    [pushQuery whereKey:@"owner" equalTo:providerID];
    
    // Send push notification to query
    AVPush *push = [[AVPush alloc] init];
    [push setQuery:pushQuery]; // Set our Installation query
    [push setMessage:message];
    [push sendPushInBackground];
    NSDictionary *data = [NSDictionary dictionaryWithObjectsAndKeys:url, @"chatURL",nil];
    [push setData:data];
    [push sendPushInBackground];
    
    
}


- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
{
    BOOL ret = [super webView:webView shouldStartLoadWithRequest:request navigationType:navigationType];
    
    if (self.shouldShowLoading && ret && _isFirstLoaded) {
        [self showLoadingMessage:@"正在加载..."];
        _isFirstLoaded = NO;
    }

    return ret;
}


- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error
{
    NSLog(@"%@", error);
    
    if (self.shouldShowLoading) {
        [self dismissLoading];
    }
    
    [self.navigationController popViewControllerAnimated:YES];
}


- (void)webViewDidStartLoad:(UIWebView *)webView
{
    NSLog(@"webViewDidStartLoad");
}
- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    NSLog(@"webViewDidFinishLoad");
    
    
    [super webViewDidFinishLoad:webView];
    
    if (self.shouldShowLoading) {
        [self dismissLoading];
    }
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
