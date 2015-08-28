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
    var  Id: Int?
    var currentTimeStamp: Double?
    var title: String?
    var content: String?
    var type: Int?
    var expend:Int?
    var expendData:NSArray?
    var role:Int?
    
    init() {
        
    }
    
    required init(_ decoder: JSONDecoder) {
        currentTimeStamp = decoder["current_time_stamp"].double
        title = decoder["title"].string
        content = decoder["desc"].string
        type = 0
        expend = 0
        role = decoder["role"].integer
        Id = decoder["expand_type_id"].integer
        expendData = NSArray()
    }
    
}
