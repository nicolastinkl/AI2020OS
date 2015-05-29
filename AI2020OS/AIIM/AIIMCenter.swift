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
    
    var storage:AIIMStorage?
    
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
        self.storage = AIIMStorage.sharedManager
        
        updateConnectStatus()
        
    }
    
    deinit{
        self.removeObserver(self, forKeyPath: "status")
    }
    
    
    // MARK: update status
    
    func updateConnectStatus(){
        let status = self.imClient?.status as AVIMClientStatus?
        if status!.value == AVIMClientStatusOpened.value{
            self.connect = true
        }else{
            self.connect = false
        }
    }
    
    // MARK: Open ClientID
    
    func openWithClientId(clientId:String,callbackBlock:AVIMBooleanResultBlock){
        selfClientId = clientId
        
        self.imClient?.openWithClientId(clientId, callback: { (succeeded, error) -> Void in
            
            self.updateConnectStatus()
            callbackBlock(succeeded,error)
            
        })
        
    }
    
    func closeWithCallback(result:AVBooleanResultBlock){
        self.imClient?.closeWithCallback(result)
    }
    
    // MARK:  conversation
    func fecthConvWithId(convid:String,callback:AVIMConversationResultBlock){
        let q: AVIMConversationQuery? = self.imClient?.conversationQuery()
        q?.whereKey("objectId", equalTo: convid)
        q?.findConversationsWithCallback({ (objects, error) -> Void in
            if (error != nil) {
                callback(nil, error)
            }else{
                if let objs = objects as [AVIMConversation]?{
                    callback(objs.first, error)
                }
                
            }
        })
    }
    
    func fetchConvWithMembers(members:NSArray,type:AVIMConversation.AIConvType,callback:AVIMConversationResultBlock){
        let q: AVIMConversationQuery? = self.imClient?.conversationQuery()
        q?.whereKey("attr.type", equalTo: type.description)
        q?.whereKey("m", containsAllObjectsInArray: members)
        q?.findConversationsWithCallback({ (objects, error) -> Void in
            if (error != nil) {
                callback(nil, error)
            }else{
                if let objs = objects as [AVIMConversation]?{
                    callback(objs.first, error)
                }else{
                    self.createConvWithMembers(members, type: type, callback: callback)
                }
            }
            
        })
    }
    
    func fetchConvWithMembers(members:NSArray,callback:AVIMConversationResultBlock){
        fetchConvWithMembers(members, type: AVIMConversation.AIConvType.CDConvTypeGroup, callback: callback)
    }
    
    
    func createConvWithMembers(members:NSArray,type:AVIMConversation.AIConvType,callback:AVIMConversationResultBlock){
        
        let name:String = AVIMConversation.nameOfUserIds(members)
        
        self.imClient?.createConversationWithName(name, clientIds: members, attributes: ["type":type.description], options: AVIMConversationOptionNone, callback: callback)
    }
    
    
    func fetchConvWithOtherId(otherId:String,callback:AVIMConversationResultBlock){
        
        let members = NSArray(objects: self.imClient!.clientId,otherId)
        
        fetchConvWithMembers(members, type: AVIMConversation.AIConvType.CDConvTypeSingle, callback: callback)
    }
    
    
    func findGroupedConvsWithBlock(block: AVIMArrayResultBlock){
        let q: AVIMConversationQuery? = self.imClient?.conversationQuery()
        q?.whereKey("attr.type", equalTo: AVIMConversation.AIConvType.CDConvTypeGroup.description)
        q?.whereKey("m", containsAllObjectsInArray:  NSArray(objects: self.selfClientId!))
        q?.limit = 1000
        q?.findConversationsWithCallback(block)
        
    }
    
    
    func updateConv(conv:AVIMConversation,name:String,attrs:NSDictionary,callback:AVIMBooleanResultBlock){
        conv.update(["name":name,"attrs":attrs], callback: callback)
    }
    
    func fetchConvsWithConvids(convids:NSSet,callback:AVIMArrayResultBlock){
        if convids.count>0 {
            let q: AVIMConversationQuery? = self.imClient?.conversationQuery()
            q?.whereKey("objectId", containedIn: convids.allObjects)
            q?.limit = 1000
            q?.findConversationsWithCallback(callback)
        }else{
            callback([],nil)
        }
        
    }
    
    
    // MARK: query msgs
    func queryMsgsWithConv(conv:AVIMConversation,timeSpan:Int64,limit:UInt,msgId:String,error:NSErrorPointer)->NSArray?{
        
        let dsema:dispatch_semaphore_t = dispatch_semaphore_create(0)
        
        var result:NSArray?
        var blockError:NSError?
        
        conv.queryMessagesBeforeId(msgId, timestamp: timeSpan, limit: limit, callback: {(objects, error) -> Void in
            result = objects
            blockError = error as NSError
            dispatch_semaphore_signal(dsema)
            return

        })
        
        dispatch_semaphore_wait(dsema, DISPATCH_TIME_FOREVER)
        
        error.memory = blockError
        return result
    }
    
    
    // MARK: send or receive message
    
    func receiveMsg(msg: AVIMTypedMessage, conv: AVIMConversation){
        self.notify?.postMessageNotify(msg)
    }
    
    
    // MARK : AVIMClientDelegate
    
    func imClientPaused(imClient: AVIMClient!) {
        updateConnectStatus()
    }
    
    func imClientResumed(imClient: AVIMClient!) {
        updateConnectStatus()
    }
    
    func imClientResuming(imClient: AVIMClient!) {
        updateConnectStatus()
    }
    
    // MARK: AVIMMessageDelegate
    
    func conversation(conversation: AVIMConversation!, didReceiveCommonMessage message: AVIMMessage!) {
        logInfo("didReceiveCommonMessage ...  ")
    }
    
    func conversation(conversation: AVIMConversation!, didReceiveTypedMessage message: AVIMTypedMessage!) {
        if (message.messageId != nil) {
            receiveMsg(message, conv: conversation)
        }else{
            logInfo("Receive Message , but MessageId is nil ...  ")
        }
    }
    
    func conversation(conversation: AVIMConversation!, messageDelivered message: AVIMMessage!) {
        if (message != nil){
            self.notify?.postMessageNotify(message as AVIMTypedMessage)
        }
    }
    
    
    // MARK: convSignWithSelfId
    func convSignWithSelfId(selfId:String,convid:String,targetIds:NSArray,action:String) -> AnyObject!{
        var dict:Dictionary<String,AnyObject> = ["self_id":selfId]
        if !convid.isEmpty {
            dict["convid"] = convid
        }
        
        if targetIds.count > 0 {
            dict["targetIds"] = targetIds
        }
        
        if !action.isEmpty {
            dict["action"] = action
        }
        
        return AVCloud.callFunction("conv_sign", withParameters: dict)        
    }
    
    func getAVSignatureWithParams(fields:NSDictionary,peerIds:NSArray) -> AVIMSignature!{
        var avSignature:AVIMSignature = AVIMSignature()
        let timestampNum = fields.valueForKey("timestamp") as NSNumber
        avSignature.timestamp = timestampNum.longLongValue
        avSignature.nonce = fields.valueForKey("nonce") as String
        avSignature.signature = fields.valueForKey("signature") as String
        return avSignature
    }
    
    func signatureWithClientId(clientId:String,conversationId:String,var action:String,clientIds:NSArray) -> AVIMSignature{
        
        if action == "open" || action == "start" {
            action = ""
        }
        
        if action == "remove" {
            action = "kick"
        }
        
        if action == "add" {
            action = "invite"
        }
        
        let dict = convSignWithSelfId(clientId, convid: conversationId, targetIds: clientIds, action: action) as NSDictionary?
        if let newDict = dict {
            return getAVSignatureWithParams(newDict, peerIds: clientIds)
        }
        return AVIMSignature()
    }
    
    
    // MARK : AVIMConversation cache
    
    func lookupConvById(convid:String) -> AVIMConversation!{
        return self.cachedConvs?.valueForKey(convid) as AVIMConversation
    }
    
    func registerConvs(convs:NSArray){
        for conv in convs as [AVIMConversation] {
            self.cachedConvs?.setValue(conv, forKey: conv.conversationId)
        }
    }
    
    func cacheConvsWithIds(convids:NSMutableSet,callback:AVArrayResultBlock){
        let uncacheConvids:NSMutableSet = NSMutableSet()
        for convID in convids.allObjects as [String]{
            if !(lookupConvById(convID) != nil) {
                uncacheConvids.addObject(convID)
            }
        }
        
        fetchConvsWithConvids(uncacheConvids, callback: { (objects, error) -> Void in
            if ((error) != nil) {
                callback(nil, error);
            }else{
                self.registerConvs(objects)
                callback(objects, error)
            }
        })
        
    }
    
    // MARK: Recent roooms
    
    func findRecentRoomsWithBlock(block: AVArrayResultBlock){
        let newArray: AnyObject? = self.storage?.getRooms().mutableCopy()
        let rooms = NSMutableArray(object: newArray!)
        let convids:NSMutableSet = NSMutableSet()
        for room in rooms {
            let romitem = room as AIIMRoom
            convids.addObject(romitem.convid!)
        }
        
        cacheConvsWithIds(convids, callback: { (objects, error) -> Void in
            if ((error) != nil) {
                block(nil, error)
            }else{
                let filterRooms =  NSMutableArray()
                for room in rooms {
                    let roomitem = room as AIIMRoom
                    roomitem.conv = self.lookupConvById(roomitem.convid!)
                    if (room.conv != nil) {
                        filterRooms.addObject(roomitem)
                    }else{
                        // error
                    }
                }
                
                let userIds = NSMutableSet()
                for room in filterRooms   {
                    let roomitem = room as AIIMRoom
                    //roomitem.conv.type = roomitem.type
                    userIds.addObject(roomitem.conv!.otherId!)
                }
                
                //cacheUserByIds
                self.storage?.cacheUserByIds(userIds, block: { (successed, error) -> Void in
                    if ((error) != nil) {
                        block(nil, error)
                    }else{
                        block(filterRooms,nil)
                    }
                })
            }
        })
        
    }
    

    
}