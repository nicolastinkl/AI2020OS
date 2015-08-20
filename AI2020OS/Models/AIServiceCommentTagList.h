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


@interface AIServiceCommentTagList : JSONModel

@property (strong,nonatomic) NSMutableArray<AIServiceComment, ConvertOnDemand>* service_comment_list;

@end

@implementation AIServiceCommentTagList
@end


@interface AIServiceComment : JSONModel

@property (assign,nonatomic) int service_id;
@property (strong,nonatomic) NSString<Optional>* service_name;
@property (strong,nonatomic) NSString<Optional>* provider_portrait_url;
@property (strong,nonatomic) NSMutableArray<AICommentTag, ConvertOnDemand>* comment_tags;

@end

@implementation AIServiceComment
@end


@interface AICommentTag : JSONModel

@property (strong,nonatomic) NSString* content;

@end

@implementation AICommentTag
@end


/*

 class AIServiceCommentTagList: JSONModel {
 var service_comment_list: NSMutableArray?
 }
 
 class AIServiceComment: JSONModel {
 var service_id : Int?
 var service_name : NSString?
 var provider_portrait_url : NSString?
 var comment_tags : NSMutableArray?
 
 }
 
 class AICommentTag: JSONModel {
 var content : NSString?
 }
 */