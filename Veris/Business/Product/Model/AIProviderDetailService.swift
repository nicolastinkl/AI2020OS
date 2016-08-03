//
//  AIProviderDetailService.swift
//  AIVeris
//
//  Created by zx on 8/1/16.
//  Copyright © 2016 ___ASIAINFO___. All rights reserved.
//

import UIKit

class AIProviderDetailService: NSObject {
	func queryProvider(provider_id: String, success: (AnyObject) -> Void, fail: (errType: AINetError, errDes: String) -> Void) {
        //2.6.7 服务者介绍
		let message = AIMessage()
        message.url = AIApplication.AIApplicationServerURL.queryProvider.description
		let body = ["data": ["provider_id": provider_id], "desc": ["data_mode": "0", "digest": ""]]
		message.body = NSMutableDictionary(dictionary: body)
		AINetEngine.defaultEngine().postMessage(message, success: { (response) -> Void in
			success(response)
		}) { (error: AINetError, errorDes: String!) -> Void in
			fail(errType: error, errDes: errorDes ?? "")
		}
	}
}
