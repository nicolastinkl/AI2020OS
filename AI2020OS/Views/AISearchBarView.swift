//
//  AISearchBarView.swift
//  AI2020OS
//
//  Created by admin on 15/6/17.
//  Copyright (c) 2015年 ___ASIAINFO___. All rights reserved.
//

import UIKit

protocol AISearchBarDelegate {
    func voiceButtonClick(sender: UIButton)
}

class AISearchBarView: UIView {

    @IBOutlet weak var background: UIImageView!
    @IBOutlet weak var voiceButton: UIButton!
    @IBOutlet weak var inputTextField: UITextField!
    
    private var delegate: AISearchBarDelegate?
    /*
    // Only override drawRect: if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func drawRect(rect: CGRect) {
        // Drawing code
    }
    */

    @IBAction func buttonAction(sender: AnyObject) {
        if sender as NSObject == voiceButton {
            delegate?.voiceButtonClick(sender as UIButton)
        }
    }
}
