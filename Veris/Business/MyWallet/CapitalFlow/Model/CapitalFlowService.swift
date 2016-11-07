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
    /**
     查询资金流水
     
     - parameter type:    资金类型，nil是查询全部类型
     - parameter success:
     - parameter fail:    
     */
    func getCapitalFlowList(type: String?, success: (responseData: CapitalFlowList) -> Void, fail: (errType: AINetError, errDes: String) -> Void)
    
    func getCapitalTypeList(success: (responseData: CapitalTypeList) -> Void, fail: (errType: AINetError, errDes: String) -> Void)
}

class HttpCapitalFlowService: CapitalFlowService {
    func getCapitalFlowList(type: String? = nil, success: (responseData: CapitalFlowList) -> Void, fail: (errType: AINetError, errDes: String) -> Void) {
        
        let message = AIMessage()
        let url = AIApplication.AIApplicationServerURL.getCapitalFlowList.description
        message.url = url
        
        if let type = type {
            let data: [String: AnyObject] = ["type": type]
            message.body = BDKTools.createRequestBody(data)
        }
        
        
        
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
    
    func getCapitalTypeList(success: (responseData: CapitalTypeList) -> Void, fail: (errType: AINetError, errDes: String) -> Void) {
        let message = AIMessage()
        let url = AIApplication.AIApplicationServerURL.getCapitalTypeList.description
        message.url = url
        
        AINetEngine.defaultEngine().postMessage(message, success: { (response) -> Void in
            
            do {
                guard let dic = response as? [NSObject : AnyObject] else {
                    fail(errType: AINetError.Format, errDes: "CapitalTypeList JSON Parse Error...")
                    return
                }
                let model = try CapitalTypeList(dictionary: dic)
                success(responseData: model)
            } catch {
                fail(errType: AINetError.Format, errDes: "CapitalTypeList JSON Parse Error...")
            }
            
        }) { (error: AINetError, errorDes: String!) -> Void in
            fail(errType: error, errDes: errorDes ?? "")
        }
    }
}
