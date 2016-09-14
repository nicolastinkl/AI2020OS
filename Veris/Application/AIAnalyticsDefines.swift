//
//  AIAnalyticsDefines.swift
//  AIVeris
//
//  Created by 王坜 on 16/9/13.
//  Copyright © 2016年 ___ASIAINFO___. All rights reserved.
//

import UIKit

enum AIAnalyticsEvent: String {
    ///
    case PageShow
    case SaveAsTaskEvent
    /// 给卖家留言
    case LeaveMessage
    
    /// 搜索服务
    case SearchService
    case FilterSearch
    
    /// 点击浏览历史
    case HistoryIconClick
    /// 点击推荐服务
    case RecommendIconClick
    
    /// 自由定制
    case DelServiceOptInfo
    case AddServiceOptInfo
    /// 查看多服务详情
    case ViewServiceDetail = "serviceDetailBrowseInfo"
}

enum AIAnalyticsKeys: String {
    // common
    case ClassName = "pageMark"
    case Title = "title"
    case PartyID = "partyID"
    case Date = "date"
    
    // 卖家留言
    case OfferingId = "offeringId"
    case URL = "url"
    case Text = "text"
    case ProposalId = "proposalId"
    
    /// 搜索服务
    case Keyword = "keyword"
    case ServiceId = "serviceId"
    
    /// 抢单
    case ProviderId
    case CustomerId
    case ServiceInstanceID
    case ServiceID
}
