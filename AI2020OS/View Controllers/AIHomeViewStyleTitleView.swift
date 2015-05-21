//
//  AIHomeViewStyleTitleView.swift
//  AI2020OS
//
//  Created by tinkl on 21/5/15.
//  Copyright (c) 2015 ___ASIAINFO___. All rights reserved.
//

import Foundation
import Spring

class AIHomeViewStyleTitleView: SpringView {

    @IBOutlet weak var title: UILabel!
    @IBOutlet weak var contentImage: AIImageView! 
    
    class func currentView()->AIHomeViewStyleTitleView{
        var cell = NSBundle.mainBundle().loadNibNamed(AIApplication.MainStoryboard.ViewIdentifiers.AIHomeViewStyleTitleView, owner: self, options: nil).last  as AIHomeViewStyleTitleView
        return cell
    }
    
    
}