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
class LoginAction: NSObject, AILoginViewControllerDelegate {

    typealias LoginHandler = ()->()

    private var loginHandler: LoginHandler?

    init(viewController: UIViewController, completion: LoginHandler?) {
        super.init()
        loginHandler = completion
        let storyBoard: UIStoryboard = UIStoryboard(name: AIApplication.MainStoryboard.MainStoryboardIdentifiers.AILoginStoryboard, bundle: nil)
        let viewNavi = storyBoard.instantiateInitialViewController() as! UINavigationController
        viewController.presentViewController(viewNavi, animated: false, completion: nil)
    }

    func didLogin(completion: LoginHandler) {
        loginHandler = completion
    }

    func loginViewControllerDidLogin(controller: AILoginViewController) {
        loginHandler?()
        NSNotificationCenter.defaultCenter().postNotificationName(AIApplication.Notification.UIAIASINFOLoginNotification, object: nil)
    }
}

// TODO: LogoutAction

class LogoutAction: NSObject {

    override init() {
        super.init()
        AILocalStore.logout()
        NSNotificationCenter.defaultCenter().postNotificationName(AIApplication.Notification.UIAIASINFOLogOutNotification, object: nil)
    }
}

// TODO: LoginStateHandler

class LoginStateHandler: NSObject {

    typealias ChangeHandler = (LoginState)->()

    enum LoginState {
        case LoggedIn, LoggedOut
    }

    private var changeHandler: ChangeHandler?

    init(handler: ChangeHandler) {
        super.init()
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(LoginStateHandler.loginNotification(_:)), name: AIApplication.Notification.UIAIASINFOLoginNotification, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(LoginStateHandler.logoutNotification(_:)), name: AIApplication.Notification.UIAIASINFOLogOutNotification, object: nil)
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

class AILoginService: NSObject {
    
    struct AINetErrorDescription {
        static let FormatError = "AIOrderPreListModel JSON Parse error."
    }
    
    /**
     登陆服务
     
     - parameter userCode: <#userCode description#>
     - parameter password: <#password description#>
     - parameter success:  <#success description#>
     - parameter fail:     <#fail description#>
     */
    func login(userCode: String, password: String, success : (userId: String) -> Void, fail : (errType: AINetError, errDes: String) -> Void) {
        let message = AIMessage()
        let body : NSDictionary = [
            "username" : userCode,
            "password" : password
        ]
        
        message.body.addEntriesFromDictionary(body as [NSObject : AnyObject])
        message.url = AIApplication.AIApplicationServerURL.login.description as String
        
        AINetEngine.defaultEngine().postMessage(message, success: { (response) -> Void in
            
            if let responseJSON: AnyObject = response {
                
                let dic = responseJSON as! [NSString : AnyObject]
                success(userId: "1")
                
                
            } else {
                fail(errType: AINetError.Format, errDes: AINetErrorDescription.FormatError)
            }
            
        }) { (error: AINetError, errorDes: String!) -> Void in
            fail(errType: error, errDes: errorDes)
        }

    }
    
    /**
     <#Description#>
     
     - parameter userCode: <#userCode description#>
     - parameter success:  <#success description#>
     - parameter fail:     <#fail description#>
     */
    func registUser(userCode: String, password: String, success : (userId: String) -> Void, fail : (errType: AINetError, errDes: String) -> Void) {
        let message = AIMessage()
        let body : NSDictionary = [
            "username" : userCode,
            "password" : password]
        
        message.body.addEntriesFromDictionary(body as [NSObject : AnyObject])
        message.url = AIApplication.AIApplicationServerURL.register.description as String
        
        AINetEngine.defaultEngine().postMessage(message, success: { (response) -> Void in
            
            if let responseJSON: AnyObject = response {
                
                let dic = responseJSON as! [NSString : AnyObject]
                success(userId: "1")
                
                
            } else {
                fail(errType: AINetError.Format, errDes: AINetErrorDescription.FormatError)
            }
            
        }) { (error: AINetError, errorDes: String!) -> Void in
            fail(errType: error, errDes: errorDes)
        }
    }
}
