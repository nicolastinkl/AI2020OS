//
//  AIServiceListModel.h
//  AI2020OS
//
//  Created by 王坜 on 15/8/28.
//  Copyright (c) 2015年 ___ASIAINFO___. All rights reserved.
//

#import "JSONModel.h"

@protocol AIServiceIntroModel @end

@interface AIServiceIntroModel : JSONModel

@property (nonatomic, strong) NSString *service_id;

@property (nonatomic, strong) NSString *service_intro_url;

@property (nonatomic, strong) NSString *service_intro;

@property (nonatomic, strong) NSString *service_name;

@end


@interface AIServiceListModel : JSONModel


@property (nonatomic, strong) NSArray<AIServiceIntroModel, ConvertOnDemand> *service_list;


+ (NSArray *)modelsFromArray:(NSArray *)array;



@end