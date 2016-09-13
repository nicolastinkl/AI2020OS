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

enum ProcedureType: Int {
    // 需要授权的节点
    case jurisdiction = 1
    // 需要用户确认的节点
    case confirm = 2
    // 只读节点
    case read = 3
}

enum JurisdictionStatus: Int {
    case notAuthorized = 0
    case alreadyAuthorized = 1
    case noNeed = 2
}

enum ConfirmStatus: Int {
    case notConfirm = 0
    case alreadyConfirm = 1
}

enum ReadStatus: Int {
    case notRead = 0
    case alreadyRead = 1
}

enum ProcedureStatus: Int {
    case noStart = 0
    case excuting = 1
    case complete = 2
    case needAuthorize = 3
}

protocol ExcuteManager {
    func submitServiceNodeResult(serviceId: Int, procedureId: Int, resultList: [NodeResultContent], success: (responseData: (hasNextNode: Bool, resultCode: ResultCode)) -> Void, fail: (errType: AINetError, errDes: String) -> Void)
    func queryProcedureInstInfo(serviceId serviceId: Int, serviceInstId: Int, userId: Int, success: (responseData: (customer: AICustomerModel, procedure: Procedure)) -> Void, fail: (errType: AINetError, errDes: String) -> Void)
    func updateServiceNodeStatus(procedureId: Int, status: ProcedureStatus, success: (responseData: ResultCode) -> Void, fail: (errType: AINetError, errDes: String) -> Void)
    func submitRequestAuthorization(serviceId: Int, customerId: Int, success: (responseData: ResultCode) -> Void, fail: (errType: AINetError, errDes: String) -> Void)
}


class BDKExcuteManager: ExcuteManager {
    func submitServiceNodeResult(serviceId: Int, procedureId: Int, resultList: [NodeResultContent], success: (responseData: (hasNextNode: Bool, resultCode: ResultCode)) -> Void, fail: (errType: AINetError, errDes: String) -> Void) {
        
        let message = AIMessage()
        let url = AIApplication.AIApplicationServerURL.submitServiceNodeResult.description
        message.url = url
        
        let data: [String: AnyObject] = ["service_instance_id": serviceId, "procedure_inst_id": procedureId, "note_list": NodeResultContent.arrayOfDictionariesFromModels(resultList)]
        message.body = BDKTools.createRequestBody(data)
        
        AINetEngine.defaultEngine().postMessage(message, success: { (response) -> Void in
            
            guard let dic = response as? [NSObject : AnyObject] else {
                fail(errType: AINetError.Format, errDes: "submitServiceNodeResult JSON Parse Error...")
                return
            }
            
            guard
                let hasNextNode = dic["process_flag"] as? Bool, c = dic["result_code"] as? Int else {
                    fail(errType: AINetError.Format, errDes: "submitServiceNodeResult JSON Parse Error...")
                    return
            }
            
            let result = (hasNextNode, ResultCode(rawValue: c)!)
            success(responseData: result)
            
        }) { (error: AINetError, errorDes: String!) -> Void in
            fail(errType: error, errDes: errorDes ?? "")
        }
    }


    //MARK: 抢单结果信息查询
    func queryQaingDanResultInfo(body: [String : AnyObject], success: (resultModel: AIQiangDanResultModel) -> Void, fail: net_fail_block) {
        let message = AIMessage()
        message.url = AIApplication.AIApplicationServerURL.queryQiangDanResult.description
        message.body = BDKTools.createRequestBody(body)

        AINetEngine.defaultEngine().postMessage(message, success: { (response) -> Void in

            do {
                guard let dic = response as? [NSObject : AnyObject] else {
                    fail(AINetError.Format, AIErrors.AINetErrors.ResponseFormatError)
                    return
                }
                let model = try AIQiangDanResultModel(dictionary: dic)
                success(resultModel: model)
            } catch {
                fail(AINetError.Format, AIErrors.AINetErrors.ResponseFormatError)
            }

        }) { (error: AINetError, errorDes: String!) -> Void in
            fail(error, errorDes ?? AIErrors.AINetErrors.NetError)
        }

    }




    
    func queryProcedureInstInfo(serviceId serviceId: Int, serviceInstId: Int, userId: Int, success: (responseData: (customer: AICustomerModel, procedure: Procedure)) -> Void, fail: (errType: AINetError, errDes: String) -> Void) {
        
        
        let message = AIMessage()
        let url = AIApplication.AIApplicationServerURL.queryProcedureInstInfo.description
        message.url = url
        
        let data: [String: AnyObject] = ["service_id": serviceId, "service_instance_id": serviceInstId, "customer_user_id": userId]
        message.body = BDKTools.createRequestBody(data)
        
        AINetEngine.defaultEngine().postMessage(message, success: { (response) -> Void in
            
            do {
                guard let dic = response as? [NSObject : AnyObject] else {
                    fail(errType: AINetError.Format, errDes: "queryProcedureInstInfo JSON Parse Error...")
                    return
                }
                
                guard let p = dic["procedure"] as? [NSObject : AnyObject] else {
                    fail(errType: AINetError.Format, errDes: "queryProcedureInstInfo JSON Parse Error...")
                    return
                }
                
                guard let c = dic["customer"] as? [NSObject : AnyObject] else {
                    fail(errType: AINetError.Format, errDes: "queryProcedureInstInfo JSON Parse Error...")
                    return
                }
                
                let procedure = try Procedure(dictionary: p)
                let customer = try AICustomerModel(dictionary: c)
                success(responseData: (customer, procedure))
            } catch {
                fail(errType: AINetError.Format, errDes: "queryProcedureInstInfo JSON Parse Error...")
            }
            
        }) { (error: AINetError, errorDes: String!) -> Void in
            fail(errType: error, errDes: errorDes ?? "")
        }
    }
    
    func updateServiceNodeStatus(procedureId: Int, status: ProcedureStatus, success: (responseData: ResultCode) -> Void, fail: (errType: AINetError, errDes: String) -> Void) {
        
        let message = AIMessage()
        let url = AIApplication.AIApplicationServerURL.updateServiceNodeStatus.description
        message.url = url
        
        let data: [String: AnyObject] = ["procedure_inst_id": procedureId, "status": status.rawValue]
        message.body = BDKTools.createRequestBody(data)
        
        AINetEngine.defaultEngine().postMessage(message, success: { (response) -> Void in
            
            guard let dic = response as? [NSObject : AnyObject] else {
                fail(errType: AINetError.Format, errDes: "updateServiceNodeStatus JSON Parse Error...")
                return
            }
            
            guard let c = dic["result_code"] as? Int else {
                fail(errType: AINetError.Format, errDes: "JSON Parse Error...")
                return
            }
            
            success(responseData: ResultCode(rawValue: c)!)
            
        }) { (error: AINetError, errorDes: String!) -> Void in
            fail(errType: error, errDes: errorDes ?? "")
        }
    }
    
    func submitRequestAuthorization(procedureInstId: Int, customerId: Int, success: (responseData: ResultCode) -> Void, fail: (errType: AINetError, errDes: String) -> Void) {
        
        let message = AIMessage()
        let url = AIApplication.AIApplicationServerURL.submitRequestAuthorization.description
        message.url = url
        
        let data: [String: AnyObject] = ["procedure_inst_id": procedureInstId]
        message.body = BDKTools.createRequestBody(data)
        
        AINetEngine.defaultEngine().postMessage(message, success: { (response) -> Void in
            
            guard let dic = response as? [NSObject : AnyObject] else {
                fail(errType: AINetError.Format, errDes: "JSON Parse Error...")
                return
            }
            
            guard let c = dic["result_code"] as? Int else {
                fail(errType: AINetError.Format, errDes: "JSON Parse Error...")
                return
            }
            
            success(responseData: ResultCode(rawValue: c)!)
            
        }) { (error: AINetError, errorDes: String!) -> Void in
            fail(errType: error, errDes: errorDes ?? "")
        }
    }
    
    /**
     启动服务流程实例
     
     - parameter serviceInstId: <#serviceInstId description#>
     - parameter success:       <#success description#>
     - parameter fail:          <#fail description#>
     */
    func startServiceProcess(serviceInstId: Int, success: (responseData: ResultCode) -> Void, fail: (errType: AINetError, errDes: String) -> Void) {
        let message = AIMessage()
        let url = AIApplication.AIApplicationServerURL.startServiceProcess.description
        message.url = url
        
        let data: [String: AnyObject] = ["service_instance_id": serviceInstId]
        message.body = BDKTools.createRequestBody(data)
        
        AINetEngine.defaultEngine().postMessage(message, success: { (response) -> Void in
            
            guard let dic = response as? [NSObject : AnyObject] else {
                fail(errType: AINetError.Format, errDes: "JSON Parse Error...")
                return
            }
            
            guard let c = dic["result_code"] as? Int else {
                fail(errType: AINetError.Format, errDes: "JSON Parse Error...")
                return
            }
            
            success(responseData: ResultCode(rawValue: c)!)
            
        }) { (error: AINetError, errorDes: String!) -> Void in
            fail(errType: error, errDes: errorDes ?? "")
        }

    }
}
