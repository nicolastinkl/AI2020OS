//
//  AISearchModel.h
//  AI2020OS
//
//  Created by admin on 15/8/26.
//  Copyright (c) 2015年 ___ASIAINFO___. All rights reserved.
//

#import "JSONModel.h"
#import "AIServiceCatalogModel.h"
#import "AIServiceModel.h"

@protocol AISearchResultItem

@end

@interface AISearchServicesAndCatalogsResultModel : JSONModel

@property (strong,nonatomic) NSArray<AIServiceCatalogModel, ConvertOnDemand>* catalog_list;
@property (strong,nonatomic) NSArray<AIServiceModel, ConvertOnDemand>* service_list;

@property (strong,nonatomic) NSArray<Optional>* catalogArray;
@property (strong,nonatomic) NSArray<Optional>* serviceArray;

- (void) createModelList;
@end

@interface AIQueryHotSearchResponse : JSONModel

@property (strong,nonatomic) NSArray<AIServiceCatalogModel, ConvertOnDemand, Optional>* catalog_list;
@property (strong,nonatomic) NSArray<AISearchResultItem, ConvertOnDemand, Optional>* search_list;

- (NSArray*) createCatalogList;
- (NSArray*) createSearchList;
@end



@interface AISearchResultItem : JSONModel
@property (strong,nonatomic) NSString<Optional>* name;
@end
