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
        service_id = decoder["service_id"].integer
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
        
        // TEST
//        service_guarantee = "一次性鞋套｜ 进口精油 ｜ 服务满50分钟 ｜ 美女服务员 ｜ 免费自选水果套餐 风味小吃（汤圆，水饺等）+时尚水果+饮料茶水"
//        service_process = "后背 → 后腿 → 胳膊 → 腹部 → 前腿（全程大约70分钟）"
//        service_restraint = "每张糯米券限1人使用，超出收费标准：按当时店内实际价格收取费用或者另购买糯米券 | 免费提供储物柜 | 免费提供洗浴用品 | 本单不适宜皮肤病、高血压等患者使用"
        
    }
}

struct AIServiceDetailParamsModel: JSONJoy  {
    
    var param_type: Int?
    var param_key: String?
    var param_value: Array<AIServiceDetailParamsDetailModel>?
    
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
    
    struct AIServiceDetailParamsDetailModel: JSONJoy  {

        var id: Int?
        var title: String?
        var content: String?
        var memo: String?
        var value: String?
        
        init(_ decoder: JSONDecoder) {
            id = decoder["id"].integer
            title = decoder["title"].string
            content = decoder["content"].string
            memo = decoder["memo"].string
            value = decoder["value"].string
        }
    }
    
}




