//
//  AIChangePasswordViewController.swift
//  AIVeris
//
//  Created by 刘先 on 16/6/14.
//  Copyright © 2016年 ___ASIAINFO___. All rights reserved.
//

import UIKit
import AIAlertView

class AIChangePasswordViewController: UIViewController, UIGestureRecognizerDelegate {


    @IBOutlet weak var confirmButton: AIChangeStatusButton!
    @IBOutlet weak var passwordTextField: AILoginPasswordTextField!
    var rightImageView: UIImageView!
    
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

        confirmButton.layer.cornerRadius = 5
        confirmButton.layer.masksToBounds = true
        confirmButton.setBackgroundImage(LoginConstants.PropertyConstants.ButtonDisabledColor.imageWithColor(), forState: UIControlState.Disabled)
        confirmButton.setBackgroundImage(LoginConstants.PropertyConstants.ButtonNormalColor.imageWithColor(), forState: UIControlState.Normal)
        confirmButton.enabled = false

        //修复navigationController侧滑关闭失效的问题
        self.navigationController?.interactivePopGestureRecognizer?.delegate = self
    }

    func passwordInputAction(target: UITextField) {
        confirmButton.enabled = AILoginUtil.validatePassword(passwordTextField.text)
    }

    @IBAction func confirmAction(sender: AnyObject) {
        guard let phoneNumber = AILoginPublicValue.phoneNumber else { return }
        if AILoginUtil.validatePassword(passwordTextField.text){
            if AILoginPublicValue.loginType == LoginConstants.LoginType.Register{
                loginService.registUser(phoneNumber, password: passwordTextField.text!, success: { (userId) in
                    //TODO: 暂时的提示
                    AIAlertView().showSuccess("注册成功!", subTitle: "")
                    }, fail: { (errType, errDes) in
                        <#code#>
                })
            }
            else if AILoginPublicValue.loginType == LoginConstants.LoginType.ForgotPassword{
                
            }
        }

    }

}
