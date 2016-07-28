//
//  ServiceCommentViewModel.swift
//  AIVeris
//
//  Created by Rocky on 16/7/27.
//  Copyright © 2016年 ___ASIAINFO___. All rights reserved.
//

import Foundation

class ServiceCommentLocalSavedModel: NSObject, NSCoding {
    var images: [ImageInfo]?
    var serviceId = ""
    var text: String?
    var changed = false
    var isAppend = false
    
    func encodeWithCoder(coder: NSCoder) {
        if let ims = images {
            coder.encodeObject(ims, forKey: "images")
        }
        
        if let t = text {
            coder.encodeObject(t, forKey: "text")
        }
        
        coder.encodeObject(serviceId, forKey: "serviceId")
    }
    
    required convenience init(coder aDecoder: NSCoder) {
        self.init()
        
        serviceId = aDecoder.decodeObjectForKey("serviceId") as! String
        images = aDecoder.decodeObjectForKey("images") as? NSArray as? [ImageInfo]
        text = aDecoder.decodeObjectForKey("text") as? String
    }
}
