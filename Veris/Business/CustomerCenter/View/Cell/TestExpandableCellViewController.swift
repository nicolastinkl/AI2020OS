//
//  TestExpandableCellViewController.swift
//  AIVeris
//
//  Created by admin on 16/6/20.
//  Copyright © 2016年 ___ASIAINFO___. All rights reserved.
//

import UIKit

class TestExpandableCellViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    @IBOutlet weak var tableView: UITableView!
    
    private var tableSource: [Bool]!
    
    class func loadFromXib() -> TestExpandableCellViewController {
        let vc = TestExpandableCellViewController(nibName: "TestExpandableCellViewController", bundle: nil)
        return vc
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableSource = [Bool]()
        tableSource.append(false)
        tableSource.append(false)
        
        tableView.registerNib(UINib(nibName: "ExpandableTableViewCell", bundle: nil), forCellReuseIdentifier: "ExpandableTableViewCell")
        
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 20

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tableSource.count
    }

    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {

        let cell = tableView.dequeueReusableCellWithIdentifier("ExpandableTableViewCell") as! ExpandableTableViewCell
        if cell.expandedContentView == nil {
            cell.setFoldedView(AIFolderCellView.currentView())
                    cell.setBottomExpandedView(SubServiceCardView.initFromNib("SubServiceCard") as! SubServiceCardView)
//            cell.setBottomExpandedView({
//                let result = UILabel()
//                result.text = "test"
//                return result
//                }())
        }


        cell.isExpanded = tableSource[indexPath.row]

        return cell
    }

    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let row = indexPath.row

        tableSource[row] = !tableSource[row]
        tableView.reloadData()
    }

}
