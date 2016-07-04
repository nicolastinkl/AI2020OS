//
//  AICustomerOrderFoldedView.swift
//  AIVeris
//
//  Created by 刘先 on 16/7/4.
//  Copyright © 2016年 ___ASIAINFO___. All rights reserved.
//

import UIKit
import Spring

class AICustomerOrderFoldedView: UIView {
    
    
    @IBOutlet weak var taskSchedulTimeLabel: UILabel!
    @IBOutlet weak var taskStatusLabel: UILabel!
    @IBOutlet weak var taskNameLabel: UILabel!
    @IBOutlet weak var providerIcon: UIImageView!
    @IBOutlet weak var statusButton: UIButton!
    @IBOutlet weak var noticeBadgeLabel: DesignableLabel!
    @IBOutlet weak var proporalNameLabel: UILabel!
    
    
    @IBAction func ServiceDetailAction(sender: UIButton) {
        
    }
    

    // MARK: currentView
    class func currentView() -> AICustomerOrderFoldedView {
        let selfView = NSBundle.mainBundle().loadNibNamed("AICustomerOrderFoldedView", owner: self, options: nil).first  as! AICustomerOrderFoldedView
        return selfView
    }

}
