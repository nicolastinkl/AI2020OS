//
//  CommentLocalModel.h
//  AIVeris
//
//  Created by Rocky on 16/9/5.
//  Copyright © 2016年 ___ASIAINFO___. All rights reserved.
//

#import "JSONModel.h"
#import <UIKit/UIKit.h>

@protocol ImageInfoModel
@end

@protocol ServiceCommentLocalSavedModel
@end

@interface ImageInfoModel: JSONModel <NSCoding>

@property (strong, nonatomic) NSString<Optional> * imageId;
@property (strong, nonatomic) NSString<Optional> * localUrl;
@property (strong, nonatomic) NSString<Optional> * webUrl;
@property (strong, nonatomic) NSString<Optional> * serviceId;
@property (assign, nonatomic) BOOL isSuccessUploaded;
@property (assign, nonatomic) BOOL uploadFinished;
@property (assign, nonatomic) BOOL isCurrentCreate;

@end



@interface ServiceCommentLocalSavedModel: JSONModel <NSCoding, NSCopying>

@property (strong, nonatomic) NSMutableArray<ImageInfoModel, Optional> * imageInfos;
@property (strong, nonatomic) NSString<Optional> * serviceId;
@property (strong, nonatomic) NSString<Optional> * text;
@property (assign, nonatomic) CGFloat starValue;
@property (assign, nonatomic) BOOL changed;
@property (assign, nonatomic) BOOL isAppend;

@end
