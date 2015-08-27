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

// MARK: 首页服务列表
struct AIServiceTopicListModel: JSONJoy  {
    var result_type: Int?
    var service_array: Array<AIServiceTopicModel>?
    
    init(_ decoder: JSONDecoder) {
        result_type = 2 //decoder["result_type"].integer ?? 0
        if let addrs = decoder["result_items"].array {
            service_array = Array<AIServiceTopicModel>()
            for addrDecoder in addrs {
                service_array?.append(AIServiceTopicModel(addrDecoder))
            }
        }
    }
}

// MARK: 首页服务详情
class AIServiceTopicModel: JSONJoy  {

    var service_id: Int?
    var service_name: String?
    var service_price: String?
    var service_intro: String?
    var provider_id: String?
    var provider_name: String?
    var service_rating: String?
    var provider_portrait_url: String?
    var service_intro_url: String?
    var service_thumbnail_url: String?
    var contents = [String]()
    var tags = [String]()
    var isFavor = false

    init() {
        
    }
    
    required init(_ decoder: JSONDecoder) {
        service_id = decoder["service_id"].string?.toInt() ?? 201507271358
        service_name = decoder["service_name"].string
        service_price = decoder["service_price"].string
        service_intro = decoder["service_intro"].string
        provider_id = decoder["provider_id"].string
        provider_name = decoder["provider_name"].string
        service_rating = decoder["service_rating"].string
        provider_portrait_url = decoder["provider_portrait_url"].string
        service_intro_url = decoder["service_intro_url"].string
        service_thumbnail_url = decoder["service_thumbnail_url"].string
        if let tagsArray = decoder["service_tags"].array {
            for dec in tagsArray {
                if let tag = dec["tag_name"].string {
                    tags.append(tag)
                }
            }
        }
    }
}


// MARK: 单个服务详情
struct AIServiceDetailModel: JSONJoy  {
    
    var service_id: Int?
    var service_name: String?
    var service_price: String?
    var service_intro: String?
    var provider_id: String?
    var provider_name: String?
    var service_rating: String?
    var provider_portrait_url: String?
    var service_intro_url: String?
    
    var service_provider: String?
    var service_guarantee: String?  //服务保障
    var service_process: String?    //服务流程
    var service_restraint: String?  //服务约束
    var service_param_list: Array<AIServiceDetailParamsModel>?
    
    init(){
        
    }
    
    init(_ decoder: JSONDecoder) {
        service_id = decoder["service_id"].integer
        service_name = decoder["service_name"].string
        service_price = decoder["service_price"].string
        service_intro = decoder["service_intro"].string
        provider_id = decoder["provider_id"].string
        provider_name = decoder["provider_name"].string
        service_rating = decoder["service_rating"].string
        provider_portrait_url =  decoder["provider_portrait_url"].string
        service_intro_url =  decoder["service_intro_url"].string
        service_provider = decoder["service_provider"].string
        service_guarantee = decoder["service_guarantee"].string
        service_restraint = decoder["service_restraint"].string
        service_process = decoder["service_process"].string
        
        if let addrs = decoder["service_param_list"].array {
            service_param_list = Array<AIServiceDetailParamsModel>()
            for addrDecoder in addrs {
                service_param_list?.append(AIServiceDetailParamsModel(addrDecoder))
            }
        }
         
        
    }
}


struct AIServiceDetailParamsDetailModel: JSONJoy  {
    
    var id: Int?
    var title: String? 
    var content: String?
    var memo: String?
    var value: String?
    init(){
        
    }
    init(_ decoder: JSONDecoder) {
        id = decoder["id"].integer ?? 0
        title = decoder["title"].string ?? ""
        content = decoder["content"].string ?? ""
        memo = decoder["memo"].string ?? ""
        value = decoder["value"].string ?? ""
    }
}

// MARK： 参数列表  
struct AIServiceDetailParamsModel: JSONJoy  {
    
    /*
     * 参数类型, 1-时间，2-int（选择商品数量），3-double, 4-bool(开关)，5-地址 ,6-子服务 , 7-多项单选, 8-多项多选
    */
    var param_type: Int?
    var param_key: String?
    var param_value: Array<AIServiceDetailParamsDetailModel>?
    init(){
        
    }
    init(_ decoder: JSONDecoder) {
        
        param_type = decoder["param_type"].integer
        param_key = decoder["param_key"].string
        
        if let addrs = decoder["param_value"].array {
            param_value = Array<AIServiceDetailParamsDetailModel>()
            for addrDecoder in addrs {
                param_value?.append(AIServiceDetailParamsDetailModel(addrDecoder))
            }
        }
    }
}



