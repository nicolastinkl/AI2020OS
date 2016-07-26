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
@end

/**
 *  价格对象
 */
#pragma mark - 用户信息
@protocol AIPriceBusiModel @end

@interface AIPriceBusiModel : JSONModel
@property (nonatomic, strong) NSNumber<Optional> *unit;
@property (nonatomic, strong) NSNumber<Optional> *billing_mode;
@property (nonatomic, strong) NSString<Optional> *price_show;
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
@end

/**
 *  地址对象
 */
#pragma mark - 地址对象
@protocol AIGPSBusiModel @end

@interface AIGPSBusiModel : JSONModel
@property (nonatomic, strong) NSNumber<Optional> *longtitude;
@property (nonatomic, strong) NSNumber<Optional> *latitude;
@property (nonatomic, strong) NSString<Optional> *loc_type;
@end

#pragma mark - 时间线对象
@protocol AITimelineBusiModel @end

@interface AITimelineBusiModel : JSONModel
@property (nonatomic, strong) NSString<Optional> *type;
@property (nonatomic, strong) NSString<Optional> *id;
@property (nonatomic, strong) NSString<Optional> *sub_service_id;
@property (nonatomic, strong) NSNumber<Optional> *timestamp;
@property (nonatomic, assign) AIGPSBusiModel<Optional> *map;
@end

/**
 *  时间线内容对象
 */
#pragma mark - 时间线内容对象
@protocol AITimelineContentBusiModel @end

@interface AITimelineContentBusiModel : JSONModel
@property (nonatomic, strong) NSString<Optional> *type;
@property (nonatomic, strong) NSString<Optional> *url;
@property (nonatomic, assign) AIGPSBusiModel<Optional> *map;
@end


/**
 *  服务规格信息
 */
#pragma mark - 服务规格信息
@protocol AIServiceInfoBusiModel @end

@interface AIServiceInfoBusiModel : JSONModel
@property (nonatomic, strong) NSString<Optional> *service_catalog;
@property (nonatomic, strong) NSString<Optional> *service_progress;
@property (nonatomic, strong) NSNumber<Optional> *service_id;
@property (nonatomic, strong) NSString<Optional> *service_price;
@property (nonatomic, strong) NSString<Optional> *service_thumbnail_icon;
@property (nonatomic, strong) NSString<Optional> *service_intro;
@end

/**
 *  服务实例信息
 */
#pragma mark - 服务实例信息
@protocol AIServiceInstBusiModel @end

@interface AIServiceInstBusiModel : JSONModel
@property (nonatomic, strong) NSNumber<Optional> *service_progress;
@property (nonatomic, strong) NSString<Optional> *service_catalog;
@property (nonatomic, strong) NSNumber<Optional> *service_id;
@property (nonatomic, strong) NSString<Optional> *service_price;
@property (nonatomic, strong) NSString<Optional> *service_thumbnail_icon;
@property (nonatomic, strong) NSString<Optional> *service_intro;
@end

