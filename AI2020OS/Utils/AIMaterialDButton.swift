//
//  AIMaterialDButton.swift
//  AI2020OS
//
//  Created by tinkl on 21/4/15.
//  Copyright (c) 2015 ___ASIAINFO___. All rights reserved.
//

import Foundation

/*!
 *  @author tinkl, 15-04-21 15:04:48
 *
 *  Design: Material Design Button
 */
class AIMaterialDButton : UIButton {
    
    @IBInspectable private var currentColor: UIColor = UIColor.clearColor() {
        didSet {
            self.backgroundColor = currentColor
        }
    }
    @IBInspectable private var mdColor: UIColor = UIColor.clearColor();
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.configure()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
    }
    
    override func beginTrackingWithTouch(touch: UITouch, withEvent event: UIEvent) -> Bool {
        self.userInteractionEnabled = false
        let position = event.allTouches()?.anyObject()?.locationInView(self)
        let sender:UIView = self
        sender.mdInflateAnimatedFromPoint(position!, backgroundColor: self.mdColor, duration: 0.5) { () -> Void in
            self.backgroundColor = self.currentColor
            self.userInteractionEnabled = true
        }
        
        return true
    }

    private func configure() {
        self.currentColor = self.backgroundColor!
        self.setTranslatesAutoresizingMaskIntoConstraints(false)
    }

}