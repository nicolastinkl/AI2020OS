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

@property (strong,nonatomic) NSMutableArray<AIServiceCatalogModel, ConvertOnDemand>* catalog_list;
@property (strong,nonatomic) NSMutableArray<AIServiceModel, ConvertOnDemand>* service_list;

@end
