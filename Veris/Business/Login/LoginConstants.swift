//
//  LoginConstants.swift
//  AIVeris
//
//  Created by 刘先 on 16/6/27.
//  Copyright © 2016年 ___ASIAINFO___. All rights reserved.
//

import Foundation

struct LoginConstants {
    struct Colors {
        static let TextFieldInput = UIColor.whiteColor()
        static let TextFieldBackground = UIColor(hexString: "#ebe7ff", alpha: 0.15)
        static let TextFieldBorder = UIColor(hexString: "#a99ece", alpha: 0.8)
    }
    
    struct Fonts {
        static let validateResult = AITools.myriadLightWithSize(AITools.displaySizeFrom1080DesignSize(36))
        static let textFieldInput = AITools.myriadSemiCondensedWithSize(AITools.displaySizeFrom1242DesignSize(48))
    }
    
    struct textContent {
        static let confirmButton = "确认完成"
    }
    
    struct defaultImages {
        static let timelineImage = UIImage()
        static let ServiceExecAllSelect = UIImage(named: "service_execute_all_select")
        static let ServiceExecAllUnSelect = UIImage(named: "service_execute_all_unselect")
        static let ServiceExecAlertSelect = UIImage(named: "service_execute_alert_select")
        static let ServiceExecAlertUnSelect = UIImage(named: "service_execute_alert_unselect")
        static let ServiceExecConfirmSelect = UIImage(named: "service_execute_confirm_select")
        static let ServiceExecConfirmUnSelect = UIImage(named: "service_execute_confirm_unselect")
    }
    
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

    
    enum ValidateResultCode : String {
        case WrongIdOrPassword = "Wrong ID or password!"
    }
}