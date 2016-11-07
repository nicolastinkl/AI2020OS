//
//  AIFundAccountService.swift
//  AIVeris
//
//  Created by zx on 11/4/16.
//  Copyright © 2016 ___ASIAINFO___. All rights reserved.
//

import UIKit

class AIFundAccountService: NSObject {
    
    // 2.14.3.	资金帐户列表
    func capitalAccounts(success: ([AICapitalAccount]) -> Void, fail: (errType: AINetError, errDes: String) -> Void) {
        
        let message = AIMessage()
        message.url = AIApplication.AIApplicationServerURL.capitalAccounts.description
        let data = [
            :] as NSMutableDictionary
        
        let body = ["data": data, "desc": ["data_mode": "0", "digest": ""]]
        message.body = NSMutableDictionary(dictionary: body)
        
        AINetEngine.defaultEngine().postMessage(message, success: { (response) -> Void in
            if let serviceList = response["accounts"] as? [NSObject] {
                let result = AICapitalAccount.arrayOfModelsFromDictionaries(serviceList) as NSArray as! [AICapitalAccount]
                success(result)
            } else {
                success([])
            }
        }) { (error: AINetError, errorDes: String!) -> Void in
            fail(errType: error, errDes: errorDes ?? "")
        }
    }
    
    // 2.14.12.	我的会员卡
    func queryMemberCard(success: ([AIMemberCard]) -> Void, fail: (errType: AINetError, errDes: String) -> Void) {
        
        let message = AIMessage()
        message.url = AIApplication.AIApplicationServerURL.queryMemberCard.description
        let data = [
            :] as NSMutableDictionary
        
        let body = ["data": data, "desc": ["data_mode": "0", "digest": ""]]
        message.body = NSMutableDictionary(dictionary: body)
        
        AINetEngine.defaultEngine().postMessage(message, success: { (response) -> Void in
            if let serviceList = response["cards"] as? [NSObject] {
                let result = AIMemberCard.arrayOfModelsFromDictionaries(serviceList) as NSArray as! [AIMemberCard]
                success(result)
            } else {
                success([])
            }
        }) { (error: AINetError, errorDes: String!) -> Void in
            fail(errType: error, errDes: errorDes ?? "")
        }
    }

}
