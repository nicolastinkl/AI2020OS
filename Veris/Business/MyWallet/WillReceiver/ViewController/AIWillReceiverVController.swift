//
//  AIWillPayVController.swift
//  AIVeris
//
//  Created by asiainfo on 10/28/16.
//  Copyright © 2016 ___ASIAINFO___. All rights reserved.
//

import Foundation
import UIKit

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
        
        let model1 = AIWillPayService.AIWillPayServiceModel()
        model1.saddress = "医院"
        model1.sname  = "海淀"
        model1.stime = 12
        model1.sprice = "¥23"
        model1.simageurl = ""
        
        let model2 = AIWillPayService.AIWillPayServiceModel()
        model2.saddress = "服务器地址"
        model2.sname  = "服务"
        model2.stime = 123232
        model2.sprice = "¥800"
        model2.simageurl = ""
        
        dataSource.append(model1)
        dataSource.append(model2)
        
    }
}

extension AIWillReceiverVController: UITableViewDelegate, UITableViewDataSource {
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataSource.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
//        var cell = AIWillPayVControllerCell.initFromNib() as? AIWillPayVControllerCell
        //tableView.dequeueReusableCellWithIdentifier("cell")
//        if (cell == nil ) {
//            cell = AIWillPayVControllerCell.initFromNib() as? AIWillPayVControllerCell
//        }
        
        return   UITableViewCell()
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 100
    }
    
    
}
