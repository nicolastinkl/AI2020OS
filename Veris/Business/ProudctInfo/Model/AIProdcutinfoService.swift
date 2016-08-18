//
//  AIProdcutinfoService.swift
//  AIVeris
//
//  Created by tinkl on 8/3/16.
//  Copyright © 2016 ___ASIAINFO___. All rights reserved.
//

import Foundation


struct AIProdcutinfoService {
    
    /// 请求产品详情数据
    static func requestServiceInfo(serviceId: String, complate: ((AnyObject?, String?) -> Void)) {
        
        let message = AIMessage()
        let userId = NSUserDefaults.standardUserDefaults().objectForKey(kDefault_UserID) as! String
        let body: NSDictionary = ["data": [
            "service_id": serviceId,
            "user_id":userId
            ], "desc": ["data_mode": "0", "digest": ""]]
        message.body.addEntriesFromDictionary(body as [NSObject: AnyObject])
        message.url = AIApplication.AIApplicationServerURL.detail.description as String
        
        AINetEngine.defaultEngine().postMessage(message, success: { (response) in
            if let responseJSON: AnyObject = response {
                let model = AIProdcutinfoModel(JSONDecoder(responseJSON))
                complate(model, nil)
            } else {
                complate(nil, "data is null")
            }
        }) { (error, des) in
            complate(nil, des)
        }
    }

    /// 处理收藏添加
    static func addFavoriteServiceInfo(serviceId: String, complate: ((AnyObject?, String?) -> Void)) {
//        let userId = NSUserDefaults.standardUserDefaults().objectForKey(kDefault_UserID) as! String
        let message = AIMessageWrapper.addFavoriteService(11)
        message.url = AIApplication.AIApplicationServerURL.favoriteadd.description as String
        
        AINetEngine.defaultEngine().postMessage(message, success: { (response) in
            if let responseJSON: AnyObject = response {
                if let d = responseJSON as? NSDictionary {
                    if let i = d["result"] as? Int {
                        if i == 1 {
                            complate("1", nil)
                        }else{
                            complate(nil, "0")
                        }
                    }
                }
                
            } else {
                complate(nil, "data is null")
            }
        }) { (error, des) in
            complate(nil, des)
        }
    }
    
}
