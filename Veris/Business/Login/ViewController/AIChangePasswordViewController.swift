//
//  AIChangePasswordViewController.swift
//  AIVeris
//
//  Created by 刘先 on 16/6/14.
//  Copyright © 2016年 ___ASIAINFO___. All rights reserved.
//

import UIKit

class AIChangePasswordViewController: UIViewController, UIGestureRecognizerDelegate {


    @IBOutlet weak var confirmButton: AIChangeStatusButton!
    @IBOutlet weak var passwordTextField: UITextField!
    var rightImageView: UIImageView!
    
    var loginService = AILoginService()

    //切换是否显示密码的图标
    let showPasswordImageArray = [UIImage(named: "aa_speaker_off"), UIImage(named: "aa_speaker_on")]
    var showPasswordText = false

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
        passwordTextField.secureTextEntry = true
        passwordTextField.returnKeyType = UIReturnKeyType.Go
        passwordTextField.layer.cornerRadius = 5
        passwordTextField.layer.masksToBounds = true
        rightImageView = UIImageView(frame: CGRect(x: 0, y: 10, width: 40, height: 30))
        rightImageView.image = showPasswordImageArray[0]
        rightImageView.contentMode = UIViewContentMode.ScaleAspectFit
        rightImageView.userInteractionEnabled = true
        passwordTextField.rightView = rightImageView
        passwordTextField.rightViewMode = UITextFieldViewMode.Always

        passwordTextField.addTarget(self, action: #selector(AILoginViewController.passwordInputAction(_:)), forControlEvents: UIControlEvents.EditingChanged)

        let tapGuesture = UITapGestureRecognizer(target: self, action: #selector(AIChangePasswordViewController.switchDisplayPasswordText(_:)))
        rightImageView.addGestureRecognizer(tapGuesture)

        confirmButton.layer.cornerRadius = 5
        confirmButton.layer.masksToBounds = true
        confirmButton.setBackgroundImage(LoginConstants.PropertyConstants.ButtonDisabledColor.imageWithColor(), forState: UIControlState.Disabled)
        confirmButton.setBackgroundImage(LoginConstants.PropertyConstants.ButtonNormalColor.imageWithColor(), forState: UIControlState.Normal)
        confirmButton.enabled = false

        //修复navigationController侧滑关闭失效的问题
        self.navigationController?.interactivePopGestureRecognizer?.delegate = self
    }

    func switchDisplayPasswordText(sender: UITapGestureRecognizer) {
        showPasswordText = !showPasswordText
        passwordTextField.secureTextEntry = !passwordTextField.secureTextEntry
        rightImageView.image = showPasswordText ? showPasswordImageArray[1] : showPasswordImageArray[0]
    }

    func passwordInputAction(target: UITextField) {
        confirmButton.enabled = AILoginUtil.validatePassword(passwordTextField.text)
    }

    @IBAction func confirmAction(sender: AnyObject) {
//        guard let phoneNumber = AILoginPublicValue.phoneNumber else { return }
//        if AILoginUtil.validatePassword(passwordTextField.text){
//            
//            loginService.registUser(userIdTextField.text!, password: passwordTextField.text!, success: { (userId) in
//                self.dismissViewControllerAnimated(true, completion: nil)
//                }, fail: { (errType, errDes) in
//                    AILoginUtil.showValidateResult(LoginConstants.ValidateResultCode.WrongIdOrPassword, validateInfoLabel: self.validateInfoLabel, widthConstraint: self.validateInfoLabelWidthConstraint)
//            })
//            
//            
//        } else {
//            AILoginUtil.showValidateResult(LoginConstants.ValidateResultCode.WrongIdOrPassword, validateInfoLabel: validateInfoLabel, widthConstraint: validateInfoLabelWidthConstraint)
//        }
    }


    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
