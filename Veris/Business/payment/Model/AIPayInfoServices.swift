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
    static func reqeustOrderInfo(order: String, orderitemid: String? = nil, billId: String? = nil, success: (AIPayInfoModel?) -> Void, fail: (errType: AINetError, errDes: String) -> Void) {
        let message = AIMessage()
        message.url = AIApplication.AIApplicationServerURL.queryPayment.description
        
        var data: [String: AnyObject] = ["order_id": order]
        
        if let orderItemId = orderitemid {
            data["order_item_id"] = orderItemId
        }
        
        if let billId = billId {
            data["bill_id"] = billId
        }
        
        message.body = BDKTools.createRequestBody(data)
        
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
