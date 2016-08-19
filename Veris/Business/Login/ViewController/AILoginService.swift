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
	
	typealias LoginHandler = () -> ()
	
	private var loginHandler: LoginHandler?
	
	init(viewController: UIViewController, completion: LoginHandler?) {
		super.init()
		loginHandler = completion
		let storyBoard: UIStoryboard = UIStoryboard(name: AIApplication.MainStoryboard.MainStoryboardIdentifiers.AILoginStoryboard, bundle: nil)
		let loginVC = storyBoard.instantiateInitialViewController() as! AILoginViewController
        let navVC = UINavigationController(rootViewController: loginVC)
		viewController.presentViewController(navVC, animated: false, completion: nil)
	}
	
	func didLogin(completion: LoginHandler) {
		loginHandler = completion
        loginHandler?()
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
	
	typealias ChangeHandler = (LoginState) -> ()
	
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
		static let FormatError = "login Failed."
	}
	
	/**
	 登陆服务

	 - parameter userCode: <#userCode description#>
	 - parameter password: <#password description#>
	 - parameter success:  <#success description#>
	 - parameter fail:     <#fail description#>
	 */
	func login(userCode: String, password: String, success: (userId: String) -> Void, fail: (errType: AINetError, errDes: String) -> Void) {
		let message = AIMessage()
		let body: NSDictionary = [
			"username": userCode,
			"password": password.md5()
		]
        
        message.body.addEntriesFromDictionary(body as [NSObject: AnyObject])
        message.url = AIApplication.AIApplicationServerURL.login.description as String
        
        AINetEngine.defaultEngine().postMessage(message, success: { (response) -> Void in
            
            if let responseJSON: AnyObject = response {
                #if DEBUG
                    success(userId: "")
                #endif
                
                let dic = responseJSON as! [NSString: AnyObject]
                
                if let cid = dic["customer_id"] as? String, pid = dic["provider_id"] as? String, hurl = dic["head_url"] as? String {
                    
                    NSUserDefaults.standardUserDefaults().setObject(cid, forKey: AILoginUtil.KEY_CUSTOM_ID)
                    NSUserDefaults.standardUserDefaults().setObject(pid, forKey: AILoginUtil.KEY_PROVIDER_ID)
                    NSUserDefaults.standardUserDefaults().setObject(hurl, forKey: AILoginUtil.KEY_HEADURL_STRING)
                    NSUserDefaults.standardUserDefaults().synchronize()
                }
                
                if let userId = dic["user_id"] as? String {
                    let user = AIUser()
                    user.id = userId.toInt()!
                    if let hurl = dic["head_url"] as? String {
                        user.headURL = hurl
                    }
                    success(userId: userId)
                } else {
                    fail(errType: AINetError.Format, errDes: AINetErrorDescription.FormatError)
                }
				
			} else {
				fail(errType: AINetError.Format, errDes: AINetErrorDescription.FormatError)
			}
			
		}) { (error: AINetError, errorDes: String!) -> Void in
			fail(errType: error, errDes: errorDes)
		}
		
	}
	
	func logout(success: (userId: String) -> Void, fail: (errType: AINetError, errDes: String) -> Void) {
		
	}
	
	/**
	 注册用户

	 - parameter userCode: <#userCode description#>
	 - parameter success:  <#success description#>
	 - parameter fail:     <#fail description#>
	 */
	func registUser(userCode: String, password: String, success: (userId: String) -> Void, fail: (errType: AINetError, errDes: String) -> Void) {
		let message = AIMessage()
		let body: NSDictionary = [
			"username": userCode,
			"password": password.md5()
        ]
		message.body.addEntriesFromDictionary(body as [NSObject: AnyObject])
		message.url = AIApplication.AIApplicationServerURL.register.description as String
		
		AINetEngine.defaultEngine().postMessage(message, success: { (response) -> Void in
			
			if let responseJSON: AnyObject = response {
				let dic = responseJSON as! [NSString: AnyObject]
				if let userId = dic["user_id"] as? String {
					success(userId: userId)
				} else {
					success(userId: "")
				}
			} else {
                fail(errType: AINetError.Format, errDes: AINetErrorDescription.FormatError)
			}
			
		}) { (error: AINetError, errorDes: String!) -> Void in
			fail(errType: error, errDes: errorDes)
		}
	}
	
	/**
	 重置密码

	 - parameter smsCode:     <#smsCode description#>
	 - parameter newPassword: <#newPassword description#>
	 - parameter success:     <#success description#>
	 - parameter fail:        <#fail description#>
	 */
	func resetPassword(smsCode: String, newPassword: String, success: () -> Void, fail: (errType: AINetError, errDes: String) -> Void) {
        let password = newPassword.md5()
		AVUser.resetPasswordWithSmsCode(smsCode, newPassword: password) { (bol, error) in
			if bol {
				success()
			} else {
				fail(errType: AINetError.Failed, errDes: error.description)
			}
		}
	}
	
	func requestPasswordResetWithPhoneNumber(phoneNumber: String, success: () -> Void, fail: (errType: AINetError, errDes: String) -> Void) {
		AVUser.requestPasswordResetWithPhoneNumber(phoneNumber) { (bol, error) in
			if bol {
				success()
			} else {
				fail(errType: AINetError.Failed, errDes: error.description)
			}
		}
	}
}
