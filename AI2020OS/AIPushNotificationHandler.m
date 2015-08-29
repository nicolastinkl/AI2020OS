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

@implementation AIPushNotificationHandler


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
    NSString *message = self.notification[kAPNS_Alert]?:@"你收到一条新的消息，是否立即去查看？";
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"消息" message:message delegate:self cancelButtonTitle:@"不管了" otherButtonTitles:@"去看看", nil];
    [alertView show];
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
}


- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    
}


+ (UIViewController *)topViewController
{
    return nil;
}


@end
