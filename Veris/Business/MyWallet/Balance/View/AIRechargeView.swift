
//
//  AIRechargeView.swift
//  AIVeris
//
//  Created by asiainfo on 10/31/16.
//  Copyright © 2016 ___ASIAINFO___. All rights reserved.
//

import Foundation
import Spring

enum AIRechargeViewType {
    case charge
    case tixian
    case pay
}

class AIRechargeView: UIView {
    
    @IBOutlet weak var bgview: UIView!
    @IBOutlet weak var title: UILabel!
    @IBOutlet weak var subtitle: UILabel!
    @IBOutlet weak var money: UILabel!
    @IBOutlet weak var button: UIButton!
    
    var PlaceholdObject: AnyObject?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.bgview.layer.cornerRadius = 5
        self.bgview.layer.masksToBounds = true
        
        self.button.layer.cornerRadius = 4
        self.button.layer.masksToBounds = true
        
    }
    
    func initSettings(type: AIRechargeViewType) {
        if (type == AIRechargeViewType.pay) {
            title.text = "支付密码"
            subtitle.text = "支付"
            button.setTitle("支付", forState: UIControlState.Normal)
            
            if let model  = PlaceholdObject as? AIFundWillWithDrawModel {
                money.text = "¥\(model.price ?? 0)"
            }
        }
    }
    
    @IBAction func forgetAction(sender: AnyObject) {
        
    }
    
    @IBAction func closeAction(sender: AnyObject) {
        
        SpringAnimation.springWithCompletion(0.3, animations: {
            self.alpha = 0
        }) { (complate) in
            self.removeFromSuperview()
        }
    }

    @IBAction func submitAction(sender: AnyObject) {
        
    }
}
