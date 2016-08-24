//
//  AISearchServiceModel.m
//  AIVeris
//
//  Created by zx on 8/15/16.
//  Copyright © 2016 ___ASIAINFO___. All rights reserved.
//

#import "AISearchServiceModel.h"

@implementation AISearchServiceModel
+(JSONKeyMapper*)keyMapper
{
    // 这里就采用了KVC的方式来取值...
    return [[JSONKeyMapper alloc] initWithDictionary:@{
                                                       @"id": @"sid"
                                                       
                                                       }];
}
@end
@implementation AISearchFilterModel @end
@implementation AISearchFilterCatalog @end
@implementation AISearchFilterPrice @end
