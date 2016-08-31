//
//  AIProductAllCommentsService.swift
//  AIVeris
//
//  Created by zx on 8/29/16.
//  Copyright © 2016 ___ASIAINFO___. All rights reserved.
//

class AIProductAllCommentsService: NSObject {
	
	/**
     2.11.5 查询某个服务所有的评论列表
     
     - author: zx
     - date: 16-08-31 09:08:09
     
     - parameter service_id:  service_id description
     - parameter filter_type: 1: 全部, 2: 好评,3:中评,4:,差评5:带图
     - parameter page_size:   page_size description
     - parameter page_number: page_number description
     - parameter success:     success description
     - parameter fail:        fail description
     */
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
	
	/**
     3.8.5 查询评论统计信息
     
     - author: zx
     - date: 16-08-31 09:08:13
     
     - parameter service_id: service_id
     - parameter success:    返回数量数组
     - parameter fail:       fail block
     */
	func queryRatingStatistics(service_id: Int, success: [String] -> Void, fail: (errType: AINetError, errDes: String) -> Void) {
		let message = AIMessage()
		message.url = AIApplication.AIApplicationServerURL.queryRatingStatistics.description
		let body = ["data": [
			"service_id": service_id,
			], "desc": ["data_mode": "0", "digest": ""]]
		
		message.body = NSMutableDictionary(dictionary: body)
		AINetEngine.defaultEngine().postMessage(message, success: { (response) -> Void in
			
			if let responseDic = response as? [NSObject: Int] {
				var result = [Int]()
				let keys = [
					"count",
					"good",
					"middle",
					"low",
					"blueprint"
				]
				
				for i in 0...keys.count - 1 {
					result.append(responseDic[keys[i]]!)
				}
				
				success(result.map { $0.toString() })
			} else {
			}
		}) { (error: AINetError, errorDes: String!) -> Void in
			fail(errType: error, errDes: errorDes ?? "")
		}
	}
}
