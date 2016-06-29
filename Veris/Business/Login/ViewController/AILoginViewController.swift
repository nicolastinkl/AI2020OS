//
//  AILoginViewController.swift
//  AIVeris
//
//  Created by 刘先 on 16/5/25.
//  Copyright © 2016年 ___ASIAINFO___. All rights reserved.
//

import UIKit
import Spring


class AILoginViewController: UIViewController {
    
    @IBOutlet weak var loginButton: AIChangeStatusButton!
    @IBOutlet weak var logoImageView: UIImageView!
    @IBOutlet weak var appNameCenterXConstraint: NSLayoutConstraint!
    @IBOutlet weak var appNameViewTopConstraint: NSLayoutConstraint!
    @IBOutlet weak var logoImageTopConstraint: NSLayoutConstraint!
    @IBOutlet weak var userIdTextField: AILoginBaseTextField!
    @IBOutlet weak var passwordTextField: AILoginBaseTextField!
    @IBOutlet weak var logoImageCenterXConstraint: NSLayoutConstraint!
    @IBOutlet weak var validateInfoLabel: UILabel!
    
    @IBOutlet weak var validateInfoLabelWidthConstraint: NSLayoutConstraint!
    
    let loginService = AILoginService()
    
    // MARK: -IBActions
    @IBAction func loginAction(sender: AnyObject) {
        
        
        if AILoginUtil.validatePassword(passwordTextField.text) && AILoginUtil.validatePhoneNumber(userIdTextField.text) {
            
            loginService.login(userIdTextField.text!, password: passwordTextField.text!, success: { (userId) in
                self.dismissViewControllerAnimated(true, completion: nil)
                }, fail: { (errType, errDes) in
                    AILoginUtil.showValidateResult(LoginConstants.ValidateResultCode.WrongIdOrPassword, validateInfoLabel: self.validateInfoLabel, widthConstraint: self.validateInfoLabelWidthConstraint)
            })
            
            
        } else {
            AILoginUtil.showValidateResult(LoginConstants.ValidateResultCode.WrongIdOrPassword, validateInfoLabel: validateInfoLabel, widthConstraint: validateInfoLabelWidthConstraint)
        }
    }
    
    
    @IBAction func forgotPasswordAction(sender: UIButton) {
        
        let validateVC = UIStoryboard(name: AIApplication.MainStoryboard.MainStoryboardIdentifiers.AILoginStoryboard, bundle: nil).instantiateViewControllerWithIdentifier(AIApplication.MainStoryboard.ViewControllerIdentifiers.AIRegistViewController)
        //设置类型为忘记密码
        AILoginPublicValue.loginType = LoginConstants.LoginType.ForgotPassword
        self.navigationController?.pushViewController(validateVC, animated: true)
    }
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        AILoginPublicValue.loginType = LoginConstants.LoginType.Login
        setupViews()
        setupNavigationBar()
        
        #if !DEBUG
            userIdTextField.text = "213231231321"
            passwordTextField.text = "1233123213"
            loginButton.enabled = true
        #endif
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        view.endEditing(true)
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == AIApplication.MainStoryboard.StoryboardSegues.RegisterSegue {
            AILoginPublicValue.loginType = LoginConstants.LoginType.Register
        }
    }
    
    
    func setupNavigationBar() {
        let navigationBar = self.navigationController!.navigationBar
        navigationBar.setBackgroundImage(UIImage(), forBarMetrics: UIBarMetrics.Default)
        navigationBar.shadowImage = UIImage()
        navigationBar.backgroundColor = UIColor.clearColor()
        navigationBar.translucent = true
        self.navigationController?.navigationBarHidden = true
    }
    
    func setupViews() {
        userIdTextField.delegate = self
        userIdTextField.keyboardType = UIKeyboardType.DecimalPad
        userIdTextField.returnKeyType = UIReturnKeyType.Done
        passwordTextField.delegate = self
        passwordTextField.secureTextEntry = true
        passwordTextField.returnKeyType = UIReturnKeyType.Go
        
        passwordTextField.addTarget(self, action: #selector(AILoginViewController.passwordInputAction(_:)), forControlEvents: UIControlEvents.EditingChanged)
        
        loginButton.setBackgroundImage(LoginConstants.PropertyConstants.ButtonDisabledColor.imageWithColor(), forState: UIControlState.Disabled)
        loginButton.setBackgroundImage(LoginConstants.PropertyConstants.ButtonNormalColor.imageWithColor(), forState: UIControlState.Normal)
        loginButton.enabled = false
        
        validateInfoLabelWidthConstraint.constant = 0
        validateInfoLabel.layer.cornerRadius = 8
        validateInfoLabel.font = LoginConstants.Fonts.validateResult
        validateInfoLabel.layer.masksToBounds = true
    }
    
    func passwordInputAction(target: UITextField) {
        loginButton.enabled = (target.text?.length >= 6)
    }
    
}

extension AILoginViewController : UITextFieldDelegate {
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    func textFieldDidBeginEditing(textField: UITextField) {
        
        SpringAnimation.spring(0.5) {
            self.logoImageTopConstraint.constant = -20
            self.logoImageCenterXConstraint.constant = -170
            self.appNameCenterXConstraint.constant = 80
            self.appNameViewTopConstraint.constant = -55
            self.view.layoutIfNeeded()
            self.logoImageView.transform = CGAffineTransformScale(CGAffineTransformIdentity, 0.4, 0.4)
        }
    }
    
    func textFieldDidEndEditing(textField: UITextField) {
        SpringAnimation.spring(0.5) {
            self.logoImageTopConstraint.constant = 80
            self.logoImageCenterXConstraint.constant = 0
            self.appNameCenterXConstraint.constant = 0
            self.appNameViewTopConstraint.constant = 0
            self.view.layoutIfNeeded()
            self.logoImageView.transform = CGAffineTransformScale(CGAffineTransformIdentity, 1, 1)
        }
    }
    
    
}

protocol AILoginViewControllerDelegate: class {
    func loginViewControllerDidLogin(controller: AILoginViewController)
}
