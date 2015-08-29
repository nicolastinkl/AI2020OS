//
//  AITimeLineModel.swift
//  AI2020OS
//
//  Created by admin on 8/13/15.
//  Copyright (c) 2015 ___ASIAINFO___. All rights reserved.
//

import Foundation
import JSONJoy


struct AITimeLineModelResult: JSONJoy  {
    var service_array: Array<AITimeLineModel>?
    init(_ decoder: JSONDecoder) {
        if let addrs = decoder["data"].array {
            service_array = Array<AITimeLineModel>()
            for addrDecoder in addrs {
                service_array?.append(AITimeLineModel(addrDecoder))
            }
        }
    }
    
}


class AITimeLineModel: JSONJoy {
    
    var order_id:Int?
    var expend:Int?
    var service_name: String?
    var order_create_time: String?
     var expendData:Array<AIOrderTaskListModel>?
    
    init() {
        
    }
    
    required init(_ decoder: JSONDecoder) {
        
        expend = 0
        service_name = decoder["service_name"].string
        order_id = decoder["order_id"].integer
        order_create_time = decoder["order_create_time"].string
        if let addrs = decoder["order_task_list"].array {
            expendData = Array<AIOrderTaskListModel>()
            for addrDecoder in addrs {
                expendData?.append(AIOrderTaskListModel(addrDecoder))
            }
        }
        
    }
    
}

class AIOrderTaskListModel : JSONJoy {
    var title: String?
    var content: String?
    var type: Int?
    var role:Int?
    var currentTimeStamp: Double?
    var expand_type_id:Int?
    init() {
        
    }
    
    required init(_ decoder: JSONDecoder) {
        currentTimeStamp = decoder["current_time_stamp"].double
        title = decoder["title"].string
        content = decoder["desc"].string
        type = 0
        role = decoder["role"].integer
        expand_type_id = decoder["expand_type_id"].integer
        
    }
}
