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
	weak var confirmButton: AIChangeStatusButton!
	weak var passwordTextField: AILoginPasswordTextField!
	
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
			confirmButton.setTitle("Confirm", forState: .Normal)
			self.setupLoginNavigationBar("LoginConstants.forgetButton".localized)
		} else {
			confirmButton.setTitle("Next", forState: .Normal)
			self.setupLoginNavigationBar("LoginConstants.EnterPassword".localized)
		}
	}
	
    func setupViews() {
        passwordTextField.buildCustomerPlaceholder(LoginConstants.Fonts.promptLabel, color: LoginConstants.Colors.TextFieldPlaceholder, text: LoginConstants.textContent.SetPasswordPlaceholder)
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

        
        if AILoginUtil.validatePassword(passwordTextField.text) {
            if AILoginPublicValue.loginType == LoginConstants.LoginType.Register {
                AILoginPublicValue.password = passwordTextField.text
                let vc = AINickNameEditViewController.initFromStoryboard(AIApplication.MainStoryboard.MainStoryboardIdentifiers.AILoginStoryboard, storyboardID: nil)
                self.navigationController?.pushViewController(vc, animated: true)
                
            } else if AILoginPublicValue.loginType == LoginConstants.LoginType.ForgotPassword {
                showButtonLoading(confirmButton)
                loginService.resetPassword(smsCode, newPassword: passwordTextField.text!, success: {
                    self.hideButtonLoading(self.confirmButton, title: title)
                    AIAlertView().showSuccess("修改密码成功!", subTitle: "")
                    //跳回登陆页面
                    self.navigationController?.popToRootViewControllerAnimated(true)
                    }, fail: { (errType, errDes) in
                        self.hideButtonLoading(self.confirmButton, title: title)
                        self.validateInfoLabel.showPrompt(errDes)
                })
            }
        }
        
    }

}
