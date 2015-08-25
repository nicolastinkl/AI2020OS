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


#pragma mark - 设置基础报文格式

+ (NSMutableDictionary *)baseBodyWithData:(NSDictionary *)data
{
    NSMutableDictionary *body = [[NSMutableDictionary alloc] init];
    
    [body setObject:data?:@{} forKey:@"data"];
    
    [body setObject:@{@"data_mode":@"0",@"digest":@""} forKey:@"desc"];
    
    
    return body;
}


+ (NSMutableDictionary *)baseBodyWithData:(NSDictionary *)data desc:(NSDictionary *)desc
{
    NSMutableDictionary *body = [[NSMutableDictionary alloc] init];
    
    [body setObject:data?:@{} forKey:@"data"];
    
    [body setObject:desc?:@{} forKey:@"desc"];
    
    
    return body;
}

+ (NSMutableDictionary *)baseData
{
    return [[NSMutableDictionary alloc] init];
}

+ (NSMutableDictionary *)baseDesc
{
    return [[NSMutableDictionary alloc] init];
}



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
