//
//  ServiceCatalogModel.swift
//  AI2020OS
//
//  Created by admin on 15/5/29.
//  Copyright (c) 2015年 ___ASIAINFO___. All rights reserved.
//

import Foundation
import JSONJoy

//订单列表model
struct AICatalogListModel : JSONJoy {
    var catalogArray: Array<AICatalogItemModel>?
    init(_ decoder: JSONDecoder) {
        if let addrs = decoder.array {
            catalogArray = Array<AICatalogItemModel>()
            for item in addrs {
                catalogArray?.append(AICatalogItemModel(item))
            }
        }
    }
}

//订单列表项model
struct AICatalogItemModel : JSONJoy{

    var catalog_id : Int?
    var catalog_name : String?
    
    init(){
        
    }
    
    init(_ decoder: JSONDecoder) {
        catalog_id = decoder["order_id"].integer
        catalog_name = decoder["order_number"].string
    }
}