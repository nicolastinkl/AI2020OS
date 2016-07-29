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
@interface AICustomerServiceInstBusiModel : AIOrderInfoBusiModel
@property (nonatomic, strong) NSNumber<Optional> *un_read_messages;
@property (nonatomic, strong) NSNumber<Optional> *un_confirms;
@property (nonatomic, strong) NSArray<AIServiceInstBusiModel, Optional> *sub_service;
@end

#pragma mark - 时间线详情
@interface AICustomerTimelineBusiModel : AIOrderInfoBusiModel
@property (nonatomic, strong) NSArray<AITimelineBusiModel, Optional> *procedure_list;
@end