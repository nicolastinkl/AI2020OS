//
//  AIRegistViewController.swift
//  AIVeris
//
//  Created by 刘先 on 16/5/26.
//  Copyright © 2016年 ___ASIAINFO___. All rights reserved.
//

import UIKit
import Spring

class AIRegistViewController: UIViewController,UIGestureRecognizerDelegate {

    
    @IBOutlet weak var regionSelectContainerView: UIView!
    @IBOutlet weak var nextStepButton: DesignableButton!
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

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    // MARK: - Navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == AIApplication.MainStoryboard.StoryboardSegues.SelectRegionSegue{
            if let selectRegionVC = segue.destinationViewController as? AISelectRegionViewController{
                selectRegionVC.delegate = self
            }
        }
        else if segue.identifier == AIApplication.MainStoryboard.StoryboardSegues.ValidateRegisterSegue{
            if let _ = segue.destinationViewController as? AIValidateRegistViewController{
                AILoginPublicValue.phoneNumber = phoneNumberTextField.text
                phoneNumberTextField.resignFirstResponder()
            }
            
        }
    }

    override func shouldPerformSegueWithIdentifier(identifier: String, sender: AnyObject?) -> Bool {
        return true
    }
    
    func handleLoginType(){
        if AILoginPublicValue.loginType == AILoginUtil.LoginType.ForgotPassword{
            self.setupLoginNavigationBar("Forgot Password")
        }
        else{
            self.setupLoginNavigationBar("Register")
        }
    }


    func setupViews(){
        phoneNumberTextField.leftViewMode = UITextFieldViewMode.Always
        let frame = CGRect(x: 0, y: 0, width: 80, height: phoneNumberTextField.height)
        let leftView = UILabel(frame: frame)
        leftView.text = "+86"
        leftView.textAlignment = NSTextAlignment.Center
        leftView.textColor = UIColor.whiteColor()
        phoneNumberTextField.leftView = leftView
        phoneNumberTextField.addTarget(self, action: #selector(AIRegistViewController.phoneNumberInputAction(_:)), forControlEvents: UIControlEvents.EditingChanged)
        
        nextStepButton.setBackgroundImage(AILoginUtil.PropertyConstants.ButtonDisabledColor.imageWithColor(), forState: UIControlState.Disabled)
        nextStepButton.setBackgroundImage(AILoginUtil.PropertyConstants.ButtonNormalColor.imageWithColor(), forState: UIControlState.Normal)
        nextStepButton.enabled = false
    }
    
    //TODO: 这里要根据规则判断，调用判断方法
    func phoneNumberInputAction(target : UITextField){
        nextStepButton.enabled = (AILoginUtil.validatePhoneNumber(target.text!))
    }
}

extension AIRegistViewController : AISelectRegionViewControllerDelegate{
    func didSelectRegion(regionName: String, countryNumber: String) {
        if let leftView = phoneNumberTextField.leftView as? UILabel{
            leftView.text = countryNumber
        }
        regionSelectButton.titleLabel?.text = regionName
    }
}


