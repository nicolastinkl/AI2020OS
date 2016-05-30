//
//  AISearchModel.m
//  AI2020OS
//
//  Created by admin on 15/8/26.
//  Copyright (c) 2015年 ___ASIAINFO___. All rights reserved.
//

#import "AISearchModel.h"

@implementation AISearchServicesAndCatalogsResultModel

- (void) createModelList
{
    
    if (self.catalog_list != nil && self.catalog_list.count > 0) {

        NSMutableArray *list = [[NSMutableArray alloc] init];
        
        for (NSInteger i = 0; i < self.catalog_list.count; i++) {
            
            AIServiceCatalogModel *model = self.catalog_list[i];
            
            [list addObject:model];
        }
        
        self.catalogArray = [NSArray arrayWithArray:list];
    }
    
    if (self.service_list != nil && self.service_list.count > 0) {
        
        NSMutableArray *list = [[NSMutableArray alloc] init];
        
        for (NSInteger i = 0; i < self.service_list.count; i++) {
            
            AIServiceModel *model = self.service_list[i];
            
            [list addObject:model];
        }
        
        self.serviceArray = [NSArray arrayWithArray:list];
    }


}

@end


@implementation AIQueryHotSearchResponse

- (NSArray*) createCatalogList
{
    NSMutableArray *list = nil;
    
    if (self.catalog_list != nil && self.catalog_list.count > 0) {
        list = [[NSMutableArray alloc] init];
        
        for (NSInteger i = 0; i < self.catalog_list.count; i++) {
            
            AIServiceCatalogModel *model = self.catalog_list[i];
            
            [list addObject:model];
        }
    }
    
    return list;
    
}

- (NSArray*) createSearchList
{
    NSMutableArray *list = nil;
    
    if (self.search_list != nil && self.search_list.count > 0) {
        list = [[NSMutableArray alloc] init];
        
        for (NSInteger i = 0; i < self.search_list.count; i++) {
            
            AISearchResultItem *model = self.search_list[i];
            
            [list addObject:model];
        }
    }
    
    return list;
}

@end

@implementation AISearchResultItem


@end

