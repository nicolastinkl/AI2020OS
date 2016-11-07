//
//  AIMyWalletBalanceViewController.swift
//  AIVeris
//
//  Created by asiainfo on 10/27/16.
//  Copyright © 2016 ___ASIAINFO___. All rights reserved.
//

import Foundation
import UIKit

// 我的余额
class AIMyWalletBalanceViewController: UIViewController {
    
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var money: UILabel!
    @IBOutlet weak var tixianmoney: UILabel!
    
    @IBOutlet weak var tixianButton: UIButton!
    @IBOutlet weak var rechargeButton: UIButton!
    
    @IBOutlet weak var imageview: UIImageView!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        rechargeButton.layer.cornerRadius = 5
        rechargeButton.layer.masksToBounds = true
        
        tixianButton.layer.cornerRadius = 5
        tixianButton.layer.masksToBounds = true
        
        AIFundManageServices.reqeustBlanceInfo({ (model) in
            self.name.text = model?.user_name ?? ""
            self.money.text = "余额\(model?.balance_amout ?? 0)元"
            self.tixianmoney.text  = "可提现金额\(model?.withdraw_balance_amout ?? 0)元"
            self.imageview.sd_setImageWithURL(NSURL(string:model?.user_head_url ?? ""))
            }) { (error) in                
        }
    }
    
    @IBAction func rechargeAction(sender: AnyObject) {
        let bevc = AIBalanceRechargeViewController()
        self.presentBlurViewController(bevc, animated: true, completion: nil)
        
    }
    
    @IBAction func tixianAction(sender: AnyObject) {
        let bevc = AIBalanceTixianViewController()
        self.presentBlurViewController(bevc, animated: true, completion: nil)
    }
    
}
