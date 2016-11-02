//
//  CapitalFlowModel.h
//  AIVeris
//
//  Created by Rocky on 2016/11/1.
//  Copyright © 2016年 ___ASIAINFO___. All rights reserved.
//

#import "JSONModel.h"

@protocol CapitalFlowItem
@end

@interface CapitalFlowItem : JSONModel

// 列表项名称
@property (strong, nonatomic) NSString<Optional> * name;
// 帐单ID
@property (strong, nonatomic) NSString<Optional> * bill_id;
// 发生时间
@property (strong, nonatomic) NSNumber<Optional> * time;
// 金额
@property (strong, nonatomic) NSNumber<Optional> * amout;
// 交易类型名称: 信用付款,现金提现,现金退款等
@property (strong, nonatomic) NSString<Optional> * type_name;
// 交易类型: 1表示收入 0表示支出
@property (strong, nonatomic) NSString<Optional> * type;
// 关联类型: Order 表示订单, ZFB 表示是支付宝, WXPAY表示是微信
@property (strong, nonatomic) NSString<Optional> * rela_type;
// 关联ID: 对应于rela_type. Order->OrderId, ZFB->支付宝提现ID, WXPAY->微信提现ID
@property (strong, nonatomic) NSString<Optional> * rela_id;

@end

@protocol CapitalFlowList
@end

@interface CapitalFlowList : JSONModel

@property (strong, nonatomic) NSArray<CapitalFlowItem, Optional> * money_list;

@end
