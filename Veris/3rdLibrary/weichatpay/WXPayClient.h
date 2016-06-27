//
//  WXPayClient.h
//  WechatPayDemo
//
//  Created by Alvin on 3/22/14.
//  Copyright (c) 2014 Alvin. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "WXApi.h"
#import "JSONModel.h"
#import "Constant.h"


/*!
 *  支付类型
 order_type: 业务类型 1 => 充值, 2 => 快件超期支付
 for_id:业务ID
 pay_type: 支付类型，1 => 余额， 2 => 支付宝， 3 => 微信
 fee:金额  分为单位
 */
@interface MDPayTypeModel : JSONModel

@property (nonatomic, assign) NSInteger             order_type;
@property (nonatomic, strong) NSString<Optional>    *for_id;
@property (nonatomic, assign) NSInteger             pay_type;
@property (nonatomic, assign) double                fee;
@property (nonatomic, strong) NSString<Optional>    *sign_str;

@end

@interface WXPayClient : NSObject

+ (instancetype)shareInstance;

- (void)payProduct:(MDPayTypeModel * ) model withNotify:(NSString *) notify;

@end
