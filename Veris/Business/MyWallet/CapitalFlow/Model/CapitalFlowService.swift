//
//  CapitalFlowService.swift
//  AIVeris
//
//  Created by Rocky on 2016/11/1.
//  Copyright © 2016年 ___ASIAINFO___. All rights reserved.
//

import Foundation

enum CapitalType: String {
    case all = ""
    case income = "1"
    case outcome = "0"
}

protocol CapitalFlowService {
    func getCapitalFlowList(type: CapitalType, success: (responseData: CapitalFlowList) -> Void, fail: (errType: AINetError, errDes: String) -> Void)
}

class HttpCapitalFlowService: CapitalFlowService {
    func getCapitalFlowList(type: CapitalType, success: (responseData: CapitalFlowList) -> Void, fail: (errType: AINetError, errDes: String) -> Void) {
        
        let message = AIMessage()
        let url = AIApplication.AIApplicationServerURL.serviceComment.description
        message.url = url
        
        let data: [String: AnyObject] = ["type": type.rawValue]
        message.body = BDKTools.createRequestBody(data)
        
        AINetEngine.defaultEngine().postMessage(message, success: { (response) -> Void in
            
            do {
                guard let dic = response as? [NSObject : AnyObject] else {
                    fail(errType: AINetError.Format, errDes: "CapitalFlowList JSON Parse Error...")
                    return
                }
                let model = try CapitalFlowList(dictionary: dic)
                success(responseData: model)
            } catch {
                fail(errType: AINetError.Format, errDes: "CapitalFlowList JSON Parse Error...")
            }
            
        }) { (error: AINetError, errorDes: String!) -> Void in
            fail(errType: error, errDes: errorDes ?? "")
        }
    }
}
