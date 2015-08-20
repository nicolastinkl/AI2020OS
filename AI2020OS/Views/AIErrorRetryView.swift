//
//  AIErrorRetryView.swift
//  AI2020OS
//
//  Created by tinkl on 21/5/15.
//  Copyright (c) 2015 ___ASIAINFO___. All rights reserved.
//

import Foundation
import Spring

class AIErrorRetryView: SpringView {

    @IBOutlet weak var alertContent: UILabel!
    class func currentView()->AIErrorRetryView{
        var cell = NSBundle.mainBundle().loadNibNamed(AIApplication.MainStoryboard.ViewIdentifiers.AIErrorRetryView, owner: self, options: nil).first  as AIErrorRetryView
        return cell
    }
    
    //action's retryNetworkingAction
    @IBAction func retryAction(sender: AnyObject) {
        AIApplication().SendAction("retryNetworkingAction", ownerName: self)
    }
}