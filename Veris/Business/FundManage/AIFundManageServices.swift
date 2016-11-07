//
//  AIFundManageServices.swift
//  AIVeris
//
//  Created by asiainfo on 11/4/16.
//  Copyright © 2016 ___ASIAINFO___. All rights reserved.
//

import Foundation

class AIFundManageServices: NSObject {
    
    //查询首页信息
    static func reqeustIndexInfo(success: (AIFundManageModel?) -> Void, fail: (String) -> Void) {
        let message = AIMessage()
        message.body.addEntriesFromDictionary(["desc":["data_mode":"0", "digest":""], "data":[]])
        message.url = AIApplication.AIApplicationServerURL.accountIndex.description
        
        AINetEngine.defaultEngine().postMessage(message, success: { (response) -> Void in
            if let responseJSON: AnyObject = response {
                
                let model = AIFundManageModel(JSONDecoder(responseJSON))
                success(model)
            } else {
                success(nil)
            }
        }) { (error: AINetError, errorDes: String!) -> Void in
            
        }
    }
    
    
    //查询我的余额
    static func reqeustBlanceInfo(success: (AIFundBlanceModel?) -> Void, fail: (String) -> Void) {
        let message = AIMessage()
        message.body.addEntriesFromDictionary(["desc":["data_mode":"0", "digest":""], "data":[]])
        message.url = AIApplication.AIApplicationServerURL.blanceInfo.description
        
        AINetEngine.defaultEngine().postMessage(message, success: { (response) -> Void in
            if let responseJSON: AnyObject = response {
                
                let model = AIFundBlanceModel(JSONDecoder(responseJSON))
                success(model)
            } else {
                success(nil)
            }
        }) { (error: AINetError, errorDes: String!) -> Void in
            
        }
    }
    
    // 查询我的待收
    static func reqeustWillWithdrawInfo(success: ([AIFundWillWithDrawModel]?) -> Void, fail: (String) -> Void) {
        let message = AIMessage()
        message.body.addEntriesFromDictionary(["desc":["data_mode":"0", "digest":""], "data":[]])
        message.url = AIApplication.AIApplicationServerURL.waitPayOrders.description
        
        AINetEngine.defaultEngine().postMessage(message, success: { (response) -> Void in
            var arrayJson = Array<AIFundWillWithDrawModel>()
            if let responseJSON: AnyObject = response {
                if let response = JSONDecoder(responseJSON)["orders"].array {
                    for itemJSON in response {
                        let model = AIFundWillWithDrawModel(itemJSON)
                        arrayJson.append(model)
                    }
                }                
                success(arrayJson)
            } else {
                success(nil)
            }
        }) { (error: AINetError, errorDes: String!) -> Void in
            
        }
    }
    
    // 提醒
    static func reqeustNotifyPay(bill_id: String, success: (Bool) -> Void, fail: (String) -> Void) {
        let message = AIMessage()
        message.body.addEntriesFromDictionary(["desc":["data_mode":"0", "digest":""], "data":["bill_id":bill_id]])
        message.url = AIApplication.AIApplicationServerURL.noticePay.description
        
        AINetEngine.defaultEngine().postMessage(message, success: { (response) -> Void in
            
            if let responseJSON: AnyObject = response {
                success(true)
            } else {
                success(false)
            }
        }) { (error: AINetError, errorDes: String!) -> Void in
            
        }
    }
    
    // 查询我的待付
    
}
