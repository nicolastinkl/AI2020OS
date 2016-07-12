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

@property (strong, nonatomic) NSString<Optional> * numbers;
@property (strong, nonatomic) NSString<Optional> * desc;

@end


@protocol SingleComment
@end

@interface SingleComment : JSONModel

@property (strong, nonatomic) NSString<Optional> * service_name;
@property (strong, nonatomic) NSString<Optional> * service_icon;
@property (strong, nonatomic) NSArray<StarDesc, Optional> * stars;

@end

@protocol SubServiceComment
@end

@interface SubServiceComment : JSONModel


@property (strong, nonatomic) NSString<Optional> * service_id;
@property (strong, nonatomic) NSString<Optional> * service_name;
@property (strong, nonatomic) NSString<Optional> * service_icon;
@property (strong, nonatomic) NSString<Optional> * stars;
@property (strong, nonatomic) NSString<Optional> * judegment;
@property (strong, nonatomic) NSString<Optional> * image;

@end

@protocol CompondComment
@end

@interface CompondComment : JSONModel

@property (strong, nonatomic) NSString<Optional> * service_name;
@property (strong, nonatomic) NSString<Optional> * service_icon;
@property (strong, nonatomic) NSArray<SubServiceComment, Optional> * sub_services;

@end
