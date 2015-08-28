//
//  AICommendModel.swift
//  AI2020OS
//
//  Created by admin on 8/28/15.
//  Copyright (c) 2015 ___ASIAINFO___. All rights reserved.
//

import Foundation

import JSONJoy

class AICommendModel: JSONJoy {
    var createDate: String?
    var tag: String?
    var service_intro: String?
    
    var service_param_list: Array<AIServiceDetailParamsModel>?
    
    init(){
        
    }
    
    required init(_ decoder: JSONDecoder) {
        createDate = decoder["createDate"].string
        tag = decoder["tag"].string
        
        if let addrs = decoder["tagComment"].array {
            service_param_list = Array<AIServiceDetailParamsModel>()
            for addrDecoder in addrs {
                service_param_list?.append(AIServiceDetailParamsModel(addrDecoder))
            }
        }
        
        
    }
}