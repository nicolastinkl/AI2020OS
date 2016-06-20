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

    @IBOutlet weak var validationButtonWidthConstrant: NSLayoutConstraint!
    @IBOutlet weak var validationButton: UIButton!
    @IBOutlet weak var identifyTextField: UITextField!
    @IBOutlet weak var nextStepButton: DesignableButton!

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

        AVOSCloud.verifySmsCode(validateCode, mobilePhoneNumber: phoneNumber) { (bol, error) in
            if bol {
                let changePasswordVC = UIStoryboard(name: AIApplication.MainStoryboard.MainStoryboardIdentifiers.AILoginStoryboard, bundle: nil).instantiateViewControllerWithIdentifier(AIApplication.MainStoryboard.ViewControllerIdentifiers.AIChangePasswordViewController)
                //设置类型为忘记密码
                AILoginPublicValue.loginType = AILoginUtil.LoginType.ForgotPassword
                self.navigationController?.pushViewController(changePasswordVC, animated: true)
            } else {
                AIAlertView().showError("input error validate code", subTitle: error.description)
            }
        }
    }

    @IBAction func sendValidationAction(sender: UIButton) {

        if let phoneNumber = AILoginPublicValue.phoneNumber {
            AVOSCloud.requestSmsCodeWithPhoneNumber(phoneNumber, callback: { (bol, error) in
                if bol {
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
                    }                } else {
                    AIAlertView().showError("Request validation code failed", subTitle: error.description)
                }
            })
        }


    }

    func changeTimer(timer: NSTimer) {
        let timerInterval = NSInteger(timerEndDate.timeIntervalSinceNow) % 60

        if timerInterval == 0 {
            self.timer!.invalidate()
            self.timer = nil

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
        if AILoginPublicValue.loginType == AILoginUtil.LoginType.ForgotPassword {
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
        //navigation
        handleLoginType()
        //修复navigationController侧滑关闭失效的问题
        self.navigationController?.interactivePopGestureRecognizer?.delegate = self
    }

}
