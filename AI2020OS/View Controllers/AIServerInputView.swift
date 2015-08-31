//
//  AIServerInputView.swift
//  AI2020OS
//
//  Created by admin on 8/28/15.
//  Copyright (c) 2015 ___ASIAINFO___. All rights reserved.
//

import Foundation
import UIKit

class AIServerInputView: UIView {
    
    typealias viewChangeCloseure = (String)->()
    var myClosure:viewChangeCloseure?
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func viewChangeClosure(changeClosure:viewChangeCloseure){
        
        myClosure = changeClosure
    }
    
    @IBOutlet weak var inputText: UITextField!
    
    class func currentView() -> AIServerInputView {
        return NSBundle(forClass: self).loadNibNamed("AIServerInputView", owner: self, options: nil).first as AIServerInputView
    }
    
}

extension AIServerInputView:UITextFieldDelegate {
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        if let closure = myClosure {
            closure(textField.text)
        }
        return true
    }
    
    func textFieldDidEndEditing(textField: UITextField) {
        if let closure = myClosure {
            closure(textField.text)
        }
    }
}