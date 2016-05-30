//
//  AIOrderModifyView.swift
//  AI2020OS
//
//  Created by admin on 8/20/15.
//  Copyright (c) 2015 ___ASIAINFO___. All rights reserved.
//

import Foundation

class AIOrderModifyView: UIView {
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    class func currentView() -> AIOrderModifyView {
        return NSBundle(forClass: self).loadNibNamed("AIOrderModifyView", owner: self, options: nil).first as AIOrderModifyView
    }
    
}