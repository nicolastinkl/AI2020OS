//
//  AITagModel.swift
//  AI2020OS
//
//  Created by admin on 15/6/15.
//  Copyright (c) 2015年 ___ASIAINFO___. All rights reserved.
//

import Foundation

import JSONJoy

class AITagModel: JSONJoy {
    var id: Int?
    var tag_name: String?
    
    init() {
        id = 1
    }
    
    required init(_ decoder: JSONDecoder) {
        
    }
    
    func toJson() -> String{
        var dicData: NSMutableDictionary = NSMutableDictionary()
        if id != nil {
            dicData.setValue(id!, forKey: "tag_id")
        }
        
        if tag_name != nil {
            dicData.setValue(tag_name!, forKey: "tag_name")
        }

        if let jsonData = NSJSONSerialization.dataWithJSONObject(dicData, options: NSJSONWritingOptions.PrettyPrinted, error: nil) {
            var jsonStr = NSString(data: jsonData, encoding: NSUTF8StringEncoding)
            return NSString(data: jsonData, encoding: NSUTF8StringEncoding) as String
        }
        return ""
    }
    
}
