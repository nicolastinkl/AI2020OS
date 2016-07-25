//
//  AILoginViewController.swift
//  AIVeris
//
//  Created by 刘先 on 16/5/25.
//  Copyright © 2016年 ___ASIAINFO___. All rights reserved.
//

import UIKit
import Spring
import SVProgressHUD


class AILoginViewController: UIViewController {
    
    // MARK: -IBOutlets
    @IBOutlet weak var loginButton: AIChangeStatusButton!
    @IBOutlet weak var logoImageView: UIImageView!
    @IBOutlet weak var appNameCenterXConstraint: NSLayoutConstraint!
    @IBOutlet weak var appNameViewTopConstraint: NSLayoutConstraint!
    @IBOutlet weak var logoImageTopConstraint: NSLayoutConstraint!
    @IBOutlet weak var userIdTextField: AILoginBaseTextField!
    @IBOutlet weak var passwordTextField: AILoginPasswordTextField!
    @IBOutlet weak var logoImageCenterXConstraint: NSLayoutConstraint!
    @IBOutlet weak var validateInfoLabel: AIAnimatedPromptLabel!
    
    let loginService = AILoginService()
    
    // MARK: -IBActions
    @IBAction func loginAction(sender: AnyObject) {
        let title = loginButton.titleLabel?.text ?? ""
        loginButton.showActioningLoading()
        if AILoginUtil.validatePassword(passwordTextField.text) && AILoginUtil.validatePhoneNumber(userIdTextField.text) {
            loginService.login(userIdTextField.text!, password: passwordTextField.text!, success: { (userId) in
                self.loginButton.hideActioningLoading(title)
                AILoginUtil.handleUserLogin(userId)
                self.dismissViewControllerAnimated(true, completion: nil)
                }, fail: { (errType, errDes) in
                    self.loginButton.hideActioningLoading(title)
                    self.validateInfoLabel.showPrompt(LoginConstants.ValidateResultCode.WrongIdOrPassword.rawValue)
            })
            
            
        } else {
            self.loginButton.hideActioningLoading(title)
            self.validateInfoLabel.showPrompt(LoginConstants.ValidateResultCode.WrongIdOrPassword.rawValue)
        }
    }
    
    
    @IBAction func forgotPasswordAction(sender: UIButton) {
        
        let validateVC = UIStoryboard(name: AIApplication.MainStoryboard.MainStoryboardIdentifiers.AILoginStoryboard, bundle: nil).instantiateViewControllerWithIdentifier(AIApplication.MainStoryboard.ViewControllerIdentifiers.AIRegistViewController)
        //设置类型为忘记密码
        AILoginPublicValue.loginType = LoginConstants.LoginType.ForgotPassword
        self.navigationController?.pushViewController(validateVC, animated: true)
    }
    
    
    // MARK: -lifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        AILoginPublicValue.loginType = LoginConstants.LoginType.Login
        setupViews()
        setupNavigationBar()
        
        #if DEBUG
//            userIdTextField.text = "18982194190"
//            passwordTextField.text = "nodgdi"
//            loginButton.enabled = true
        #endif
        
        
//        let image = AIImageView(image: UIImage(named: "AIRequirebg1"))
//        view.addSubview(image)
//        image.frame = CGRectMake(100, 450, 100, 100)
//        image.uploadImage { (url, error) in
//            debugPrint(url)
//        }
        
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
    
    // MARK: -private methods
    func setupNavigationBar() {
//        let navigationBar = self.navigationController!.navigationBar
//        navigationBar.setBackgroundImage(UIImage(), forBarMetrics: UIBarMetrics.Default)
//        navigationBar.shadowImage = UIImage()
//        navigationBar.backgroundColor = UIColor.clearColor()
//        navigationBar.translucent = true
        self.navigationController?.navigationBarHidden = true
    }
    
    func setupViews() {
        //userIdTextField
        userIdTextField.delegate = self
        userIdTextField.keyboardType = UIKeyboardType.DecimalPad
        userIdTextField.returnKeyType = UIReturnKeyType.Done
        userIdTextField.addTarget(self, action: #selector(AILoginViewController.passwordInputAction(_:)), forControlEvents: UIControlEvents.EditingChanged)
        //passwordTextField
        passwordTextField.delegate = self
        passwordTextField.addTarget(self, action: #selector(AILoginViewController.passwordInputAction(_:)), forControlEvents: UIControlEvents.EditingChanged)
        //loginButton
        loginButton.enabled = false
        //validateInfoLabel
//        validateInfoLabelWidthConstraint.constant = 0
//        validateInfoLabel.layer.cornerRadius = 8
//        validateInfoLabel.font = LoginConstants.Fonts.validateResult
//        validateInfoLabel.layer.masksToBounds = true
    }
    
    func passwordInputAction(target: UITextField) {
        loginButton.enabled = AILoginUtil.validatePassword(passwordTextField.text) && AILoginUtil.validatePhoneNumber(userIdTextField.text)
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
