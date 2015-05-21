//
//  AIHomeViewStyleTitleAndContentView.swift
//  AI2020OS
//
//  Created by tinkl on 21/5/15.
//  Copyright (c) 2015 ___ASIAINFO___. All rights reserved.
//

import Foundation
import Spring

class AIHomeViewStyleTitleAndContentView: SpringView {
    
    @IBOutlet weak var title: UILabel!
    
    @IBOutlet weak var price: UILabel!
    
    @IBOutlet weak var contentImage: AIImageView!
    
    class func currentView()->AIHomeViewStyleTitleAndContentView{
        var cell = NSBundle.mainBundle().loadNibNamed(AIApplication.MainStoryboard.ViewIdentifiers.AIHomeViewStyleTitleAndContentView, owner: self, options: nil).last  as AIHomeViewStyleTitleAndContentView
        return cell
    }
    
}