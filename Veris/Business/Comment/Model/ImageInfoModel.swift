//
//  ImageInfoModel.swift
//  AIVeris
//
//  Created by Rocky on 16/7/26.
//  Copyright © 2016年 ___ASIAINFO___. All rights reserved.
//

import Foundation
import UIKit

class ImageInfo {
    var image: UIImage?
    var url: NSURL?
    var imageId: String?
    
    init(image: UIImage, url: NSURL?) {
        self.image = image
        self.url = url
        
        if let url = url {
            let len = url.absoluteString!.length
            
            var randomStr = ""
            for _ in 1...4 {
                let random = (Int(arc4random()) % len)
                
                randomStr += "\(random)"
            }
            
            imageId = url.absoluteString! + randomStr
        }
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
