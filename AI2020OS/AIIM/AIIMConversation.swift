//
//  AIIMConversation.swift
//  AI2020OS
//
//  Created by tinkl on 28/5/15.
//  Copyright (c) 2015 ___ASIAINFO___. All rights reserved.
//

import Foundation


class AIIMConversation: AVIMConversation {
    
    var conversationType: AIIMConversationType! = AIIMConversationType.AIIMConversationTypeLeanCloud  // 对话 类型
    
}

// MARK: Extension AVIMConversation.
extension AVIMConversation{
    enum AIConvType:Int{
        case CDConvTypeSingle = 0
        case CDConvTypeGroup = 1
    }
    
    var type:AIConvType?
    
    var otherId:String?
    
    var displayName:String?
    
    var title:String?
    
    var icon:String?    
    
}