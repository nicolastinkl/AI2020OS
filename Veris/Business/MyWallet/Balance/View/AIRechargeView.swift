
//
//  AIRechargeView.swift
//  AIVeris
//
//  Created by asiainfo on 10/31/16.
//  Copyright © 2016 ___ASIAINFO___. All rights reserved.
//

import Foundation
import Spring
import AIAlertView

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
    private var currentStatus: AIRechargeViewType? = nil
    var viewControllerPre: UIViewController? = nil
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.bgview.layer.cornerRadius = 5
        self.bgview.layer.masksToBounds = true
        
        self.button.layer.cornerRadius = 4
        self.button.layer.masksToBounds = true
        
    }
    
    func initSettings(type: AIRechargeViewType) {
        currentStatus = type
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
        if moneyNumber <= 0 {
            return
        }
        
        //获取金额
        var lists = Dictionary<String, AnyObject>()
        var account = Dictionary<String, AnyObject>()
        if let model  = PlaceholdObject as? AICapitalAccount {
            account["id"] = "\(model.id.intValue)"
            account["method_spec_code"] = model.method_spec_code
            account["method_name"] = model.method_name
            account["mch_id"] = model.mch_id
        }
        lists["account"] = account
        if let currentStatus = currentStatus {
            if currentStatus == AIRechargeViewType.charge {
                lists["payment_spec_code"] = "RECHARGE_CASH"
            } else if currentStatus == AIRechargeViewType.tixian {
                lists["payment_spec_code"] = "WITHDRAW_CASH"
            }
        }
        
        lists["amout"] = "\(moneyNumber)"
        lists["money_type"] = "CNY"
        lists["unit"] = "元"
        showLoadingWithMessage("正在处理中...")
        AIFundManageServices.reqeustWithdraw(lists, success: { (obj) in
            if(obj) {
                self.dismissLoading()
                AIAlertView().showSuccess("操作成功", subTitle: "")
                NSNotificationCenter.defaultCenter().postNotificationName("NSNotificationCenter_Blance", object: nil)
                self.removeFromSuperview()
                
                if let currentStatus = self.currentStatus {
                    if currentStatus == AIRechargeViewType.charge {
                        if let vc = self.viewControllerPre {
                            let s = AITiXianViewController.initFromNib()
                            if let model  = self.PlaceholdObject as? AICapitalAccount {
                                 s.mthcode = model.method_name
                            }
                            s.moneynumber = self.moneyNumber
                            vc.presentPopupViewController(s, animated: true)
                            s.targetType(2)
                        }
                    } else if currentStatus == AIRechargeViewType.tixian {
                        if let vc = self.viewControllerPre {
                            let s = AITiXianViewController.initFromNib()
                            if let model  = self.PlaceholdObject as? AICapitalAccount {
                                s.mthcode = model.method_name
                            }
                            s.moneynumber = self.moneyNumber
                            vc.presentPopupViewController(s, animated: true)
                            s.targetType(2)
                        }
                    }
                }
                
                
            }
            
        }) { (error) in
            self.dismissLoading()
            AIAlertView().showError("充值失败", subTitle: error)
        }
        
    }
    
    
}
