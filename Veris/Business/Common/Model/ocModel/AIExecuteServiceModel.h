//
//  AIExecuteServiceModel.h
//  AIVeris
//
//  Created by 刘先 on 16/5/18.
//  Copyright © 2016年 ___ASIAINFO___. All rights reserved.
//

#import "JSONModel.h"
#import "AIOrderManagementModels.h"
#import "AICommonBusinessModels.h"

#pragma mark - AIGrabOrderDetailModel 抢单订单详情

@protocol AIGrabOrderParamModel @end

@interface AIGrabOrderParamModel : JSONModel

@property(nonatomic,strong) NSString<Optional> *icon;
@property(nonatomic,strong) NSString<Optional> *content;

@end


@protocol AIGrabOrderDetailModel @end

@interface AIGrabOrderDetailModel : JSONModel

@property(nonatomic,strong) AIServiceSpecBusiModel<Optional> *service;
@property(nonatomic,strong) AICustomer<Optional> *customer;
@property(nonatomic, strong) NSDictionary<Optional> *order;

@end


@protocol AIGrabOrderUserNeedsModel @end

@interface AIGrabOrderUserNeedsModel : JSONModel

@property(nonatomic, strong) NSArray<Optional, AIGrabOrderParamModel> *contents;
@property(nonatomic,strong) NSString<Optional> *desc;

@end

#pragma mark - AIGrabOrderDetailModel 抢单结果模型
@protocol AIGrabOrderResultModel @end

@interface AIGrabOrderResultModel : JSONModel

@property(nonatomic,strong) NSNumber<Optional> *result_code;
//@property(nonatomic,strong) AIGrabOrderUserNeedsModel<Optional> *customer;

@end