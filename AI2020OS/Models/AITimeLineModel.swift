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
    var order_create_time: Int?
    var expendData:Array<AIOrderTaskListModel>?
    
    init() {
        
    }
    
    required init(_ decoder: JSONDecoder) {
        
        expend = 0
        service_name = decoder["service_name"].string
        order_id = decoder["order_number"].integer
        order_create_time = decoder["order_create_time"].string?.toInt()
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
    // 节点描述
    var content: String?
    var type: Int?
    // 对某一类型的角色显示 1:消费者 2:提供者 3:两者都显示
    var role:Int?
    // 服务步骤开始时间戳
    var currentTimeStamp: Int?
    // 展开子页面类型id
    var expand_type_id:Int?
    
    var position:Int!
    var currentTime:String!
    var status:Int!
    
    init() {
        
    }
    
    convenience init(position: Int, currentTime: String, label: String,status: Int) {
        self.init()
        self.position = position
        self.currentTime = currentTime
        self.title = label
        self.status = status
    }
    
    required init(_ decoder: JSONDecoder) {
        currentTimeStamp = decoder["current_time_stamp"].integer
        title = decoder["title"].string
        content = decoder["desc"].string
        type = 0
        role = decoder["role"].integer
        expand_type_id = decoder["expand_type_id"].integer
        
    }
    
    struct TaskType {
        static let ROLE_CUSTOMER = 1
        static let ROLE_PROVIDER = 2
        static let ROLE_BOTH = 3
    }
}
