//
//  AILoginUtil.swift
//  AIVeris
//
//  Created by 刘先 on 16/6/14.
//  Copyright © 2016年 ___ASIAINFO___. All rights reserved.
//

import Foundation
import Spring

class AILoginUtil: NSObject {

    static let KEY_USER_ID = "KEY_USER_ID"
    static let KEY_CUSTOM_ID = "KEY_CUSTOM_ID"
    static let KEY_PROVIDER_ID = "KEY_PROVIDER_ID"
    static let KEY_HEADURL_STRING = "KEY_HEADURL_STRING"
    static let KEY_USER_NAME_STRING = "KEY_USER_NAME_STRING"
    static let KEY_USER_NICKNAME_STRING = "KEY_USER_NICKNAME_STRING"
    // MARK: -验证密码是否符合规范
    //密码位数为6-20位，可包含以下类别：
    //英文字母（从 A 到 Z以及从 a 到 z ）
    //10 个基本数字（从 0 到 9）
   // 非字母字符（例如!、$、#、%、@、&、*等）
    class func validatePassword(password: String?) -> Bool {
        guard let password = password else {return false}
        let pattern = "[0-9a-zA-Z!@#$%*()_+^&]{6,20}"
        if let _ = password.rangeOfString(pattern, options: NSStringCompareOptions.RegularExpressionSearch, range: nil, locale: nil) {
            return true
        }
        return false
    }
    

    // MARK: -验证手机号是否符合规范
    // 11位数字
    class func validatePhoneNumber(phoneNumber: String?) -> Bool {
        guard let phoneNumber = phoneNumber else {return false}
        let pattern = "^1+[3578]+\\d{9}"
        if let _ = phoneNumber.rangeOfString(pattern, options: NSStringCompareOptions.RegularExpressionSearch, range: nil, locale: nil) {
            return true
        }
        return false
    }

    // 4位数字
    class func validateCode(validationCode: String?) -> Bool {
        guard let validationCode = validationCode else {return false}
        let pattern = "[0-9]{6}"
        if let _ = validationCode.rangeOfString(pattern, options: NSStringCompareOptions.RegularExpressionSearch, range: nil, locale: nil) {
            return true
        }
        return false
    }
    
    //显示验证结果提示信息
    class func showValidateResult(validateResultCode: LoginConstants.ValidateResultCode, validateInfoLabel: UILabel, widthConstraint: NSLayoutConstraint) {
        let resultText = validateResultCode.rawValue
        let width = resultText.sizeWithFont(LoginConstants.Fonts.validateResult, forWidth: 1000).width + 23
        
        validateInfoLabel.text = resultText
        
        widthConstraint.constant = 0
        
        //避免重复动画，先remove
        validateInfoLabel.layer.removeAllAnimations()
        UIView.animateWithDuration(0.5, animations: {
            widthConstraint.constant = width
            validateInfoLabel.superview!.layoutIfNeeded()
        }) { (finished) in
            UIView.animateWithDuration(0.5, delay: 2, options: UIViewAnimationOptions.CurveEaseInOut, animations: {
                widthConstraint.constant = 0
                validateInfoLabel.superview!.layoutIfNeeded()
                }, completion: nil)
        }
    }
    
    class func currentLocalUserID() -> String? {
        if let user = NSUserDefaults.standardUserDefaults().objectForKey(KEY_USER_ID) {
            return user as? String
        }
        return ""
    }
    
    //处理用户登陆事件， 1.存储userId到本地
    class func handleUserLogin(userId: String) { // 更换root以后废除
        NSUserDefaults.standardUserDefaults().setObject(userId, forKey: KEY_USER_ID)
        NSUserDefaults.standardUserDefaults().synchronize()
        NSNotificationCenter.defaultCenter().postNotificationName(AIApplication.Notification.UIAIASINFOLoginNotification, object: nil)
    }
    
    /**
     处理用户登出事件， 清除所有的本地用户信息
     */
    class func handleUserLogout() {
        NSUserDefaults.standardUserDefaults().removeObjectForKey(KEY_USER_ID)
        NSUserDefaults.standardUserDefaults().synchronize()
    }
    
    /**
     验证当前用户是否已登陆
     
     - returns: <#return value description#>
     */
    class func isLogin() -> Bool {
        if (NSUserDefaults.standardUserDefaults().objectForKey(KEY_USER_ID) as? String) != nil {
            return true
        } else {
            return false
        }
    }
}

// MARK: -登录模块全局变量
class AILoginPublicValue: NSObject {
    static var loginType: LoginConstants.LoginType?
    static var phoneNumber: String?
    static var password: String?
    //短信验证码
    static var smsCode: String?
}

// MARK: -> 点击按钮时禁止页面操作
extension UIViewController {
    func showButtonLoading(button: UIButton) {
        button.showActioningLoading()
        view.userInteractionEnabled = false
    }
    
    func hideButtonLoading(button: UIButton, title: String) {
        button.hideActioningLoading(title)
        view.userInteractionEnabled = true
    }
}

// MARK: -> 扩展自定义设置placeholder的方法，传入自定义的字体和颜色
extension UITextField {
    func buildCustomerPlaceholder(font: UIFont, color: UIColor, text: String) {
        let attrPlaceholder = NSMutableAttributedString(string: text)
        attrPlaceholder.addAttribute(NSForegroundColorAttributeName, value: color, range: NSMakeRange(0, attrPlaceholder.length))
        attrPlaceholder.addAttribute(NSFontAttributeName, value: font, range: NSMakeRange(0, attrPlaceholder.length))
        self.attributedPlaceholder = attrPlaceholder
    }
}
