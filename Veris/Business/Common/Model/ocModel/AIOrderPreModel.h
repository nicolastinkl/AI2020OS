//
//  AIOrderPreModel.h
//  AIVeris
//
//  Created by 王坜 on 15/9/22.
//  Copyright © 2015年 ___ASIAINFO___. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>
#import "JSONModel.h"
#import "AICustomerModel.h"










/**
 
 "": 1,
 "": "",
 "": 1,
 "": "时间",
 "": "09:00,Aug 9th"
 
 */

// 服务参数

@protocol AIServiceParamModel
@end

@interface AIServiceParamModel : JSONModel

@property (nonatomic, assign) NSInteger param_id;

@property (nonatomic, assign) NSInteger param_type;

@property (nonatomic, strong) NSString<Optional> *param_name;

@property (nonatomic, strong) NSString<Optional> *param_value;

@property (nonatomic, strong) NSString<Optional> *param_key;

@end



// 进度

@protocol AIProgressModel

@end

@interface AIProgressModel : JSONModel

@property (nonatomic, assign) CGFloat percentage;

@property (nonatomic, strong) NSString<Optional> *name;

@property (nonatomic, assign) NSInteger operation;

@property (nonatomic, assign) NSInteger status;

@property (nonatomic, strong) NSString<Optional> *icon;

@property (nonatomic, strong) NSArray<AIServiceParamModel, Optional, ConvertOnDemand> *param_list;

@end


// 服务类别


@protocol AIServiceCategoryModel
@end

@interface AIServiceCategoryModel : JSONModel

@property (nonatomic, assign) NSInteger category_id;
@property (nonatomic, strong) NSString<Optional> *category_name;             // 服务的类别名称
@property (nonatomic, strong) NSString<Optional> *category_icon;             // 服务的类别图标

@end







// 订单

@protocol AIServiceModel

@end


@interface AIServiceModel : JSONModel

@property (nonatomic, assign) NSInteger service_id;
@property (nonatomic, strong) NSString<Optional> *service_price;
@property (nonatomic, strong) NSString<Optional> *service_name;
//新增订单执行
@property (nonatomic, assign) NSInteger service_instance_id;
@property (nonatomic, assign) NSInteger service_instance_status;

@property (nonatomic, strong) NSString<Optional> *service_type;


@end




// 服务

@protocol AIOrderPreModel
@end

@interface AIOrderPreModel : JSONModel

@property (nonatomic, assign) NSInteger proposal_id;

@property (nonatomic, assign) NSInteger order_id;

@property (nonatomic, assign) NSInteger order_number;

@property (nonatomic, assign) NSInteger order_state;

@property (nonatomic, strong) NSString *order_sort_time;

@property (nonatomic, strong) NSString *order_create_time;


@property (nonatomic, strong) NSString *proposal_name;


@property (nonatomic, strong) NSString<Optional> *order_state_name;

@property (nonatomic, strong) AICustomerModel<Optional> *customer;

@property (nonatomic, strong) AIServiceModel<Optional> *service;

@property (nonatomic, strong) AIServiceCategoryModel<Optional> *service_category;

@property (nonatomic, strong) AIProgressModel<Optional> *service_progress;   // 服务执行的进度



@end


// 订单列表

@protocol AIOrderPreListModel

@end

@interface AIOrderPreListModel : JSONModel

@property (nonatomic, strong) NSArray<AIOrderPreModel, Optional, ConvertOnDemand> *order_list;

@end


