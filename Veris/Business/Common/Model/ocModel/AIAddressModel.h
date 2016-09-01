//
//  AIAddressModel.h
//  AIVeris
//
//  Created by 王坜 on 16/9/1.
//  Copyright © 2016年 ___ASIAINFO___. All rights reserved.
//

#import "JSONModel.h"



/**
 "":"中国四川省",
 "":"四川省成都市高朋大道3号东方希望大厦",
 "":"104.047357",
 "":"30.632648",
 "":"610054"
 */

@protocol AIAddressModel

@end
@interface AIAddressModel : JSONModel

@property (nonatomic, strong) NSString<Optional> *area;
@property (nonatomic, strong) NSString<Optional> *address;
@property (nonatomic, strong) NSString<Optional> *longitude;
@property (nonatomic, strong) NSString<Optional> *latitude;
@property (nonatomic, strong) NSString<Optional> *postcode;


@end
