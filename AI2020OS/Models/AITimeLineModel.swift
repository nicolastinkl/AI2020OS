//
//  AITimeLineModel.swift
//  AI2020OS
//
//  Created by admin on 8/13/15.
//  Copyright (c) 2015 ___ASIAINFO___. All rights reserved.
//

import Foundation
import JSONJoy

class AITimeLineModel: JSONJoy {
    var  Id: Int?
    var currentTimeStamp: Double?
    var title: String?
    var content: String?
    var type: Int?
    
    init() {
        //["currentTimeStamp":"1439436741","title":"瑞士凯斯瑜伽课","content":"Jeeny老师|印度特色课"],
    }
    
    required init(_ decoder: JSONDecoder) {
        
    }
    
}
