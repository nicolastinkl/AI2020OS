//
//  AIServiceCommentTagList.h
//  AI2020OS
//  服务评价标签列表数据模型
//  Created by Rocky on 15/8/20.
//  Copyright (c) 2015年 ___ASIAINFO___. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "JSONModel.h"


@protocol AICommentTag
@end

@protocol AIServiceComment
@end

// 服务评价列表数据模型
@interface AIServiceCommentListModel : JSONModel

@property (strong,nonatomic) NSMutableArray<AIServiceComment, ConvertOnDemand>* service_comment_list;

@end

@implementation AIServiceCommentListModel
@end

// 服务评价数据模型
@interface AIServiceComment : JSONModel

@property (assign,nonatomic) int service_id;
@property (strong,nonatomic) NSString<Optional>* service_name;
// 服务提供者头像url
@property (strong,nonatomic) NSString<Optional>* provider_portrait_url;
// 评级百分数
@property (assign,nonatomic) float ratingPercent;
// 小费
@property (assign,nonatomic) int tips;
// 自定义评论
@property (strong,nonatomic) NSString<Optional>* additionalCommentTag;
@property (strong,nonatomic) NSMutableArray<AICommentTag, ConvertOnDemand>* comment_tags;

@end

@implementation AIServiceComment
@end

// 评论标签数据模型
@interface AICommentTag : JSONModel

@property (strong,nonatomic) NSString* content;

@end

@implementation AICommentTag
@end



