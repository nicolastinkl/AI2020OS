//
//  AIRecommondForYouService.swift
//  AIVeris
//
//  Created by zx on 8/1/16.
//  Copyright © 2016 ___ASIAINFO___. All rights reserved.
//

import UIKit

class AIRecommondForYouService: NSObject {
	func allRecomends(service_id: Int, success: ([AISearchServiceModel]) -> Void, fail: (errType: AINetError, errDes: String) -> Void) {
//        2.6.6 所有推荐（为您推荐）
		let message = AIMessage()
		message.url = AIApplication.AIApplicationServerURL.allRecommends.description
		let body = ["data": ["service_id": service_id], "desc": ["data_mode": "0", "digest": ""]]
		message.body = NSMutableDictionary(dictionary: body)
		AINetEngine.defaultEngine().postMessage(message, success: { (response) -> Void in
			
			let array = response["recommend_list"] as! [AnyObject]
			let result: [AISearchServiceModel] = AISearchServiceModel.arrayOfModelsFromDictionaries(array) as NSArray as! [AISearchServiceModel]
			
			success(result)
		}) { (error: AINetError, errorDes: String!) -> Void in
			fail(errType: error, errDes: errorDes ?? "")
		}
	}
}
