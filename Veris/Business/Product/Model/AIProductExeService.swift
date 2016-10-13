//
//  AIProductExeService.swift
//  AIVeris
//
//  Created by asiainfo on 10/13/16.
//  Copyright © 2016 ___ASIAINFO___. All rights reserved.
//

import Foundation

class AIProductExeService: NSObject {
    func removeOrAddServiceFromDIYService(service_id: Int, deleteOrAdd: Int, success: ([[String: String]]) -> Void, fail: (errType: AINetError, errDes: String) -> Void) {
        
        // delete 0 ,   add 1
        let user_id = AIUser.currentUser().userId
        let message = AIMessage()
        message.url = AIApplication.AIApplicationServerURL.allQuestions.description
        let body = ["data": ["service_id": service_id, "user_id": user_id], "desc": ["data_mode": "0", "digest": ""]]
        message.body = NSMutableDictionary(dictionary: body)
        AINetEngine.defaultEngine().postMessage(message, success: { (response) -> Void in
            if let result = response["question_list"] as? [[String: String]] {
                success(result)
            }
        }) { (error: AINetError, errorDes: String!) -> Void in
            fail(errType: error, errDes: errorDes ?? "")
        }
        
        
    }
}
