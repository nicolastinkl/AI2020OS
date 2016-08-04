//
//  ServiceCommentViewModel.swift
//  AIVeris
//
//  Created by Rocky on 16/7/27.
//  Copyright © 2016年 ___ASIAINFO___. All rights reserved.
//

import Foundation

class ServiceCommentLocalSavedModel: NSObject, NSCoding {
    var imageInfos = [ImageInfoModel]()
    var serviceId = ""
    var text: String?
    var changed = false
    var isAppend = false
    
    func encodeWithCoder(coder: NSCoder) {
        
        coder.encodeObject(imageInfos, forKey: "imageInfos")
        
        if let t = text {
            coder.encodeObject(t, forKey: "text")
        }
        
        coder.encodeObject(serviceId, forKey: "serviceId")
    }
    
    required convenience init(coder aDecoder: NSCoder) {
        self.init()
        
        serviceId = aDecoder.decodeObjectForKey("serviceId") as! String
        imageInfos = aDecoder.decodeObjectForKey("imageInfos") as! NSArray as! [ImageInfoModel]
        text = aDecoder.decodeObjectForKey("text") as? String
    }
}

class ImageInfoModel: NSObject, NSCoding {
    var imageId = ""
    var url: NSURL?
    var isSuccessUploaded = false
    var uploadFinished = true
    var serviceId: String?
    
    func encodeWithCoder(aCoder: NSCoder) {
        aCoder.encodeObject(imageId, forKey: "imageId")
        aCoder.encodeObject(url, forKey: "url")
        aCoder.encodeBool(isSuccessUploaded, forKey: "isSuccessUploaded")
    }
    
    required init(coder aDecoder: NSCoder) {
        super.init()
        imageId = aDecoder.decodeObjectForKey("imageId") as! String
        url = aDecoder.decodeObjectForKey("url") as? NSURL
        isSuccessUploaded = aDecoder.decodeBoolForKey("isSuccessUploaded")
    }
    
    init(url: NSURL?) {
        self.url = url
    }
    
    override init() {
        
    }
}
