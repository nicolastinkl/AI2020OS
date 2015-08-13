//
//  AIOrderSubmitViewController.swift
//  AI2020OS
//
//  Created by admin on 8/13/15.
//  Copyright (c) 2015 ___ASIAINFO___. All rights reserved.
//

import Foundation
import UIKit

class AIOrderSubmitViewController: UIViewController {
    
    @IBOutlet weak var label_title: UILabel!
    @IBOutlet weak var buyButton: UIButton!
    @IBOutlet weak var tableview: UITableView!
    
    var datasource:NSMutableArray = {
        let array = NSArray(objects: ["地陪":"6天"],["接送机":"AUV SUVV"],["单飞":"国航CA2333"],["民宿":"精品两局，住4人"],["境外旅游险":"平安保险"],["漫游套餐":"100分钟 100MB流量"])
       
        return NSMutableArray(array: array)
        }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    @IBAction func buyAction(sender: AnyObject) {
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
}


extension AIOrderSubmitViewController:UITableViewDataSource,UITableViewDelegate{
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let data = datasource[indexPath.row] as [String:String]
        let cell = tableView.dequeueReusableCellWithIdentifier("orderSumbitCell") as UITableViewCell
        cell.textLabel.text = data.keys.first
        cell.detailTextLabel?.text = data.values.first
        return cell
        
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 76
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return datasource.count
    }
    
}