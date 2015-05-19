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
    
    weak var delegate: AILoginViewControllerDelegate?
    
    @IBOutlet weak var phoneTextFlied: DesignableTextField!
    
    @IBOutlet weak var passwordTextFlied: DesignableTextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    @IBAction func loginAction(sender: AnyObject) {
        
        if self.phoneTextFlied.text.length > 0 && self.passwordTextFlied.text.length > 0{
            self.view.showLoading()
            self.phoneTextFlied.resignFirstResponder()
            self.passwordTextFlied.resignFirstResponder()
            
            AVUser.logInWithMobilePhoneNumberInBackground(self.phoneTextFlied.text, password: self.passwordTextFlied.text) { (user, error) -> Void in
                self.view.hideLoading()
                if let u = user{
                    // dissmiss viewController
                    AILocalStore.setAccessToken(self.phoneTextFlied.text)
                    self.dismissViewControllerAnimated(true, completion: { () -> Void in
                        
                    })
                }else{
                    // Get started
                    SCLAlertView().showError("提示", subTitle: "登录失败", closeButtonTitle: "关闭", duration: 2)
                    
                }
            }
        }else{
             SCLAlertView().showError("提示", subTitle: "手机号或密码不能为空", closeButtonTitle: "关闭", duration: 2)
        }
        
        
        
    }
    
    // #MARK  View Lifecycle
    override func viewWillAppear(animated: Bool) {
        navigationController?.setNavigationBarHidden(true, animated: true)
        navigationController?.interactivePopGestureRecognizer.delegate = nil
        super.viewWillAppear(animated)
    }
    
}

extension AILoginViewController: UITextFieldDelegate{
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}