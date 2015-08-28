//
//  AILoginViewController.swift
//  AI2020OS
//
//  Created by tinkl on 18/5/15.
//  Copyright (c) 2015 ___ASIAINFO___. All rights reserved.
//

import Foundation
import Spring
import SCLAlertView

class AILoginViewController: UIViewController {
    
    // MARK: getters and setters
    
    weak var delegate: AILoginViewControllerDelegate?
    
    @IBOutlet weak var phoneTextFlied: DesignableTextField!
    
    @IBOutlet weak var passwordTextFlied: DesignableTextField!
    
    
    
    
    
    
    // MARK: life cycle
    
    override func viewDidLoad() {
    
        super.viewDidLoad()
      
        addLine()
       
    }
    
    func addLine(){
        localCode({
        
            let color = UIColor(rgba: AIApplication.AIColor.AIVIEWLINEColor).CGColor
            let lineLayer =  CALayer()
            lineLayer.backgroundColor = color
            lineLayer.frame = CGRectMake(0, 0, self.phoneTextFlied.width, 0.5)
            self.phoneTextFlied.layer.addSublayer(lineLayer)
        
        })
        
        
        localCode { () -> () in
            
            let color = UIColor(rgba: AIApplication.AIColor.AIVIEWLINEColor).CGColor
            let lineLayer =  CALayer()
            lineLayer.backgroundColor = color
            lineLayer.frame = CGRectMake(0, 0, self.phoneTextFlied.width, 0.5)
            self.passwordTextFlied.layer.addSublayer(lineLayer)
            
        }

        
        
        localCode { () -> () in
            let color = UIColor(rgba: AIApplication.AIColor.AIVIEWLINEColor).CGColor
            let lineLayer =  CALayer()
            lineLayer.backgroundColor = color
            lineLayer.frame = CGRectMake(0, self.passwordTextFlied.height-1, self.phoneTextFlied.width, 0.5)
            self.passwordTextFlied.layer.addSublayer(lineLayer)
        }
    }
    
    override func viewWillAppear(animated: Bool) {
        
        super.viewWillAppear(animated)
        
//        navigationController?.setNavigationBarHidden(true, animated: true)

       self.navigationController?.navigationBar.setBackgroundImage(UIImage(named: "navigationbar-white"), forBarMetrics: UIBarMetrics.Default)
        navigationController?.interactivePopGestureRecognizer.delegate = nil
    }
    
    // MARK: event response
    @IBAction func disMissKeyboardAction(sender: UITapGestureRecognizer) {
        self.phoneTextFlied.resignFirstResponder()
        self.passwordTextFlied.resignFirstResponder()
    }
    
    @IBAction func loginAction(sender: AnyObject) {
        
        if self.phoneTextFlied.text.length > 0 && self.passwordTextFlied.text.length > 0{
            self.view.showLoading()
            self.phoneTextFlied.resignFirstResponder()
            self.passwordTextFlied.resignFirstResponder()
            
            AVUser.logInWithMobilePhoneNumberInBackground(self.phoneTextFlied.text, password: self.passwordTextFlied.text) { (user, error) -> Void in
                self.view.hideLoading()
                func loginFaile(){
                    SCLAlertView().showError("提示", subTitle: "登录失败", closeButtonTitle: "关闭", duration: 2)
                    
                }
                if let u = user{
                    // dissmiss viewController
                    AILocalStore.setAccessToken(self.phoneTextFlied.text)
                    
                    
                    AIServicesRequester().cachaUserInfo(self.phoneTextFlied.text, completion: { (success) -> () in
                        if success {
                            NSNotificationCenter.defaultCenter().postNotificationName(AIApplication.Notification.UIAIASINFOLoginNotification, object: nil)
                            self.dismissViewControllerAnimated(true, completion: { () -> Void in
                                
                            })
                        }else{
                            loginFaile()
                        }
                    })
                }else{
                    loginFaile()
                    
                }
            }
        }else{
             SCLAlertView().showError("提示", subTitle: "手机号或密码不能为空", closeButtonTitle: "关闭", duration: 2)
        }
         
    }
    
}

// MARK: function extension

extension AILoginViewController: UITextFieldDelegate{
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}