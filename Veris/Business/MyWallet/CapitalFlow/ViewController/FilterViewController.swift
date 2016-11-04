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
    
    
    var filteData: [CapitalClassification]? {
        didSet {
            if filteData != nil {
                tableView.reloadData()
            }
        }
    }
    var delegate: CapitalFilterDelegate?
    
    class func initFromStoryboard() -> FilterViewController {
        let vc = UIStoryboard(name: "CapitalFlow", bundle: nil).instantiateViewControllerWithIdentifier("FilterViewController") as! FilterViewController
        return vc
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 25
        
        tableView.registerNib(UINib(nibName: "FilteTypeCell", bundle: nil), forCellReuseIdentifier: "FilteTypeCell")
        tableView.registerNib(UINib(nibName: "FilteTypeSubCell", bundle: nil), forCellReuseIdentifier: "FilteTypeSubCell")
        tableView.sksTableViewDelegate = self
  
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
}

extension FilterViewController: SKSTableViewDelegate {
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filteData?.count ?? 0
    }
    
    func tableView(tableView: UITableView, numberOfSubRowsAtIndexPath indexPath: NSIndexPath) -> Int {
        if let subRows = filteData?[indexPath.row].lists {
            return subRows.count
        } else {
            return 0
        }
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath: NSIndexPath) -> UITableViewCell {
        let cellIdentifier = "FilteTypeCell"
        
        let cell = tableView.dequeueReusableCellWithIdentifier(cellIdentifier) as! FilteTypeCell
        
        
        if let data = filteData?[cellForRowAtIndexPath.row] {
            cell.typeName?.text = data.type_name
            
            if data.lists != nil {
                cell.isExpandable = data.lists.count > 0
            } else {
                cell.isExpandable = false
            }
            
        }
        
        return cell
    }
    
    func tableView(tableView: UITableView, cellForSubRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cellIdentifier = "FilteTypeSubCell"
        
        let cell = tableView.dequeueReusableCellWithIdentifier(cellIdentifier) as! FilteTypeSubCell

        
        cell.typeName?.text = filteData?[indexPath.row].lists[indexPath.subRow].name
        
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectSubRowAtIndexPath indexPath: NSIndexPath) {
        if let subRows = filteData?[indexPath.row].lists {
            if let type = subRows[indexPath.subRow] as? CapitalTypeItem {
                delegate?.capitalTypeDidSelect(type)
            }
        }
    }
}

protocol CapitalFilterDelegate {
    func capitalTypeDidSelect(type: CapitalTypeItem)
}

