//
//  AIWorkManageBusiModel.h
//  AIVeris
//
//  Created by 刘先 on 10/9/16.
//  Copyright © 2016 ___ASIAINFO___. All rights reserved.
//

#import "JSONModel.h"
#import "AICommonBusinessModels.h"

//工作机会资质
@protocol AIWorkQualificationBusiModel @end

@interface AIWorkQualificationBusiModel : JSONModel
@property (nonatomic, strong) NSString<Optional> *type_name;
@property (nonatomic, strong) NSNumber<Optional> *type_id;
@property (nonatomic, strong) NSString<Optional> *aspect_type;
@property (nonatomic, strong) NSString<Optional> *aspect_photo;
@property (nonatomic, strong) NSString<Optional> *uploaded;
@property (nonatomic, strong) NSString<Optional> *upload_date;
@end

//工作机会资质列表
@protocol AIWorkQualificationsBusiModel @end

@interface AIWorkQualificationsBusiModel : JSONModel
@property (nonatomic, strong) NSArray<Optional, AIWorkQualificationBusiModel> *work_qualifications;
@end


//工作机会详情
@protocol AIWorkOpportunityBusiModel @end

@interface AIWorkOpportunityBusiModel : JSONModel
@property (nonatomic, strong) NSString<Optional> *work_id;
@property (nonatomic, strong) NSString<Optional> *work_name;
@property (nonatomic, strong) NSString<Optional> *work_desc;
@property (nonatomic, strong) NSString<Optional> *work_thumbnail;
@property (nonatomic, strong) NSString<Optional> *work_img;
@end

// 查询已订阅的工作机会

@protocol AISubscribledJobModel @end

@interface AISubscribledJobModel : JSONModel

/**
 * 订阅时间
 */
@property (nonatomic, strong) NSString<Optional> *subscribed_date;

@property (nonatomic, strong) NSString<Optional> *work_id;

@property (nonatomic, strong) NSString<Optional> *work_state;

/**
 * 服务次数
 */
@property (nonatomic, strong) NSString<Optional> *service_counts;

/**
 * 最近一次下线的时间
 */
@property (nonatomic, strong) NSString<Optional> *offline_date; 


/**
 * 最近一次上线时间
 */
@property (nonatomic, strong) NSString<Optional> *online_date;

@property (nonatomic, strong) NSString<Optional> *work_name;

@property (nonatomic, strong) NSString<Optional> *work_desc;

/**
 * 工作机会缩略图url
 */
@property (nonatomic, strong) NSString<Optional> *work_thumbnail;

/**
 * 工作机会详情图url
 */
@property (nonatomic, strong) NSString<Optional> *work_img;

/**
 * 当前在线人数
 */
@property (nonatomic, strong) NSString<Optional> *online_count;


@end




