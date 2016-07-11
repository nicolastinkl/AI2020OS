//
//  BDKTools.swift
//  AIVeris
//
//  Created by Rocky on 16/7/11.
//  Copyright © 2016年 ___ASIAINFO___. All rights reserved.
//

import Foundation

class BDKTools {
    static let descBody = ["data_mode": "0", "digest": ""]
    
    class func createRequestBody(dataBody: [String: AnyObject]) -> NSMutableDictionary {
        var body = [String: AnyObject]()
        
        body["data"] = dataBody
        body["desc"] = descBody
        
        return NSMutableDictionary(dictionary: body)
    }
}