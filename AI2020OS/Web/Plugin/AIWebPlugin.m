//
//  AIWebPlugin.m
//  AI2020OS
//
//  Created by 王坜 on 15/8/13.
//  Copyright (c) 2015年 ___ASIAINFO___. All rights reserved.
//

#import <AVOSCloud/AVOSCloud.h>
#import "AIWebPlugin.h"
#import "AIServerConfig.h"
#import "AIOGlobalStorage.h"

@implementation AIWebPlugin


- (void)openPage:(CDVInvokedUrlCommand*)command
{
    CDVPluginResult* pluginResult = nil;
    NSDictionary* pageDic = [command.arguments objectAtIndex:0];
    
    if (pageDic != nil) {
        
        //NSString *url = [];
        
        pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsString:@"success"];
    } else {
        pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR];
    }
    
    [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
}



- (void)shelfBackAction:(CDVInvokedUrlCommand*)command
{
    [[AIOGlobalStorage defaultStorage].shelfNavigationController popViewControllerAnimated:YES];
    [AIOGlobalStorage defaultStorage].shelfNavigationController = nil;
}


- (void)pushNotification:(CDVInvokedUrlCommand*)command
{
    NSString *userName = [command.arguments objectAtIndex:0];
    NSString *providerID = [command.arguments objectAtIndex:1];
    NSString *url = [command.arguments objectAtIndex:2];
    
    
    NSString *message = [NSString stringWithFormat:@"%@ 给你发送了一条消息，请注意查收~", userName?:@""];
    // Create our Installation query
    AVQuery *pushQuery = [AVInstallation query];
    [pushQuery whereKey:KAPNS_Owner equalTo:providerID];
    
    // Send push notification to query
    AVPush *push = [[AVPush alloc] init];
    [push setQuery:pushQuery]; // Set our Installation query
    NSDictionary *data = [NSDictionary dictionaryWithObjectsAndKeys:url, kAPNS_ChatURL, message, kAPNS_Alert, message, kAPNS_Message,nil];
    [push setData:data];
    [push sendPushInBackground];
    
    
}


- (void)uploadShelf:(CDVInvokedUrlCommand*)command
{
    CDVPluginResult* pluginResult = nil;
    NSInteger aad = [[NSUserDefaults standardUserDefaults] integerForKey:@"accessUserIDKey"];
    
    if (aad == 0) {
        pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR messageAsString:@"参数获取失败!"];
    }
    else
    {
        NSString *uid = [NSString stringWithFormat:@"%ld", aad];
        pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsString:uid];
    }
    
    [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
}


@end
