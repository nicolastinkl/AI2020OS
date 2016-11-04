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
    static func reqeustIndexInfo(success: (AIPayInfoModel?) -> Void, fail: (String) -> Void) {
        let message = AIMessage()
        message.url = AIApplication.AIApplicationServerURL.queryPayment.description
       
        
        message.body.addEntriesFromDictionary(["desc":["data_mode":"0", "digest":""], "data":[]])
        message.url = AIApplication.AIApplicationServerURL.accountIndex.description
        
        AINetEngine.defaultEngine().postMessage(message, success: { (response) -> Void in
            if let responseJSON: AnyObject = response {
                
                //let model = AIPayInfoModel(JSONDecoder(responseJSON))
                //success(model)
            } else {
                success(nil)
            }
        }) { (error: AINetError, errorDes: String!) -> Void in
            
        }
    }
    
}
