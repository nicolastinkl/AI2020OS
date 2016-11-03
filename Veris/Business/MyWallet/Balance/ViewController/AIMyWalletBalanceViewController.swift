//
//  AIMyWalletBalanceViewController.swift
//  AIVeris
//
//  Created by asiainfo on 10/27/16.
//  Copyright © 2016 ___ASIAINFO___. All rights reserved.
//

import Foundation
import UIKit

class AIMyWalletBalanceViewController: UIViewController {
    
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var money: UILabel!
    @IBOutlet weak var tixianmoney: UILabel!
    
    @IBOutlet weak var tixianButton: UIButton!
    @IBOutlet weak var rechargeButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        rechargeButton.layer.cornerRadius = 5
        rechargeButton.layer.masksToBounds = true
        
        tixianButton.layer.cornerRadius = 5
        tixianButton.layer.masksToBounds = true
        
        name.text = "疯狂的小王子"
        money.text = "余额125.9元"
        tixianmoney.text  = "可提现金额 123.5 元"
        
    }
    
    @IBAction func rechargeAction(sender: AnyObject) {
        let bevc = AIBalanceRechargeViewController()
        self.presentBlurViewController(bevc, animated: true, completion: nil)
        
    }
    
    @IBAction func tixianAction(sender: AnyObject) {
        let bevc = AITiXianViewController.initFromNib()
        self.presentBlurViewController(bevc, animated: true, completion: nil)
    }
    
}
