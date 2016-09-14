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
    
    case HistoryIconClick
    case RecommendIconClick
}

enum AIAnalyticsKeys: String {
    // common
    case ClassName
    case Title
    case PartyID
    case Date
    
    // 卖家留言
    case OfferingId
    case URL
    case Text
    /// 搜索服务
    case Keyword
    
}
