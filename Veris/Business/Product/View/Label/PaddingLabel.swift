//
//  PaddingLabel.swift
//  AIVeris
//
//  Created by Rocky on 16/7/4.
//  Copyright © 2016年 ___ASIAINFO___. All rights reserved.
//

import UIKit

class PaddingLabel: UILabel {
    
    @IBInspectable var leftEdge: CGFloat = 0 {
        didSet {
            setNeedsLayout()
        }
    }
    
    @IBInspectable var rightEdge: CGFloat = 0 {
        didSet {
            setNeedsLayout()
        }
    }
    
    @IBInspectable var topEdge: CGFloat = 0 {
        didSet {
            setNeedsLayout()
        }
    }
    
    @IBInspectable var bottomEdge: CGFloat = 0 {
        didSet {
            setNeedsLayout()
        }
    }

    override func drawTextInRect(rect: CGRect) {
        let insets = UIEdgeInsets.init(top: topEdge, left: leftEdge, bottom: bottomEdge, right: rightEdge)
        super.drawTextInRect(UIEdgeInsetsInsetRect(rect, insets))
    }

}
