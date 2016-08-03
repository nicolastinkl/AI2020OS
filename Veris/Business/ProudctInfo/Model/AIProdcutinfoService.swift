//
//  AIProdcutinfoService.swift
//  AIVeris
//
//  Created by tinkl on 8/3/16.
//  Copyright © 2016 ___ASIAINFO___. All rights reserved.
//

import Foundation


struct AIProdcutinfoService {
    
    static func requestServiceInfo(serviceId: String,userId: String,complate:((AnyObject?,String?) -> Void)) {
        
        let message = AIMessage()
        let body: NSDictionary = [
            "service_id": serviceId,
            "user_id":userId
        ]
        
        message.body.addEntriesFromDictionary(body as [NSObject: AnyObject])
        message.url = AIApplication.AIApplicationServerURL.detail.description as String
        
        AINetEngine.defaultEngine().postMessage(message, success: { (response) in
            if let responseJSON: AnyObject = response {
                let model = AIProdcutinfoModel(JSONDecoder(responseJSON))
                complate(model, nil)
            }else{
                complate(nil, "data is null")
            }
        }) { (error, des) in
            complate(nil, des)
        }
    }
    
}
