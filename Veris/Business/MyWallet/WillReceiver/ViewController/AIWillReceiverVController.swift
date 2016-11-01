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
    private var dataSource = Array<AIWillPayService.AIWillPayServiceModel>()
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        initNavigation()
        
        initLayout()
        
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
        
        let model1 = AIWillPayService.AIWillPayServiceModel()
        model1.saddress = "医院"
        model1.sname  = "海淀"
        model1.stime = 12
        model1.sprice = "¥23"
        model1.simageurl = "http://ofmrrc6zd.bkt.clouddn.com/%E5%AD%95%E6%A3%80%E6%97%A0%E5%BF%A7%E6%9C%8D%E5%8A%A1-%E5%9B%BE%E6%A0%87.png"
        
        
        let model2 = AIWillPayService.AIWillPayServiceModel()
        model2.saddress = "服务器地址"
        model2.sname  = "服务"
        model2.stime = 123232
        model2.sprice = "¥800"
        model2.simageurl = "http://ofmrrc6zd.bkt.clouddn.com/%E6%98%A5%E9%9B%A8%E6%9C%8D%E5%8A%A1-%E5%9B%BE%E6%A0%87.png"
        
        dataSource.append(model1)
        dataSource.append(model2)
        tableview.reloadData()

        
    }
}


extension AIWillReceiverVController: UITableViewDelegate, UITableViewDataSource {
    
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
            buttonSurePay.setTitle("提醒付款", forState: UIControlState.Normal)
            buttonSurePay.setTitleColor(UIColor.whiteColor(), forState: UIControlState.Normal)
            
            contentView?.buttonView.addSubview(buttonSS)
            contentView?.buttonView.addSubview(buttonSurePay)
            
            buttonSS.addTarget(self, action: #selector(AIWillPayVController.showAIRechargeView), forControlEvents: UIControlEvents.TouchUpInside)
            
        }
        
        cell?.selectionStyle = .None
        
        cell?.backgroundColor = UIColor.clearColor()
        let model = dataSource[indexPath.row]
        contentView?.addresss.text = model.saddress ?? ""
        contentView?.time.text = String(model.stime ?? 0)
        contentView?.nameLabel.text = model.sname ?? ""
        contentView?.priceLabel.text = model.sprice ?? ""
        let url = NSURL(string: model.simageurl ?? "")!
        contentView?.icon.sd_setImageWithURL(url)
        
        return cell!
    }
    
    func showAIRechargeView() {
        if let viewrech = AIRechargeView.initFromNib() as? AIRechargeView {
            view.addSubview(viewrech)
            viewrech.initSettings()
            viewrech.snp_makeConstraints { (make) in
                make.edges.equalTo(view)
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
