//
//  AIValidateRegistViewController.swift
//  AIVeris
//
//  Created by 刘先 on 16/5/28.
//  Copyright © 2016年 ___ASIAINFO___. All rights reserved.
//

import UIKit
import Spring
import SnapKit
import AIAlertView

class AIValidateRegistViewController: UIViewController, UIGestureRecognizerDelegate {

    let buttonTitle1 = "Send Validation Code"
    let buttonTitle2 = "Resend"
    let titleFont = UIFont.systemFontOfSize(12)

    var timer: NSTimer?
    var timerEndDate: NSDate!

    @IBOutlet weak var validationContainerView: UIView!
    @IBOutlet weak var validationButtonWidthConstrant: NSLayoutConstraint!
    @IBOutlet weak var validationButton: UIButton!
    @IBOutlet weak var identifyTextField: UITextField!
    @IBOutlet weak var nextStepButton: AIChangeStatusButton!
    
    @IBOutlet weak var promoteLabel: AILoginPromptLabel!
    @IBOutlet weak var validateInfoLabel: UILabel!
    @IBOutlet weak var validateInfoWidthConstraint: NSLayoutConstraint!

    var loginService = AILoginService()
    // MARK: -> life cycle
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        setupViews()

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


    @IBAction func nextStepAction(sender: DesignableButton) {

        guard let validateCode = identifyTextField.text else {return}
        guard let phoneNumber = AILoginPublicValue.phoneNumber else {return}
        
        //短信验证码赋值到全局变量
        AILoginPublicValue.smsCode = validateCode
        
        if AILoginPublicValue.loginType == LoginConstants.LoginType.Register {
            AVOSCloud.verifySmsCode(validateCode, mobilePhoneNumber: phoneNumber) { (bol, error) in
                if bol {
                    let changePasswordVC = UIStoryboard(name: AIApplication.MainStoryboard.MainStoryboardIdentifiers.AILoginStoryboard, bundle: nil).instantiateViewControllerWithIdentifier(AIApplication.MainStoryboard.ViewControllerIdentifiers.AIChangePasswordViewController)
                    self.navigationController?.pushViewController(changePasswordVC, animated: true)
                } else {
                    AILoginUtil.showValidateResult(LoginConstants.ValidateResultCode.WrongIdOrPassword, validateInfoLabel: self.validateInfoLabel, widthConstraint: self.validateInfoWidthConstraint)
                }
            }
        } else if AILoginPublicValue.loginType == LoginConstants.LoginType.ForgotPassword {
            //重置密码的方法没法直接校验是否正确
            let changePasswordVC = UIStoryboard(name: AIApplication.MainStoryboard.MainStoryboardIdentifiers.AILoginStoryboard, bundle: nil).instantiateViewControllerWithIdentifier(AIApplication.MainStoryboard.ViewControllerIdentifiers.AIChangePasswordViewController)
            self.navigationController?.pushViewController(changePasswordVC, animated: true)
        }
    }

    @IBAction func sendValidationAction(sender: UIButton) {
        
        if let phoneNumber = AILoginPublicValue.phoneNumber {
            
            promoteLabel.text = "\(LoginConstants.textContent.validationPrompt) \(phoneNumber)"
            
            if AILoginPublicValue.loginType == LoginConstants.LoginType.Register {
                AVOSCloud.requestSmsCodeWithPhoneNumber(phoneNumber, callback: { (bol, error) in
                    if bol {
                        self.handleValidationButton()
                    } else {
                        AIAlertView().showError("Request validation code failed", subTitle: error.description)
                    }
                })
            } else if AILoginPublicValue.loginType == LoginConstants.LoginType.ForgotPassword {
                loginService.requestPasswordResetWithPhoneNumber(phoneNumber, success: {
                    self.handleValidationButton()
                    }, fail: { (errType, errDes) in
                        AIAlertView().showError("Request validation code failed", subTitle: errDes)
                })
            }
        }
    }
    
    /**
     处理点击发送验证码后的UI逻辑
     */
    func handleValidationButton() {
        let curButtonTitle = "\(self.buttonTitle2)(60 Sec)"
        let fontSize = curButtonTitle.sizeWithFont(self.titleFont, forWidth: self.view.width)
        self.validationButtonWidthConstrant.constant = fontSize.width + 20
        UIView.animateWithDuration(0.25, animations: {
            self.validationButton.layoutIfNeeded()
            //self.validationButtonWidthConstrant.constant = fontSize.width + 20
            
        }) { (finished) in
            if let timer = self.timer {
                timer.invalidate()
            }
            self.timerEndDate = NSDate(timeIntervalSinceNow: 60)
            self.validationButton.setTitle(curButtonTitle, forState: UIControlState.Normal)
            self.validationButton.enabled = false
            self.timer = NSTimer.scheduledTimerWithTimeInterval(0.1, target: self, selector: #selector(AIValidateRegistViewController.changeTimer(_:)), userInfo: nil, repeats: true)
        }
    }

    func changeTimer(timer: NSTimer) {
        let timerInterval = NSInteger(timerEndDate.timeIntervalSinceNow) % 60

        if timerInterval == 0 {
            self.timer!.invalidate()
            self.timer = nil
            //重置提示内容
            promoteLabel.text = " "
            let fontSize = buttonTitle1.sizeWithFont(titleFont, forWidth: view.width)
            self.validationButtonWidthConstrant.constant = fontSize.width + 20
            UIView.animateWithDuration(0.25, animations: {
                self.validationButton.layoutIfNeeded()

                }, completion: { (finished) in
                    self.validationButton.setTitle(self.buttonTitle1, forState: UIControlState.Normal)
                    self.validationButton.enabled = true
            })
        } else {
            let curButtonTitle = "\(buttonTitle2)(\(timerInterval) Sec)"
            validationButton.setTitle(curButtonTitle, forState: UIControlState.Normal)
        }
    }

    func handleLoginType() {
        if AILoginPublicValue.loginType == LoginConstants.LoginType.ForgotPassword {
            self.setupLoginNavigationBar("Forgot Password")
        } else {
            self.setupLoginNavigationBar("Enter Validation Code")
        }
    }


    func setupViews() {
        //rightView

        let fontSize = buttonTitle1.sizeWithFont(titleFont, forWidth: view.width)
        //validationButton
        validationButton.titleLabel?.font = titleFont
        validationButton.setTitle(buttonTitle1, forState: UIControlState.Normal)
        validationButton.setTitleColor(UIColor.whiteColor(), forState: UIControlState.Normal)
        validationButton.backgroundColor = UIColor.clearColor()
        let rightViewlayer = validationButton.layer
        rightViewlayer.borderColor = UIColor.whiteColor().CGColor
        rightViewlayer.borderWidth = 0.5
        rightViewlayer.opacity = 0.8
        rightViewlayer.cornerRadius = 8
        rightViewlayer.masksToBounds = true
        
        validationButtonWidthConstrant.constant = fontSize.width + 20
        //identifyTextField
        identifyTextField.clearButtonMode = UITextFieldViewMode.WhileEditing
        identifyTextField.addTarget(self, action: #selector(AIValidateRegistViewController.validateCodeInputAction(_:)), forControlEvents: UIControlEvents.EditingChanged)
        //navigation
        handleLoginType()
        //修复navigationController侧滑关闭失效的问题
        self.navigationController?.interactivePopGestureRecognizer?.delegate = self
        
        validateInfoWidthConstraint.constant = 0
        validateInfoLabel.layer.cornerRadius = 8
        validateInfoLabel.layer.masksToBounds = true
        
        //validationContainerView
        validationContainerView.backgroundColor = LoginConstants.Colors.TextFieldBackground
        validationContainerView.layer.cornerRadius = 5
        validationContainerView.layer.masksToBounds = true
        validationContainerView.layer.borderColor = LoginConstants.Colors.TextFieldBorder.CGColor
        validationContainerView.layer.borderWidth = 1
        //nextStepButton
        nextStepButton.enabled = false
    }

    func validateCodeInputAction(sender: UITextField) {
        nextStepButton.enabled = AILoginUtil.validateCode(identifyTextField.text)    }
}
