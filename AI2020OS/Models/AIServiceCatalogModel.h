//
//  AIServiceCatalogModel.h
//  AI2020OS
//
//  Created by admin on 15/8/24.
//  Copyright (c) 2015年 ___ASIAINFO___. All rights reserved.
//

#import "JSONModel.h"


@protocol AIServiceCatalogModel


@end

@interface AIServiceCatalogModel : JSONModel

@property (assign,nonatomic) int catalog_id;
@property (strong,nonatomic) NSString* catalog_name;
@property (assign,nonatomic) int level;
@property (assign,nonatomic) BOOL has_children;
@property (assign,nonatomic) int parent_id;

@end

@interface AIQueryHotSearchResponse : JSONModel

@property (strong,nonatomic) NSMutableArray<AIServiceCatalogModel, ConvertOnDemand>* catalog_list;

@end

