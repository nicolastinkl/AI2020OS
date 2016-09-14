//
//  AIAnalyticsDefines.swift
//  AIVeris
//
//  Created by 王坜 on 16/9/13.
//  Copyright © 2016年 ___ASIAINFO___. All rights reserved.
//

import UIKit

enum AIAnalyticsEvent: String {
    case SaveAsTaskEvent
    /// 给卖家留言
    case LeaveMessage
}

enum AIAnalyticsKeys: String {
    // common
    case CurrentPageName
    case PartyID
    case Date
    
    // 卖家留言
    case OfferingId
    case URL
    case Text
}
