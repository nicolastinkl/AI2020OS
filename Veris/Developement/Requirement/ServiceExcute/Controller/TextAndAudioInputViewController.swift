//
//  TextAndAudioInputViewController.swift
//  AIVeris
//
//  Created by Rocky on 16/8/24.
//  Copyright © 2016年 ___ASIAINFO___. All rights reserved.
//

import UIKit

class TextAndAudioInputViewController: UIViewController {

    @IBOutlet weak var textView: UITextView!
    @IBOutlet weak var audioImage: UIImageView!
    @IBOutlet weak var audioBottomConstraint: NSLayoutConstraint!
    @IBOutlet weak var hint: UILabel!
    
    private var bottomSpace: CGFloat = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupNavigationBar()
        
        hint.font = AITools.myriadLightSemiCondensedWithSize(48.displaySizeFrom1242DesignSize())
        
        bottomSpace = audioBottomConstraint.constant
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(TextAndAudioInputViewController.keyboardWillAppear), name: UIKeyboardWillShowNotification, object: nil)

        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(TextAndAudioInputViewController.keyboardWillDisappear), name: UIKeyboardWillHideNotification, object: nil)
        
        let audioSelector =
            #selector(TextAndAudioInputViewController.showAudio(_:))
        let audioTap = UITapGestureRecognizer(target: self, action: audioSelector)
        audioImage.addGestureRecognizer(audioTap)
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
        
        audioBottomConstraint.constant = bottomSpace + keyboardHeight
        
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
    
    func showAudio(sender: UIGestureRecognizer) {
        let vc = AIAudioSearchViewController.initFromNib()
        vc.modalTransitionStyle = UIModalTransitionStyle.CrossDissolve
        vc.modalPresentationStyle = UIModalPresentationStyle.OverCurrentContext
        presentViewController(vc, animated: true, completion: nil)
    }
    
    private func setupNavigationBar() {
        
        let cancelButton = UIButton()
        cancelButton.setTitle("Cancel".localized, forState: .Normal)
        cancelButton.titleLabel?.font = AITools.myriadSemiCondensedWithSize(60.displaySizeFrom1242DesignSize())
        cancelButton.setTitleColor(UIColor(hexString: "#ffffff"), forState: .Normal)
        cancelButton.backgroundColor = UIColor.clearColor()
        cancelButton.layer.cornerRadius = 12.displaySizeFrom1242DesignSize()
        cancelButton.setSize(CGSize(width: 196.displaySizeFrom1242DesignSize(), height: 80.displaySizeFrom1242DesignSize()))
        cancelButton.addTarget(self, action: #selector(UIViewController.dismiss), forControlEvents: .TouchUpInside)
        
        let saveButton = UIButton()
        saveButton.setTitle("Save".localized, forState: .Normal)
        saveButton.titleLabel?.font = AITools.myriadSemiCondensedWithSize(60.displaySizeFrom1242DesignSize())
        saveButton.setTitleColor(UIColor(hexString: "#ffffff"), forState: .Normal)
        saveButton.backgroundColor = UIColor(hexString: "#6b6f76").colorWithAlphaComponent(0.5)
        saveButton.layer.cornerRadius = 12.displaySizeFrom1242DesignSize()
        saveButton.setSize(CGSize(width: 196.displaySizeFrom1242DesignSize(), height: 86.displaySizeFrom1242DesignSize()))
        saveButton.addTarget(self, action: #selector(TextAndAudioInputViewController.save), forControlEvents: .TouchUpInside)
        
        let appearance = UINavigationBarAppearance()
        appearance.leftBarButtonItems = [cancelButton]
        appearance.rightBarButtonItems = [saveButton]
        appearance.itemPositionForIndexAtPosition = { index, position in
            if position == .Left {
                return (47.displaySizeFrom1242DesignSize(), 55.displaySizeFrom1242DesignSize())
            } else {
                return (47.displaySizeFrom1242DesignSize(), 40.displaySizeFrom1242DesignSize())
            }
        }
        appearance.barOption = UINavigationBarAppearance.BarOption(backgroundColor: UIColor(hexString: "#0f0c2c"), backgroundImage: nil, removeShadowImage: true, height: AITools.displaySizeFrom1242DesignSize(192))
        appearance.titleOption = UINavigationBarAppearance.TitleOption(bottomPadding: 51.displaySizeFrom1242DesignSize(), font: AITools.myriadSemiCondensedWithSize(72.displaySizeFrom1242DesignSize()), textColor: UIColor.whiteColor(), text: "AICustomAudioNotesView.note".localized)
        setNavigationBarAppearance(navigationBarAppearance: appearance)
    }
    
    func save() {
        
    }

}

extension TextAndAudioInputViewController: UITextViewDelegate {
    func textViewDidBeginEditing(textView: UITextView) {
        hint.hidden = true
    }

    func textViewDidEndEditing(textView: UITextView) {
        guard textView.text != nil else {
            hint.hidden = false
            return
        }
        
        if textView.text.isEmpty {
            hint.hidden = false
        }
    }
}
