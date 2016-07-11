//
//  AICustomerServiceExecuteModel.swift
//  AIVeris
//
//  Created by 刘先 on 16/6/21.
//  Copyright © 2016年 ___ASIAINFO___. All rights reserved.
//

import Foundation

class AITimelineViewModel: AIBaseViewModel {
    var itemId: String?
    var layoutType: AITimelineLayoutTypeEnum?
    var timeModel: AIDateTimeViewModel?
    var desc: String?
    var contents: [AITimeContentViewModel]?
    var cellHeight: CGFloat = 0
    
    class func createFakeData(itemId: String) -> AITimelineViewModel {
        let timelineViewModel = AITimelineViewModel()
        timelineViewModel.itemId = itemId
        timelineViewModel.layoutType = AITimelineLayoutTypeEnum.ConfirmServiceComplete
        timelineViewModel.desc = "陪护人员已完成挂号任务"
        let timeModel = AIDateTimeViewModel()
        timeModel.date = "6-20"
        timeModel.time = "\(16 + Int(itemId)!):10"
        timelineViewModel.timeModel = timeModel
        
        let contentViewModel = [AITimeContentViewModel(contentType: AITimelineContentTypeEnum.Image, contentUrl: "http://tinkl.qiniudn.com/tinklUpload_newimage/imageview-01.png"), AITimeContentViewModel(contentType: AITimelineContentTypeEnum.Voice, contentUrl: "https://dn-xkz4nhs9.qbox.me/jeltYtKqE6fVQIUSbz04SbB.aac")]
        timelineViewModel.contents = contentViewModel
        return timelineViewModel
    }
    
    class func createFakeDataOrderComplete(itemId: String) -> AITimelineViewModel {
        let timelineViewModel = AITimelineViewModel()
        timelineViewModel.itemId = itemId
        timelineViewModel.layoutType = AITimelineLayoutTypeEnum.ConfirmOrderComplete
        timelineViewModel.desc = "订单服务已完成"
        let timeModel = AIDateTimeViewModel()
        timeModel.date = "6-20"
        timeModel.time = "\(16 + Int(itemId)!):10"
        timelineViewModel.timeModel = timeModel
        return timelineViewModel
    }
}

class AIDateTimeViewModel: AIBaseViewModel {
    var date: String?
    var time: String?
    var isNow = false
    var shouldShowDate = false
}

class AITimeContentViewModel: AIBaseViewModel {
    var contentType: AITimelineContentTypeEnum?
    var contentUrl: String?
    
    init(contentType: AITimelineContentTypeEnum, contentUrl: String) {
        self.contentType = contentType
        self.contentUrl = contentUrl
    }
}

/// 客户订单列表视图
class AICustomerOrderViewModel: AIBaseViewModel {
    
}

class AICustomerOrderDetailTopViewModel: AIBaseViewModel {
    var serviceIcon: String!
    var serviceName: String!
    var serviceDesc: String!
    var completion: Float!
    var price: String!
    var messageNumber: Int?
}

/// 客户订单服务实例视图
class AICustomerServInstViewModel: AIBaseViewModel {
    
}

// MARK: -> enums
enum AITimelineLayoutTypeEnum: Int {
    case Normal = 1, Authoration, ConfirmServiceComplete, ConfirmOrderComplete, Now
}

enum AITimelineContentTypeEnum: Int {
    case Image = 1, Voice, LocationMap
}
