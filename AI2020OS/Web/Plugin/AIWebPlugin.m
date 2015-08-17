//
//  AIWebPlugin.m
//  AI2020OS
//
//  Created by 王坜 on 15/8/13.
//  Copyright (c) 2015年 ___ASIAINFO___. All rights reserved.
//

#import "AIWebPlugin.h"

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

@end
