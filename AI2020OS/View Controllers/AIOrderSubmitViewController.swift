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
    
    //MARK: Variables
    @IBOutlet weak var label_title: UILabel!
    @IBOutlet weak var buyButton: UIButton!
    @IBOutlet weak var tableview: UITableView!

    //MARK: Variables
    var serviceId:Int?
    
    var isSubmitSuccess = false
    
    var selectedParams:NSMutableDictionary?
    
    var titleString:String?
    
    //MARK: life cricly
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let titleLabel =  self.tableview.tableHeaderView?.viewWithTag(1) as UILabel
        
        let color = UIColor(rgba: "#a7a7a7").CGColor
        let lineLayer =  CALayer()
        lineLayer.backgroundColor = color
        lineLayer.frame = CGRectMake(0, titleLabel.height+8, titleLabel.width, 0.5)
        titleLabel.layer.addSublayer(lineLayer)
        if let ti = titleString {
            label_title.text =  ti
        }

    }
    
    @IBAction func buyAction(sender: AnyObject) {
        
        let detailModel = AIServiceDetailParamsModel()
        
        let paramsPams = selectedParams?.allValues
        if paramsPams?.count > 0{
            
                self.view.showLoading()
                Async.userInitiated {
                    AIOrderRequester().submitOrder(self.serviceId  ?? 0, serviceParams: NSMutableArray(array: paramsPams!), completion: { (success) -> Void in
                        self.view.hideLoading()
                        if success {
                            self.isSubmitSuccess = true
                            UIAlertView(title: "提示", message: "购买成功", delegate: self, cancelButtonTitle: "关闭").show()
                        }else{
                            UIAlertView(title: "提示", message: "购买失败", delegate: nil, cancelButtonTitle: "关闭").show()
                        }
                    })
                }
            
        }else{
            UIAlertView(title: "提示", message: "购买失败", delegate: nil, cancelButtonTitle: "关闭").show()
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    
    func dismissPopToRoot(){
        self.dismissViewControllerAnimated(false, completion: nil)
    }
}

extension AIOrderSubmitViewController:UIAlertViewDelegate{
    func alertView(alertView: UIAlertView, clickedButtonAtIndex buttonIndex: Int) {
        if buttonIndex == 0{
            //cancel
            NSNotificationCenter.defaultCenter().postNotificationName(AIApplication.Notification.NSPOPAIOrderSubmitViewController, object: nil)
            self.dismissViewControllerAnimated(false, completion: nil)
        }
        
        self.isSubmitSuccess = false
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