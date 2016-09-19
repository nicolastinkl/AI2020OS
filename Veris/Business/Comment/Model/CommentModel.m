//
//  CommentModel.m
//  AIVeris
//
//  Created by Rocky on 16/7/11.
//  Copyright © 2016年 ___ASIAINFO___. All rights reserved.
//

#import "CommentModel.h"

@implementation StarDesc
@end

@implementation CommentPhoto
@end

@implementation SingleComment

- (id) init
{
    self = [super init];

    if (self) {
        _spec_id = @"2201";
    }

    return self;
}

@end

@implementation ServiceComment
@end

@implementation CompondComment

- (id) init
{
    self = [super init];
    
    if (self) {
        _rating_level = 1;
    }
    
    return self;
}

@end

@implementation RequestResult
@end
