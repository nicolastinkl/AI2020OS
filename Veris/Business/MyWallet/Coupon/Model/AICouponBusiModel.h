//
//  AICouponBusiModel.h
//  AIVeris
//
//  Created by 刘先 on 16/10/31.
//  Copyright © 2016年 ___ASIAINFO___. All rights reserved.
//

#import "JSONModel.h"

//优惠券 voucher:coupon
@protocol AIVoucherBusiModel @end

@interface AIVoucherBusiModel : JSONModel
@property (nonatomic, strong) NSString<Optional> *id;
@property (nonatomic, strong) NSString<Optional> *icon;
@property (nonatomic, strong) NSString<Optional> *type;
@property (nonatomic, strong) NSString<Optional> *name;
@property (nonatomic, strong) NSString<Optional> *amount;
@property (nonatomic, strong) NSString<Optional> *unit;
@property (nonatomic, strong) NSString<Optional> *expire_time;
@end

//商家币 coins: business currency
@protocol AICoinBusiModel @end

@interface AICoinBusiModel : JSONModel
@property (nonatomic, strong) NSString<Optional> *id;
@property (nonatomic, strong) NSString<Optional> *name;
@property (nonatomic, strong) NSString<Optional> *amount;
@property (nonatomic, strong) NSString<Optional> *unit;
@end
