//
//  CommentService.swift
//  AIVeris
//
//  Created by Rocky on 16/7/11.
//  Copyright © 2016年 ___ASIAINFO___. All rights reserved.
//

import Foundation

enum AnonymousFlag: Int {
    case noAnonymous = 0
    case anonymous = 1
}

enum CommentType: String {
    case service = "ServiceInstance"
    case order = "Order"
}


protocol CommentService: NSObjectProtocol {
    func getSingleComment(userId: String, userType: Int, serviceId: String, success: (responseData: ServiceComment) -> Void, fail: (errType: AINetError, errDes: String) -> Void)
    func getCompondComment(userId: String, userType: Int, orderId: String, success: (responseData: CompondComment) -> Void, fail: (errType: AINetError, errDes: String) -> Void)
    func queryCommentSpecification(success: (responseData: [StarDesc]) -> Void, fail: (errType: AINetError, errDes: String) -> Void)
    // 提交评论。userType：1 – customer, 2 - provider
    func submitComments(userID: String, userType: Int, commentList: [SingleComment], success: (responseData: RequestResult) -> Void, fail: (errType: AINetError, errDes: String) -> Void)
}

class HttpCommentService: NSObject {}

extension HttpCommentService: CommentService {
    func getSingleComment(userId: String, userType: Int, serviceId: String, success: (responseData: ServiceComment) -> Void, fail: (errType: AINetError, errDes: String) -> Void) {
        
        let message = AIMessage()
        let url = AIApplication.AIApplicationServerURL.serviceComment.description
        message.url = url
        
        let data: [String: AnyObject] = ["service_id": serviceId, "user_id": userId, "userType": userType]
        message.body = BDKTools.createRequestBody(data)
        
        AINetEngine.defaultEngine().postMessage(message, success: { (response) -> Void in
            
            do {
                guard let dic = response as? [NSObject : AnyObject] else {
                    fail(errType: AINetError.Format, errDes: "ServiceComment JSON Parse Error...")
                    return
                }
                let model = try ServiceComment(dictionary: dic)
                success(responseData: model)
            } catch {
                fail(errType: AINetError.Format, errDes: "ServiceComment JSON Parse Error...")
            }
            
        }) { (error: AINetError, errorDes: String!) -> Void in
            fail(errType: error, errDes: errorDes ?? "")
        }
    }
    
    func getCompondComment(userId: String, userType: Int, orderId: String, success: (responseData: CompondComment) -> Void, fail: (errType: AINetError, errDes: String) -> Void) {
        
        let message = AIMessage()
        let url = AIApplication.AIApplicationServerURL.compondComment.description
        message.url = url
        
        let data: [String: AnyObject] = ["order_id": orderId, "user_id": userId, "user_type": userType]
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
    
    func queryCommentSpecification(success: (responseData: [StarDesc]) -> Void, fail: (errType: AINetError, errDes: String) -> Void) {
        let message = AIMessage()
        let url = AIApplication.AIApplicationServerURL.commentSpec.description
        message.url = url
        
        let data = [String: AnyObject]()
        message.body = BDKTools.createRequestBody(data)
        
        AINetEngine.defaultEngine().postMessage(message, success: { (response) -> Void in
            
            
            
            guard let dic = response as? [AnyObject] else {
                fail(errType: AINetError.Format, errDes: "queryCommentSpecification JSON Parse Error...")
                return
            }
            
            if let model = StarDesc.arrayOfModelsFromDictionaries(dic) as NSArray? as? [StarDesc] {
                success(responseData: model)
            } else {
                fail(errType: AINetError.Format, errDes: "queryCommentSpecification JSON Parse Error...")
                
            }
            
            
        }) { (error: AINetError, errorDes: String!) -> Void in
            fail(errType: error, errDes: errorDes ?? "")
        }
    }
    
    // 提交评论。userType：1 – customer, 2 - provider
    func submitComments(userID: String, userType: Int, commentList: [SingleComment], success: (responseData: RequestResult) -> Void, fail: (errType: AINetError, errDes: String) -> Void) {
        let message = AIMessage()
        let url = AIApplication.AIApplicationServerURL.saveComment.description
        message.url = url
        
        let data: [String: AnyObject] = ["user_id": userID, "user_type": userType, "comment_list": ServiceComment.arrayOfDictionariesFromModels(commentList)]
        message.body = BDKTools.createRequestBody(data)
        
        AINetEngine.defaultEngine().postMessage(message, success: { (response) -> Void in
            
            do {
                guard let dic = response as? [NSObject : AnyObject] else {
                    fail(errType: AINetError.Format, errDes: "submitComments JSON Parse Error...")
                    return
                }
                let model = try RequestResult(dictionary: dic)
                success(responseData: model)
            } catch {
                fail(errType: AINetError.Format, errDes: "submitComments JSON Parse Error...")
            }
            
        }) { (error: AINetError, errorDes: String!) -> Void in
            fail(errType: error, errDes: errorDes ?? "")
        }
    }
    
}
