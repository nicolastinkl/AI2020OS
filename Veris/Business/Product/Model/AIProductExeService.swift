//
//  AIProductExeService.swift
//  AIVeris
//
//  Created by asiainfo on 10/13/16.
//  Copyright © 2016 ___ASIAINFO___. All rights reserved.
//

import Foundation

class AIProductExeService: NSObject {
    func removeOrAddServiceFromDIYService(service_id: Int, deleteOrAdd: Int, success: (Bool) -> Void, fail: (errType: AINetError, errDes: String) -> Void) {
        
        // delete 1 ,   add 0
        let message = AIMessage()
        message.url = AIApplication.AIApplicationServerURL.setProposalItemDisableFlag.description
        let body = ["data": ["service_id": service_id, "disableFlag": deleteOrAdd], "desc": ["data_mode": "0", "digest": ""]]
        message.body = NSMutableDictionary(dictionary: body)
        AINetEngine.defaultEngine().postMessage(message, success: { (response) -> Void in
            success(true)
        }) { (error: AINetError, errorDes: String!) -> Void in
            fail(errType: error, errDes: errorDes ?? "")
        }
        
        
    }
}
