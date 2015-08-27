//
//  AIServiceModel.h
//  AI2020OS
//
//  Created by admin on 15/8/26.
//  Copyright (c) 2015年 ___ASIAINFO___. All rights reserved.
//

#import "JSONModel.h"

@protocol AIServiceModel



@end

@interface AIServiceModel : JSONModel

@property (assign,nonatomic) int service_id;
@property (strong,nonatomic) NSString* service_name;
@property (strong,nonatomic) NSString<Optional>* service_price;
@property (strong,nonatomic) NSString<Optional>* service_intro_url;

@end
