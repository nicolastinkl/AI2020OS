//
//  AICustomerServiceExecBusiModel.h
//  AIVeris
//
//  Created by 刘先 on 7/26/16.
//  Copyright © 2016 ___ASIAINFO___. All rights reserved.
//

#import "JSONModel.h"
#import "AICommonBusinessModels.h"

#pragma mark - 服务执行详情


@protocol AICustomerOrderBusiModel @end

@interface AICustomerOrderBusiModel : AIOrderInfoBusiModel
@property (nonatomic, strong) NSNumber<Optional> *un_read_messages;
@property (nonatomic, strong) NSNumber<Optional> *un_confirms;
@end

@protocol AICustomerServiceInstBusiModel @end

@interface AICustomerServiceInstBusiModel : JSONModel
@property (nonatomic, strong) AICustomerOrderBusiModel<Optional> *order;
@property (nonatomic, strong) NSArray<AIServiceInstBusiModel, Optional> *sub_services;
@end

#pragma mark - 时间线详情
@protocol AICustomerTimelineBusiModel

@end
@interface AICustomerTimelineBusiModel : JSONModel
@property (nonatomic, strong) NSArray<AITimelineBusiModel, Optional> *procedure_list;
@end