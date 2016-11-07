//
//  AIFundManageModel.swift
//  AIVeris
//
//  Created by asiainfo on 11/4/16.
//  Copyright © 2016 ___ASIAINFO___. All rights reserved.
//

import Foundation

class AIFundManageModel: JSONJoy {
    
    let total_income_amout: Int?
    let total_income_unit: String?
    
    let total_wait_pay_amout: Int?
    let total_wait_pay_unit: String?
    
    let total_wait_collection_amout: Int?
    let total_wait_collection_unit: String?
    
    
    var drawers = Array<AIFundManageModelDrawer>()
    
    required init(_ decoder: JSONDecoder) {
        
        total_income_amout = decoder["total_income"]["amount"].integer ?? 0
        total_income_unit = decoder["total_income"]["unit"].string ?? ""
        total_wait_pay_amout = decoder["total_wait_pay"]["amount"].integer ?? 0
        total_wait_pay_unit = decoder["total_wait_pay"]["unit"].string ?? ""
        total_wait_collection_amout = decoder["total_wait_collection"]["amount"].integer ?? 0
        total_wait_collection_unit = decoder["total_wait_collection"]["unit"].string ?? ""
        
        if let addrs = decoder["drawers"].array {
            for addrDecoder in addrs {
                drawers.append(AIFundManageModelDrawer(addrDecoder))
            }
        }
    }
    
}

class AIFundManageModelDrawer: JSONJoy {
    let id: Int?
    let icon: String?
    let desc: String?
    let amout: Int?
    let unit: String?
    
    required init(_ decoder: JSONDecoder) {
        
        id = decoder["id"].integer ?? 0
        amout = decoder["amount"].integer ?? 0
        icon = decoder["icon"].string ?? ""
        desc = decoder["desc"].string ?? ""
        unit = decoder["unit"].string ?? ""
    }
    
}
