//
//  AILoginUtil.swift
//  AIVeris
//
//  Created by 刘先 on 16/6/14.
//  Copyright © 2016年 ___ASIAINFO___. All rights reserved.
//

import Foundation

class AILoginUtil {

    struct PropertyConstants {
        //按钮颜色
        static let ButtonDisabledColor = UIColor.lightGrayColor()
        static let ButtonNormalColor = UIColor.blueColor()
        //圆角的值
        static let cornerRadiusValue: CGFloat = 5
    }

    struct StringConstants {
        static let ForgotPassword = "Forgot Password"
        static let Register = "Register"
        static let SendValidationCode = "Send Validation Code"
        static let Resend = "Resend"
        static let SelectCountry = "Select Country"
        static let EnterPassword = "Enter Password"
    }

    //定义登录类型，界面逻辑会根据不同类型变化
    enum LoginType: Int {
        case Login = 1, ForgotPassword, Register
    }


    // MARK: -验证密码是否符合规范
    //密码位数为6-20位，可包含以下类别：
    //英文字母（从 A 到 Z以及从 a 到 z ）
    //10 个基本数字（从 0 到 9）
   // 非字母字符（例如!、$、#、%、@、&、*等）
    static func validatePassword(password: String) -> Bool {
        return false
    }

    // MARK: -验证手机号是否符合规范
    // 11位数字
    static func validatePhoneNumber(phoneNumber: String) -> Bool {
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
}

// MARK: -登录模块全局变量
class AILoginPublicValue {
    static var loginType: AILoginUtil.LoginType?
    static var phoneNumber: String?
}
