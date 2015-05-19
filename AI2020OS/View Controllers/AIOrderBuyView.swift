//
//  AIOrderBuyView.swift
//  AI2020OS
//
//  Created by tinkl on 15/5/15.
//  Copyright (c) 2015 ___ASIAINFO___. All rights reserved.
//

import Foundation

class AIOrderBuyView: UIView {
    
    class func currentView()->AIOrderBuyView{
        var cell = NSBundle.mainBundle().loadNibNamed(AIApplication.MainStoryboard.ViewIdentifiers.AIOrderBuyView, owner: self, options: nil).last  as AIOrderBuyView
        return cell
    }
    
}