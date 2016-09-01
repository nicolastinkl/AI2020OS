//
//  ExcuteManager.swift
//  AIVeris
//
//  Created by Rocky on 16/8/31.
//  Copyright © 2016年 ___ASIAINFO___. All rights reserved.
//

import Foundation

enum NodeResultType: String {
    case text = "Text"
    case voice = "Voice"
    case picture = "Picture"
}

enum ResultCode: Int {
    case fail = 0
    case success = 1
}

enum PermissionType: Int {
    case unneed = 0
    case needPermision = 1
}

enum ProcedureStatus: Int {
    case noStart = 0
    case excuting = 1
    case complete = 2
}

protocol ExcuteManager {
    func submitServiceNodeResult(nodeId: Int, resultList: [NodeResultContent], success: (responseData: RequestCode) -> Void, fail: (errType: AINetError, errDes: String) -> Void)
    func queryProcedureInstInfo(procedureId: Int, userId: Int, success: (responseData: Procedure) -> Void, fail: (errType: AINetError, errDes: String) -> Void)
    func updateServiceNodeStatus(procedureId: Int, status: ProcedureStatus, success: (responseData: RequestCode) -> Void, fail: (errType: AINetError, errDes: String) -> Void)
}


class BDKExcuteManager: ExcuteManager {
    func submitServiceNodeResult(procedureId: Int, resultList: [NodeResultContent], success: (responseData: RequestCode) -> Void, fail: (errType: AINetError, errDes: String) -> Void) {
        
        let message = AIMessage()
        let url = AIApplication.AIApplicationServerURL.submitServiceNodeResult.description
        message.url = url
        
        let data: [String: AnyObject] = ["procedure_inst_id": procedureId, "note_list": NodeResultContent.arrayOfDictionariesFromModels(resultList)]
        message.body = BDKTools.createRequestBody(data)
        
        AINetEngine.defaultEngine().postMessage(message, success: { (response) -> Void in
            
            do {
                guard let dic = response as? [NSObject : AnyObject] else {
                    fail(errType: AINetError.Format, errDes: "submitServiceNodeResult JSON Parse Error...")
                    return
                }
                let model = try RequestCode(dictionary: dic)
                success(responseData: model)
            } catch {
                fail(errType: AINetError.Format, errDes: "submitServiceNodeResult JSON Parse Error...")
            }
            
        }) { (error: AINetError, errorDes: String!) -> Void in
            fail(errType: error, errDes: errorDes ?? "")
        }
    }
    
    func queryProcedureInstInfo(serviceId: Int, userId: Int, success: (responseData: Procedure) -> Void, fail: (errType: AINetError, errDes: String) -> Void) {
        
        
        let message = AIMessage()
        let url = AIApplication.AIApplicationServerURL.queryProcedureInstInfo.description
        message.url = url
        
        let data: [String: AnyObject] = ["service_inst_id": serviceId, "user_id": userId]
        message.body = BDKTools.createRequestBody(data)
        
        AINetEngine.defaultEngine().postMessage(message, success: { (response) -> Void in
            
            do {
                guard let dic = response as? [NSObject : AnyObject] else {
                    fail(errType: AINetError.Format, errDes: "queryProcedureInstInfo JSON Parse Error...")
                    return
                }
                let model = try Procedure(dictionary: dic)
                success(responseData: model)
            } catch {
                fail(errType: AINetError.Format, errDes: "queryProcedureInstInfo JSON Parse Error...")
            }
            
        }) { (error: AINetError, errorDes: String!) -> Void in
            fail(errType: error, errDes: errorDes ?? "")
        }
    }
    
    func updateServiceNodeStatus(procedureId: Int, status: ProcedureStatus, success: (responseData: RequestCode) -> Void, fail: (errType: AINetError, errDes: String) -> Void) {
        
        let message = AIMessage()
        let url = AIApplication.AIApplicationServerURL.updateServiceNodeStatus.description
        message.url = url
        
        let data: [String: AnyObject] = ["procedure_inst_id": procedureId, "status": status.rawValue]
        message.body = BDKTools.createRequestBody(data)
        
        AINetEngine.defaultEngine().postMessage(message, success: { (response) -> Void in
            
            do {
                guard let dic = response as? [NSObject : AnyObject] else {
                    fail(errType: AINetError.Format, errDes: "updateServiceNodeStatus JSON Parse Error...")
                    return
                }
                let model = try RequestCode(dictionary: dic)
                success(responseData: model)
            } catch {
                fail(errType: AINetError.Format, errDes: "updateServiceNodeStatus JSON Parse Error...")
            }
            
        }) { (error: AINetError, errorDes: String!) -> Void in
            fail(errType: error, errDes: errorDes ?? "")
        }
    }
}