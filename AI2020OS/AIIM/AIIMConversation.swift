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
private var AIIMKeyType = "AIIMKeyType"
private var AIIMKeyOtherId = "AIIMKeyOtherId"
private var AIIMKeyOtherdisplayName = "AIIMKeyOtherdisplayName"
private var AIIMKeyOtherTitle = "AIIMKeyOtherTitle"
private var AIIMKeyOtherIcon = "AIIMKeyOtherIcon"


// MARK: Extension AVIMConversation.
extension AVIMConversation{
    enum AIConvType:Int, Printable{
        case CDConvTypeSingle = 0
        case CDConvTypeGroup = 1
        
        var description: String {
            switch self {
            case .CDConvTypeSingle: return "0"
            case .CDConvTypeGroup: return "1"
            }
        }
    }
    
    var type: AIConvType{
        get{
            let assocObject  = objc_getAssociatedObject(self, &AIIMKeyType) as? String
            if let stringItem = assocObject {
                if stringItem == AIConvType.CDConvTypeSingle.description {
                    return AIConvType.CDConvTypeSingle
                }else{
                    return AIConvType.CDConvTypeGroup
                }
            }
            return AIConvType.CDConvTypeSingle
        }
        
        set{
            objc_setAssociatedObject(self, &AIIMKeyType, newValue.description, UInt(OBJC_ASSOCIATION_ASSIGN))
        }
    }
    
    var otherId: String?{
        get{
            return objc_getAssociatedObject(self, &AIIMKeyOtherId) as? String
        }
        set{
            objc_setAssociatedObject(self, &AIIMKeyOtherId, newValue, UInt(OBJC_ASSOCIATION_RETAIN_NONATOMIC))
        }
    }
    
    var displayName: String?{
        get{
            return objc_getAssociatedObject(self, &AIIMKeyOtherdisplayName) as? String
        }
        set{
            objc_setAssociatedObject(self, &AIIMKeyOtherdisplayName, newValue, UInt(OBJC_ASSOCIATION_RETAIN_NONATOMIC))
        }
    }
    
    var title: String?{
        get{
            return objc_getAssociatedObject(self, &AIIMKeyOtherTitle) as? String
        }
        set{
            objc_setAssociatedObject(self, &AIIMKeyOtherTitle, newValue, UInt(OBJC_ASSOCIATION_RETAIN_NONATOMIC))
        }
    }
    
    var icon: String?{
        get{
            return objc_getAssociatedObject(self, &AIIMKeyOtherIcon) as? String
        }
        set{
            objc_setAssociatedObject(self, &AIIMKeyOtherIcon, newValue, UInt(OBJC_ASSOCIATION_RETAIN_NONATOMIC))
        }
    }
    
    
    class func nameOfUserIds(members:NSArray) -> String{
        return ""
    }
}