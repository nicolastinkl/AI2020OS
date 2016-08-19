//
//  ServiceCommentViewModel.swift
//  AIVeris
//
//  Created by Rocky on 16/7/27.
//  Copyright © 2016年 ___ASIAINFO___. All rights reserved.
//

import Foundation

class ServiceCommentLocalSavedModel: NSObject, NSCoding, NSCopying {
    var imageInfos = [ImageInfoModel]()
    var serviceId = ""
    var text: String?
    var starValue: CGFloat = 0
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
    
    func copyWithZone(zone: NSZone) -> AnyObject {
        let copy = ServiceCommentLocalSavedModel()
        copy.imageInfos = imageInfos
        copy.serviceId = serviceId
        copy.text = text
        copy.changed = changed
        copy.isAppend = isAppend
        return copy
    }
}

class ImageInfoModel: NSObject, NSCoding {
    var imageId = ""
    var localUrl: NSURL?
    var webUrl: NSURL?
    var isSuccessUploaded = false
    var uploadFinished = true
    var serviceId: String?
    var isCurrentCreate = false
    
    func encodeWithCoder(aCoder: NSCoder) {
        aCoder.encodeObject(imageId, forKey: "imageId")
        aCoder.encodeObject(localUrl, forKey: "url")
        aCoder.encodeObject(webUrl, forKey: "webUrl")
        aCoder.encodeBool(isSuccessUploaded, forKey: "isSuccessUploaded")
    }
    
    required init(coder aDecoder: NSCoder) {
        super.init()
        imageId = aDecoder.decodeObjectForKey("imageId") as! String
        localUrl = aDecoder.decodeObjectForKey("url") as? NSURL
        webUrl = aDecoder.decodeObjectForKey("webUrl") as? NSURL
        isSuccessUploaded = aDecoder.decodeBoolForKey("isSuccessUploaded")
    }
    
    init(url: NSURL?) {
        self.localUrl = url
    }
    
    override init() {
        
    }
}
