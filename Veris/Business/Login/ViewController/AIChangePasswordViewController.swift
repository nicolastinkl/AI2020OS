//
//  AIChangePasswordViewController.swift
//  AIVeris
//
//  Created by 刘先 on 16/6/14.
//  Copyright © 2016年 ___ASIAINFO___. All rights reserved.
//

import UIKit
import AIAlertView
import SVProgressHUD

class AIChangePasswordViewController: UIViewController, UIGestureRecognizerDelegate {

    @IBOutlet weak var validateInfoLabel: AIAnimatedPromptLabel!
    @IBOutlet weak var confirmButton: AIChangeStatusButton!
    @IBOutlet weak var passwordTextField: AILoginPasswordTextField!
    
    var loginService = AILoginService()


    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        setupViews()
        handleLoginType()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func handleLoginType() {
        if AILoginPublicValue.loginType == LoginConstants.LoginType.ForgotPassword {
            self.setupLoginNavigationBar("Forgot Password")
        } else {
            self.setupLoginNavigationBar("Enter Password")
        }
    }

    func setupViews() {
        passwordTextField.addTarget(self, action: #selector(AILoginViewController.passwordInputAction(_:)), forControlEvents: UIControlEvents.EditingChanged)

        confirmButton.enabled = false

        //修复navigationController侧滑关闭失效的问题
        self.navigationController?.interactivePopGestureRecognizer?.delegate = self
    }

    func passwordInputAction(target: UITextField) {
        confirmButton.enabled = AILoginUtil.validatePassword(passwordTextField.text)
    }

    @IBAction func confirmAction(sender: AnyObject) {
        let phoneNumber = AILoginPublicValue.phoneNumber ?? ""
        let smsCode = AILoginPublicValue.smsCode ?? ""
        
        if phoneNumber.length <= 0 || smsCode.length <= 0 {
            AIAlertView().showSuccess("密码格式错误", subTitle: "")
            return
        }
        
        let title = confirmButton.titleLabel?.text ?? ""
        confirmButton.showActioningLoading()
        
        if AILoginUtil.validatePassword(passwordTextField.text) {
            if AILoginPublicValue.loginType == LoginConstants.LoginType.Register {
                
                loginService.registUser(phoneNumber, password: passwordTextField.text!, success: { (userId) in
                    //TODO: 暂时的提示
                    self.confirmButton.hideActioningLoading(title)
                    AIAlertView().showSuccess("注册成功!", subTitle: "")
                    //跳回登陆页面
                    self.navigationController?.popToRootViewControllerAnimated(true)
                    }, fail: { (errType, errDes) in
                        self.confirmButton.hideActioningLoading(title)
                        self.validateInfoLabel.showPrompt(LoginConstants.ValidateResultCode.RegisterFaild.rawValue)
                })
            } else if AILoginPublicValue.loginType == LoginConstants.LoginType.ForgotPassword {
                loginService.resetPassword(smsCode, newPassword: passwordTextField.text!, success: {
                    self.confirmButton.hideActioningLoading(title)
                    AIAlertView().showSuccess("修改密码成功!", subTitle: "")
                    //跳回登陆页面
                    self.navigationController?.popToRootViewControllerAnimated(true)
                    }, fail: { (errType, errDes) in
                        self.confirmButton.hideActioningLoading(title)
                        self.validateInfoLabel.showPrompt(LoginConstants.ValidateResultCode.RestPassword.rawValue)
                })
            }
        }

    }

}
