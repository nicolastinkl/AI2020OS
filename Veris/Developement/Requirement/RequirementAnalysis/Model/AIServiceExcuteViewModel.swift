//
//  AIServiceExcuteModel.swift
//  AIVeris
//
//  Created by 刘先 on 16/5/10.
//  Copyright © 2016年 ___ASIAINFO___. All rights reserved.
//

import Foundation

//MARK: - view模型
class AIIconLabelViewModel: AIBaseViewModel {
    var labelText: String
    var iconUrl: String
    
    init(labelText: String, iconUrl: String) {

        self.labelText = labelText
        self.iconUrl = iconUrl
    }
}

class AIGrabOrderDetailViewModel: AIBaseViewModel {
    
    var serviceName: String
    var serviceThumbnailIcon: String
    var serviceIntroContent: String
    var customerName: String
    var customerIcon: String
    var customerParamArray: Array<AIIconLabelViewModel>?
    
    init(serviceName: String, serviceThumbnailIcon: String, serviceIntroContent: String, customerName: String, customerIcon: String) {

        self.serviceName = serviceName
        self.serviceThumbnailIcon = serviceThumbnailIcon
        self.serviceIntroContent = serviceIntroContent
        self.customerName = customerName
        self.customerIcon = customerIcon
    }
    
    class func getInstanceByJSONModel(jsonModel: AIGrabOrderDetailModel) -> AIGrabOrderDetailViewModel {
        let viewModel = AIGrabOrderDetailViewModel(serviceName: jsonModel.service.service_name, serviceThumbnailIcon: jsonModel.service.service_thumbnail_icon, serviceIntroContent: jsonModel.service.service_intro, customerName: jsonModel.customer.user_name, customerIcon: jsonModel.customer.user_portrait_icon)
        var customerParamArray = Array<AIIconLabelViewModel>()
        let orderParamDic = jsonModel.order as NSDictionary
        let phoneValue = String(orderParamDic.valueForKey("phone")!)
        let addressValue = String(orderParamDic.valueForKey("address")!)
        let iconLabelViewModel1 = AIIconLabelViewModel(labelText: phoneValue, iconUrl: "")
        let iconLabelViewModel2 = AIIconLabelViewModel(labelText: addressValue, iconUrl: "")
        customerParamArray.append(iconLabelViewModel1)
        customerParamArray.append(iconLabelViewModel2)
        viewModel.customerParamArray = customerParamArray
//        for paramModel: AIGrabOrderParamModel in jsonModel.contents as! [AIGrabOrderParamModel] {
//            let iconLabelViewModel = AIIconLabelViewModel(labelText: paramModel.content, iconUrl: paramModel.icon)
//            customerParamArray.append(iconLabelViewModel)
//        }
        return viewModel
    }
}

class AIGrabOrderSuccessViewModel: AIBaseViewModel {
    var grabResult: GrabResultEnum
    var customerName: String?
    var customerIcon: String?
    var customerDesc: String?
    var orderParamArray: Array<AIIconLabelViewModel>?
    //TODO 这里还有一个分析后的心愿单数据，等界面出来后再改
    var desc: String?
    
    init(grabResult: Int) {
       self.grabResult = GrabResultEnum(rawValue: grabResult)!
    }
    
    func setOrderInfoByJSONModel(jsonModel: AIGrabOrderResultModel) {
        
    }
}

// MARK: -> enums
enum GrabResultEnum: Int {
    case Fail = 0, Success
}
