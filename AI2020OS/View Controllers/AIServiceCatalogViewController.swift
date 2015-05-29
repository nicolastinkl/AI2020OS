//
//  AIServiceCatalogViewController.swift
//  AI2020OS
//
//  Created by admin on 15/5/28.
//  Copyright (c) 2015年 ___ASIAINFO___. All rights reserved.
//

import UIKit

class AIServiceCatalogViewController: UIViewController {

    
    @IBOutlet weak var catalogTable: UITableView!
    @IBOutlet weak var serviceTable: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        

        let nib = UINib(nibName: "AICatalogTableCellTableViewCell", bundle: nil)
        catalogTable.registerNib(nib,
            forCellReuseIdentifier: "CatalogCell")

        catalogTable.dataSource = self
        catalogTable.delegate = self
        
        
        
        serviceTable.dataSource = self
        serviceTable.delegate = self

       var header = NSBundle.mainBundle().loadNibNamed("AIProviderAvatarView", owner: self, options: nil).last as AIProviderAvatarView
        serviceTable.tableHeaderView =  header
        serviceTable.reloadData()
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

}

extension AIServiceCatalogViewController : UITableViewDelegate, UITableViewDataSource {
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView == catalogTable {
            return 5
        } else if tableView == serviceTable {
            return 10
        }
        
        return 0
    }
    
    // Row display. Implementers should *always* try to reuse cells by setting each cell's reuseIdentifier and querying for available reusable cells with dequeueReusableCellWithIdentifier:
    // Cell gets various attributes set automatically based on table (separators) and data source (accessory views, editing controls)
    
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return CGFloat(60)
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {


        var cell: UITableViewCell!
        if tableView == catalogTable {
            let catalogCell  = tableView.dequeueReusableCellWithIdentifier("CatalogCell") as AICatalogTableCellTableViewCell
            catalogCell.name = "catalog"
            catalogCell.addBottomWholeBorderLine()
            cell = catalogCell
        } else if tableView == serviceTable {
            cell  = tableView.dequeueReusableCellWithIdentifier("ServiceCell") as UITableViewCell
            cell!.textLabel.text = "service"
        }
        
        return cell!
    }
    
    
}

 