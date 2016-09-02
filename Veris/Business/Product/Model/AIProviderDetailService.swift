//
//  AIProviderDetailService.swift
//  AIVeris
//
//  Created by zx on 8/1/16.
//  Copyright © 2016 ___ASIAINFO___. All rights reserved.
//

import UIKit

class AIProviderDetailService: NSObject {
	func queryProvider(provider_id: Int, id: Int, success: (AIProviderDetailJSONModel) -> Void, fail: (errType: AINetError, errDes: String) -> Void) {
		// 2.6.7 服务者介绍
		let message = AIMessage()
		message.url = AIApplication.AIApplicationServerURL.queryProvider.description
		let body = ["data": ["provider_id": provider_id, "id": id], "desc": ["data_mode": "0", "digest": ""]]
		message.body = NSMutableDictionary(dictionary: body)
		AINetEngine.defaultEngine().postMessage(message, success: { (response) -> Void in
			let responseDic = response as! [NSObject: AnyObject]
			if let model = try?AIProviderDetailJSONModel(dictionary: responseDic["provider_info"] as! [NSObject: AnyObject]) {
				if let service_list = responseDic["service_list"] as? [AnyObject] {
					model.service_list = AISearchServiceModel.arrayOfModelsFromDictionaries(service_list) as NSArray as! [AISearchServiceModel]
				}
				success(model)
			} else {
				// handle error
//				fail(errType: error, errDes: errorDes ?? "")
			}
		}) { (error: AINetError, errorDes: String!) -> Void in
			fail(errType: error, errDes: errorDes ?? "")
		}
	}
}
