//
//  ImageInfoModel.swift
//  AIVeris
//
//  Created by Rocky on 16/7/26.
//  Copyright © 2016年 ___ASIAINFO___. All rights reserved.
//

import Foundation
import UIKit

class ImageInfo: NSObject, NSCoding {
    var image: UIImage?
    var url: NSURL?
    var isUploaded = false
    var serviceId: String?
    var isAppendType = false
    
    func encodeWithCoder(aCoder: NSCoder) {
        //      aCoder.encodeBool(isAppendType, forKey: "isAppendType")
        aCoder.encodeObject(url, forKey: "url")
    }
    
    required init(coder aDecoder: NSCoder) {
        super.init()
        //      isAppendType = aDecoder.decodeBoolForKey("isAppendType")
        url = aDecoder.decodeObjectForKey("url") as? NSURL
    }
    
    init(image: UIImage, url: NSURL?) {
        self.image = image
        self.url = url
    }
    
    override init() {
        
    }
}

class ImageInfoPList: NSObject, NSCoding {
    var firstImages: [ImageInfo]?
    var appendImages: [ImageInfo]?
    
    func encodeWithCoder(coder: NSCoder) {
        if let fis = firstImages {
            coder.encodeObject(fis, forKey: "first")
        }
        
        if let ais = appendImages {
            coder.encodeObject(ais, forKey: "append")
        }
    }
    
    required convenience init(coder aDecoder: NSCoder) {
        
        let fis = aDecoder.decodeObjectForKey("first") as? NSArray as? [ImageInfo]
        let ais = aDecoder.decodeObjectForKey("append") as? NSArray as? [ImageInfo]
        
        self.init(firstImages: fis, appendImages: ais)
    }
    
    
    init(firstImages: [ImageInfo]?, appendImages: [ImageInfo]?) {
        self.firstImages = firstImages
        self.appendImages = appendImages
    }
}