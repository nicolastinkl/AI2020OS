//
//  AISearchMenuTableViewController.swift
//  AI2020OS
//
//  Created by tinkl on 13/4/15.
//  Copyright (c) 2015 ___ASIAINFO___. All rights reserved.
//

import Foundation
class AISearchMenuTableViewController: UITableViewController {
    
    
    private struct CellIdentifier {
        static let CellIdentifierHistory = "AISMenuTableCellHistory"
        static let CellIdentifierHot = "AISMenuTableCellHot"
    }
    
    private var historyList:[String]{
        get{
            return ["小时工","瑜伽","美甲"]
        }
    }

    
    private var hotList:[String]{
        get{
            return ["理财","租房","美容"]
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }    
  

    // MARK: TableViewDelegate
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat{
        return 120
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell:UITableViewCell?
        if indexPath.section == 0{
            cell = tableView.dequeueReusableCellWithIdentifier(CellIdentifier.CellIdentifierHistory) as UITableViewCell?
            let contentview:UIView? = cell?.contentView
            for historyNmae in historyList{
                let contentChlids:Int? = contentview?.subviews.count ?? 0
                let button:UIButton = UIButton.buttonWithType(UIButtonType.Custom) as UIButton
                button.setTitleColor(UIColor.blackColor(), forState: UIControlState.Normal)
                button.setTitle(historyNmae, forState: UIControlState.Normal)
                let xPosition : CGFloat = (20 + 100*CGFloat(contentChlids!))
                button.frame = CGRectMake(xPosition, 10, 100, 40)
                contentview?.addSubview(button)
            }
            
        }else if indexPath.section == 1{
            cell = tableView.dequeueReusableCellWithIdentifier(CellIdentifier.CellIdentifierHot) as UITableViewCell?
            let contentview:UIView? = cell?.contentView
            for hotName in hotList{
                let contentChlids:Int? = contentview?.subviews.count ?? 0
                let button:UIButton = UIButton.buttonWithType(UIButtonType.Custom) as UIButton
                button.setTitleColor(UIColor.blackColor(), forState: UIControlState.Normal)
                button.setTitle(hotName, forState: UIControlState.Normal)
                let xPosition : CGFloat = (20 + 100*CGFloat(contentChlids!))
                button.frame = CGRectMake(xPosition, 10, 100, 40)
                contentview?.addSubview(button)
            }
        }
        return cell!
    }

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 2
    }
    
    override func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if section == 0{
            return "搜索历史"
        }
        return "热门推荐"
    }
    

    
        
}