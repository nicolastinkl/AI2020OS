//
//  AICustomerServiceExecuteService.swift
//  AIVeris
//
//  Created by 刘先 on 7/26/16.
//  Copyright © 2016 ___ASIAINFO___. All rights reserved.
//

import Foundation

class AICustomerServiceExecuteHandler: NSObject {
    
    struct AINetErrorDescription {
        static let FormatError = "AIOrderPreListModel JSON Parse error."
    }
    
    //单例变量
    static let sharedInstance = AICustomerServiceExecuteHandler()
    
    /**
     查询消费者服务执行详情
     
     - parameter serviceInstId: <#serviceInstId description#>
     - parameter success:       <#success description#>
     - parameter fail:          <#fail description#>
     */
    func queryCustomerServiceExecute(serviceInstId: NSString, success: (businessInfo: AICustomerOrderDetailTopViewModel) -> Void, fail: (errType: AINetError, errDes: String) -> Void) {
        
        let message = AIMessage()
        let body = ["data": ["service_inst_id": serviceInstId], "desc": ["data_mode": "0", "digest": ""]]
        message.body.addEntriesFromDictionary(body as [NSObject: AnyObject])
        message.url = AIApplication.AIApplicationServerURL.queryBusinessInfo.description as String
        
        weak var weakSelf = self
        
        AINetEngine.defaultEngine().postMessage(message, success: { (response) -> Void in
            do {
                let dic = response as! [NSObject: AnyObject]
                let originalRequirements = try AIServiceInstBusiModel(dictionary: dic)
                weakSelf!.parseCustomerServiceExecuteToViewModel(originalRequirements, success: success, fail: fail)
            } catch {
                fail(errType: AINetError.Format, errDes: AINetErrorDescription.FormatError)
            }
        }) { (error: AINetError, errorDes: String!) -> Void in
            fail(errType: error, errDes: errorDes)
        }
    }
    
    func parseCustomerServiceExecuteToViewModel(busiModel: AIServiceInstBusiModel, success: (viewModel: AICustomerOrderDetailTopViewModel) -> Void, fail: (errType: AINetError, errDes: String) -> Void) {
    }
    
    func queryCustomerTimelineList(serviceInstId: NSString, success: (businessInfo: AICustomerOrderDetailTopViewModel) -> Void, fail: (errType: AINetError, errDes: String) -> Void) {
        
        let message = AIMessage()
        let body = ["data": ["service_inst_id": serviceInstId], "desc": ["data_mode": "0", "digest": ""]]
        message.body.addEntriesFromDictionary(body as [NSObject: AnyObject])
        message.url = AIApplication.AIApplicationServerURL.queryBusinessInfo.description as String
        
        weak var weakSelf = self
        
        AINetEngine.defaultEngine().postMessage(message, success: { (response) -> Void in
            do {
                let dic = response as! [NSObject: AnyObject]
                let originalRequirements = try AIServiceInstBusiModel(dictionary: dic)
                weakSelf!.parseCustomerServiceExecuteToViewModel(originalRequirements, success: success, fail: fail)
            } catch {
                fail(errType: AINetError.Format, errDes: AINetErrorDescription.FormatError)
            }
        }) { (error: AINetError, errorDes: String!) -> Void in
            fail(errType: error, errDes: errorDes)
        }
    }
    
    func parseTimelineToViewModel(busiModel: AIServiceInstBusiModel, success: (viewModel: AICustomerOrderDetailTopViewModel) -> Void, fail: (errType: AINetError, errDes: String) -> Void) {
    }
}
