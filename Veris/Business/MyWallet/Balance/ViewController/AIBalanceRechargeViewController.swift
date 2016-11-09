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

//// 余额充值
class AIBalanceRechargeViewController: AIBaseViewController {
    
    var accountMoneyLabel: UITextField? = nil
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        self.title = "余额充值"
        
        initNavigation()
        
        initLayout()
        
    }
    
    func initNavigation() {
        let maxWidth = UIScreen.mainScreen().bounds.size.width
        
        let payInfoLabel = UILabel(frame: CGRectMake(0, 0, maxWidth, 50))
        payInfoLabel.text = "余额充值"
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
        payInfoLabel.text = "付款信息"
        payInfoLabel.textColor = UIColor(hexString: "#ffffff", alpha: 0.6)
        view.addSubview(payInfoLabel)
        setFont(payInfoLabel)
        
        let fuStyleLabel = UILabel(frame: CGRectMake(95/3, 386/3, 100, 50))
        fuStyleLabel.text = "付款方式"
        setFont(fuStyleLabel)
        fuStyleLabel.textColor = UIColor(hexString: "#ffffff", alpha: 0.6)
        view.addSubview(fuStyleLabel)
        
        let payMoneyLabel = UILabel(frame: CGRectMake(95/3, 496/3, 100, 50))
        payMoneyLabel.text = "付款金额"
        payMoneyLabel.textColor = UIColor(hexString: "#ffffff", alpha: 0.6)
        setFont(payMoneyLabel)
        view.addSubview(payMoneyLabel)
        
        let accountLabel = UILabel(frame: CGRectMake(maxWidth-95/3-100, 276/3, 100, 50))
        accountLabel.text = "账户充值"
        accountLabel.textAlignment = .Right
        accountLabel.textColor = UIColor(hexString: "#ffffff")
        setFont(accountLabel)
        view.addSubview(accountLabel)
        
        let accountNumberLabel = UILabel(frame: CGRectMake(maxWidth-95/3-320, 386/3, 300, 50))
        accountNumberLabel.text = ""
        accountNumberLabel.textAlignment = .Right
        accountNumberLabel.textColor = UIColor(hexString: "#ffffff")
        view.addSubview(accountNumberLabel)
        setFont(accountNumberLabel)
        accountNumberLabel.userInteractionEnabled = true
        accountNumberLabel.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(AIBalanceRechargeViewController.chargeAction)))
        
        let accountImg = UIImageView(frame:  CGRectMake(accountNumberLabel.right+5, 386/3+20, 10, 12))
        accountImg.image = UIImage(named:"flowRightArrow")
        view.addSubview(accountImg)
        
        
        accountMoneyLabel = UITextField(frame: CGRectMake(maxWidth-95/3-300, 496/3, 300, 50))
        
        accountMoneyLabel?.font = UIFont.systemFontOfSize(16)
        accountMoneyLabel?.textAlignment = .Right
        accountMoneyLabel?.textColor = UIColor(hexString: "#fee300")
        view.addSubview(accountMoneyLabel!)
    
        accountMoneyLabel?.attributedPlaceholder = NSAttributedString(string: "请输入充值金额", attributes: [NSForegroundColorAttributeName:UIColor(hexString: "#fee300")])

        let price_List_Left_Line = StrokeLineView(frame: CGRectMake(payInfoLabel.left, payInfoLabel.top + 40, maxWidth-(95/3)*2, 1))
        price_List_Left_Line.backgroundColor = UIColor.clearColor()
        view.addSubview(price_List_Left_Line)
        
        let price_List_Left_Line1 = StrokeLineView(frame: CGRectMake(payInfoLabel.left, fuStyleLabel.top + 40, maxWidth-(95/3)*2, 1))
        price_List_Left_Line1.backgroundColor = UIColor.clearColor()
        view.addSubview(price_List_Left_Line1)
        
        let price_List_Left_Line2 = StrokeLineView(frame: CGRectMake(payInfoLabel.left, payMoneyLabel.top + 40, maxWidth-(95/3)*2, 1))
        price_List_Left_Line2.backgroundColor = UIColor.clearColor()
        view.addSubview(price_List_Left_Line2)
        
        let buttonSubmit = DesignableButton(frame:  CGRectMake(95/3, accountMoneyLabel!.top + 150, maxWidth-(95/3)*2, 45))
        buttonSubmit.backgroundColor = UIColor(hexString: "#1086E8")
        buttonSubmit.setTitle("确认付款", forState: UIControlState.Normal)
        buttonSubmit.setTitleColor(UIColor.whiteColor(), forState: UIControlState.Normal)
        buttonSubmit.titleLabel?.font = UIFont.systemFontOfSize(16)
        buttonSubmit.cornerRadius = 5
        view.addSubview(buttonSubmit)
        
        buttonSubmit.addTarget(self, action: #selector(AIBalanceRechargeViewController.submit), forControlEvents: UIControlEvents.TouchUpInside)
        
        view.showLoading()
        //监测充值方式
        AIFundAccountService().capitalAccounts({ (array) in
            self.view.hideLoading()
            if let model = array.first {
                accountNumberLabel.text = "\(model.method_name)\(model.method_spec_code)"
            }
        }) { (errType, errDes) in
            self.view.hideLoading()
        }
    }
    
    func submit() {
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
            viewrech.initSettings(AIRechargeViewType.charge)
        
        }
    }
    
    func chargeAction() {
        if let viewrech = AIRechargePaylistView.initFromNib() as? AIRechargePaylistView {
            view.addSubview(viewrech)
            viewrech.initSettings()
            viewrech.snp_makeConstraints { (make) in
                make.edges.equalTo(view)
            }
            
            viewrech.initSettings()
        }
    }
    
    
    
}
