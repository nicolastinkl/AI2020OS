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
    
    private let tableview = UITableView(frame: CGRectMake(0, 50, UIScreen.mainScreen().bounds.size.width, UIScreen.mainScreen().bounds.size.height))
    private var dataSource = Array<AIFundWillWithDrawModel>()
    
    private let CellIdentifier = "CellID"
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        initNavigation()
        
        initLayout()
        
        AIFundManageServices.reqeustWillPayInfo({ (model) in
            self.dataSource = model ?? []
            self.tableview.reloadData()
        }) { (error) in
            
        }
        
    }
    
    func initNavigation() {
        let maxWidth = UIScreen.mainScreen().bounds.size.width
        
        let payInfoLabel = UILabel(frame: CGRectMake(0, 0, maxWidth, 50))
        payInfoLabel.text = "我的待付"
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
            buttonSS.borderWidth = 3/2
            buttonSS.backgroundColor = UIColor.clearColor()
            buttonSS.setTitle("我要申诉", forState: UIControlState.Normal)
            buttonSS.setTitleColor(UIColor(hex: "0f86e8"), forState: UIControlState.Normal)
            buttonSS.titleLabel?.font = UIFont.systemFontOfSize(15)
            buttonSurePay.titleLabel?.font = UIFont.systemFontOfSize(15)            
            buttonSurePay.cornerRadius = 5
            buttonSurePay.backgroundColor =  UIColor(hex: "0f86e8")
            buttonSurePay.setTitle("确定付款", forState: UIControlState.Normal)
            buttonSurePay.setTitleColor(UIColor.whiteColor(), forState: UIControlState.Normal)
            
            contentView?.buttonView.addSubview(buttonSS)
            contentView?.buttonView.addSubview(buttonSurePay)
            
            buttonSurePay.addTarget(self, action: #selector(AIWillPayVController.showAIRechargeView), forControlEvents: UIControlEvents.TouchUpInside)
        }
        
        cell?.selectionStyle = .None
        
        cell?.backgroundColor = UIColor.clearColor()
        let model = dataSource[indexPath.row]
        contentView?.addresss.text = model.vendor ?? ""
        contentView?.time.text = model.time?.toDate()
        contentView?.nameLabel.text = model.name ?? ""
        contentView?.priceLabel.text = String(model.price ?? 0)
        let url = NSURL(string: model.icon ?? "")!
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
