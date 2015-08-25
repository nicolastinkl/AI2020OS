//
//  OrderDetailModel.h
//  AI2020OS
//
//  Created by 刘先 on 15/8/25.
//  Copyright (c) 2015年 ___ASIAINFO___. All rights reserved.
//

#import "JSONModel.h"

@interface OrderDetailModel : JSONModel

@property (nonatomic, strong) NSString *order_create_time;
@property (nonatomic, strong) NSString *order_id;
@property (nonatomic, strong) NSString *order_number;
@property (nonatomic, strong) NSString *order_price;
@property (nonatomic, assign) NSInteger order_state;
@property (nonatomic, strong) NSString *order_state_name;
@property (nonatomic, strong) NSString *provider_id;
@property (nonatomic, strong) NSString *provider_portrait_url;
@property (nonatomic, strong) NSString *service_id;
@property (nonatomic, strong) NSString *service_name;
@property (nonatomic, strong) NSString *service_time_duration;
@property (nonatomic, strong) NSString *service_type;



@end
