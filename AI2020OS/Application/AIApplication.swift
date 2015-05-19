//
//  AIApplication.swift
//  AI2020OS
//
//  Created by tinkl on 30/3/15.
//  Copyright (c) 2015 ___ASIAINFO___. All rights reserved.
//

import Foundation

/*!
*  @author tinkl, 15-03-30 15:03:35
*
*  AI2020OS 全局参数
*/
struct AIApplication{

    // MARK: LEANCLOUD APPKEY
    internal static let AVOSCLOUDID  = "xkz4nhs9rmvw3awnolcu3effmdkvynztt1umggatbrx72krk"
    
    internal static let AVOSCLOUDKEY = "qqcxwtjlx3ctw32buizjkaw5elwf0s41u4xf8ct7glbox171"
    
    // MARK: 讯飞语音助手APPID
    internal static let XUNFEIAPPID  = "551ba83b"
    
    // MARK: 所有ViewController Identifiers
    struct MainStoryboard {
        
        struct MainStoryboardIdentifiers {
            static let AIMainStoryboard             = "AIMainStoryboard"
            static let AILoginStoryboard            = "AILoginStoryboard"
            static let AILoadingStoryboard          = "AILoadingStoryboard"
            static let AIMenuStoryboard             = "AIMenuStoryboard"
        }
        
        struct ViewControllerIdentifiers {
            static let listViewController           = "listViewController"
            static let favoritsTableViewController  = "AIFavoritsTableViewController"
            static let AIMenuViewController         = "AIMenuViewController"
        }
        
        struct CellIdentifiers {
            
            // MARK: HOME
            static let AIHomeSDAvatorViewCell   = "AIHomeAvatorViewCell"    // avator
            static let AIHomeSDDefaultViewCell  = "AIHomeSDDefaultViewCell" // price
            static let AIHomeSDDesViewCell      = "AIHomeSDDesViewCell"     // description
            static let AIHomeSDCommentViewCell  = "AIHomeSDCommentViewCell" // comment list
            static let AIHomeSDParamesViewCell  = "AIHomeSDParamesViewCell" // params
            
            // MARK: TIME LINE
            static let AITIMELINESDTimesViewCell        = "AITIMELINESDTimesViewCell"
            static let AITIMELINESDContentViewCell      = "AITIMELINESDContentViewCell"
        }
        
        struct ViewIdentifiers {
            static let AIOrderBuyView           = "AIOrderBuyView"
            static let AILoginViewController    = "AILoginViewController"
        }
    }
    
    // Notification with IM or System Push.
    struct Notification{
        static let UIAIASINFOWillShowBarNotification    = "UIAIASINFOWillShowBarNotification"
        static let UIAIASINFOWillhiddenBarNotification  = "UIAIASINFOWillhiddenBarNotification"
        static let UIAIASINFOLoginNotification          = "UIAIASINFOLoginNotification"
        static let UIAIASINFOLogOutNotification         = "UIAIASINFOLogOutNotification"
    }
    
    // MARK: 系统主题颜色
    struct AIColor {
        static let MainTextColor     = "#41414C"
        static let MainTabBarBgColor = "#00cec0"
        static let MainYellowBgColor = "#f0ff00"
        static let MainGreenBgColor  = "#5fc30d"
        
        static let MainSystemBlueColor   = "#00CEC3"
        static let MainSystemBlackColor  = "#848484"
    }
    
    // MARK: 处理响应事件
    internal func SendAction(functionName:String,ownerName:AnyObject){
        /*!
        *  @author tinkl, 15-04-22 16:04:07
        *
        *   how to use it ?
            SendAction("minimizeView:", ownerName: self)
        */
        UIApplication.sharedApplication().sendAction(Selector(functionName), to: nil, from: ownerName, forEvent: nil)
    }
    
    /*!
        Application hook viewdidload
    */
    static func hookViewDidLoad(){
        swizzlingMethod(UIViewController.self,
            oldSelector: "viewDidLoad",
            newSelector: "viewDidLoadForChangeTitleColor")
    }
    
    /*!
        Application hookViewDesLoad
    */
    static func hookViewWillAppear(){
        swizzlingMethod(UIViewController.self,
            oldSelector: "viewDidAppear:",
            newSelector: "viewWillAppearForShowBottomBar:")
    }
    
    static func hookViewWillDisappear(){
        swizzlingMethod(UIViewController.self,
            oldSelector: "viewWillDisappear:",
            newSelector: "viewWillDisappearForHiddenBottomBar:")
    }
    
    
    static func swizzlingMethod(clzz: AnyClass, oldSelector: Selector, newSelector: Selector) {
        let oldMethod = class_getInstanceMethod(clzz, oldSelector)
        let newMethod = class_getInstanceMethod(clzz, newSelector)
        method_exchangeImplementations(oldMethod, newMethod)
    }
    
    
}
