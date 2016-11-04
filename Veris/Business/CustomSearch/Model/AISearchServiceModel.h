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
@property (nonatomic, assign) NSInteger sid;
@property (nonatomic, strong) NSString<Optional> *name;
@property (nonatomic, strong) NSString<Optional> *icon;
@property (nonatomic, strong) NSString<Optional> *desc;
@property (nonatomic, strong) NSString<Optional> *like;
@property (nonatomic, strong) NSString<Optional> *hot;
@property (nonatomic, strong) NSString<Optional> *order_time;
@property (nonatomic, strong) AIPriceBusiModel<Optional> *price;
@property (nonatomic, strong) NSArray<Optional, AISearchServiceModel> *sub_service_list;
@property (nonatomic, strong) NSArray<Optional> *sub_icons;
@end


/**
 *  搜索Filter Price模型
 */
#pragma mark - 搜索Filter Price模型
@protocol AISearchFilterPrice @end
@interface AISearchFilterPrice : JSONModel

@property (nonatomic, strong) NSString<Optional> *max;
@property (nonatomic, strong) NSString<Optional> *min;
@end

/**
 *  搜索Filter Catalog模型
 */
#pragma mark - 搜索Filter Catalog模型
@protocol AISearchFilterCatalog @end
@interface AISearchFilterCatalog : JSONModel
@property (nonatomic, assign) NSInteger id;
@property (nonatomic, strong) NSString *name;
@end

/**
 *  搜索Filter模型
 */
#pragma mark - 搜索Filter模型
@protocol AISearchFilterModel @end

@interface AISearchFilterModel : JSONModel
@property (nonatomic, strong) NSArray<Optional, AISearchFilterCatalog> *catalogs;
@property (nonatomic, strong) NSArray<Optional, AISearchFilterPrice> *prices;
@property (nonatomic, strong) NSString *sort_by;
@property (nonatomic, strong) NSArray<Optional, AISearchServiceModel> *service_list;
@end

#pragma mark - 我的钱包
//2.14.3.	资金帐户列表
@protocol AICapitalAccount @end

@interface AICapitalAccount : JSONModel
@property (nonatomic, strong) NSNumber *id;
@property (nonatomic, strong) NSString *method_name;
@property (nonatomic, strong) NSString *method_spec_code;
@property (nonatomic, strong) NSString *mch_id;
@property (nonatomic, strong) NSString *icon;
@end

//2.14.12.	我的会员卡

@protocol AIMemberCard @end
@interface AIMemberCard : JSONModel
@property (nonatomic, strong) NSString *id;
@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSString *icon;
@end
