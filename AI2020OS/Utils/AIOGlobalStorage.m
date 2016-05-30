//
//  AIOGlobalStorage.m
//  AI2020OS
//
//  Created by 王坜 on 15/8/30.
//  Copyright (c) 2015年 ___ASIAINFO___. All rights reserved.
//

#import "AIOGlobalStorage.h"

@implementation AIOGlobalStorage

+ (instancetype)defaultStorage
{
    static AIOGlobalStorage *_oGlobalStorage = nil;
    
    static dispatch_once_t once;
    
    dispatch_once(&once, ^{
        _oGlobalStorage = [[AIOGlobalStorage alloc] init];
    });
    
    return _oGlobalStorage;
    
}

@end
