//
//  AIQiangDanResultModel.h
//  AIVeris
//
//  Created by 王坜 on 16/9/1.
//  Copyright © 2016年 ___ASIAINFO___. All rights reserved.
//

#import "JSONModel.h"
#import "AICustomerModel.h"

@protocol AIQiangDanServiceParamModel @end

@interface AIQiangDanServiceParamModel : JSONModel
@property (nonatomic, strong) NSString<Optional> *param_id;
@property (nonatomic, strong) NSString<Optional> *param_name;
@property (nonatomic, strong) NSString<Optional> *param_value;
@property (nonatomic, strong) NSString<Optional> *param_icon;
@end

@protocol AIQiangDanServiceDetailModel
@end

@interface AIQiangDanServiceDetailModel : JSONModel

@property (nonatomic, strong) NSString<Optional> *service_desc;
@property (nonatomic, strong) NSArray<AIQiangDanServiceParamModel, Optional> *service_param_list;
@end


@protocol AIQiangDanResultModel
@end

@interface AIQiangDanResultModel : JSONModel

@property (nonatomic, strong) AIQiangDanServiceDetailModel<Optional> *service_process;

@property (nonatomic, strong) AICustomerModel<Optional> *customer;

@end
