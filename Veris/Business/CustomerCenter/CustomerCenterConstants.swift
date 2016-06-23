//
//  CustomerCenterConstants.swift
//  AIVeris
//
//  Created by 刘先 on 16/6/21.
//  Copyright © 2016年 ___ASIAINFO___. All rights reserved.
//

import Foundation

struct CustomerCenterConstants {
    struct Colors {
        static let TimeLabelColor = UIColor(hex: "#dcd6e2")
        static let TimelineDotColor = UIColor(hex: "#b8b5c0")
        static let ConfirmButton = UIColor(hex: "#0f86e8")
    }
    
    struct Fonts {
        static let TimeLabelNormal = AITools.myriadLightSemiCondensedWithSize(AITools.displaySizeFrom1080DesignSize(42))
        static let TimelineButton = AITools.myriadLightSemiCondensedWithSize(AITools.displaySizeFrom1080DesignSize(48))
    }
    
    struct textContent {
        static let confirmButton = "确认完成"
    }
    
    struct defaultImages {
        static let timelineImage = UIImage()
        static let ServiceExecAllSelect = UIImage(named: "service_execute_all_select")
        static let ServiceExecAllUnSelect = UIImage(named: "service_execute_all_unselect")
        static let ServiceExecAlertSelect = UIImage(named: "service_execute_alert_select")
        static let ServiceExecAlertUnSelect = UIImage(named: "service_execute_alert_unselect")
        static let ServiceExecConfirmSelect = UIImage(named: "service_execute_confirm_select")
        static let ServiceExecConfirmUnSelect = UIImage(named: "service_execute_confirm_unselect")
    }
}
