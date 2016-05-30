//
//  OrderDetailModel.h
//  AI2020OS
//
//  Created by 刘先 on 15/8/25.
//  Copyright (c) 2015年 ___ASIAINFO___. All rights reserved.
//

#import "JSONModel.h"


@protocol OrderSelectedParamModel
@end

@interface OrderSelectedParamModel : JSONModel

@property (nonatomic, strong) NSString<Optional> *param_key;
@property (nonatomic, assign) NSInteger param_id;
@property (nonatomic, strong) NSString<Optional> *param_value;

@end


@interface OrderDetailModel : JSONModel

@property (nonatomic, strong) NSString<Optional> *order_create_time;
@property (nonatomic, strong) NSString<Optional> *order_id;
@property (nonatomic, strong) NSString<Optional> *order_number;
@property (nonatomic, strong) NSString<Optional> *order_price;
@property (nonatomic, assign) NSInteger order_state;
@property (nonatomic, strong) NSString<Optional> *order_state_name;
@property (nonatomic, strong) NSString<Optional> *provider_id;
@property (nonatomic, strong) NSString<Optional> *provider_portrait_url;
@property (nonatomic, strong) NSString<Optional> *service_id;
@property (nonatomic, strong) NSString<Optional> *service_name;
@property (nonatomic, strong) NSString<Optional> *service_time_duration;
@property (nonatomic, strong) NSString<Optional> *service_type;
@property (nonatomic, strong) NSArray<OrderSelectedParamModel, Optional> *char_list;


@end

@interface OrderNumberModel : JSONModel

@property (nonatomic, assign) NSInteger order_state;
@property (nonatomic, assign) NSInteger order_num;

@end

