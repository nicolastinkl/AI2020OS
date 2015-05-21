//
//  UIHomeViewStyleOne.swift
//  AI2020OS
//
//  Created by tinkl on 21/5/15.
//  Copyright (c) 2015 ___ASIAINFO___. All rights reserved.
//

import Foundation
import Spring

class AIHomeViewStyleMultiepleView: SpringView {

    @IBOutlet weak var title: UILabel!
    
    @IBOutlet weak var price: UILabel!
    
    @IBOutlet weak var contentImage: AIImageView!
    
    @IBOutlet weak var nick: UILabel!
    
    @IBOutlet weak var starlevel: UIImageView!
    
    @IBOutlet weak var avator: AsyncButton!    
    
    class func currentView()->AIHomeViewStyleMultiepleView{
        var cell = NSBundle.mainBundle().loadNibNamed(AIApplication.MainStoryboard.ViewIdentifiers.AIHomeViewStyleMultiepleView, owner: self, options: nil).last  as AIHomeViewStyleMultiepleView
        cell.avator.maskWithEllipse()
        return cell
    }
    
}
