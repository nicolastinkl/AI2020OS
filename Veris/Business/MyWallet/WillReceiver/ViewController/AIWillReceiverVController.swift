//
//  AIWillPayVController.swift
//  AIVeris
//
//  Created by asiainfo on 10/28/16.
//  Copyright © 2016 ___ASIAINFO___. All rights reserved.
//

import Foundation
import UIKit
import Spring

class AIWillReceiverVController: AIBaseViewController {
    
    private let tableview = UITableView(frame: CGRectMake(0, 50, UIScreen.mainScreen().bounds.size.width, UIScreen.mainScreen().bounds.size.height))
    private var dataSource = Array<AIFundWillWithDrawModel>()
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        initNavigation()
        
        initLayout()
        
        AIFundManageServices.reqeustWillCollectInfo({ (model) in
            self.dataSource = model ?? []
            self.tableview.reloadData()
            }) { (error) in
                
        }
    }
    
    func initNavigation() {
        let maxWidth = UIScreen.mainScreen().bounds.size.width
        
        let payInfoLabel = UILabel(frame: CGRectMake(0, 0, maxWidth, 50))
        payInfoLabel.text = "我的待收"
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
        
        tableview.dataSource = self
        tableview.delegate = self
        tableview.backgroundColor = UIColor.clearColor()
        tableview.separatorColor = UIColor.clearColor()
        
        view.addSubview(tableview)
        
    }
}


extension AIWillReceiverVController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataSource.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCellWithIdentifier("cell")
        let model = dataSource[indexPath.row]
        var contentView: AIWillPayVControllerCell?
        if cell == nil {
            cell = UITableViewCell(style: .Default, reuseIdentifier: "cell")
            contentView = AIWillPayVControllerCell.initFromNib() as? AIWillPayVControllerCell
            cell?.contentView.addSubview(contentView!)
            contentView!.snp_makeConstraints { (make) in
                make.edges.equalTo((cell?.contentView)!)
            }
//            提醒按钮
            let buttonSS = DesignableButton(frame: CGRectMake(0, 0, 244/3, 96/3))
            let buttonSurePay = DesignableButton(frame: CGRectMake(244/3+10, 0, 244/3, 96/3))
            
            buttonSS.cornerRadius = 5
            buttonSS.borderColor = UIColor(hex: "0f86e8")
            buttonSS.borderWidth = 3/2
            buttonSS.backgroundColor = UIColor.clearColor()
            buttonSS.setTitle("", forState: UIControlState.Normal)
            buttonSS.setTitleColor(UIColor(hex: "0f86e8"), forState: UIControlState.Normal)
            buttonSS.titleLabel?.font = UIFont.systemFontOfSize(15)
            buttonSS.hidden = true
            
            buttonSurePay.cornerRadius = 5
            buttonSurePay.titleLabel?.font = UIFont.systemFontOfSize(15)
            buttonSurePay.borderColor = UIColor(hex: "ffffff")
            buttonSurePay.borderWidth = 0.5
            buttonSurePay.backgroundColor = UIColor.clearColor()
            
            
            contentView?.buttonView.addSubview(buttonSS)
            contentView?.buttonView.addSubview(buttonSurePay)
            
            buttonSurePay.addTarget(self, action: #selector(AIWillReceiverVController.notifyPay(_:)), forControlEvents: UIControlEvents.TouchUpInside)
            
            if model.noticed == "0" {
                buttonSurePay.setTitle("提醒付款", forState: UIControlState.Normal)
                buttonSurePay.setTitleColor(UIColor.whiteColor(), forState: UIControlState.Normal)
            } else {
                buttonSurePay.setTitle("已提醒", forState: UIControlState.Normal)
                buttonSurePay.setTitleColor(UIColor(hexString:"#FFFFFF", alpha: 0.5), forState: UIControlState.Normal)
                buttonSurePay.borderColor = UIColor(hexString:"#FFFFFF", alpha: 0.5)
                buttonSurePay.enabled = false
                
            }
        }
        
        cell?.selectionStyle = .None
        
        cell?.backgroundColor = UIColor.clearColor()
        
        contentView?.addresss.text = model.name ?? ""
        contentView?.time.text = model.time?.toDate()
        contentView?.nameLabel.text =  model.payer ?? ""
        contentView?.priceLabel.text = String(model.price ?? 0)
        let url = NSURL(string: model.icon ?? "")!
        contentView?.icon.sd_setImageWithURL(url)
        
        return cell!
    }
    
    //notify pay
    func notifyPay(any: AnyObject) {
        if let s = any as? DesignableButton {
            if let ss = s.superview?.superview?.superview?.superview as? UITableViewCell {
                if let indexPath = tableview.indexPathForCell(ss) {
                    let model = dataSource[indexPath.row]
                    AIFundManageServices.reqeustNotifyPay( (model.id ?? 0).toString(), success: { (bol) in
                        if(bol) {
                            s.setTitle("已提醒", forState: UIControlState.Normal)
                            
                            s.setTitleColor(UIColor(hexString:"#FFFFFF", alpha: 0.5), forState: UIControlState.Normal)
                            s.borderColor = UIColor(hexString:"#FFFFFF", alpha: 0.5)
                            
                            s.enabled = false
                            NBMaterialToast.showWithText(self.view, text: "已经提醒付款", duration: NBLunchDuration.SHORT)
                            
                        }
                    }) { (error) in
                        
                    }
                }
                
            }
        }
    }
    
    
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 120
    }
}
