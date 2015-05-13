//
//  AIFavoritsHandler.swift
//  AI2020OS
//
//  Created by tinkl on 5/5/15.
//  Copyright (c) 2015 ___ASIAINFO___. All rights reserved.
//

import Foundation

/*!
*  @author tinkl, 15-05-05 19:05:28
*
*  收藏夹对应所有事件响应
*/
class AIFavoritsHandler : NSObject{
    typealias  ChangeHandler = (LoginState)->()

    enum LoginState{
        case LoggedIn, LoggedOut
    }
    
    private var changeHandler : ChangeHandler?
    init(handl: ChangeHandler) {
        
    }
    
}
