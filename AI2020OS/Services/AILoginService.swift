//
//  AILoginService.swift
//  AI2020OS
//
//  Created by tinkl on 18/5/15.
//  Copyright (c) 2015 ___ASIAINFO___. All rights reserved.
//

import Foundation

/*!
*  @author tinkl, 15-05-18 11:05:59
*
*  提供登录服务
*/
class LoginAction : NSObject, AILoginViewControllerDelegate {
    
    typealias LoginHandler = ()->()
    
    private var loginHandler : LoginHandler?
    
    init(viewController: UIViewController, completion: LoginHandler?) {
        super.init()
        loginHandler = completion
        let loginViewController = UIStoryboard(name: AIApplication.MainStoryboard.MainStoryboardIdentifiers.AILoginStoryboard, bundle: nil).instantiateViewControllerWithIdentifier(AIApplication.MainStoryboard.ViewIdentifiers.AILoginViewController) as AILoginViewController
        loginViewController.modalPresentationStyle = .OverCurrentContext
        loginViewController.modalTransitionStyle = .CrossDissolve
        loginViewController.delegate = self
        viewController.presentViewController(loginViewController, animated: false, completion: nil)
    }
    
    func didLogin(completion: LoginHandler) {
        loginHandler = completion
    }
    
    func loginViewControllerDidLogin(controller: AILoginViewController) {
        loginHandler?()
        NSNotificationCenter.defaultCenter().postNotificationName(AIApplication.Notification.UIAIASINFOLoginNotification, object: nil)
    }
}

class LogoutAction : NSObject {
    
    override init() {
        super.init()
        AILocalStore.logout()
        NSNotificationCenter.defaultCenter().postNotificationName(AIApplication.Notification.UIAIASINFOLogOutNotification, object: nil)
    }
}

class LoginStateHandler : NSObject {
    
    typealias ChangeHandler = (LoginState)->()
    
    enum LoginState {
        case LoggedIn, LoggedOut
    }
    
    private var changeHandler : ChangeHandler?
    
    init(handler : ChangeHandler) {
        super.init()
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "loginNotification:", name: AIApplication.Notification.UIAIASINFOLoginNotification, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "logoutNotification:", name: AIApplication.Notification.UIAIASINFOLogOutNotification, object: nil)
        changeHandler = handler
        let isLoggedIn = AILocalStore.accessToken() != nil
        handler(isLoggedIn ? .LoggedIn : .LoggedOut)
    }
    
    deinit {
        NSNotificationCenter.defaultCenter().removeObserver(self)
    }
    
    func loginNotification(notification: NSNotification) {
        changeHandler?(.LoggedIn)
    }
    
    func logoutNotification(notification: NSNotification) {
        changeHandler?(.LoggedOut)
    }
}