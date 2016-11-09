
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
    var moneyNumber: Int = 0
    
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
        } else if (type == AIRechargeViewType.charge) {
            title.text = "支付密码"
            subtitle.text = "充值"
            button.setTitle("充值", forState: UIControlState.Normal)
            money.text = "¥\(moneyNumber)"
        } else if (type == AIRechargeViewType.tixian) {
            title.text = "支付密码"
            subtitle.text = "提现"
            button.setTitle("提现", forState: UIControlState.Normal)
            money.text = "¥\(moneyNumber)"
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
        
        var lists = Array<AnyObject>()
        if let model  = PlaceholdObject as? AIFundWillWithDrawModel {
            lists.append(["billId":model.id ?? ""])
            lists.append(["userId":AILocalStore.userId])
            lists.append(["ruleType":"BALANCE_PAY"])
            
        }
        showLoadingWithMessage("正在检查资金帐户")
        AIFundManageServices.reqeustCheckPayInfo(lists, success: { (obj) in
            if(obj) {
            
            }
            
            }) { (error) in
                
        }
    }
}
