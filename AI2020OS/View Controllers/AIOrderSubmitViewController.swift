//
//  AIOrderSubmitViewController.swift
//  AI2020OS
//
//  Created by admin on 8/13/15.
//  Copyright (c) 2015 ___ASIAINFO___. All rights reserved.
//

import Foundation
import UIKit
import SCLAlertView

class AIOrderSubmitViewController: UIViewController {
    
    @IBOutlet weak var label_title: UILabel!
    @IBOutlet weak var buyButton: UIButton!
    @IBOutlet weak var tableview: UITableView!

    var serviceId:Int?
    
    var selectedParams:NSMutableDictionary?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let titleLabel =  self.tableview.tableHeaderView?.viewWithTag(1) as UILabel
        
        let color = UIColor(rgba: "#a7a7a7").CGColor
        let lineLayer =  CALayer()
        lineLayer.backgroundColor = color
        lineLayer.frame = CGRectMake(0, titleLabel.height+8, titleLabel.width, 0.5)
        titleLabel.layer.addSublayer(lineLayer)
        
    }
    
    @IBAction func buyAction(sender: AnyObject) {
        let detailModel = AIServiceDetailParamsModel()
        
        let paramsPams = selectedParams?.allValues
        if paramsPams?.count > 0{
            
                self.view.showLoading()
                Async.userInitiated {
                    AIOrderRequester().submitOrder(self.serviceId  ?? 0, serviceParams: NSMutableArray(array: paramsPams!), completion: { (success) -> Void in
                        self.view.hideLoading()
                        SCLAlertView().showSuccess("提交成功", subTitle: "提示", closeButtonTitle: "关闭", duration: 2)
                    })
                }
            
        }else{
            SCLAlertView().showError("提交失败", subTitle: "参数有误", closeButtonTitle: "关闭", duration: 2)
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
}

extension AIOrderSubmitViewController:UITableViewDataSource,UITableViewDelegate{
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let key =  selectedParams?.allKeys[indexPath.row] as String
        
        let valueDic =  selectedParams?.allValues[indexPath.row] as [String:AnyObject]
        
        let cell = tableView.dequeueReusableCellWithIdentifier("orderSumbitCell") as UITableViewCell
        cell.textLabel.text = key
        if let value: AnyObject = valueDic["param_value"] {
            
            if let timeSpan: AnyObject = valueDic["formattime"] {
                let timeS = value as? Double
                cell.detailTextLabel?.text = timeS?.dateStringFromTimestamp()
            }else{
                cell.detailTextLabel?.text = "\(value)"
            }
            
        }else{
            cell.detailTextLabel?.text = ""
        }
        
        return cell
        
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 76
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let par = selectedParams {
            return par.allKeys.count
        }
        return 0
    }
    
}