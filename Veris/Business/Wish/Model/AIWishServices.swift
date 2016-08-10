//
//  AIWishServices.swift
//  AIVeris
//
//  Created by tinkl on 8/9/16.
//  Copyright © 2016 ___ASIAINFO___. All rights reserved.
//

import Foundation

//许愿服务接口实现类
struct AIWishServices{
    
    /// 提交许愿单
    static func requestMakeWishs(money: Double, wish: String, complate: ((AnyObject?, String?) -> Void)) {
        let userId = NSUserDefaults.standardUserDefaults().objectForKey(kDefault_UserID) as! String
        let message = AIMessage()
        //获取本地语言类型推算币种类型
        print(Localize.currentLanguage())
        let body: NSDictionary = [
            "wish_desc": wish,
            "user_id":userId,
            "money_amount":money,
            "money_type":"CNY",
            "money_unit":""
        ]
        
        message.body.addEntriesFromDictionary(body as [NSObject: AnyObject])
        message.url = AIApplication.AIApplicationServerURL.makewish.description as String
        
        AINetEngine.defaultEngine().postMessage(message, success: { (response) in
            if let responseJSON: AnyObject = response {
                let model = AISuperiorityModel(JSONDecoder(responseJSON))
                complate(model, nil)
            } else {
                complate(nil, "data is null")
            }
        }) { (error, des) in
            complate(nil, des)
        }
    }
    
    /// 许愿单查询
    static func requestQueryWishs(complate: ((AnyObject?, String?) -> Void)) {
        let userId = NSUserDefaults.standardUserDefaults().objectForKey(kDefault_UserID) as! String
        let message = AIMessage()
        let body: NSDictionary = [
            "user_id":userId
        ]
        
        message.body.addEntriesFromDictionary(body as [NSObject: AnyObject])
        message.url = AIApplication.AIApplicationServerURL.wishpreview.description as String
        
        AINetEngine.defaultEngine().postMessage(message, success: { (response) in
            if let responseJSON: AnyObject = response {
                let model = AIWishModel(JSONDecoder(responseJSON))
                complate(model, nil)
            } else {
                complate(nil, "data is null")
            }
        }) { (error, des) in
            complate(nil, des)
        }
    }
    
}