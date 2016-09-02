//
//  AICustomerModel.h
//  AIVeris
//
//  Created by 王坜 on 16/9/1.
//  Copyright © 2016年 ___ASIAINFO___. All rights reserved.
//

#import "JSONModel.h"
#import "AIAddressModel.h"

// 买家

@protocol AICustomerModel
@end

@interface AICustomerModel : JSONModel

@property (nonatomic, assign) NSInteger user_id;               // 用户ID
@property (nonatomic, strong) NSString<Optional> *user_portrait_icon;    // 用户头像
@property (nonatomic, strong) NSString<Optional> *user_name;
@property (nonatomic, strong) NSString<Optional> *user_phone;
@property (nonatomic, strong) AIAddressModel<Optional> *user_address;
@property (nonatomic, strong) NSString<Optional> *user_birthday;

@end
