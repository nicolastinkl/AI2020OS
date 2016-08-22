//
//  ProposalOrderViewModel.swift
//  AIVeris
//
//  Created by Rocky on 16/7/29.
//  Copyright © 2016年 ___ASIAINFO___. All rights reserved.
//

import Foundation


class ProposalOrderViewModel {
    var isExpanded: Bool = false
    var model: ProposalOrderModel!
    //订单展开内容viewModel
    var timelineViewModels: [AITimelineViewModel]?
    
    init() {
        
    }
    
    init(model: ProposalOrderModel) {
        self.model = model
        parseAITimelineViewModel()
    }
    
    func parseAITimelineViewModel() {
        timelineViewModels = Array<AITimelineViewModel>()
        for service: ServiceOrderModel in model.service as! [ServiceOrderModel] {
            guard let
                timeline = service.node,
                itemId = timeline.procedure_inst_id,
                layoutType = timeline.procedure_inst_type,
                desc = timeline.procedure_inst_name,
                timeValue = timeline.time_value,
                //commentStatus = timeline.comment_status,
                contentsBusiModel = timeline.attchments as? [AITimelineContentBusiModel]
                else {
                    //TODO: 这里应该抛出错误
                    //fail(errType: AINetError.Format, errDes: AINetErrorDescription.FormatError)
                    AILog("ServiceOrderModel format error! \(service.toJSONString())")
                    return
            }
            //创建viewModel
            let viewModel = AITimelineViewModel()
            viewModel.itemId = itemId
            viewModel.layoutType = AITimelineLayoutTypeEnum(rawValue: Int(layoutType)!)
            viewModel.operationType = AITimelineOperationTypeEnum(rawValue: Int(timeline.comment_status ?? 1))
            viewModel.desc = desc
            viewModel.timeModel = AIDateTimeViewModel.timestampToTimeViewModel(timeValue)
            //时间线内容
            var contents = [AITimeContentViewModel]()
            for contentBusiModel: AITimelineContentBusiModel in contentsBusiModel {
                guard let contentType = contentBusiModel.type
                    else {
                        //fail(errType: AINetError.Format, errDes: AINetErrorDescription.FormatError)
                        return
                }
                let contentUrl = contentBusiModel.content
                let content = AITimeContentViewModel(contentType: AITimelineContentTypeEnum(rawValue: Int(contentType)!)!, contentUrl: contentUrl)
                //如果有gps信息的话
                if let gpsBusiModel = contentBusiModel.map {
                    let gpsViewModel = AIGPSViewModel()
                    gpsViewModel.locType = gpsBusiModel.type
                    gpsViewModel.latitude = Double(gpsBusiModel.latitude)
                    gpsViewModel.longitude = Double(gpsBusiModel.longitude)
                    content.location = gpsViewModel
                }
                contents.append(content)
            }
            viewModel.contents = contents
            timelineViewModels?.append(viewModel)
        }
    }
}
