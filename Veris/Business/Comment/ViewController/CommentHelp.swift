//
//  CommentUtils.swift
//  AIVeris
//
//  Created by Rocky on 16/6/17.
//  Copyright © 2016年 ___ASIAINFO___. All rights reserved.
//

import Foundation

class CommentUtils {
    private static let idPrefix = "CommentViewModel_"
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
        
        let key = createSearchKey(serviceId)
        
        if let data = defa.objectForKey(key) as? NSData {
            return NSKeyedUnarchiver.unarchiveObjectWithData(data) as? ImageInfoPList
        }
        
        return nil
    }
    
    class func saveCommentImageInfo(serviceId: String, info: ImageInfoPList) -> Bool {
        
        let defa = NSUserDefaults.standardUserDefaults()
        
        let data = NSKeyedArchiver.archivedDataWithRootObject(info)
        
        defa.setObject(data, forKey: createSearchKey(serviceId))
        return defa.synchronize()
    }
    
    class func getCommentModelFromLocal(serviceId: String) -> ServiceCommentLocalSavedModel? {
        let defa = NSUserDefaults.standardUserDefaults()
        
        let key = createSearchKey(serviceId)
        
        if let data = defa.objectForKey(key) as? NSData {
            return NSKeyedUnarchiver.unarchiveObjectWithData(data) as? ServiceCommentLocalSavedModel
        }
        
        return nil
    }
    
    class func saveCommentModelToLocal(serviceId: String, model: ServiceCommentLocalSavedModel) -> Bool {
        
        let defa = NSUserDefaults.standardUserDefaults()
        
        let data = NSKeyedArchiver.archivedDataWithRootObject(model)
        
        defa.setObject(data, forKey: createSearchKey(serviceId))
        return defa.synchronize()
    }
    
    private class func createSearchKey(serviceId: String) -> String {
        return idPrefix + serviceId
    }
    
    
}
