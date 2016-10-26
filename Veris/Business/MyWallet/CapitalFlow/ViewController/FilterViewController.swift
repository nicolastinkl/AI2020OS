//
//  FilterViewController.swift
//  AIVeris
//
//  Created by Rocky on 2016/10/25.
//  Copyright © 2016年 ___ASIAINFO___. All rights reserved.
//

import UIKit

class FilterViewController: UIViewController {

    @IBOutlet weak var tableView: SKSTableView!
    @IBOutlet weak var tableViewHeight: NSLayoutConstraint!
    
    
    var filteData: [FilteType]?
    
    class func initFromStoryboard() -> FilterViewController {
        let vc = UIStoryboard(name: "CapitalFlow", bundle: nil).instantiateViewControllerWithIdentifier("FilterViewController") as! FilterViewController
        return vc
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.registerClass(SKSTableViewCell.self, forCellReuseIdentifier: "SKSTableViewCell")
        tableView.registerClass(UITableViewCell.self, forCellReuseIdentifier: "SubTableViewCell")
        
        tableView.sksTableViewDelegate = self

        loadData()
        
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func didMoveToParentViewController(parent: UIViewController?) {
        
        self.tableViewHeight.constant = 0
        self.view.setNeedsUpdateConstraints()
        self.view.layoutIfNeeded()
        
        UIView.animateWithDuration(0.2) {
            
            self.tableViewHeight.constant = 350
            self.view.setNeedsUpdateConstraints()
            self.view.layoutIfNeeded()
        }
    }
    
    private func loadData() {
        filteData = [FilteType]()
        
        var filteType = FilteType(name: "全部")
        filteData?.append(filteType)
        
        filteType = FilteType(name: "现金")
        
        var subType = FilteType(name: "付款")
        filteType.subItems.append(subType)
        subType = FilteType(name: "退款")
        filteType.subItems.append(subType)
        
        filteData?.append(filteType)
        
        tableView.reloadData()
    }

}

extension FilterViewController: SKSTableViewDelegate {
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filteData?.count ?? 0
    }
    
    func tableView(tableView: UITableView, numberOfSubRowsAtIndexPath indexPath: NSIndexPath) -> Int {
        if let subRows = filteData?[indexPath.row].subItems {
            return subRows.count
        } else {
            return 0
        }
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath: NSIndexPath) -> UITableViewCell {
        let cellIdentifier = "SKSTableViewCell"
        
        var cell = tableView.dequeueReusableCellWithIdentifier(cellIdentifier) as? SKSTableViewCell
        
        if cell == nil {
            cell = SKSTableViewCell(style: .Default, reuseIdentifier: cellIdentifier)
        }
        
        cell?.backgroundColor = UIColor.clearColor()
        cell?.selectionStyle = .None
        
        if let data = filteData?[cellForRowAtIndexPath.row] {
            cell?.textLabel?.text = data.name
            
            cell?.isExpandable = data.subItems.count > 0
        }
        
        return cell!
    }
    
    func tableView(tableView: UITableView, cellForSubRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cellIdentifier = "SubTableViewCell"
        
        var cell = tableView.dequeueReusableCellWithIdentifier(cellIdentifier)
        
        if cell == nil {
            cell = UITableViewCell(style: .Default, reuseIdentifier: cellIdentifier)
        }
        
        cell?.backgroundColor = UIColor.clearColor()
        cell?.selectionStyle = .None
        
        cell?.textLabel?.text = filteData?[indexPath.row].subItems[indexPath.subRow].name
        cell?.accessoryType = .DisclosureIndicator
        
        return cell!
    }
}

class FilteType {
    var name: String
    var subItems = [FilteType]()
    
    init(name: String) {
        self.name = name
    }  
}

