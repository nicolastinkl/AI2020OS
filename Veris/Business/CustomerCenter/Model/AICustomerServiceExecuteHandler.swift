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
    func queryCustomerServiceExecute(serviceInstId: NSString, success: (viewModel: AICustomerOrderDetailTopViewModel) -> Void, fail: (errType: AINetError, errDes: String) -> Void) {
        
        let message = AIMessage()
        let body = ["data": ["service_inst_id": serviceInstId], "desc": ["data_mode": "0", "digest": ""]]
        message.body.addEntriesFromDictionary(body as [NSObject: AnyObject])
        message.url = AIApplication.AIApplicationServerURL.queryBusinessInfo.description as String
        
        weak var weakSelf = self
        
        AINetEngine.defaultEngine().postMessage(message, success: { (response) -> Void in
            do {
                let dic = response as! [NSObject: AnyObject]
                let originalRequirements = try AICustomerServiceInstBusiModel(dictionary: dic)
                weakSelf!.parseCustomerServiceExecuteToViewModel(originalRequirements, success: success, fail: fail)
            } catch {
                fail(errType: AINetError.Format, errDes: AINetErrorDescription.FormatError)
            }
        }) { (error: AINetError, errorDes: String!) -> Void in
            fail(errType: error, errDes: errorDes)
        }
    }
    
    func parseCustomerServiceExecuteToViewModel(busiModel: AICustomerServiceInstBusiModel, success: (viewModel: AICustomerOrderDetailTopViewModel) -> Void, fail: (errType: AINetError, errDes: String) -> Void) {
        let viewModel = AICustomerOrderDetailTopViewModel()
        guard let priceModel = busiModel.price?.price_show,
            serviceName = busiModel.name,
            serviceIcon = busiModel.icon,
            iconServiceInsts = busiModel.sub_service as? [AIServiceInstBusiModel]
        else {
            fail(errType: AINetError.Format, errDes: AINetErrorDescription.FormatError)
            return
        }
        var serviceInsts = [IconServiceIntModel]()
        for iconServiceInst: AIServiceInstBusiModel in iconServiceInsts {
            guard let serviceInstId = iconServiceInst.id,
                serviceIcon = iconServiceInst.icon,
                executeProgress = iconServiceInst.progress
                else{
                    fail(errType: AINetError.Format, errDes: AINetErrorDescription.FormatError)
                    return
            }
            let serviceInst = IconServiceIntModel(serviceInstId: Int(serviceInstId)!, serviceIcon: serviceIcon, serviceInstStatus: ServiceInstStatus.Assigned, executeProgress: Int(executeProgress))
            serviceInsts.append(serviceInst)
        }
        viewModel.unConfirmMessageNumber = Int(busiModel.un_confirms ?? 0)
        viewModel.unReadMessageNumber = Int(busiModel.un_read_messages ?? 0)
        viewModel.serviceName = serviceName
        viewModel.serviceIcon = serviceIcon
        viewModel.completion = Float(busiModel.progress ?? 0)
        viewModel.price = priceModel
        viewModel.serviceInsts = serviceInsts
    }
    
    /**
     查询消费者时间线列表
     
     - parameter serviceInstId: <#serviceInstId description#>
     - parameter success:       <#success description#>
     - parameter fail:          <#fail description#>
     */
    func queryCustomerTimelineList(orderId: NSString, serviceInstIds: NSArray, filterType: NSNumber, success: (viewModel: [AITimelineViewModel]) -> Void, fail: (errType: AINetError, errDes: String) -> Void) {
        
        let message = AIMessage()
        let body = ["data": ["service_inst_id": serviceInstIds, "order_id": orderId, "filter_type": filterType],
                    "desc": ["data_mode": "0", "digest": ""]
        ]
        message.body.addEntriesFromDictionary(body as [NSObject: AnyObject])
        message.url = AIApplication.AIApplicationServerURL.queryBusinessInfo.description as String
        
        weak var weakSelf = self
        
        AINetEngine.defaultEngine().postMessage(message, success: { (response) -> Void in
            do {
                let dic = response as! [NSObject: AnyObject]
                let originalRequirements = try AIServiceInstBusiModel(dictionary: dic)
                weakSelf!.parseTimelineToViewModel(originalRequirements, success: success, fail: fail)
            } catch {
                fail(errType: AINetError.Format, errDes: AINetErrorDescription.FormatError)
            }
        }) { (error: AINetError, errorDes: String!) -> Void in
            fail(errType: error, errDes: errorDes)
        }
    }
    
    func parseTimelineToViewModel(busiModel: AIServiceInstBusiModel, success: (viewModel: [AITimelineViewModel]) -> Void, fail: (errType: AINetError, errDes: String) -> Void) {
    }
}
