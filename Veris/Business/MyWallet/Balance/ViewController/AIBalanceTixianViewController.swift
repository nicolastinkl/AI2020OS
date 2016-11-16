//
//  AIBalanceRechargeViewController.swift
//  AIVeris
//
//  Created by asiainfo on 10/27/16.
//  Copyright © 2016 ___ASIAINFO___. All rights reserved.
//

import Foundation
import UIKit
import Spring

//// 余额提现
class AIBalanceTixianViewController: AIBaseViewController {
    
    var accountMoneyLabel: UITextField? = nil
    private var currentPayModel: AICapitalAccount? = nil
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        self.title = "余额提现"
        
        initNavigation()
        
        initLayout()
        
    }
    
    func initNavigation() {
        let maxWidth = UIScreen.mainScreen().bounds.size.width
        
        let payInfoLabel = UILabel(frame: CGRectMake(0, 0, maxWidth, 50))
        payInfoLabel.text = "余额提现"
        payInfoLabel.textAlignment = .Center
        payInfoLabel.textColor = UIColor(hexString: "#ffffff", alpha: 1)
        view.addSubview(payInfoLabel)
        payInfoLabel.font = UIFont.systemFontOfSize(24)
        
        let backButton = goBackButtonWithImage("comment-back")
        view.addSubview(backButton)
        backButton.setLeft(7)
        backButton.setTop(12)
        
    }

    func setFont(label: UILabel) {
        label.font = UIFont.systemFontOfSize(16)
    }
    
    func initLayout() {
        let maxWidth = UIScreen.mainScreen().bounds.size.width
 
        let payInfoLabel = UILabel(frame: CGRectMake(95/3, 276/3, 100, 50))
        payInfoLabel.text = "提现账户"
        payInfoLabel.textColor = UIColor(hexString: "#ffffff", alpha: 0.6)
        view.addSubview(payInfoLabel)
        setFont(payInfoLabel)
        
        let fuStyleLabel = UILabel(frame: CGRectMake(95/3, 386/3, 100, 50))
        fuStyleLabel.text = "到账时间"
        setFont(fuStyleLabel)
        fuStyleLabel.textColor = UIColor(hexString: "#ffffff", alpha: 0.6)
        view.addSubview(fuStyleLabel)
        
        let payMoneyLabel = UILabel(frame: CGRectMake(95/3, 496/3, 100, 50))
        payMoneyLabel.text = "提现金额"
        payMoneyLabel.textColor = UIColor(hexString: "#ffffff", alpha: 0.6)
        setFont(payMoneyLabel)
        view.addSubview(payMoneyLabel)
        
        let accountLabel = UILabel(frame: CGRectMake(maxWidth-95/3-300, 276/3, 300, 50))
        accountLabel.text = "支付宝（*****@gmail.com）"
        accountLabel.textAlignment = .Right
        accountLabel.textColor = UIColor(hexString: "#ffffff")
        setFont(accountLabel)
        view.addSubview(accountLabel)
        
        let accountNumberLabel = UILabel(frame: CGRectMake(maxWidth-95/3-300, 386/3, 300, 50))
        accountNumberLabel.text = "当日即可到账"
        accountNumberLabel.textAlignment = .Right
        accountNumberLabel.textColor = UIColor(hexString: "#ffffff")
        view.addSubview(accountNumberLabel)
        setFont(accountNumberLabel)
        
        let accountMoneyLabel = UITextField(frame: CGRectMake(maxWidth-95/3-300, 496/3, 300, 50))
        accountMoneyLabel.font = UIFont.systemFontOfSize(16)
        accountMoneyLabel.textAlignment = .Right
        accountMoneyLabel.textColor = UIColor(hexString: "#fee300")
        view.addSubview(accountMoneyLabel)
        accountMoneyLabel.attributedPlaceholder = NSAttributedString(string: "请输入金额", attributes: [NSForegroundColorAttributeName:UIColor(hexString: "#fee300")])
        self.accountMoneyLabel = accountMoneyLabel
        let price_List_Left_Line = StrokeLineView(frame: CGRectMake(payInfoLabel.left, payInfoLabel.top + 40, maxWidth-(95/3)*2, 1))
        price_List_Left_Line.backgroundColor = UIColor.clearColor()
        view.addSubview(price_List_Left_Line)
        
        let price_List_Left_Line1 = StrokeLineView(frame: CGRectMake(payInfoLabel.left, fuStyleLabel.top + 40, maxWidth-(95/3)*2, 1))
        price_List_Left_Line1.backgroundColor = UIColor.clearColor()
        view.addSubview(price_List_Left_Line1)
        
        let price_List_Left_Line2 = StrokeLineView(frame: CGRectMake(payInfoLabel.left, payMoneyLabel.top + 40, maxWidth-(95/3)*2, 1))
        price_List_Left_Line2.backgroundColor = UIColor.clearColor()
        view.addSubview(price_List_Left_Line2)
        
        let buttonSubmit = DesignableButton(frame:  CGRectMake(95/3, accountMoneyLabel.top + 150, maxWidth-(95/3)*2, 45))
        buttonSubmit.backgroundColor = UIColor(hexString: "#1086E8")
        buttonSubmit.setTitle("确认提现", forState: UIControlState.Normal)
        buttonSubmit.setTitleColor(UIColor.whiteColor(), forState: UIControlState.Normal)
        buttonSubmit.titleLabel?.font = UIFont.systemFontOfSize(16)
        buttonSubmit.cornerRadius = 5
        view.addSubview(buttonSubmit)
        buttonSubmit.addTarget(self, action: #selector(AIBalanceTixianViewController.tixianAction), forControlEvents: UIControlEvents.TouchUpInside)
        
        view.showLoading()
        //监测充值方式
        AIFundAccountService().capitalAccounts({ (array) in
            self.view.hideLoading()
            if let model = array.first {
                let ss1: String = ( model.mch_id as NSString).substringToIndex(4)
                accountLabel.text = "\(model.method_name)\(model.method_spec_code)(\(ss1)***)"
                self.currentPayModel = model
            }
        }) { (errType, errDes) in
            self.view.hideLoading()
        }
        
    }
    
    func tixianAction() {
        //let s = AITiXianViewController.initFromNib()
        //presentBlurViewController(s, animated: true, completion: nil)
        
        if let viewrech = AIRechargeView.initFromNib() as? AIRechargeView {
            view.addSubview(viewrech)
            viewrech.alpha = 0
            
            viewrech.snp_makeConstraints { (make) in
                make.edges.equalTo(view)
            }
            SpringAnimation.springWithCompletion(0.3, animations: {
                viewrech.alpha = 1
                }, completion: { (s) in
            })
            viewrech.moneyNumber = accountMoneyLabel?.text?.toInt() ?? 0
            viewrech.initSettings(AIRechargeViewType.tixian)
            viewrech.PlaceholdObject = currentPayModel
            viewrech.viewControllerPre = self
        }
        
    }
    
}
