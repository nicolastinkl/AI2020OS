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

@interface AISearchServicesAndCatalogsResultModel : JSONModel

@property (strong,nonatomic) NSArray<AIServiceCatalogModel, ConvertOnDemand>* catalog_list;
@property (strong,nonatomic) NSArray<AIServiceModel, ConvertOnDemand>* service_list;

@property (strong,nonatomic) NSArray<Optional>* catalogArray;
@property (strong,nonatomic) NSArray<Optional>* serviceArray;

- (void) createModelList;
@end

@interface AIQueryHotSearchResponse : JSONModel

@property (strong,nonatomic) NSArray<AIServiceCatalogModel, ConvertOnDemand>* catalog_list;

- (NSArray*) createCatalogList;
@end
