//
//  CommentService.swift
//  AIVeris
//
//  Created by Rocky on 16/7/11.
//  Copyright © 2016年 ___ASIAINFO___. All rights reserved.
//

import Foundation

protocol CommentService: NSObjectProtocol {
    func getSingleComment(serviceId: String, success: (responseData: SingleComment) -> Void, fail: (errType: AINetError, errDes: String) -> Void)
    func getCompondComment(serviceId: String, success: (responseData: CompondComment) -> Void, fail: (errType: AINetError, errDes: String) -> Void)

}

class HttpCommentService: NSObject {}

extension HttpCommentService: CommentService {
    func getSingleComment(serviceId: String, success: (responseData: SingleComment) -> Void, fail: (errType: AINetError, errDes: String) -> Void) {
        
        let message = AIMessage()
        let url = AIApplication.AIApplicationServerURL.singleComment.description
        message.url = url
        
        let data = ["service_id" : serviceId]
        message.body = BDKTools.createRequestBody(data)
        
        AINetEngine.defaultEngine().postMessage(message, success: { (response) -> Void in
            
            do {
                guard let dic = response as? [NSObject : AnyObject] else {
                    fail(errType: AINetError.Format, errDes: "SingleComment JSON Parse Error...")
                    return
                }
                let model = try SingleComment(dictionary: dic)
                success(responseData: model)
            } catch {
                fail(errType: AINetError.Format, errDes: "SingleComment JSON Parse Error...")
            }
            
        }) { (error: AINetError, errorDes: String!) -> Void in
            fail(errType: error, errDes: errorDes ?? "")
        }
    }
    
    func getCompondComment(serviceId: String, success: (responseData: CompondComment) -> Void, fail: (errType: AINetError, errDes: String) -> Void) {
        
        let message = AIMessage()
        let url = AIApplication.AIApplicationServerURL.compondComment.description
        message.url = url
        
        let data = ["service_id" : serviceId]
        message.body = BDKTools.createRequestBody(data)
        
        AINetEngine.defaultEngine().postMessage(message, success: { (response) -> Void in
            
            do {
                guard let dic = response as? [NSObject : AnyObject] else {
                    fail(errType: AINetError.Format, errDes: "CompondComment JSON Parse Error...")
                    return
                }
                let model = try CompondComment(dictionary: dic)
                success(responseData: model)
            } catch {
                fail(errType: AINetError.Format, errDes: "CompondComment JSON Parse Error...")
            }
            
        }) { (error: AINetError, errorDes: String!) -> Void in
            fail(errType: error, errDes: errorDes ?? "")
        }
    }
}
