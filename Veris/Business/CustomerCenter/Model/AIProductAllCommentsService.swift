//
//  AIProductAllCommentsService.swift
//  AIVeris
//
//  Created by zx on 8/29/16.
//  Copyright © 2016 ___ASIAINFO___. All rights reserved.
//

class AIProductAllCommentsService: NSObject {
	func queryAllComments(service_id: Int, filter_type: Int, page_size: Int, page_number: Int, success: [AIProductComment] -> Void, fail: (errType: AINetError, errDes: String) -> Void) {
		let message = AIMessage()
		message.url = AIApplication.AIApplicationServerURL.queryAllComments.description
		let body = ["data": [
			"service_id": service_id,
			"filter_type": filter_type,
			"page_size": page_size,
			"page_number": page_number
			], "desc": ["data_mode": "0", "digest": ""]]
		
		message.body = NSMutableDictionary(dictionary: body)
		AINetEngine.defaultEngine().postMessage(message, success: { (response) -> Void in
			if let responseDic = response as? [NSObject: AnyObject] {
				if let commentList = responseDic["comment_list"] as? [AnyObject] {
					let result = AIProductComment.arrayOfModelsFromDictionaries(commentList) as NSArray as! [AIProductComment]
					success(result)
				} else {
					success([])
				}
			} else {
				success([])
			}
		}) { (error: AINetError, errorDes: String!) -> Void in
			fail(errType: error, errDes: errorDes ?? "")
		}
	}
}
