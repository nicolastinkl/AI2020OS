//
//  asd.swift
//  AIVeris
//
//  Created by tinkl on 8/2/16.
//  Copyright © 2016 ___ASIAINFO___. All rights reserved.
//

import Foundation

struct AISuperiorityService {
    
    /// 服务首页数据接口
    static func requestSuperiority(serviceId: String, complate: ((AnyObject?, String?) -> Void)) {
     
        let message = AIMessage()
        
        let body: NSDictionary = ["data": ["service_id": serviceId], "desc": ["data_mode": "0", "digest": ""]]
        
        message.body.addEntriesFromDictionary(body as [NSObject: AnyObject])
        message.url = AIApplication.AIApplicationServerURL.preview.description as String
        
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
    
}
