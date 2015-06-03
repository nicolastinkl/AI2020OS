//
//  AITableViewInsetMakeView.swift
//  AI2020OS
//
//  Created by tinkl on 3/6/15.
//  Copyright (c) 2015 ___ASIAINFO___. All rights reserved.
//

import Foundation

class AITableViewInsetMakeView: UIView {
    
    class func currentView()->AITableViewInsetMakeView{
        var cell = NSBundle.mainBundle().loadNibNamed(AIApplication.MainStoryboard.ViewIdentifiers.AITableViewInsetMakeView, owner: self, options: nil).first  as AITableViewInsetMakeView
        return cell
    }
    
}