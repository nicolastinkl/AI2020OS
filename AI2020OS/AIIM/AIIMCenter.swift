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

private let sharedInstance = AIIMCenter()

/*!
*  @author tinkl, 15-05-28 17:05:02
*
*  this leanCloud message receive and send center.
*/
class AIIMCenter: NSObject,AVIMClientDelegate, AVIMSignatureDataSource{
    
    // MARK: create singlon object
    class var sharedManager : AIIMCenter {
        return sharedInstance
    }
    
    
    /*convenience init(type:AIIMConversationType){
        self.init()
    }*/
 
    var imClient:AVIMClient?
    
    var selfClientId:String?
    
    var connect:Bool?
    
    var cachedConvs: NSMutableArray?
    
    var notify: AIIMNotify?
    
    override init() {
        super.init()
        self.imClient = AVIMClient()
        self.imClient?.delegate = self
        self.notify = AIIMNotify.sharedManager
        self.cachedConvs = NSMutableArray()
        
       // self.connect = (self.imClient?.status ?? AVIMClientStatusOpened)
    }
    
    deinit{
        self.removeObserver(self, forKeyPath: "status")
    }
    
    func openWithClientId(clientId:String,callback:AVIMBooleanResultBlock){
        selfClientId = clientId
        
        
    }
    
    
    
    
}