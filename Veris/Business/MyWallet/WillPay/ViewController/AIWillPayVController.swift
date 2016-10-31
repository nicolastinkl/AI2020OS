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
    private var dataSource = Array<AIWillPayService.AIWillPayServiceModel>()
    
    private let CellIdentifier = "CellID"
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        initNavigation()
        
        initLayout()
        
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
            let buttonSS = DesignableButton(frame: CGRectMake(0, 0,0, 0))
            let buttonSurePay = DesignableButton(frame: CGRectMake(0, 0,0, 0))
            
            contentView?.buttonView.addSubview(buttonSS)
            contentView?.buttonView.addSubview(buttonSurePay)
        }
        
        cell?.selectionStyle = .None
        
        cell?.backgroundColor = UIColor.clearColor()
        let model = dataSource[indexPath.row]
        contentView?.addresss.text = model.saddress ?? ""
        contentView?.time.text = String(model.stime ?? 0)
        contentView?.nameLabel.text = model.sname ?? ""
        contentView?.priceLabel.text = model.sprice ?? ""
        let url = NSURL(string: model.simageurl ?? "")!
        contentView?.icon.setImageWithURL(url)
            
        return cell!
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 120
    }
    
    
}
