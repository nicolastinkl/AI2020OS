//
//  AIMessageWrapper.h
//  AITrans
//
//  Created by 王坜 on 15/8/7.
//  Copyright (c) 2015年 __ASIAINFO__. All rights reserved.
//

#import <Foundation/Foundation.h>


@class AIMessage;
@interface AIMessageWrapper : NSObject




+ (NSMutableDictionary *)baseBodyWithData:(NSDictionary *)data;


+ (NSMutableDictionary *)baseBodyWithData:(NSDictionary *)data desc:(NSDictionary *)desc;

+ (NSMutableDictionary *)baseData;

+ (NSMutableDictionary *)baseDesc;


/*说明:获取服务列表
 */
+ (AIMessage *)getServiceListWithTopicID:(NSString *)topicID dataMode:(NSString *)dataMode;




@end
