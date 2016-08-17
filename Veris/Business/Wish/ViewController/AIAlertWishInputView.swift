//
//  AIAlertWishInputViewController.swift
//  AIVeris
//
//  Created by tinkl on 8/16/16.
//  Copyright © 2016 ___ASIAINFO___. All rights reserved.
//

import Foundation
import Spring

class AIAlertWishInputView: UIView {
    
    @IBOutlet weak var closeButton: UIButton!
    @IBOutlet weak var textInputView: DesignableTextField!
    @IBOutlet weak var buttonSubmit: DesignableButton!
    @IBOutlet weak var titleLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        titleLabel.font = AITools.myriadSemiCondensedWithSize(20)
        titleLabel.textColor = UIColor(hexString: "#5f5f5f")
        
        textInputView.font = AITools.myriadSemiCondensedWithSize(20)
    }
    @IBAction func closeAction(sender: AnyObject) {
        SpringAnimation.springWithCompletion(0.5, animations: { 
            self.alpha = 0
            }) { (com) in
            self.removeFromSuperview()
        }
        
    }
}