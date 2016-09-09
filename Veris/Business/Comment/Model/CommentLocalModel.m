//
//  CommentLocalModel.m
//  AIVeris
//
//  Created by admin on 16/9/5.
//  Copyright © 2016年 ___ASIAINFO___. All rights reserved.
//

#import "CommentLocalModel.h"

@implementation ImageInfoModel

- (void)encodeWithCoder:(NSCoder *)aCoder {
    [aCoder encodeObject:_imageId forKey:@"imageId"];
    [aCoder encodeObject:_localUrl forKey:@"url"];
    [aCoder encodeObject:_webUrl forKey:@"webUrl"];
    [aCoder encodeBool:_isSuccessUploaded forKey:@"isSuccessUploaded"];
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
 //   self = [super initWithCoder:aDecoder];
    if (self) {
        _imageId = [aDecoder decodeObjectForKey:@"imageId"];
        _localUrl = [aDecoder decodeObjectForKey:@"url"];
        _webUrl = [aDecoder decodeObjectForKey:@"webUrl"];
        _isSuccessUploaded = [aDecoder decodeBoolForKey:@"isSuccessUploaded"];

    }
    return self;
}

- (instancetype)initWithULR:(NSString *)url {
    self = [super init];
    if (self) {
        self.localUrl = url;
    }
    return self;
}

@end

@implementation ServiceCommentLocalSavedModel

- (void)encodeWithCoder:(NSCoder *)aCoder {
    [aCoder encodeObject:_imageInfos forKey:@"imageInfos"];
    
    if (_text) {
        [aCoder encodeObject:_text forKey:@"text"];
    }
    
    [aCoder encodeObject:_serviceId forKey:@"serviceId"];
}

- (instancetype)init {
    self = [super init];
    if (self) {
        self.imageInfos = [[NSMutableArray<ImageInfoModel, Optional> alloc] init];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
 //   self = [super initWithCoder:aDecoder];
    if (self) {
        _imageInfos = [aDecoder decodeObjectForKey:@"imageInfos"];
        _serviceId = [aDecoder decodeObjectForKey:@"serviceId"];
        _text = [aDecoder decodeObjectForKey:@"text"];
        
    }
    return self;
}

- (id)copyWithZone:(NSZone *)zone {
    ServiceCommentLocalSavedModel *copy = [ServiceCommentLocalSavedModel init];
    copy.imageInfos = _imageInfos;
    copy.serviceId = _serviceId;
    copy.text = _text;
    copy.changed = _changed;
    copy.isAppend = _isAppend;
    return copy;
}

@end
