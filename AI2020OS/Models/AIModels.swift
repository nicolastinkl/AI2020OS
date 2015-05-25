//
//  AIModels.swift
//  AI2020OS
//
//  Created by tinkl on 25/5/15.
//  Copyright (c) 2015 ___ASIAINFO___. All rights reserved.
//

import Foundation

import JSONJoy

struct AIServiceTopicResult: JSONJoy  {
    var service_array: Array<AIServiceTopicListModel>?
    init(_ decoder: JSONDecoder) {
        if let addrs = decoder["results"].array {
            service_array = Array<AIServiceTopicListModel>()
            for addrDecoder in addrs {
                service_array?.append(AIServiceTopicListModel(addrDecoder))
            }
        }
    }
    
}

struct AIServiceTopicListModel: JSONJoy  {
    var result_type: Int?
    var service_array: Array<AIServiceTopicModel>?
    
    init(_ decoder: JSONDecoder) {
        result_type = decoder["result_type"].integer
        if let addrs = decoder["result_items"].array {
            service_array = Array<AIServiceTopicModel>()
            for addrDecoder in addrs {
                service_array?.append(AIServiceTopicModel(addrDecoder))
            }
        }
    }
}

struct AIServiceTopicModel: JSONJoy  {

    var service_id: Int?
    var service_name: String?
    var service_price: String?
    var service_intro: String?
    var provider_id: String?
    var provider_name: String?
    var service_rating: String?
    var provider_portrait_url: String?
    var service_intro_url: String?

    init() {
        
    }
    
    init(_ decoder: JSONDecoder) {
        service_id = decoder["service_id"].integer
        service_name = decoder["service_name"].string
        service_price = decoder["service_price"].string
        service_intro = decoder["service_intro"].string
        provider_id = decoder["provider_id"].string
        provider_name = decoder["provider_name"].string
        service_rating = decoder["service_rating"].string
        provider_portrait_url = decoder["provider_portrait_url"].string
        service_intro_url = decoder["service_intro_url"].string
        
        
    }
}

