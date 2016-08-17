//
//  AIProviderDetailJSONModel.h
//  AIVeris
//
//  Created by zx on 8/15/16.
//  Copyright © 2016 ___ASIAINFO___. All rights reserved.
//

#import "JSONModel.h"
#import "AISearchServiceModel.h"

@interface AIProviderDetailJSONModel : JSONModel
@property (nonatomic, strong) NSString<Optional> *good_rate;
@property (nonatomic, strong) NSString<Optional> *icon;
@property (nonatomic, strong) NSString<Optional> *name;
@property (nonatomic, strong) NSArray<Optional> *qualification_list;
@property (nonatomic, assign) NSInteger total_serviced;
@property (nonatomic, strong) NSArray<AISearchServiceModel> *service_list;
@end
