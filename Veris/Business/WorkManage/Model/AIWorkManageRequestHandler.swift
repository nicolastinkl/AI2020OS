//
//  AIWorkManagRequestHandler.swift
//  AIVeris
//
//  Created by 刘先 on 10/9/16.
//  Copyright © 2016 ___ASIAINFO___. All rights reserved.
//

import Foundation

class AIWorkManageRequestHandler: NSObject {
    
    struct AINetErrorDescription {
        static let FormatError = "BusinessModel data error."
        static let BusinessError = "Backend data error."
        static let BusinessFail = "Backend business fail."
    }
    
    //单例变量
    static let sharedInstance = AIWorkManageRequestHandler()
    
    /**
     查询工作机会详情
     
     - parameter workId:  工作机会id
     - parameter success:
     - parameter fail:
     */
    func queryWorkOpportunity(workId: NSString, success: (busiModel: AIWorkOpportunityBusiModel) -> Void, fail: (errType: AINetError, errDes: String) -> Void) {
        
        let message = AIMessage()
        let body = ["data": ["work_id": workId], "desc": ["data_mode": "0", "digest": ""]]
        message.body.addEntriesFromDictionary(body as [NSObject: AnyObject])
        message.url = AIApplication.AIApplicationServerURL.queryWorkOpportunity.description as String
        
        //weak var weakSelf = self
        
        AINetEngine.defaultEngine().postMessage(message, success: { (response) -> Void in
            do{
                let dic = response as! [NSObject: AnyObject]
                let originalRequirements = try AIWorkOpportunityBusiModel(dictionary: dic)
                originalRequirements.work_id = workId as String
                success(busiModel: originalRequirements)
            } catch {
                fail(errType: AINetError.Format, errDes: AINetErrorDescription.FormatError)
            }
        }) { (error: AINetError, errorDes: String!) -> Void in
            fail(errType: error, errDes: errorDes)
        }
    }
    
    /**
     查询工作机会资质列表
     
     - parameter workId:  工作机会id
     - parameter success:
     - parameter fail:
     */
    func queryWorkQualification(workId: NSString, success: (busiModel: AIWorkQualificationsBusiModel) -> Void, fail: (errType: AINetError, errDes: String) -> Void) {
        
        let message = AIMessage()
        let body = ["data": ["work_id": workId], "desc": ["data_mode": "0", "digest": ""]]
        message.body.addEntriesFromDictionary(body as [NSObject: AnyObject])
        message.url = AIApplication.AIApplicationServerURL.getWorkQualification.description as String
        
        //weak var weakSelf = self
        
        AINetEngine.defaultEngine().postMessage(message, success: { (response) -> Void in
            do{
                let dic = response as! [NSObject: AnyObject]
                let originalRequirements = try AIWorkQualificationsBusiModel(dictionary: dic)
                success(busiModel: originalRequirements)
//                let dic = response as! [AnyObject]
//                if let model = AIWorkQualificationBusiModel.arrayOfModelsFromDictionaries(dic) as? NSArray {
//                    let models = AIWorkQualificationsBusiModel()
//                    models.work_qualifications = model as [AnyObject]
//                    success(busiModel: models)
//                }
            } catch {
                fail(errType: AINetError.Format, errDes: AINetErrorDescription.FormatError)
            }
        }) { (error: AINetError, errorDes: String!) -> Void in
            fail(errType: error, errDes: errorDes)
        }
    }

    
    /**
     工作机会详情从业务model转为viewModel
     
     - parameter workOpptunityBusiModel: <#busiModel description#>
     - parameter workQualificationsBusiModel:
     - parameter success:   <#success description#>
     - parameter fail:      <#fail description#>
     */
    func parseWorkBusiModelsToViewModel(workOpptunityBusiModel workOpptunityBusiModel: AIWorkOpportunityBusiModel, workQualificationsBusiModel: AIWorkQualificationsBusiModel, success: (viewModel: AIWorkOpportunityDetailViewModel) -> Void, fail: (errType: AINetError, errDes: String) -> Void) {
        let viewModel = AIWorkOpportunityDetailViewModel()
        guard let _ = workOpptunityBusiModel.work_name,
            _ = workQualificationsBusiModel.work_qualifications
            else {
                fail(errType: AINetError.Failed, errDes: AINetErrorDescription.BusinessFail)
                return
        }
        viewModel.opportunityBusiModel = workOpptunityBusiModel
        viewModel.qualificationsBusiModel = workQualificationsBusiModel
        success(viewModel: viewModel)
    }
    
    /**
     查询工作机会详情
     
     - parameter workId:  工作机会id
     - parameter success:
     - parameter fail:
     */
    func subscribeWorkOpportunity(workId: NSString, success: (resultCode: String) -> Void, fail: (errType: AINetError, errDes: String) -> Void) {
        
        let message = AIMessage()
        let body = ["data": ["work_id": workId], "desc": ["data_mode": "0", "digest": ""]]
        message.body.addEntriesFromDictionary(body as [NSObject: AnyObject])
        message.url = AIApplication.AIApplicationServerURL.subscribeWorkOpportunity.description as String
        
        //weak var weakSelf = self
        
        AINetEngine.defaultEngine().postMessage(message, success: { (response) -> Void in
            do{
                let dic = response as! [NSObject: AnyObject]
                if let resultCode = dic["result_code"] as? String where resultCode == "1" {
                    success(resultCode: resultCode)
                } else {
                    fail(errType: AINetError.Format, errDes: AINetErrorDescription.FormatError)
                }
                
            } catch {
                fail(errType: AINetError.Format, errDes: AINetErrorDescription.FormatError)
            }
        }) { (error: AINetError, errorDes: String!) -> Void in
            fail(errType: error, errDes: errorDes)
        }
    }
}
