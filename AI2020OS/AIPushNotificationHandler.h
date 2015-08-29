//
//  AIPushNotificationHandler.h
//  AI2020OS
//
//  Created by 王坜 on 15/8/29.
//  Copyright (c) 2015年 ___ASIAINFO___. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface AIPushNotificationHandler : NSObject<UIAlertViewDelegate>

@property (nonatomic, strong) NSDictionary *notification;


- (id)initWithNotification:(NSDictionary *)notification;


- (void)startHandleNotification;

- (void)handlePushNotification:(NSDictionary *)notification;

@end
