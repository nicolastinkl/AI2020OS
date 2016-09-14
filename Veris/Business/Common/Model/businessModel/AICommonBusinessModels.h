//
//  AICommonBusinessModels.h
//  AIVeris
//
//  Created by 刘先 on 7/26/16.
//  Copyright © 2016 ___ASIAINFO___. All rights reserved.
//

#import "JSONModel.h"

#pragma mark - 用户信息
@protocol AIUserInfoBusiModel @end

@interface AIUserInfoBusiModel : JSONModel
@property (nonatomic, strong) NSNumber<Optional> *customer_id;
@property (nonatomic, strong) NSString<Optional> *user_name;
@property (nonatomic, strong) NSString<Optional> *user_phone;
@property (nonatomic, strong) NSNumber<Optional> *user_id;
@property (nonatomic, strong) NSString<Optional> *user_portrait_icon;
@end

/**
 *  价格对象
 */
#pragma mark - 用户信息
@protocol AIPriceBusiModel @end

@interface AIPriceBusiModel : JSONModel
@property (nonatomic, strong) NSString<Optional> *unit;
@property (nonatomic, strong) NSString<Optional> *billing_mode;
@property (nonatomic, strong) NSString<Optional> *price;
@property (nonatomic, strong) NSString<Optional> *price_show;
@end



/**
 *  地址对象
 */
#pragma mark - 地址对象
@protocol AIGPSBusiModel @end

@interface AIGPSBusiModel : JSONModel
@property (nonatomic, strong) NSNumber<Optional> *longitude;
@property (nonatomic, strong) NSNumber<Optional> *latitude;
@property (nonatomic, strong) NSString<Optional> *type;
@end

/**
 *  时间线内容对象
 */
#pragma mark - 时间线内容对象
@protocol AITimelineContentBusiModel @end

@interface AITimelineContentBusiModel : JSONModel
@property (nonatomic, strong) NSString<Optional> *type;
@property (nonatomic, strong) NSString<Optional> *content;
@property (nonatomic, strong) AIGPSBusiModel<Optional> *map;
@end

#pragma mark - 时间线对象
@protocol AITimelineBusiModel @end

@interface AITimelineBusiModel : JSONModel
@property (nonatomic, strong) NSString<Optional> *procedure_inst_id;
@property (nonatomic, strong) NSString<Optional> *procedure_inst_name;
@property (nonatomic, strong) NSString<Optional> *procedure_inst_desc;
@property (nonatomic, strong) NSString<Optional> *status;
@property (nonatomic, strong) NSString<Optional> *service_instance_id;
@property (nonatomic, strong) NSString<Optional> *procedure_inst_type;
@property (nonatomic, strong) NSString<Optional> *procedure_inst_type_value;
@property (nonatomic, strong) NSNumber<Optional> *time_value;
//TODO:评论状态，应该是订单状态，需要修改
@property (nonatomic, strong) NSNumber<Optional> *comment_status;
@property (nonatomic, strong) NSArray<AITimelineContentBusiModel, Optional> *attchments;
@end

/**
 *  服务规格信息
 */
#pragma mark - offering规格信息，需要改成AIOfferingInfoBusiModel
@protocol AIOfferingInfoBusiModel @end

@interface AIOfferingInfoBusiModel : JSONModel
@property (nonatomic, strong) NSString<Optional> *service_catalog;
@property (nonatomic, strong) NSString<Optional> *service_progress;
@property (nonatomic, strong) NSNumber<Optional> *service_id;
@property (nonatomic, strong) NSString<Optional> *service_price;
@property (nonatomic, strong) NSString<Optional> *service_thumbnail_icon;
@property (nonatomic, strong) NSString<Optional> *service_intro;
@end

#pragma mark - 后端的服务模型
@protocol AIServiceSpecBusiModel @end

@interface AIServiceSpecBusiModel : JSONModel
@property (nonatomic, strong) NSNumber<Optional> *service_spec_id;
@property (nonatomic, strong) NSString<Optional> *service_name;
@property (nonatomic, strong) NSString<Optional> *service_thumbnail_icon;
@property (nonatomic, strong) NSString<Optional> *service_intro;
@end

/**
 *  服务实例信息
 */
#pragma mark - 服务实例信息
@protocol AIServiceInstBusiModel @end

@interface AIServiceInstBusiModel : JSONModel
@property (nonatomic, strong) NSNumber<Optional> *progress;
@property (nonatomic, strong) NSString<Optional> *service_catalog;
@property (nonatomic, strong) NSString<Optional> *id;
@property (nonatomic, strong) NSString<Optional> *service_price;
@property (nonatomic, strong) NSString<Optional> *icon;
@property (nonatomic, strong) NSString<Optional> *name;
@property (nonatomic, strong) NSString<Optional> *service_intro;

@end

/**
 *  订单信息
 */
#pragma mark - 订单信息
@protocol AIOrderInfoBusiModel @end

@interface AIOrderInfoBusiModel : JSONModel
@property (nonatomic, strong) NSString<Optional> *order_id;
@property (nonatomic, strong) NSString<Optional> *order_state;
@property (nonatomic, strong) NSString<Optional> *order_create_time;
@property (nonatomic, strong) NSString<Optional> *icon;
@property (nonatomic, strong) NSString<Optional> *name;
@property (nonatomic, strong) NSNumber<Optional> *progress;
@property (nonatomic, strong) NSString<Optional> *prvoider_name;
@property (nonatomic, strong) AIPriceBusiModel<Optional> *price;

@end

