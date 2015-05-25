//
//  AIRegisterViewController.swift
//  AI2020OS
//
//  Created by tinkl on 18/5/15.
//  Copyright (c) 2015 ___ASIAINFO___. All rights reserved.
//

import Foundation
import Spring
import SCLAlertView


class AIRegisterViewController : UIViewController {

    // MARK: swift controls
    
    @IBOutlet weak var phoneTextField: DesignableTextField!
    
    @IBOutlet weak var verifyTextFeild: DesignableTextField!
    
    @IBOutlet weak var passwordTextField: DesignableTextField!
    
    @IBOutlet weak var requestVerify: DesignableButton!
    
    // MARK: getters and setters
    
    private var timer: NSTimer!
    private var remainTime: Int!
    
    // MARK: life cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    // MARK: event response
    
    @IBAction func requestVerifyAction(sender: AnyObject) {
        self.phoneTextField.resignFirstResponder()
        self.verifyTextFeild.resignFirstResponder()
        self.passwordTextField.resignFirstResponder()
        
        let phoneText  = self.phoneTextField.text
        AVUser.requestMobilePhoneVerify(phoneText, withBlock: { (bol, error) -> Void in
            if bol{
                self.requestVerify.enabled = false
                self.remainTime = 60
                self.timer = NSTimer.scheduledTimerWithTimeInterval(1, target: self, selector: "countDown", userInfo: nil, repeats:true);
                self.timer.fire()
            }else
            {
                SCLAlertView().showError("提示", subTitle: "验证码获取失败", closeButtonTitle: "关闭", duration: 2)
            }
        })
    
    }
    
    // 每秒定时触发
    func countDown() {
        if(remainTime < 0){
            //倒计时结束
            self.timer.invalidate()
            requestVerify.enabled = true
            self.requestVerify.setTitle("重新获取", forState: UIControlState.Normal)
        } else {
            remainTime = remainTime - 1
            let title:String = "\(remainTime)秒"
            self.requestVerify.setTitle(title, forState: UIControlState.Normal)
        }
    }
    
    
    @IBAction func registerAction(sender: AnyObject) {
        
        
        if self.phoneTextField.text.length > 0 && self.passwordTextField.text.length > 0{

            self.view.showLoading()
            self.phoneTextField.resignFirstResponder()
            self.verifyTextFeild.resignFirstResponder()
            self.passwordTextField.resignFirstResponder()
            
            var newUser:AVUser = AVUser()
            //正式注册
            newUser.username = self.phoneTextField.text
            newUser.mobilePhoneNumber = self.phoneTextField.text
            newUser.password = self.passwordTextField.text
            newUser.signUpInBackgroundWithBlock({ (succeeded, error) -> Void in
                if succeeded{
                    AILocalStore.setAccessToken(self.phoneTextField.text)
                    self.view.hideLoading()
                    self.dismissViewControllerAnimated(true, completion: nil)
                }else{
                     SCLAlertView().showError("提示", subTitle: "注册失败", closeButtonTitle: "关闭", duration: 2)
                }
            })

            //二次验证验证码是否正确
            /*AVUser.verifyMobilePhone(self.verifyTextFeild.text, withBlock: { (bol, Error) -> Void in
            })*/
            
        }
        
    }

}