//
//  AIWebPlugin.h
//  AI2020OS
//
//  Created by 王坜 on 15/8/13.
//  Copyright (c) 2015年 ___ASIAINFO___. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CDVPlugin.h"

@interface AIWebPlugin : CDVPlugin


- (void)openPage:(CDVInvokedUrlCommand*)command;


- (void)backAction:(CDVInvokedUrlCommand*)command;


- (void)pushNotification:(CDVInvokedUrlCommand*)command;

@end
