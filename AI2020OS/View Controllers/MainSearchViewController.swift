//
//  MainSearchViewController.swift
//  AI2020OS
//
//  Created by Rocky on 15/5/22.
//  Copyright (c) 2015年 ___ASIAINFO___. All rights reserved.
//

import UIKit

class MainSearchViewController: UIViewController , UITableViewDelegate , UITableViewDataSource {

    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        initTableView()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    
    func initTableView() {
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    // Row display. Implementers should *always* try to reuse cells by setting each cell's reuseIdentifier and querying for available reusable cells with dequeueReusableCellWithIdentifier:
    // Cell gets various attributes set automatically based on table (separators) and data source (accessory views, editing controls)

    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        // 添加FooterView，去除多余的单元格
        tableView.tableFooterView = UIView(frame:CGRectZero)
        
        let myIdentifier = "SearchTag"
        var cell  = tableView.dequeueReusableCellWithIdentifier(myIdentifier) as? UITableViewCell
        if cell == nil {
            cell = UITableViewCell(style: UITableViewCellStyle.Default, reuseIdentifier: myIdentifier)
            cell?.accessoryType = UITableViewCellAccessoryType.None
            
            let button = UIButton.buttonWithType(.System) as UIButton
            button.frame = CGRect(x: 0, y: 10, width: 90, height: 20)
            button.setTitle("lable", forState:UIControlState.Normal)

            cell?.contentView.addSubview(button)

        }      
        
        
        return cell!
    }
    
    func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        switch section {
        case 0:
            return "热门服务"
        case 1:
            return "搜索历史"
        default:
            return "Other section"
        }
    }

}
