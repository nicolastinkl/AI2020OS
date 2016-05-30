//
//  AIBuildView.swift
//  AI2020OS
//
//  Created by admin on 8/28/15.
//  Copyright (c) 2015 ___ASIAINFO___. All rights reserved.
//

import Foundation
import UIKit

class AIBuildView: UIView {
    
    @IBOutlet weak var contentTitle: UILabel!
    
    class func currentView()->AIBuildView{
        var cell = NSBundle.mainBundle().loadNibNamed(AIApplication.MainStoryboard.ViewIdentifiers.AIBuildView, owner: self, options: nil).first  as AIBuildView
        return cell
    }
}