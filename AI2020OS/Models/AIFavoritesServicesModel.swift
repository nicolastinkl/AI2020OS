//
//  AIFavoritesServicesModel.swift
//  AI2020OS
//
//  Created by Rocky on 15/6/12.
//  Copyright (c) 2015年 ___ASIAINFO___. All rights reserved.
//

import Foundation
import JSONJoy

struct AIFavoritesServicesResult: JSONJoy {
    var services = [AIServiceTopicModel]()

    init() {
        
    }
    
    init(_ decoder: JSONDecoder) {
        if var jsonArray = decoder["collected_services"].array {
            for subDecoder in jsonArray {
                services.append(AIServiceTopicModel(subDecoder))
            }
        }
    }

}