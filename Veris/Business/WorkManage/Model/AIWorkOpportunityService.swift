//
//  AIWorkOpportunityService.swift
//  AIVeris
//
//  Created by zx on 10/18/16.
//  Copyright © 2016 ___ASIAINFO___. All rights reserved.
//

import UIKit

class AIWorkOpportunityService: NSObject {
    
//    2.12.2.	查询供需最大的工作机会
//    queryMostRequestedWork
    func queryMostRequestedWork(success: ([AISearchServiceModel]) -> Void, fail: (errType: AINetError, errDes: String) -> Void) {
        
        let message = AIMessage()
        message.url = AIApplication.AIApplicationServerURL.queryMostRequestedWork.description
        let data = [
            :] as NSMutableDictionary
        
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
    
//    2.12.3.	查询最新工作机会
//    queryNewestWorkOpportunity
    func queryNewestWorkOpportunity(success: ([AISearchServiceModel]) -> Void, fail: (errType: AINetError, errDes: String) -> Void) {
    }
//    
//    
//    2.12.1.	查询最受欢迎的工作机会
//    queryMostPopularWork
    
    func queryMostPopularWork(success: ([AISearchServiceModel]) -> Void, fail: (errType: AINetError, errDes: String) -> Void) {
    }
}
