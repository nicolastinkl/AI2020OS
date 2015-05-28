//
//  AIIMNotify.swift
//  AI2020OS
//
//  Created by tinkl on 28/5/15.
//  Copyright (c) 2015 ___ASIAINFO___. All rights reserved.
//

import Foundation

/*!
*  @author tinkl, 15-05-28 17:05:36
*
*  message notification center
*/

private let sharedInstance = AIIMNotify()

class AIIMNotify {
    
    // MARK: create singlon object
    class var sharedManager : AIIMNotify {
        return sharedInstance
    }
    
    // MARK: veriables
    private let NOTIFICATION_CONV_UPDATED:String    = "NOTIFICATION_CONV_UPDATED"
    private let NOTIFICATION_MESSAGE_UPDATED:String = "NOTIFICATION_MESSAGE_UPDATED"
    
    // MARK:add Conversation Observer's notification
    func addConversationObserver(observer: AnyObject, selector: Selector){
        NSNotificationCenter.defaultCenter().addObserver(observer, selector: selector, name: NOTIFICATION_CONV_UPDATED, object: nil)
    }
    
    func removeConversationObserver(observer: AnyObject){
        NSNotificationCenter.defaultCenter().removeObserver(observer, name: NOTIFICATION_CONV_UPDATED, object: nil)
    }
    
    func postConversationNotify(){
        NSNotificationCenter.defaultCenter().postNotificationName(NOTIFICATION_CONV_UPDATED, object: nil)
    }
    
    // MARK:add Message Observer's notification
    func addMessageObserver(observer: AnyObject, selector: Selector){
        NSNotificationCenter.defaultCenter().addObserver(observer, selector: selector, name: NOTIFICATION_MESSAGE_UPDATED, object: nil)
    }
    
    func removeMessageObserver(observer: AnyObject){
        NSNotificationCenter.defaultCenter().removeObserver(observer, name: NOTIFICATION_MESSAGE_UPDATED, object: nil)
    }
    
    func postMessageNotify(){
        NSNotificationCenter.defaultCenter().postNotificationName(NOTIFICATION_MESSAGE_UPDATED, object: nil)
    }
    
}