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

class AIWillPayVController: AIBaseViewController {
    
    private let tableview = UITableView(frame: CGRectMake(0, 55, UIScreen.mainScreen().bounds.size.width, UIScreen.mainScreen().bounds.size.height))
    private var dataSource = Array<AIFundWillWithDrawModel>()
    
    private let CellIdentifier = "CellID"
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        
        initLayout()
        view.showLoading()
        AIFundManageServices.reqeustWillPayInfo({ (model) in
            self.dataSource = model ?? []
            self.tableview.reloadData()
            self.view.hideLoading()
        }) { (error) in
            self.view.hideLoading()
        }
        
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

extension AIWillPayVController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataSource.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCellWithIdentifier("cell")
        var contentView: AIWillPayVControllerCell?
        if cell == nil {
            cell = UITableViewCell(style: .Default, reuseIdentifier: "cell")
            contentView = AIWillPayVControllerCell.initFromNib() as? AIWillPayVControllerCell
            cell?.contentView.addSubview(contentView!)
            contentView!.snp_makeConstraints { (make) in
                make.edges.equalTo((cell?.contentView)!)
            }
            //绘制我要付款和我要申述按钮
            let buttonSS = DesignableButton(frame: CGRectMake(0, 0, 244/3, 96/3))
            let buttonSurePay = DesignableButton(frame: CGRectMake(244/3+10, 0, 244/3, 96/3))
            
            buttonSS.cornerRadius = 5
            buttonSS.borderColor = UIColor(hex: "0f86e8")
            buttonSS.borderWidth = 0.5
            buttonSS.backgroundColor = UIColor.clearColor()
            buttonSS.setTitle("我要申诉", forState: UIControlState.Normal)
            buttonSS.setTitleColor(UIColor(hex: "0f86e8"), forState: UIControlState.Normal)
            buttonSS.addTarget(self, action: #selector(AIWillPayVController.callPhone), forControlEvents: UIControlEvents.TouchUpInside)
            buttonSS.titleLabel?.font = UIFont.systemFontOfSize(15)
            buttonSurePay.titleLabel?.font = UIFont.systemFontOfSize(15)            
            buttonSurePay.cornerRadius = 5
            buttonSurePay.backgroundColor =  UIColor(hex: "0f86e8")
            buttonSurePay.setTitle("确认付款", forState: UIControlState.Normal)
            buttonSurePay.setTitleColor(UIColor.whiteColor(), forState: UIControlState.Normal)
            
            contentView?.buttonView.addSubview(buttonSS)
            contentView?.buttonView.addSubview(buttonSurePay)
            
            buttonSurePay.addTarget(self, action: #selector(AIWillPayVController.showAIRechargeView(_:)), forControlEvents: UIControlEvents.TouchUpInside)
        }
        
        cell?.selectionStyle = .None
        
        cell?.backgroundColor = UIColor.clearColor()
        let model = dataSource[indexPath.row]
        contentView?.addresss.text = model.vendor ?? ""
        contentView?.time.text = model.time?.toDate()
        contentView?.nameLabel.text = model.name ?? ""
        contentView?.priceLabel.text = "¥\(String(model.price ?? 0))"
        let url = NSURL(string: model.icon ?? "")!
        contentView?.icon.sd_setImageWithURL(url)
            
        return cell!
    }
    
    func callPhone() {
        let alert = JSSAlertView()
        
        alert.info( self, title:"400-8888-8888", text: "", buttonText: "Call", cancelButtonText: "Cancel")
        alert.defaultColor = UIColorFromHex(0xe7ebf5, alpha: 1)
        alert.addAction {
            UIApplication.sharedApplication().openURL(NSURL(string: "tel:400-8888-8888")!)
        }
    }
    
    func showAIRechargeView(any: AnyObject) {
        
        if let s = any as? DesignableButton {
            if let ss = s.superview?.superview?.superview?.superview as? UITableViewCell {
                if let indexPath = tableview.indexPathForCell(ss) {
                    let model = dataSource[indexPath.row]
                    
                    let popupVC = AIPaymentViewController.initFromNib()
                    popupVC.order_id = model.id ?? ""
                    let natigationController = UINavigationController(rootViewController: popupVC)
                    self.showTransitionStyleCrossDissolveView(natigationController)
                    
                }
            }
        }
        
    }
    
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 150
    }
    
    
}
