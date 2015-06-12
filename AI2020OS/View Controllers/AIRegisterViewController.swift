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
    
    @IBOutlet weak var placeHolderText: DesignableTextField!
    
    @IBOutlet weak var receiveLabel: UILabel!
    
    @IBOutlet weak var receiveView: SpringView!
    // MARK: getters and setters
    
    private var timer: NSTimer!
    private var remainTime: Int!
    
    // MARK: life cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "注册新账号"
        addLine()
    }
    
    func addLine(){
        localCode({
            
            let color = UIColor(rgba: AIApplication.AIColor.AIVIEWLINEColor).CGColor
            let lineLayer =  CALayer()
            lineLayer.backgroundColor = color
            lineLayer.frame = CGRectMake(0, 0, self.phoneTextField.width, 0.5)
            self.phoneTextField.layer.addSublayer(lineLayer)
            
        })
        
        localCode { () -> () in
            
            let color = UIColor(rgba: AIApplication.AIColor.AIVIEWLINEColor).CGColor
            let lineLayer =  CALayer()
            lineLayer.backgroundColor = color
            lineLayer.frame = CGRectMake(0, 0, self.passwordTextField.width, 0.5)
            self.passwordTextField.layer.addSublayer(lineLayer)
            
        }
        
        localCode { () -> () in
            let color = UIColor(rgba: AIApplication.AIColor.AIVIEWLINEColor).CGColor
            let lineLayer =  CALayer()
            lineLayer.backgroundColor = color
            lineLayer.frame = CGRectMake(0, self.passwordTextField.height-1, self.passwordTextField.width, 0.5)
            self.passwordTextField.layer.addSublayer(lineLayer)
        }
        
        
        localCode { () -> () in
            let color = UIColor(rgba: AIApplication.AIColor.AIVIEWLINEColor).CGColor
            let lineLayer =  CALayer()
            lineLayer.backgroundColor = color
            lineLayer.frame = CGRectMake(0, self.passwordTextField.height-1, self.passwordTextField.width, 0.5)
            self.placeHolderText.layer.addSublayer(lineLayer)
        }        
        
        localCode { () -> () in
            let color = UIColor(rgba: AIApplication.AIColor.AIVIEWLINEColor).CGColor
            let lineLayer =  CALayer()
            lineLayer.backgroundColor = color
            lineLayer.frame = CGRectMake(0, self.passwordTextField.height-1, self.passwordTextField.width, 0.5)
            self.verifyTextFeild.layer.addSublayer(lineLayer)
        }
        
        
        
    }
    
    // MARK: event response
    
    @IBAction func disMissKeyboardAction(sender: UITapGestureRecognizer) {
        self.phoneTextField.resignFirstResponder()
        self.passwordTextField.resignFirstResponder()
        
    }
    
    @IBAction func requestVerifyAction(sender: AnyObject) {
        self.phoneTextField.resignFirstResponder()
        self.verifyTextFeild.resignFirstResponder()
        self.passwordTextField.resignFirstResponder()
        
        let verifyCode  = self.verifyTextFeild.text
        if verifyCode.isEmpty {
            return
        }
        self.view.showLoading()
        AVUser.verifyMobilePhone(verifyCode, withBlock: { (success, error) -> Void in
            self.view.hideLoading()
            if success {
                AILocalStore.setAccessToken(self.phoneTextField.text)
                
                self.dismissViewControllerAnimated(true, completion: nil)
            }else{
                SCLAlertView().showError("提示", subTitle: "验证码错误", closeButtonTitle: "关闭", duration: 2)
            }
        })
        
    }
    
    // 每秒定时触发
    func countDown() {
        if(remainTime <= 0){
            //倒计时结束
            self.timer.invalidate()
            self.receiveLabel.text = ""
        } else {
            remainTime = remainTime - 1
            self.receiveLabel.text = "接收短信大约需要\(remainTime)秒"
        }
    }
    
    
    
    @IBAction func registerAction(sender: AnyObject) {
        
        
        if self.phoneTextField.text.length > 0 && self.passwordTextField.text.length > 0{

            self.view.showLoading()
            self.phoneTextField.resignFirstResponder()
            self.verifyTextFeild.resignFirstResponder()
            self.passwordTextField.resignFirstResponder()
            
            self.placeHolderText.text = "手机号:  \(phoneTextField.text)"
            var newUser:AVUser = AVUser()
            //正式注册
            newUser.username = self.phoneTextField.text
            newUser.mobilePhoneNumber = self.phoneTextField.text
            newUser.password = self.passwordTextField.text
            newUser.signUpInBackgroundWithBlock({ (succeeded, error) -> Void in
                self.view.hideLoading()
                if succeeded{
                    self.receiveView.hidden = false
                    self.receiveView.animate()
                    self.remainTime = 60
                    self.timer = NSTimer.scheduledTimerWithTimeInterval(1, target: self, selector: "countDown", userInfo: nil, repeats:true);
                    self.timer.fire()

                    
                }else{
                    
                    if let err = error as NSError? {
                        SCLAlertView().showError("提示", subTitle: "\(err.localizedDescription)", closeButtonTitle: "关闭", duration: 2)
                    }
                    
                    
                }
            })
            
        }
        
    }

}