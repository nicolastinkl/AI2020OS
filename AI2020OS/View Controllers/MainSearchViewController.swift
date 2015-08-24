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
    var historyRecorder: SearchRecorder?
    var searchEngin: SearchEngine?
    var catalogList:[AICatalogItemModel]?

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        initTableView()
        
        var mockEngine = MockSearchEngine()
        historyRecorder = mockEngine
        searchEngin = mockEngine
        
//        catalogList = searchEngin?.queryHotSearchedServices()

        tableView.reloadData()

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
    
    private func initTableView() {
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
            
        }
        
        let tagWith = 60
        let tagHeight = 20
        let space = 10
        let padding = 10
        
        let records = historyRecorder!.getSearchHistoryItems()
        let services = catalogList
        var count = 0
        
        if indexPath.section == 0 {
            count = records.count
        } else if indexPath.section == 1 {
//            count = services?.count
        }
        
        for var i = 0; i < count; i++ {
            var tagName = ""
            if indexPath.section == 0 {
                tagName = records[i].name
            } else if indexPath.section == 1 {
//                tagName = services[i]?.name
            }
            
            let button = UIButton.buttonWithType(.System) as UIButton
            let tagX = padding + tagWith * i + space * i
            let tagY = 10
            button.frame = CGRect(x: tagX, y: tagY, width: tagWith, height: tagHeight)
            button.setTitle(tagName, forState:UIControlState.Normal)
            button.titleLabel?.lineBreakMode = NSLineBreakMode.ByTruncatingTail
            button.titleLabel?.backgroundColor = UIColor.grayColor()
            
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
            return ""
        }
    }

}
