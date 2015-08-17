//
//  AIMessageWrapper.m
//  AITrans
//
//  Created by 王坜 on 15/8/7.
//  Copyright (c) 2015年 __ASIAINFO__. All rights reserved.
//

#import "AIMessageWrapper.h"
#import "AIMessage.h"
#import "AIServerConfig.h"


@implementation AIMessageWrapper


#pragma mark - 获取服务列表

+ (AIMessage *)getServiceListWithTopicID:(NSString *)topicID dataMode:(NSString *)dataMode
{
    AIMessage *message = [AIMessage message];
    [message.body setObject:topicID forKey:kKey_TopicID];
    [message.body setObject:dataMode forKey:kKey_DataModel];
    message.url = kURL_GetServiceList;
    
    return message;
}

@end
