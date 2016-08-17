//
//  AISearchServiceModel.h
//  AIVeris
//
//  Created by zx on 8/15/16.
//  Copyright © 2016 ___ASIAINFO___. All rights reserved.
//

#import "JSONModel.h"
#import "AICommonBusinessModels.h"

/**
 *  搜索服务模型
 */
#pragma mark - 搜索服务模型
@protocol AISearchServiceModel @end

@interface AISearchServiceModel : JSONModel
@property (nonatomic, assign) NSInteger id;
@property (nonatomic, strong) NSString<Optional> *name;
@property (nonatomic, strong) NSString<Optional> *icon;
@property (nonatomic, strong) NSString<Optional> *desc;
@property (nonatomic, strong) NSString<Optional> *order_time;
@property (nonatomic, strong) AIPriceBusiModel<Optional> *price;
@property (nonatomic, strong) NSArray<Optional, AISearchServiceModel> *sub_service_list;
@property (nonatomic, strong) NSArray<Optional> *sub_icons;
@end
