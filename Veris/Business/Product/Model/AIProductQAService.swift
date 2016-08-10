//
//  AIProductQAService.swift
//  AIVeris
//
//  Created by zx on 8/1/16.
//  Copyright © 2016 ___ASIAINFO___. All rights reserved.
//

import UIKit

class AIProductQAService: NSObject {
	func allQuestions(service_id: String, user_id: String, success: ([[String: String]]) -> Void, fail: (errType: AINetError, errDes: String) -> Void) {
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
}
