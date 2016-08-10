//
//  CommentModel.h
//  AIVeris
//
//  Created by Rocky on 16/7/11.
//  Copyright © 2016年 ___ASIAINFO___. All rights reserved.
//

#import "JSONModel.h"
#import "CommentModel.h"

@protocol StarDesc
@end

@interface StarDesc : JSONModel

@property (strong, nonatomic) NSString<Optional> * id;
@property (strong, nonatomic) NSString<Optional> * name;
@property (strong, nonatomic) NSString<Optional> * value_max;
@property (strong, nonatomic) NSString<Optional> * value_min;

@end


@protocol SingleComment
@end



@protocol CommentPhoto
@end

@interface CommentPhoto : JSONModel

@property (strong, nonatomic) NSString<Optional> * url;

@end

@protocol ServiceComment
@end

@interface ServiceComment : JSONModel


@property (strong, nonatomic) NSString<Optional> * service_id;
@property (strong, nonatomic) NSString<Optional> * service_name;
@property (strong, nonatomic) NSString<Optional> * spec_id;
@property (strong, nonatomic) NSString<Optional> * service_thumbnail_url;
@property (strong, nonatomic) NSString<Optional> * grade_value;
@property (strong, nonatomic) NSNumber<Optional> * createDate;
@property (strong, nonatomic) NSArray<SingleComment, Optional> * comments;

@end

@protocol CompondComment
@end

@interface CompondComment : JSONModel

@property (strong, nonatomic) NSString<Optional> * service_id;
@property (strong, nonatomic) NSString<Optional> * service_name;
@property (strong, nonatomic) NSString<Optional> * spec_id;
@property (strong, nonatomic) NSString<Optional> * service_thumbnail_url;
@property (strong, nonatomic) NSString<Optional> * grade_value;
@property (strong, nonatomic) NSNumber<Optional> * createDate;
@property (strong, nonatomic) NSArray<SingleComment, Optional> * comments;
@property (strong, nonatomic) NSArray<ServiceComment, Optional> * sub_service_list;

@end

@interface SingleComment : JSONModel

@property (strong, nonatomic) NSString<Optional> * text;
@property (strong, nonatomic) NSArray<CommentPhoto, Optional> * photos;

@end


@protocol RequestResult
@end

@interface RequestResult : JSONModel

@property (nonatomic, assign) BOOL result;

@end
