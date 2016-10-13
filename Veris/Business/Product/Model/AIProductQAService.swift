//
//  AIProductQAService.swift
//  AIVeris
//
//  Created by zx on 8/1/16.
//  Copyright © 2016 ___ASIAINFO___. All rights reserved.
//

import UIKit

class AIProductQAService: NSObject {
    
    // 查询所有问题
	func allQuestions(service_id: Int, success: ([[String: String]]) -> Void, fail: (errType: AINetError, errDes: String) -> Void) {
        let user_id = AIUser.currentUser().userId
		// 2.6.4 所有问题（常见问题）
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
    
    
    // 提及问题
    func submitQuestion(service_id: Int, question: String, success: (Bool) -> Void, fail: (errType: AINetError, errDes: String) -> Void) {
        let message = AIMessage()
        message.url = AIApplication.AIApplicationServerURL.submitQuestions.description
        let body = ["data": ["service_id": service_id, "question": question], "desc": ["data_mode": "0", "digest": ""]]
        message.body = NSMutableDictionary(dictionary: body)
        AINetEngine.defaultEngine().postMessage(message, success: { (response) -> Void in
            if let result = response["result"] as? String {
                if result == "success" {
                    success(true)
                } else {
                    success(false)
                }
            }
        }) { (error: AINetError, errorDes: String!) -> Void in
            fail(errType: error, errDes: errorDes ?? "")
        }
    }
    
}
