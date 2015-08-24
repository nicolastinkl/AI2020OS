//
//  AIServiceCatalogModel.m
//  AI2020OS
//
//  Created by admin on 15/8/24.
//  Copyright (c) 2015年 ___ASIAINFO___. All rights reserved.
//

#import "AIServiceCatalogModel.h"
#import "AINetEngine.h"

@implementation AIServiceCatalogModel



- (void)test
{
    
    AIMessage *message = [AIMessage message];
    
    
    NSDictionary *body = @{
                           @"data":@"data"
                           };
//    NSDictionary *header = @{};
//    
//    
//    [[AINetEngine defaultEngine] configureCommonHeaders:header];
    
    
    [message.body addEntriesFromDictionary:body];
    message.url = @"http://198.168.1.9/server";
    
    [[AINetEngine defaultEngine] postMessage:message success:^(NSDictionary *response) {
        //AIServiceCatalogModel *model = [[AIServiceCatalogModel alloc] initWithDictionary:response error:nil];
        
    } fail:^(AINetError error, NSString *errorDes) {
        
    }];
    
    
}




@end

@implementation AIQueryHotSearchResponse
@end


