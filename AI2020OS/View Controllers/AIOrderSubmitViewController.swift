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

    var serviceId:String?
    
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
        if let serverid = self.title?.toInt() {
            if serverid > 0 {
                self.view.showLoading()
                let paramsPams = NSMutableArray(objects: ["paramsDate":"23564561356"],["paramsPrice":"452.0"])
                
                Async.userInitiated {
                    AIOrderRequester().submitOrder(serverid, serviceParams: paramsPams, completion: { (success) -> Void in
                        self.view.hideLoading()
                        
                        
                        
                    })
                }
            }else{
                SCLAlertView().showError("提交失败", subTitle: "参数有误", closeButtonTitle: "关闭", duration: 2)
            }
            
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
}


extension AIOrderSubmitViewController:UITableViewDataSource,UITableViewDelegate{
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let key =  selectedParams?.allKeys[indexPath.row] as String
        
        let cell = tableView.dequeueReusableCellWithIdentifier("orderSumbitCell") as UITableViewCell
        cell.textLabel.text = key
        if let value: AnyObject = selectedParams?.valueForKey(key) {
            cell.detailTextLabel?.text = "\(value)"
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