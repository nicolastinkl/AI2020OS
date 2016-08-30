//
//  AIProviderDetailJSONModel.h
//  AIVeris
//
//  Created by zx on 8/15/16.
//  Copyright © 2016 ___ASIAINFO___. All rights reserved.
//

#import "JSONModel.h"
#import "AISearchServiceModel.h"

@protocol AIProviderDetailJSONModel @end
@interface AIProviderDetailJSONModel : JSONModel
@property (nonatomic, strong) NSString<Optional> *good_rate;
@property (nonatomic, strong) NSString<Optional> *desc;
@property (nonatomic, strong) NSString<Optional> *icon;
@property (nonatomic, strong) NSString<Optional> *name;
@property (nonatomic, strong) NSArray<Optional> *qualification_list;
@property (nonatomic, assign) NSInteger total_serviced;
@property (nonatomic, strong) NSArray<AISearchServiceModel> *service_list;
@end

@protocol AIProductCommentCustomer @end
@interface AIProductCommentCustomer : JSONModel
@property (nonatomic, assign) NSInteger id;
@property (nonatomic, strong) NSString<Optional> *name;
@property (nonatomic, strong) NSString<Optional> *portrait_icon;
@end

@protocol AIProductComment @end
@interface AIProductComment : JSONModel
@property (nonatomic, strong) NSString<Optional> *anonymousFlag;
@property (nonatomic, strong) NSString<Optional> *comment;
@property (nonatomic, strong) AIProductCommentCustomer<Optional> *customer;
@property (nonatomic, assign) NSInteger customer_id;
@property (nonatomic, strong) NSArray<Optional> *photos;
@property (nonatomic, strong) NSString<Optional> *rating_level;
@property (nonatomic, assign) NSInteger replyingCount;
@property (nonatomic, assign) NSInteger replying_count;
@property (nonatomic, assign) NSInteger supportingCount;
@property (nonatomic, assign) NSInteger supporting_count;
@property (nonatomic, assign) NSInteger time;
@end
