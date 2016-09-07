//
//  AIWishServices.swift
//  AIVeris
//
//  Created by tinkl on 8/9/16.
//  Copyright © 2016 ___ASIAINFO___. All rights reserved.
//

import Foundation

//许愿服务接口实现类
struct AIWishServices {
    
    /// 提交许愿单
    static func requestMakeWishs(typeID: Int, name: String, money: Double, contents: String, complate: ((AnyObject?, String?) -> Void)) {
        let message = AIMessage()
        //获取本地语言类型推算币种类型
        //print(Localize.currentLanguage())
        let body: NSDictionary = ["data":[
            "contents": contents,
            "name":name,
            "type_id":typeID,
            "money_amount":money,
            "money_unit":"￥"
        ], "desc":["data_mode":"0", "digest":""]]
        
        message.body.addEntriesFromDictionary(body as [NSObject: AnyObject])
        message.url = AIApplication.AIApplicationServerURL.makewish.description as String
        
        AINetEngine.defaultEngine().postMessage(message, success: { (response) in
            if let responseJSON: AnyObject = response {                
                complate(JSONDecoder(responseJSON)["proposal_id"].integer, nil)
            } else {
                complate(nil, "data is null")
            }
        }) { (error, des) in
            complate(nil, des)
        }
    }
    
    /// 许愿单Hot查询
    static func requestHotQueryWishs(keyword: String, complate: ((AnyObject?, String?) -> Void)) {
        let message = AIMessage()
        message.url = AIApplication.AIApplicationServerURL.wishhotAndWishrecommand.description as String
        let body: NSDictionary = ["data":["keyword": keyword], "desc":["data_mode":"0", "digest":""]]
        message.body.addEntriesFromDictionary(body as [NSObject: AnyObject])
        AINetEngine.defaultEngine().postMessage(message, success: { (response) in
            if let responseJSON: AnyObject = response {
                let model = AIWishHotModel(JSONDecoder(responseJSON))
                complate(model, nil)
            } else {
                complate(nil, "data is null")
            }
        }) { (error, des) in
            complate(nil, des)
        }
    }
    
    
    /// 许愿纪录
    static func requestListQueryWishs(typeID : Int, complate: ((AnyObject?, String?) -> Void)) {
        let message = AIMessage()
        message.url = AIApplication.AIApplicationServerURL.queryWishRecordList.description as String
        let body: NSDictionary = ["data":["type_id": typeID], "desc":["data_mode":"0", "digest":""]]
        message.body.addEntriesFromDictionary(body as [NSObject: AnyObject])
        AINetEngine.defaultEngine().postMessage(message, success: { (response) in
            if let responseJSON: AnyObject = response {
                //let model = AIWishHotModel(JSONDecoder(responseJSON))
                var contentArray = Array<String>()
                if let dc = JSONDecoder(responseJSON).array {
                    for decode in dc {
                        contentArray.append("\(decode["contents"].string ?? "")")
                    }
                }                
                complate(contentArray, nil)
            } else {
                complate(nil, "data is null")
            }
        }) { (error, des) in
            complate(nil, des)
        }
    }
    
}
