//
//  TextAndAudioInputViewController.swift
//  AIVeris
//
//  Created by Rocky on 16/8/24.
//  Copyright © 2016年 ___ASIAINFO___. All rights reserved.
//

import UIKit
import AIAlertView

class TextAndAudioInputViewController: UIViewController {

    @IBOutlet weak var textView: UITextView!
    @IBOutlet weak var audioImage: UIImageView!
    @IBOutlet weak var audioBottomConstraint: NSLayoutConstraint!
    @IBOutlet weak var hint: UILabel!
    @IBOutlet weak var soundPlayButton: SoundPlayButton!
    @IBOutlet weak var textMask: UIView!
    
    var delegate: TextAndAudioInputDelegate?
    var text: String?
    var saveButton: UIButton!
    
    private var bottomSpace: CGFloat = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupNavigationBar()
        
        hint.font = AITools.myriadLightSemiCondensedWithSize(48.displaySizeFrom1242DesignSize())
        
        bottomSpace = audioBottomConstraint.constant
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(TextAndAudioInputViewController.keyboardWillAppear), name: UIKeyboardWillShowNotification, object: nil)

        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(TextAndAudioInputViewController.keyboardWillDisappear), name: UIKeyboardWillHideNotification, object: nil)
        
        let audioSelector =
            #selector(TextAndAudioInputViewController.showAudioRecorder(_:))
        let audioTap = UITapGestureRecognizer(target: self, action: audioSelector)
        audioImage.addGestureRecognizer(audioTap)
        
        let textSelector =
            #selector(TextAndAudioInputViewController.textMaskTap(_:))
        let textTap = UITapGestureRecognizer(target: self, action: textSelector)
        textMask.addGestureRecognizer(textTap)
        
        if let t = text {
            textView.text = t
        }
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
        
        let keyboardHeight = keyboardRect.size.height
        
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
    
    func showAudioRecorder(sender: UIGestureRecognizer) {
        let vc = AudioRecoderViewController.initFromNib()
        vc.delegate = self
        presentPopupViewController(vc, useBlurForPopup: false, useClearForPopup: true, animated: false)
//        let nv = UINavigationController(rootViewController: vc)
//        vc.modalTransitionStyle = UIModalTransitionStyle.CrossDissolve
//        vc.modalPresentationStyle = UIModalPresentationStyle.OverCurrentContext
//        presentViewController(nv, animated: true, completion: nil)
    }
    
    func textMaskTap(sender: UIGestureRecognizer) {
        JSSAlertView().confirm(self, title: "", text: "TextAndAudioInputViewController.replaceConfirm".localized, customIcon: nil, customIconSize: nil, onComfirm: {

            self.soundPlayButton.hidden = true
            self.setSaveButtonEnabel(false)
            self.textMask.hidden = true
            
            self.textView.hidden = false
            self.textView.becomeFirstResponder()

            }, onCancel: { () -> Void in

                
        })
    }
    
    private func setupNavigationBar() {
        
        extendedLayoutIncludesOpaqueBars = true
        
        let cancelButton = UIButton()
        cancelButton.setTitle("Cancel".localized, forState: .Normal)
        cancelButton.titleLabel?.font = AITools.myriadSemiCondensedWithSize(60.displaySizeFrom1242DesignSize())
        cancelButton.setTitleColor(UIColor(hexString: "#ffffff"), forState: .Normal)
        cancelButton.backgroundColor = UIColor.clearColor()
        cancelButton.layer.cornerRadius = 12.displaySizeFrom1242DesignSize()
        cancelButton.setSize(CGSize(width: 196.displaySizeFrom1242DesignSize(), height: 80.displaySizeFrom1242DesignSize()))
        cancelButton.addTarget(self, action: #selector(UIViewController.dismiss), forControlEvents: .TouchUpInside)
        
        saveButton = UIButton()
        saveButton.setTitle("Save".localized, forState: .Normal)
        saveButton.titleLabel?.font = AITools.myriadSemiCondensedWithSize(60.displaySizeFrom1242DesignSize())
        saveButton.layer.cornerRadius = 12.displaySizeFrom1242DesignSize()
        saveButton.setSize(CGSize(width: 196.displaySizeFrom1242DesignSize(), height: 86.displaySizeFrom1242DesignSize()))
        saveButton.addTarget(self, action: #selector(TextAndAudioInputViewController.save), forControlEvents: .TouchUpInside)
        
        setSaveButtonEnabel(false)
        
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
        if !soundPlayButton.hidden {
            delegate?.audioRecoded(soundPlayButton.audioUrl!, recordingTimeLong: soundPlayButton.soundTimeInterval)
        } else if let text = textView.text {
            if !text.isEmpty {
                delegate?.textInput(text)
            }
        }
        
        dismiss()
    }
    
    private func setSaveButtonEnabel(enable: Bool) {
        let color = enable ? UIColor(hex: "0F86E8") : UIColor(hexString: "#6b6f76", alpha: 0.5)
        let textColor = enable ? UIColor.whiteColor() : UIColor(hexString: "#1a1a58")
        saveButton.backgroundColor = color
        saveButton.setTitleColor(textColor, forState: .Normal)
        saveButton.enabled = enable
    }

}

extension TextAndAudioInputViewController: UITextViewDelegate {
//    func textViewShouldBeginEditing(textView: UITextView) -> Bool {
//        
//        var replace = false
//        
//        let queue = dispatch_get_global_queue(0, 0);
//        let semaphore = dispatch_semaphore_create(0);
//        
//        JSSAlertView().confirm(self, title: "", text: "TextAndAudioInputViewController.replaceConfirm".localized, customIcon: nil, customIconSize: nil, onComfirm: {
//            
//            self.soundPlayButton.hidden = true
//            self.setSaveButtonEnabel(false)
//            replace = true
//            dispatch_semaphore_signal(semaphore)
//            
//            }, onCancel: { () -> Void in
//                
//                dispatch_semaphore_signal(semaphore)
//        })
//        
//        
//        dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER);
//        return replace
//    }
    
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
            return
        }
        
        setSaveButtonEnabel(true)
    }
}

extension TextAndAudioInputViewController: AudioRecorderDelegate {
    func audioRecorderDidFinishRecording(successfully: Bool, audioFileUrl: String?, recordingTimeLong: NSTimeInterval) {
        
        if let url = audioFileUrl {
            soundPlayButton.hidden = false
            soundPlayButton.audioUrl = NSURL(fileURLWithPath: url)
            soundPlayButton.soundTimeInterval = recordingTimeLong
            
            hint.hidden = true
            textMask.hidden = false
            textView.hidden = true
            textView.text = nil
            
            setSaveButtonEnabel(true)
        }
        
        dismissPopupViewController(false, completion: nil)
    }
    
    func audioRecorderEncodeErrorDidOccur(error: NSError?) {
        
    }
}

protocol TextAndAudioInputDelegate {
    func textInput(text: String)
    func audioRecoded(audioFileUrl: NSURL, recordingTimeLong: NSTimeInterval)
}
