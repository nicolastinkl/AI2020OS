//
//  AIStorage.swift
//  AI2020OS
//
//  Created by tinkl on 29/5/15.
//  Copyright (c) 2015 ___ASIAINFO___. All rights reserved.
//

import Foundation
import AwesomeCache

private let sharedInstance = AIIMStorage()
  
class AIIMStorage: NSObject {
    
    // MARK: create singlon object
    class var sharedManager : AIIMStorage {
        return sharedInstance
    }
    
    func getRooms() -> NSArray {
        return NSArray()
    }
    
    func cacheUserByIds(userIds:NSSet,block:AVBooleanResultBlock){
        let cache = Cache<NSString>(name: "AIIMUSERINFOMATIONCache")
        
        let allUESRIDS: String = userIds.allObjects.reduce(""){
            one , two in
            return "\(one)+\(two)"
        }
        cache.setObject(allUESRIDS, forKey: "USERIDS", expires: .Never)
        block(true,nil)
    }
    
}
