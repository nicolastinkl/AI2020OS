//
//  AIFundManageModel.swift
//  AIVeris
//
//  Created by asiainfo on 11/4/16.
//  Copyright © 2016 ___ASIAINFO___. All rights reserved.
//

import Foundation

//我的钱包首页
class AIFundManageModel: JSONJoy {
    
    let total_income_amout: Int?
    let total_income_unit: String?
    let total_income_items: Int?
    
    let total_wait_pay_amout: Int?
    let total_wait_pay_unit: String?
    let total_wait_pay_items: Int?
    
    let total_wait_collection_amout: Int?
    let total_wait_collection_unit: String?
    let total_wait_collection_items: Int?
    
    var drawers = Array<AIFundManageModelDrawer>()
    
    required init(_ decoder: JSONDecoder) {
        
        total_income_amout = decoder["total_income"]["amout"].integer ?? 0
        total_income_unit = decoder["total_income"]["unit"].string ?? ""
        total_income_items = decoder["total_income"]["items"].integer ?? 0
        
        total_wait_pay_amout = decoder["total_wait_pay"]["amout"].integer ?? 0
        total_wait_pay_unit = decoder["total_wait_pay"]["unit"].string ?? ""
        total_wait_pay_items = decoder["total_wait_pay"]["items"].integer ?? 0
        
        total_wait_collection_amout = decoder["total_wait_collection"]["amout"].integer ?? 0
        total_wait_collection_unit = decoder["total_wait_collection"]["unit"].string ?? ""
        total_wait_collection_items = decoder["total_wait_collection"]["items"].integer ?? 0
        
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
        amout = decoder["amout"].integer ?? 0
        icon = decoder["icon"].string ?? ""
        desc = decoder["desc"].string ?? ""
        unit = decoder["unit"].string ?? ""
    }
    
}


//我的余额
class AIFundBlanceModel: JSONJoy {
    
    let user_head_url: String?
    let user_name: String?
    
    let balance_amout: Int?
    let balance_unit: String?
    
    let withdraw_balance_amout: Int?
    let withdraw_balance_unit: String?
    
    
    required init(_ decoder: JSONDecoder) {
        user_head_url = decoder["head_url"].string ?? ""
        user_name = decoder["name"].string ?? ""
        
        balance_amout = decoder["balance"]["amout"].integer ?? 0
        withdraw_balance_amout = decoder["withdraw_balance"]["amout"].integer ?? 0
        
        balance_unit = decoder["balance"]["unit"].string ?? ""
        withdraw_balance_unit = decoder["withdraw_balance"]["unit"].string ?? ""
        
    }
    
}




//我的待收 和我的待付
class AIFundWillWithDrawModel: JSONJoy {
    
    let id: String?
    let icon: String?
    let name: String?
    let vendor: String?  //商品名称
    let time: Int?
    let price: Double?
    let expire_time: Int?
    let unit: String?
    
    let noticed: String?
    let gender: String?  //付款人性别
    let payer: String?   //付款人姓名
    
    
    required init(_ decoder: JSONDecoder) {
        id = decoder["id"].string ?? ""
        icon = decoder["icon"].string ?? ""
        name = decoder["name"].string ?? ""
        vendor = decoder["vendor"].string ?? ""
        unit = decoder["unit"].string ?? ""
        
        noticed = decoder["noticed"].string ?? ""
        time = decoder["time"].integer ?? 0
        price = decoder["price"].double ?? 0
        expire_time = decoder["expire_time"].integer ?? 0
        
        gender = decoder["gender"].string ?? ""
        payer = decoder["payer"].string ?? ""
    }
}
