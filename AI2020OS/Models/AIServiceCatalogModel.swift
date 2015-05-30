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
    var catalogArray = Array<AICatalogItemModel>()
    init() {

    }
    
    init(_ decoder: JSONDecoder) {
        
        if var jsonArray = decoder["catalog_list"].array {
            catalogArray = Array<AICatalogItemModel>()
            for subDecoder in jsonArray {
                catalogArray.append(AICatalogItemModel(subDecoder))
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
        var id = decoder["catalog_id"].integer
        catalog_id = decoder["catalog_id"].integer
        var name = decoder["catalog_name"].string
        catalog_name = decoder["catalog_name"].string
    }
}