//
//  AIOrderDetailModel.swift
//  AI2020OS
//
//  Created by 郑鸿翔 on 15/5/30.
//  Copyright (c) 2015年 ___ASIAINFO___. All rights reserved.
//

import Foundation
import JSONJoy

// 订单详情数据模型
class OrderDetailModel : JSONModel {
    var order_id : Int?
    var order_number : Int?
    var order_state : Int?
    var order_state_name : String?
    var order_create_time : String?
    var service_id : Int?
    var service_name : String?
    var provider_id : Int?
    var service_type : Int?
    var provider_portrait_url : String?
    var service_time_duration : String?
    var order_price : String?
    var params: Array<ServiceParam>?
}

// 服务参数数据模型
struct ServiceParam {
    var paramKey : Int?
    var paramValue : String?
    var paramName : String?

    init(){
    
    }
    
    init(_ decoder: JSONDecoder) {
        paramKey = decoder["param_key"].integer
        paramValue = decoder["param_value"].string
        paramName = decoder["param_name"].string
    }
}












