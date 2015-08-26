//
//  AISearchHeaderCell.swift
//  AI2020OS
//
//  Created by admin on 15/5/26.
//  Copyright (c) 2015年 ___ASIAINFO___. All rights reserved.
//

import UIKit

class AISearchHeaderCell: AISearchTagCell {

    override init(frame: CGRect) {
        super.init(frame: frame)
        //label.backgroundColor = UIColor(rgba: "#eeeeef")
        label.textColor = UIColor(rgba: "#6B6B6B")
        label.setWidth(600)
        label.textAlignment = .Left
    }
    override var text: String! {
        get {
            return super.text
        }

        set(newText) {
            label.text = "  " + newText
        }
    }

    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override class func defaultFont() -> UIFont {
        return UIFont.preferredFontForTextStyle(UIFontTextStyleHeadline)
    }

}
