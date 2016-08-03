//
//  AISearchHomeService.swift
//  AIVeris
//
//  Created by zx on 8/3/16.
//  Copyright © 2016 ___ASIAINFO___. All rights reserved.
//

import UIKit

class AISearchHomeService: NSObject {
	func recentlySearch(user_id: Int, user_type: Int, success: (AnyObject) -> Void, fail: (errType: AINetError, errDes: String) -> Void) {
//       2.2.1 最近搜索
		let message = AIMessage()
		message.url = AIApplication.AIApplicationServerURL.recentlySearch.description
		let body = ["data": ["user_type": user_type, "user_id": user_id], "desc": ["data_mode": "0", "digest": ""]]
		message.body = NSMutableDictionary(dictionary: body)
		AINetEngine.defaultEngine().postMessage(message, success: { (response) -> Void in
			success(response)
		}) { (error: AINetError, errorDes: String!) -> Void in
			fail(errType: error, errDes: errorDes ?? "")
		}
	}
	
	func filterServices(search_key: String, user_id: Int, user_type: Int, page_size: Int, page_number: Int, catalog_id: Int, price_area: [String: Int], sort_by: String, success: (AnyObject) -> Void, fail: (errType: AINetError, errDes: String) -> Void) {
		let message = AIMessage()
//    2.2.3 商品搜索结果过滤
		message.url = AIApplication.AIApplicationServerURL.filterServices.description
		
		let body = ["data": [
			"user_type": user_type,
			"user_id": user_id,
			"search_key": search_key,
			"page_size": page_size,
			"page_number": page_number,
			"catalog_id": 0,
			"price_area": price_area,
			"sort_by": sort_by
			], "desc": ["data_mode": "0", "digest": ""]]
		message.body = NSMutableDictionary(dictionary: body)
		AINetEngine.defaultEngine().postMessage(message, success: { (response) -> Void in
			success(response)
		}) { (error: AINetError, errorDes: String!) -> Void in
			fail(errType: error, errDes: errorDes ?? "")
		}
	}
	
}
