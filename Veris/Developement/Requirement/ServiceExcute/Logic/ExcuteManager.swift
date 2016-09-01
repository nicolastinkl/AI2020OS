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

protocol ExcuteManager {
    func submitServiceNodeResult(nodeId: Int, resultList: [NodeResultContent], success: (responseData: RequestCode) -> Void, fail: (errType: AINetError, errDes: String) -> Void)
}


class BDKExcuteManager: ExcuteManager {
    func submitServiceNodeResult(nodeId: Int, resultList: [NodeResultContent], success: (responseData: RequestCode) -> Void, fail: (errType: AINetError, errDes: String) -> Void) {
        
        let message = AIMessage()
        let url = AIApplication.AIApplicationServerURL.submitServiceNodeResult.description
        message.url = url
        
        let data: [String: AnyObject] = ["procedure_inst_id": nodeId, "note_list": NodeResultContent.arrayOfDictionariesFromModels(resultList)]
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


    //MARK: 抢单结果信息查询
    func queryQaingDanResultInfo(ServiceInstanceID: Int, success: (resultModel: AIQiangDanResultModel) -> Void, fail: net_fail_block) {
        let message = AIMessage()
        message.url = AIApplication.AIApplicationServerURL.queryQiangDanResult.description
        let data: [String: AnyObject] = ["service_instance_id": ServiceInstanceID]
        message.body = BDKTools.createRequestBody(data)

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


}
