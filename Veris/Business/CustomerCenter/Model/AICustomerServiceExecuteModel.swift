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
    //提交所需的一系列标示
    var orderId: String?
    var orderItemId: String?
    var serviceInstanceId: String?
    //提交所需的一系列标示 end
    var layoutType: AITimelineLayoutTypeEnum?
    var operationType: AITimelineOperationTypeEnum?
    var timeModel: AIDateTimeViewModel?
    var desc: String?
    var contents: [AITimeContentViewModel]?
    //用于tableViewCell的高度
    var cellHeight: CGFloat = 0
    //队列中的index
    var index: Int?
    //里面内容的高度，可能会单独使用
    var contentContainerHeight: CGFloat = 0
    
    class func createFakeData(itemId: String) -> AITimelineViewModel {
        let timelineViewModel = AITimelineViewModel()
        timelineViewModel.itemId = itemId
        timelineViewModel.layoutType = AITimelineLayoutTypeEnum.ConfirmServiceComplete
        timelineViewModel.operationType = AITimelineOperationTypeEnum(rawValue: 2)
        timelineViewModel.desc = "陪护人员已完成挂号任务"
        let timeModel = AIDateTimeViewModel()
        timeModel.date = "7-11"
        timeModel.time = "\(16 + Int(itemId)!):10"
        timelineViewModel.timeModel = timeModel
        
        let contentViewModel = [AITimeContentViewModel(contentType: AITimelineContentTypeEnum.Image, contentUrl: "http://tinkl.qiniudn.com/tinklUpload_newimage/imageview-01.png"), AITimeContentViewModel(contentType: AITimelineContentTypeEnum.Voice, contentUrl: "https://dn-xkz4nhs9.qbox.me/jeltYtKqE6fVQIUSbz04SbB.aac")]
        timelineViewModel.contents = contentViewModel
        return timelineViewModel
    }
    
    class func createFakeDataOrderComplete(itemId: String) -> AITimelineViewModel {
        let timelineViewModel = AITimelineViewModel()
        timelineViewModel.itemId = itemId
        timelineViewModel.operationType = AITimelineOperationTypeEnum(rawValue: 2)
        timelineViewModel.layoutType = AITimelineLayoutTypeEnum.ConfirmOrderComplete
        timelineViewModel.desc = "订单服务已完成"
        let timeModel = AIDateTimeViewModel()
        timeModel.date = "7-13"
        timeModel.time = "\(16 + Int(itemId)!):10"
        timelineViewModel.timeModel = timeModel
        return timelineViewModel
    }
    
    class func createFakeDataLocation(itemId: String) -> AITimelineViewModel {
        let timelineViewModel = AITimelineViewModel()
        timelineViewModel.itemId = itemId
        timelineViewModel.layoutType = AITimelineLayoutTypeEnum.Normal
        timelineViewModel.desc = "孕妈专车将在5分钟到达"
        let timeModel = AIDateTimeViewModel()
        timeModel.date = "7-14"
        timeModel.time = "\(16 + Int(itemId)!):10"
        timelineViewModel.timeModel = timeModel
        
        let contentViewModel = [AITimeContentViewModel(contentType: AITimelineContentTypeEnum.LocationMap, contentUrl: "http://tinkl.qiniudn.com/tinklUpload_newimage/imageview-01.png")]
        timelineViewModel.contents = contentViewModel
        return timelineViewModel
    }
    
    class func createFakeDataAuthoration(itemId: String) -> AITimelineViewModel {
        let timelineViewModel = AITimelineViewModel()
        timelineViewModel.itemId = itemId
        timelineViewModel.layoutType = AITimelineLayoutTypeEnum.Authoration
        timelineViewModel.desc = "陪护人员需要您授权使用取号二维码，来完成排队工作。"
        let timeModel = AIDateTimeViewModel()
        timeModel.date = "7-14"
        timeModel.time = "\(16 + Int(itemId)!):10"
        timelineViewModel.timeModel = timeModel
        
        let contentViewModel = [AITimeContentViewModel(contentType: AITimelineContentTypeEnum.Image, contentUrl: "http://www.ai2020lab.com/qrcode.png")]
        timelineViewModel.contents = contentViewModel
        return timelineViewModel
    }
}

class AIDateTimeViewModel: AIBaseViewModel {
    var date: String?
    var time: String?
    var isNow = false
    var shouldShowDate = false
    
    class func timestampToTimeViewModel(timeValue: NSNumber) -> AIDateTimeViewModel {
        let doubleValue = timeValue.doubleValue / 1000
        let date = NSDate(timeIntervalSince1970: doubleValue)
        let timeViewModel = AIDateTimeViewModel()
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "MM月dd日"
        timeViewModel.date = dateFormatter.stringFromDate(date)
        dateFormatter.dateFormat = "HH:mm"
        timeViewModel.time = dateFormatter.stringFromDate(date)
        return timeViewModel
    }
}

/// 地图坐标模型
class AIGPSViewModel: AIBaseViewModel {
    var locType: String?
    var longitude: Double?
    var latitude: Double?
}

class AITimeContentViewModel: AIBaseViewModel {
    var contentType: AITimelineContentTypeEnum?
    var contentUrl: String?
    var location: AIGPSViewModel?
    init(contentType: AITimelineContentTypeEnum, contentUrl: String?) {
        self.contentType = contentType
        self.contentUrl = contentUrl
    }
}

class AICustomerOrderDetailTopViewModel: AIBaseViewModel {
    var serviceIcon: String!
    var serviceName: String!
    var serviceDesc: String!
    var completion: Float!
    var price: String!
    var messageNumber: Int?
    var serviceInsts: [IconServiceIntModel]?
    var unReadMessageNumber: Int?
    var unConfirmMessageNumber: Int?
}

// MARK: -> enums
enum AITimelineLayoutTypeEnum: Int {
    case Normal = 1, Authoration = 2, ConfirmServiceComplete = 3, ConfirmOrderComplete = 4, Now = 5
}

enum AITimelineContentTypeEnum: Int {
    case Image = 1, Voice, LocationMap
}

enum AITimelineFilterTypeEnum: Int {
    case showAll = 1, showNotice, showAction
}

//按钮操作类型  1.未确认，2，已确认，3.已评论
enum AITimelineOperationTypeEnum: Int {
    case unConfirm = 1, confirmed, commentted
}
