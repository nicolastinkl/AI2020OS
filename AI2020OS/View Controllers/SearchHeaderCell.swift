//
//  SearchHeaderCell.swift
//  AI2020OS
//
//  Created by admin on 15/5/26.
//  Copyright (c) 2015年 ___ASIAINFO___. All rights reserved.
//

import UIKit

class SearchHeaderCell: SearchTagCell {

    override init(frame: CGRect) {
        super.init(frame: frame)
        label.backgroundColor = UIColor(red: 0.91, green: 0.92,
            blue: 0.92, alpha: 0.5)
        label.textColor = UIColor(red: 0.47, green: 0.47,
            blue: 0.47, alpha: 1.0)
        label.setWidth(2000)
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
