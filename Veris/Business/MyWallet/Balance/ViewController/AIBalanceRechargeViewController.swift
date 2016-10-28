//
//  AIBalanceRechargeViewController.swift
//  AIVeris
//
//  Created by asiainfo on 10/27/16.
//  Copyright © 2016 ___ASIAINFO___. All rights reserved.
//

import Foundation
import UIKit

//// 余额充值
class AIBalanceRechargeViewController: AIBaseViewController {
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        self.title = "余额充值"
       // setupNavigationBar()
        
        initLayout()
        
    }
    
    
    //MARK: NavigationBar
    override func setupNavigationBar() {
        
        let backButton = goBackButtonWithImage("comment-back")
        navigatonBarAppearance?.leftBarButtonItems = [backButton]
        setNavigationBarAppearance(navigationBarAppearance: navigatonBarAppearance!)
    }

    
    func initLayout() {
        let maxWidth = UIScreen.mainScreen().bounds.size.width
 
        let payInfoLabel = UILabel(frame: CGRectMake(95/3, 276/3, 100, 50))
        payInfoLabel.text = "付款信息"
        payInfoLabel.textColor = UIColor(hexString: "#ffffff", alpha: 0.6)
        view.addSubview(payInfoLabel)
        
        let price_List_Left_Line = StrokeLineView(frame: CGRectMake(payInfoLabel.left, payInfoLabel.top + 60, maxWidth, 1))
        
        let fuStyleLabel = UILabel(frame: CGRectMake(95/3, 386/3, 100, 50))
        fuStyleLabel.text = "付款方式"
        fuStyleLabel.textColor = UIColor(hexString: "#ffffff", alpha: 0.6)
        view.addSubview(fuStyleLabel)
        
        let payMoneyLabel = UILabel(frame: CGRectMake(95/3, 496/3, 100, 50))
        payMoneyLabel.text = "付款金额"
        payMoneyLabel.textColor = UIColor(hexString: "#ffffff", alpha: 0.6)
        view.addSubview(payMoneyLabel)
        
        view.addSubview(price_List_Left_Line)
        price_List_Left_Line.backgroundColor = UIColor.clearColor()
        
        let accountLabel = UILabel(frame: CGRectMake(maxWidth-95/3, 386/3, 100, 50))
        accountLabel.text = "账户充值"
        accountLabel.textColor = UIColor(hexString: "#ffffff")
        view.addSubview(accountLabel)
        
        let accountNumberLabel = UILabel(frame: CGRectMake(maxWidth-95/3, 386/3, 100, 50))
        accountNumberLabel.text = "招商银行储值卡(*3422)"
        accountNumberLabel.textColor = UIColor(hexString: "#ffffff")
        view.addSubview(accountLabel)

        
        
        let accountMoneyLabel = UILabel(frame: CGRectMake(maxWidth-95/3, 386/3, 100, 50))
        accountMoneyLabel.text = "200"
        accountMoneyLabel.textColor = UIColor(hexString: "#fee300")
        view.addSubview(accountMoneyLabel)

        
    }
    
    
    
}
