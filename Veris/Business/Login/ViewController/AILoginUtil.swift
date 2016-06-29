//
//  AILoginUtil.swift
//  AIVeris
//
//  Created by 刘先 on 16/6/14.
//  Copyright © 2016年 ___ASIAINFO___. All rights reserved.
//

import Foundation

class AILoginUtil {

    

    // MARK: -验证密码是否符合规范
    //密码位数为6-20位，可包含以下类别：
    //英文字母（从 A 到 Z以及从 a 到 z ）
    //10 个基本数字（从 0 到 9）
   // 非字母字符（例如!、$、#、%、@、&、*等）
    static func validatePassword(password: String?) -> Bool {
        guard let password = password else {return false}
        let pattern = "[0-9a-zA-Z!@#$%*()_+^&]{6,20}"
        if let _ = password.rangeOfString(pattern, options: NSStringCompareOptions.RegularExpressionSearch, range: nil, locale: nil){
            return true
        }
        return false
    }

    // MARK: -验证手机号是否符合规范
    // 11位数字
    static func validatePhoneNumber(phoneNumber: String?) -> Bool {
        guard let phoneNumber = phoneNumber else{return false}
        let pattern = "^1+[3578]+\\d{9}"
        if let _ = phoneNumber.rangeOfString(pattern, options: NSStringCompareOptions.RegularExpressionSearch, range: nil, locale: nil) {
            return true
        }
        return false
    }

    // 4位数字
    static func validateCode(validationCode: String) -> Bool {
        return false
    }
    
    //显示验证结果提示信息
    static func showValidateResult(validateResultCode: LoginConstants.ValidateResultCode, validateInfoLabel: UILabel, widthConstraint: NSLayoutConstraint) {
        let resultText = validateResultCode.rawValue
        let width = resultText.sizeWithFont(LoginConstants.Fonts.validateResult, forWidth: 1000).width + 23
        
        validateInfoLabel.text = resultText
        widthConstraint.constant = 0
        UIView.animateWithDuration(0.5, animations: {
            widthConstraint.constant = width
            validateInfoLabel.superview!.layoutIfNeeded()
        }) { (finished) in
            widthConstraint.constant = width
            UIView.animateWithDuration(0.5, delay: 2, options: UIViewAnimationOptions.CurveEaseInOut, animations: {
                widthConstraint.constant = 0
                validateInfoLabel.superview!.layoutIfNeeded()
                }, completion: nil)
        }
        
    }
}

// MARK: -登录模块全局变量
class AILoginPublicValue {
    static var loginType: LoginConstants.LoginType?
    static var phoneNumber: String?
}
