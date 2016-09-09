//
//  AIRegistViewController.swift
//  AIVeris
//
//  Created by 刘先 on 16/5/26.
//  Copyright © 2016年 ___ASIAINFO___. All rights reserved.
//

import UIKit
import Spring

class AIRegistViewController: UIViewController, UIGestureRecognizerDelegate {

    @IBOutlet weak var promoteLabel: AILoginPromptLabel!
    @IBOutlet weak var regionTitleLabel: UILabel!
    @IBOutlet weak var regionSelectContainerView: UIView!
    @IBOutlet weak var nextStepButton: AIChangeStatusButton!
    @IBOutlet weak var phoneNumberTextField: UITextField!
    @IBOutlet weak var regionSelectButton: UIButton!

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        setupViews()
        self.navigationController?.navigationBarHidden = false
        handleLoginType()
        //修复navigationController侧滑关闭失效的问题
        self.navigationController?.interactivePopGestureRecognizer?.delegate = self

    }

    // MARK: - Navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == AIApplication.MainStoryboard.StoryboardSegues.SelectRegionSegue {
            if let selectRegionVC = segue.destinationViewController as? AISelectRegionViewController {
                selectRegionVC.delegate = self
            }
        } else if segue.identifier == AIApplication.MainStoryboard.StoryboardSegues.ValidateRegisterSegue {
            if let _ = segue.destinationViewController as? AIValidateRegistViewController {
                AILoginPublicValue.phoneNumber = phoneNumberTextField.text
                phoneNumberTextField.resignFirstResponder()
            }
        }
    }

    override func shouldPerformSegueWithIdentifier(identifier: String, sender: AnyObject?) -> Bool {
        return true
    }

    func handleLoginType() {
        if AILoginPublicValue.loginType == LoginConstants.LoginType.ForgotPassword {
            self.setupLoginNavigationBar("LoginConstants.forgetButton".localized)
        } else {
            self.setupLoginNavigationBar("LoginConstants.registerButton".localized)
        }
    }


    func setupViews() {
        phoneNumberTextField.leftViewMode = UITextFieldViewMode.Always
        let frame = CGRect(x: 0, y: 0, width: 80, height: phoneNumberTextField.height)
        let leftView = UILabel(frame: frame)
        leftView.text = "+86"
        leftView.textAlignment = NSTextAlignment.Center
        leftView.textColor = UIColor.whiteColor()
        leftView.font = LoginConstants.Fonts.textFieldInput
        phoneNumberTextField.leftView = leftView
        phoneNumberTextField.buildCustomerPlaceholder(LoginConstants.Fonts.promptLabel, color: LoginConstants.Colors.TextFieldPlaceholder, text: LoginConstants.textContent.UserIdPlaceholder)

        phoneNumberTextField.addTarget(self, action: #selector(AIRegistViewController.phoneNumberInputAction(_:)), forControlEvents: UIControlEvents.EditingChanged)

        nextStepButton.enabled = false
        
        regionTitleLabel.font = LoginConstants.Fonts.textFieldInput
        regionSelectButton.titleLabel?.font = LoginConstants.Fonts.textFieldInput
        regionSelectButton.setTitle("\("Countries.China".localized) >", forState: UIControlState.Normal)
        regionSelectContainerView.backgroundColor = LoginConstants.Colors.TextFieldBackground
        regionSelectContainerView.layer.cornerRadius = 5
        regionSelectContainerView.layer.masksToBounds = true
        regionSelectContainerView.layer.borderColor = LoginConstants.Colors.TextFieldBorder.CGColor
        regionSelectContainerView.layer.borderWidth = 1
        
        if AILoginPublicValue.loginType == LoginConstants.LoginType.ForgotPassword {
            promoteLabel.text = LoginConstants.textContent.forgotPasswordPrompt
        }
    }

    //TODO: 这里要根据规则判断，调用判断方法
    func phoneNumberInputAction(target: UITextField) {
        nextStepButton.enabled = (AILoginUtil.validatePhoneNumber(target.text!))
    }
    
    func showValidateResult(validateResultCode: LoginConstants.ValidateResultCode) {
        _ = validateResultCode.rawValue
        //let width = resultText.sizeWithFont(<#T##font: UIFont##UIFont#>, forWidth: <#T##CGFloat#>)
    }
}

extension AIRegistViewController : AISelectRegionViewControllerDelegate {
    func didSelectRegion(regionName: String, countryNumber: String) {
        if let leftView = phoneNumberTextField.leftView as? UILabel {
            leftView.text = countryNumber
        }
        regionSelectButton.setTitle("\(regionName) >", forState: UIControlState.Normal)
    }
}
