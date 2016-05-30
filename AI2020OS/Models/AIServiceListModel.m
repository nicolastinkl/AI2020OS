//
//  AIServiceListModel.m
//  AI2020OS
//
//  Created by 王坜 on 15/8/28.
//  Copyright (c) 2015年 ___ASIAINFO___. All rights reserved.
//

#import "AIServiceListModel.h"



@implementation AIServiceIntroModel



@end






@implementation AIServiceListModel

+ (NSArray *)modelsFromArray:(NSArray *)array
{
    NSMutableArray *models = nil;
    
    if (array != nil && array.count > 0) {
        models = [[NSMutableArray alloc] init];
        
        for (NSDictionary *dic in array) {
            AIServiceIntroModel *model = [[AIServiceIntroModel alloc] initWithDictionary:dic error:nil];
            
            [models addObject:model];
        }
        
    }
    
    return models;
}


@end
