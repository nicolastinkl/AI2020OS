//
//  AIPayInfoServices.swift
//  AIVeris
//
//  Created by tinkl on 8/18/16.
//  Copyright © 2016 ___ASIAINFO___. All rights reserved.
//

import Foundation

// payment 数据请求封装
class AIPayInfoServices: NSObject {
    
    //请求订单信息
    static func reqeustOrderInfo(order: String, orderitemid: String, success: (AnyObject?) -> Void, fail: (errType: AINetError, errDes: String) -> Void) {
        let userId = NSUserDefaults.standardUserDefaults().objectForKey(kDefault_UserID) as! String
        let message = AIMessage()
        message.url = AIApplication.AIApplicationServerURL.queryPayment.description
        let body = ["data": ["order": order,"order_item_id":orderitemid,"user_id":userId], "desc": ["data_mode": "0", "digest": ""]]
        message.body = NSMutableDictionary(dictionary: body)
        AINetEngine.defaultEngine().postMessage(message, success: { (response) -> Void in
            if let responseJSON: AnyObject = response {
                let model = AIPayInfoModel(JSONDecoder(responseJSON))
                success(model)
            } else {
                success(nil)
            }
        }) { (error: AINetError, errorDes: String!) -> Void in
            fail(errType: error, errDes: errorDes ?? "")
        }
    }
    
}