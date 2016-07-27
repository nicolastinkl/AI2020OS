//
//  CommentUtils.swift
//  AIVeris
//
//  Created by Rocky on 16/6/17.
//  Copyright © 2016年 ___ASIAINFO___. All rights reserved.
//

import Foundation

class CommentUtils {
    private static let idPrefix = "CommentImage_"
    private static var starDes: [StarDesc]?
    
    static var hasStarDesData: Bool {
        get {
            return starDes != nil
        }
    }
    
    class func setStarDesData(starList: [StarDesc]) {
        starDes = starList  
    }
    
    class func getCommentImageInfo(serviceId: String) -> ImageInfoPList? {
        let defa = NSUserDefaults.standardUserDefaults()
        
        let key = createImageKey(serviceId)
        
        if let data = defa.objectForKey(key) as? NSData {
            return NSKeyedUnarchiver.unarchiveObjectWithData(data) as? ImageInfoPList
        }
        
        return nil
    }
    
    class func saveCommentImageInfo(serviceId: String, info: ImageInfoPList) -> Bool {
        
        let defa = NSUserDefaults.standardUserDefaults()
        
        let data = NSKeyedArchiver.archivedDataWithRootObject(info)
        
        defa.setObject(data, forKey: createImageKey(serviceId))
        return defa.synchronize()
    }
    
    private class func createImageKey(info: ImageInfo) -> String? {
        if let id = info.serviceId {
            return createImageKey(id)
        } else {
            return nil
        }
    }
    
    private class func createImageKey(serviceId: String) -> String {
        return idPrefix + serviceId
    }
    
    
}
