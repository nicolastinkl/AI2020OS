//
//  AIIMCenter.swift
//  AI2020OS
//
//  Created by tinkl on 28/5/15.
//  Copyright (c) 2015 ___ASIAINFO___. All rights reserved.
//

import Foundation

enum AIIMConversationType:Int{
    case AIIMConversationTypeLeanCloud = 1
    case AIIMConversationTypeAsiaInfo = 2
}

private let sharedInstance = AIIMCenter(AIIMConversationType.AIIMConversationTypeLeanCloud)

/*!
*  @author tinkl, 15-05-28 17:05:02
*
*  this leanCloud message receive and send center.
*/
class AIIMCenter {
    
    // MARK: create singlon object
    class var sharedManager : AIIMCenter {
        return sharedInstance
    }
    
    convenience init(type:AIIMConversationType){
        super.init()
        
    }
 
    var imClient:AVIMClient?
    
    var selfClientId:String?
    
    var connect:Bool?
    
    func openWithClientId(clientId:String,callback:AVIMBooleanResultBlock){
        selfClientId = clientId
        
        
    }
    
}