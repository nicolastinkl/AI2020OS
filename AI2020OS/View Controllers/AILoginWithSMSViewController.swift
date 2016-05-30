//
//  AILoginWithSMSViewController.swift
//  AI2020OS
//
//  Created by tinkl on 11/6/15.
//  Copyright (c) 2015 ___ASIAINFO___. All rights reserved.
//

import Foundation
import UIKit
import Spring
import SCLAlertView


/*

/*!
*  请求登录码验证
*  发送短信到指定的手机上，内容有6位数字验证码。验证码10分钟内有效。
*  @param phoneNumber 11位电话号码
*  @param block 回调结果
*/
class func requestLoginSmsCode(phoneNumber: String!, withBlock block: AVBooleanResultBlock!)

/*!
*  使用手机号码和验证码登录
*  @param phoneNumber 11位电话号码
*  @param code 6位验证码
*  @param error 发生错误通过此参数返回
*/
class func logInWithMobilePhoneNumber(phoneNumber: String!, smsCode code: String!, error: NSErrorPointer) -> Self!
*/

class AILoginWithSMSViewController: UIViewController {

    // MARK: var
    @IBOutlet weak var phoneTextField: DesignableTextField!
    
    @IBOutlet weak var verfyTextField: DesignableTextField!
    
    @IBOutlet weak var verfyButton: DesignableButton!
    
    
    private var timer: NSTimer!
    private var remainTime: Int!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "验证码登录"
        addLine()
    }
    
    func addLine(){
        
        localCode({
            
            let color = UIColor(rgba: AIApplication.AIColor.AIVIEWLINEColor).CGColor
            let lineLayer =  CALayer()
            lineLayer.backgroundColor = color
            lineLayer.frame = CGRectMake(0, 0, self.verfyTextField.width, 0.5)
            self.phoneTextField.layer.addSublayer(lineLayer)
            
        })
        
        localCode { () -> () in
            
            let color = UIColor(rgba: AIApplication.AIColor.AIVIEWLINEColor).CGColor
            let lineLayer =  CALayer()
            lineLayer.backgroundColor = color
            lineLayer.frame = CGRectMake(0, 0, self.verfyTextField.width, 0.5)
            self.verfyTextField.layer.addSublayer(lineLayer)
            
        }
        
        
        localCode { () -> () in
            
            let color = UIColor(rgba: AIApplication.AIColor.AIVIEWLINEColor).CGColor
            let lineLayer =  CALayer()
            lineLayer.backgroundColor = color
            lineLayer.frame = CGRectMake(0, self.verfyTextField.height-1, self.verfyTextField.width, 0.5)
            self.verfyTextField.layer.addSublayer(lineLayer)
        }
        
    }
    
    // 每秒定时触发
    func countDown() {
        if(remainTime <= 0){
            //倒计时结束
            self.timer.invalidate()
            self.verfyButton.enabled = true
            self.verfyButton.setTitle("重新获取", forState: UIControlState.Normal)
        } else {
            remainTime = remainTime - 1
            self.verfyButton.setTitle("\(remainTime)秒", forState: UIControlState.Normal)
        }
    }
    
    @IBAction func verfyAction(sender: AnyObject) {
        if self.phoneTextField.text.length > 0  {
            
            self.view.showLoading()
            
            self.phoneTextField.resignFirstResponder()
            self.verfyTextField.resignFirstResponder()
            
            AVUser.requestLoginSmsCode(self.phoneTextField.text, withBlock: { (success, error) -> Void in
                self.view.hideLoading()
                if success {
                    self.verfyButton.enabled = false
                    self.remainTime = 300
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
    
    @IBAction func loginAction(sender: AnyObject) {
        if self.phoneTextField.text.length > 0 && self.verfyTextField.text.length > 0  {
            
            self.view.showLoading()
            
            self.phoneTextField.resignFirstResponder()
            self.verfyTextField.resignFirstResponder()
            AVUser.logInWithMobilePhoneNumberInBackground(self.phoneTextField.text, smsCode:  self.verfyTextField.text, block: { (avuser, error) -> Void in
                self.view.hideLoading()

                func loginFaile(errorDes:NSError){
                    if let dicError = errorDes.userInfo {
                        let err = dicError["error"] as String?
                        SCLAlertView().showError("登录失败", subTitle: err ?? "", closeButtonTitle: "关闭", duration: 5)
                    }
                    
                }

                if avuser != nil {
                    AILocalStore.setAccessToken(self.phoneTextField.text)
                    
                    
                    AIServicesRequester().cachaUserInfo(self.phoneTextField.text, completion: { (success) -> () in
                        if success {
                            
                            NSNotificationCenter.defaultCenter().postNotificationName(AIApplication.Notification.UIAIASINFOLoginNotification, object: nil)
                            self.dismissViewControllerAnimated(true, completion: nil)
                            
                        }else{
                            loginFaile(error)
                        }
                    })
                    
                    
                }else{
                    SCLAlertView().showError("提示", subTitle: "登录失败", closeButtonTitle: "关闭", duration: 2)
                }
            })
            
        }
    }
    
    
}