//
//  AIPushNotificationHandler.m
//  AI2020OS
//
//  Created by 王坜 on 15/8/29.
//  Copyright (c) 2015年 ___ASIAINFO___. All rights reserved.
//

#import "AIPushNotificationHandler.h"
#import "AIServerConfig.h"
#import "AIWebViewController.h"
#import <UIKit/UIKit.h>
#import <AVOSCloud/AVOSCloud.h>

@interface AIPushNotificationHandler ()

@property (nonatomic, strong) UIAlertView *alertView;

@end

@implementation AIPushNotificationHandler


+ (void)pushRemoteNotification:(NSDictionary *)notification
{
    NSString *pid = [notification objectForKey:kAPNS_ProviderID];
    
    if (pid == nil || pid.length == 0) {
        return;
    }
    
    
    // Create our Installation query
    AVQuery *pushQuery = [AVInstallation query];
    [pushQuery whereKey:KAPNS_Owner equalTo:pid];
    
    // Send push notification to query
    AVPush *push = [[AVPush alloc] init];
    
    // Set our Installation query
    [push setQuery:pushQuery];
    [push setData:notification];
    [push sendPushInBackground];
}




- (id)initWithNotification:(NSDictionary *)notification
{
    self = [super init];
    if (self) {
        self.notification = notification;
    }
    
    return self;
}

- (void)handleNotification
{
    // 不重复弹窗
    if (self.alertView) {
        return;
    }
    
    // 不重复present
    if ([UIApplication sharedApplication].keyWindow.rootViewController.presentedViewController) {
        return;
    }
    
    NSString *message = self.notification[kAPNS_Message]?:@"你收到一条新的消息，是否立即去查看？";
    self.alertView = [[UIAlertView alloc] initWithTitle:@"消息" message:message delegate:self cancelButtonTitle:@"不管了" otherButtonTitles:@"去看看", nil];
    [self.alertView show];
}

- (void)startHandleNotification
{
    
    [self performSelector:@selector(handleNotification) withObject:nil afterDelay:2];
    
    //[self performSelectorOnMainThread:@selector(handleNotification) withObject:nil waitUntilDone:NO];
    
    
    
}


- (void)handlePushNotification:(NSDictionary *)notification
{
    self.notification = notification;
    [self performSelector:@selector(handleNotification) withObject:nil afterDelay:0.5];
}

- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 0) {
        
    }
    else
    {
        NSString *chatURL = self.notification[kAPNS_ChatURL];
        
        if (chatURL) {
            AICDWebViewController *webVC = [[AICDWebViewController alloc] init];
            webVC.startPage = chatURL;
            webVC.shouldShowDismissButton = YES;
            UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:webVC];
            [[UIApplication sharedApplication].keyWindow.rootViewController presentViewController:nav animated:NO completion:nil];
        }
    }
    
    self.alertView = nil;
}


- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    
}


+ (UIViewController *)topViewController
{
    return nil;
}


@end
