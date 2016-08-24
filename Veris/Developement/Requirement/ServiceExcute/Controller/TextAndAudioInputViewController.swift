//
//  TextAndAudioInputViewController.swift
//  AIVeris
//
//  Created by admin on 16/8/24.
//  Copyright © 2016年 ___ASIAINFO___. All rights reserved.
//

import UIKit

class TextAndAudioInputViewController: UIViewController {

    @IBOutlet weak var textView: UITextView!
    @IBOutlet weak var audioImage: UIImageView!
    @IBOutlet weak var audioBottomConstraint: NSLayoutConstraint!
    
    private var bottomSpace: CGFloat = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        bottomSpace = audioBottomConstraint.constant
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(TextAndAudioInputViewController.keyboardWillAppear), name: UIKeyboardWillShowNotification, object: nil)

        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(TextAndAudioInputViewController.keyboardWillDisappear), name: UIKeyboardWillHideNotification, object: nil)
    }
    
    func keyboardWillAppear(notification: NSNotification) {
        
        
        guard let info = notification.userInfo else {
            return
        }
        
        var animationDuration: Double = 0
        
        if let d = info[UIKeyboardAnimationDurationUserInfoKey] as? Double {
            animationDuration = d
        }
        
        guard let keyboardRect = (info[UIKeyboardFrameEndUserInfoKey] as? NSValue)?.CGRectValue() else {
            return
        }
        
        let keyboardHeight = keyboardRect.size.height;
        
        guard let optionsValue = info[UIKeyboardAnimationCurveUserInfoKey] as? UInt else {
            return
        }
        
        let animationOptions = UIViewAnimationOptions(rawValue: optionsValue << 16)
        
        audioBottomConstraint.constant += keyboardHeight
        
        UIView.animateWithDuration(animationDuration, delay: 0, options: animationOptions, animations: {
            self.view.layoutIfNeeded()
            }, completion: nil)
    }
    
    func keyboardWillDisappear(notification: NSNotification) {
        guard let info = notification.userInfo else {
            return
        }
        
        var animationDuration: Double = 0
        
        if let d = info[UIKeyboardAnimationDurationUserInfoKey] as? Double {
            animationDuration = d
        }

        
        guard let optionsValue = info[UIKeyboardAnimationCurveUserInfoKey] as? UInt else {
            return
        }
        
        let animationOptions = UIViewAnimationOptions(rawValue: optionsValue << 16)
        
        audioBottomConstraint.constant = self.bottomSpace
        
        UIView.animateWithDuration(animationDuration, delay: 0, options: animationOptions, animations: {
            self.view.layoutIfNeeded()
            }, completion: nil)
    }

}
