//
//  AISearchHomeService.swift
//  AIVeris
//
//  Created by zx on 8/3/16.
//  Copyright © 2016 ___ASIAINFO___. All rights reserved.
//

import UIKit

class AISearchHomeService: NSObject {
	
//       2.2.1 最近搜索
	func recentlySearch(success: (recentlySearchTexts: [String], everyOneSearchTexts: [String], browseHistory: [AISearchServiceModel]) -> Void, fail: (errType: AINetError, errDes: String) -> Void) {
		let user = AIUser.currentUser()
		let user_type = AIUserType.Customer.rawValue
		let user_id = user.id
		let message = AIMessage()
		message.url = AIApplication.AIApplicationServerURL.recentlySearch.description
		let body = ["data": ["user_type": user_type, "user_id": user_id], "desc": ["data_mode": "0", "digest": ""]]
		message.body = NSMutableDictionary(dictionary: body)
		AINetEngine.defaultEngine().postMessage(message, success: { (response) -> Void in
			let responseDic = response as! [NSObject: AnyObject]
            if response != nil && responseDic.count > 0 {
                let recentlySearchTexts = responseDic["recently_search_key"] as! [String]
                let everyOneSearchTexts = responseDic["everyone_search_key"] as! [String]
                let array = responseDic["browser_history"] as! [AnyObject]
                let result = AISearchServiceModel.arrayOfModelsFromDictionaries(array) as NSArray as! [AISearchServiceModel]
                success(recentlySearchTexts: recentlySearchTexts, everyOneSearchTexts: everyOneSearchTexts, browseHistory: result)
            } else {
                fail(errType: AINetError.Failed, errDes: "no data")
            }
			 
			
		}) { (error: AINetError, errorDes: String!) -> Void in
			fail(errType: error, errDes: errorDes ?? "")
		}
	}
    
    func createBrowserHistory(service_id: Int) {
        let user = AIUser.currentUser()
        let user_id = user.id
        let message = AIMessage()
        message.url = AIApplication.AIApplicationServerURL.createBrowserHistory.description
        let body = ["data": ["role_type": 1, "user_id": user_id, "service_id": service_id], "desc": ["data_mode": "0", "digest": ""]]
        message.body = NSMutableDictionary(dictionary: body)
        AINetEngine.defaultEngine().postMessage(message, success: { (response) -> Void in
        }) { (error: AINetError, errorDes: String!) -> Void in
        }
    }
	
//   2.2.2 商品搜索并带出过滤条件
	func searchServiceCondition(search_key: String, page_size: Int, page_number: Int, success: AISearchFilterModel -> Void, fail: (errType: AINetError, errDes: String) -> Void) {
		
		let user = AIUser.currentUser()
		let user_type = AIUserType.Customer.rawValue
		let user_id = user.id
		
		let message = AIMessage()
		
		message.url = AIApplication.AIApplicationServerURL.searchServiceCondition.description
		let body = ["data": [
			"user_type": user_type,
			"user_id": user_id,
			"search_key": search_key,
			"page_size": page_size,
			"page_number": page_number
			], "desc": ["data_mode": "0", "digest": ""]]
		message.body = NSMutableDictionary(dictionary: body)
		AINetEngine.defaultEngine().postMessage(message, success: { (response) -> Void in
			let responseDic = response as! [NSObject: AnyObject]
			if let result = try?AISearchFilterModel(dictionary: responseDic) {
				success(result)
			}
		}) { (error: AINetError, errorDes: String!) -> Void in
			fail(errType: error, errDes: errorDes ?? "")
		}
	}
	
//    2.2.3 商品搜索结果过滤
	func filterServices(search_key: String, page_size: Int, page_number: Int, filterModel: [String: AnyObject], success: ([AISearchServiceModel]) -> Void, fail: (errType: AINetError, errDes: String) -> Void) {
		
		let user = AIUser.currentUser()
		let user_type = AIUserType.Customer.rawValue
		let user_id = user.id
		
		let message = AIMessage()
		message.url = AIApplication.AIApplicationServerURL.filterServices.description
		let data = [
			"user_type": user_type,
			"user_id": user_id,
			"search_key": search_key,
			"page_size": page_size,
			"page_number": page_number,
		] as NSMutableDictionary
		
		data.addEntriesFromDictionary(filterModel)
		let body = ["data": data, "desc": ["data_mode": "0", "digest": ""]]
		message.body = NSMutableDictionary(dictionary: body)
		
		AINetEngine.defaultEngine().postMessage(message, success: { (response) -> Void in
			let responseDic = response as! [NSObject: AnyObject]
			if let serviceList = responseDic["service_list"] as? [AnyObject] {
				let result = AISearchServiceModel.arrayOfModelsFromDictionaries(serviceList) as NSArray as! [AISearchServiceModel]
				success(result)
			} else {
				success([])
			}
		}) { (error: AINetError, errorDes: String!) -> Void in
			fail(errType: error, errDes: errorDes ?? "")
		}
	}
	
//    2.2.4 商品推荐
	func getRecommendedServices(success: ([AISearchServiceModel]) -> Void, fail: (errType: AINetError, errDes: String) -> Void) {
		
		let user = AIUser.currentUser()
		let user_type = AIUserType.Customer.rawValue
		let user_id = user.id
		
		let message = AIMessage()
		message.url = AIApplication.AIApplicationServerURL.getRecommendedServices.description
		let body = ["data": [
			"user_type": user_type,
			"user_id": user_id,
			], "desc": ["data_mode": "0", "digest": ""]]
		message.body = NSMutableDictionary(dictionary: body)
		AINetEngine.defaultEngine().postMessage(message, success: { (response) -> Void in
			let array = response as! [AnyObject]
			let result = AISearchServiceModel.arrayOfModelsFromDictionaries(array) as NSArray as! [AISearchServiceModel]
			success(result)
		}) { (error: AINetError, errorDes: String!) -> Void in
			fail(errType: error, errDes: errorDes ?? "")
		}
	}
}
