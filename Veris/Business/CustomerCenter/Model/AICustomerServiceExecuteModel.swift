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
    
    class func createFakeData(itemId: String) -> AITimelineViewModel {
        let timelineViewModel = AITimelineViewModel()
        timelineViewModel.itemId = itemId
        timelineViewModel.layoutType = AITimelineLayoutTypeEnum.ConfirmServiceComplete
        timelineViewModel.desc = "陪护人员已完成挂号任务"
        let timeModel = AIDateTimeViewModel()
        timeModel.date = "6月20日"
        timeModel.time = "16:10"
        timelineViewModel.timeModel = timeModel
        
        let contentViewModel = [AITimeContentViewModel(contentType: AITimelineContentTypeEnum.Image, contentUrl: "http://tinkl.qiniudn.com/tinklUpload_newimage/imageview-01.png")]
        timelineViewModel.contents = contentViewModel
        return timelineViewModel
    }
}

class AIDateTimeViewModel: AIBaseViewModel {
    var date: String?
    var time: String?
    var isNow: Bool = false
}

class AITimeContentViewModel: AIBaseViewModel {
    var contentType: AITimelineContentTypeEnum?
    var contentUrl: String?
    
    init(contentType: AITimelineContentTypeEnum, contentUrl: String) {
        self.contentType = contentType
        self.contentUrl = contentUrl
    }
}

// MARK: -> enums
enum AITimelineLayoutTypeEnum: Int {
    case Normal = 1, Authoration, ConfirmServiceComplete, ConfirmOrderComplete
}

enum AITimelineContentTypeEnum: Int {
    case Image = 1, Voice, LocationMap
}
