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
import IQKeyboardManagerSwift

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
        
        view.userInteractionEnabled = false
        showButtonLoading(loginButton)
        if AILoginUtil.validatePassword(passwordTextField.text) && AILoginUtil.validatePhoneNumber(userIdTextField.text) {
            loginService.login(userIdTextField.text!, password: passwordTextField.text!, success: { (userId) in
                self.view.userInteractionEnabled = true
                self.hideButtonLoading(self.loginButton, title: title)
                self.showMainViewController() // 切换到主页
                }, fail: { (errType, errDes) in
                    self.view.userInteractionEnabled = true
                    self.hideButtonLoading(self.loginButton, title: title)
                    self.validateInfoLabel.showPrompt(errDes)
            })
            
            
        } else {
            self.hideButtonLoading(self.loginButton, title: title)
            self.validateInfoLabel.showPrompt(LoginConstants.ValidateResultCode.WrongIdOrPassword.rawValue)
        }
    }

    //MARK: 新增-切换到主页，替代原来的dismiss方法
    func showMainViewController() {
        let root = AIRootViewController()
        let mainRootViewController = UINavigationController(rootViewController: root)
        mainRootViewController.navigationBarHidden = true
        UIApplication.sharedApplication().keyWindow?.rootViewController = mainRootViewController
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
        
        #if DEBUG
            // 刘晓娜
            userIdTextField.text = "18081999401"
            passwordTextField.text = "123456"
            loginButton.enabled = true

        #endif
        
        setupNotifications()
    }
    
    func setupNotifications() {
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(AILoginViewController.handleDidRegisted(_:)), name: AIApplication.Notification.UserDidRegistedNotification, object: nil)
    }
    func handleDidRegisted(n: NSNotification) {
       userIdTextField.text = AILoginPublicValue.phoneNumber
    }
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        //必须在view出现和消失是设置是否显示导航栏
        self.navigationController?.navigationBarHidden = true
        //这个界面不需要躲键盘
        IQKeyboardManager.sharedManager().enable = false
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        //必须在view出现和消失是设置是否显示导航栏
        self.navigationController?.navigationBarHidden = false
        IQKeyboardManager.sharedManager().enable = true
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
    
    func setupViews() {
        //userIdTextField
        userIdTextField.delegate = self
        userIdTextField.keyboardType = UIKeyboardType.DecimalPad
        userIdTextField.returnKeyType = UIReturnKeyType.Done
        userIdTextField.attributedPlaceholder = buildUserIdAttributePlaceholder()
        userIdTextField.addTarget(self, action: #selector(AILoginViewController.passwordInputAction(_:)), forControlEvents: UIControlEvents.EditingChanged)
        //passwordTextField
        passwordTextField.delegate = self
        passwordTextField.buildCustomerPlaceholder(LoginConstants.Fonts.promptLabel, color: LoginConstants.Colors.TextFieldPlaceholder, text: LoginConstants.textContent.passwordPlaceholder)
        passwordTextField.addTarget(self, action: #selector(AILoginViewController.passwordInputAction(_:)), forControlEvents: UIControlEvents.EditingChanged)
        //loginButton
        loginButton.enabled = false
    }
    
    func passwordInputAction(target: UITextField) {
        loginButton.enabled = AILoginUtil.validatePassword(passwordTextField.text) && AILoginUtil.validatePhoneNumber(userIdTextField.text)
    }
    
    private func buildUserIdAttributePlaceholder() -> NSAttributedString {
        let attrPlaceholder = NSMutableAttributedString(string: LoginConstants.textContent.UserIdPlaceholder)
        let textAttachment = NSTextAttachment(data: nil, ofType: nil)
        textAttachment.image = UIImage(named: "login_logo_small")
        textAttachment.bounds = CGRect(x: 0, y: 0, width: 64.displaySizeFrom1242DesignSize(), height: 61.displaySizeFrom1242DesignSize())
        let textAttachementString = NSAttributedString(attachment: textAttachment)
        attrPlaceholder.insertAttributedString(textAttachementString, atIndex: 0)
        //通过这个调整垂直对齐的高度
        attrPlaceholder.addAttribute(NSBaselineOffsetAttributeName, value: 4.0, range: NSMakeRange(1, attrPlaceholder.length - 1))
        attrPlaceholder.addAttribute(NSForegroundColorAttributeName, value: LoginConstants.Colors.TextFieldPlaceholder, range: NSMakeRange(1, attrPlaceholder.length - 1))
        attrPlaceholder.addAttribute(NSFontAttributeName, value: LoginConstants.Fonts.promptLabel, range: NSMakeRange(0, attrPlaceholder.length))
        return attrPlaceholder
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
