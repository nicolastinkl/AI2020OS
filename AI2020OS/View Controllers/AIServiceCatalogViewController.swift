//
//  AIServiceCatalogViewController.swift
//  AI2020OS
//
//  Created by admin on 15/5/28.
//  Copyright (c) 2015年 ___ASIAINFO___. All rights reserved.
//

import UIKit

class AIServiceCatalogViewController: UIViewController {

    let PI = 3.1415926
    
    @IBOutlet weak var catalogTable: UITableView!
    @IBOutlet weak var serviceTable: UITableView!
    private var providerTable: UITableView!
    
    private var searchEngine: SearchEngine?
    private var catalogList:[AICatalogItemModel]?
    private var serviceList: [AIServiceTopicModel]?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        createProviderTableView()
        
        var engine = HttpSearchEngine()
        searchEngine = engine

        
        
        Async.background() {
            self.searchEngine?.getAllServiceCatalog(self.loadCatalogData)
            return
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Private
    private func createProviderHeader() {
        let nib = UINib(nibName: "AICatalogTableCellTableViewCell", bundle: nil)
        catalogTable.registerNib(nib!,
            forCellReuseIdentifier: "CatalogCell")
        
        catalogTable.dataSource = self
        catalogTable.delegate = self
        
        serviceTable.dataSource = self
        serviceTable.delegate = self
        
        serviceTable.tableHeaderView =  providerTable
        serviceTable.tableHeaderView?.setHeight(CGFloat(140))
    }
    
    private func createProviderTableView() {
        providerTable = UITableView(frame: CGRect(x: 0, y: 0, width: 140, height: catalogTable.height), style:.Plain)
        providerTable.transform = CGAffineTransformMakeRotation(CGFloat(-PI/2))
        providerTable.separatorStyle = .None
        providerTable.showsVerticalScrollIndicator = false
        providerTable.dataSource = self
        providerTable.delegate = self
    }
    
    private func loadCatalogData(result: (model: [AICatalogItemModel], err: Error?)) {
        
        if result.err == nil {
            catalogList = result.model
            catalogTable.reloadData()
        }
    }
    
    private func loadServicesData(result: (model: [AIServiceTopicModel], err: Error?)) {
        if result.err == nil {
            serviceList = result.model
            serviceTable.reloadData()
        }
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
        var number = 0
        if tableView == catalogTable {
            if catalogList != nil {
                number = catalogList!.count
            }
        } else if tableView == serviceTable {
            return 10
        } else if tableView == providerTable {
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
        if tableView == providerTable {
            return 100
        }
        
        return CGFloat(60)
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {

        var cell: UITableViewCell!
        if tableView == catalogTable {
            let catalogCell  = tableView.dequeueReusableCellWithIdentifier("CatalogCell") as AICatalogTableCellTableViewCell
            
            if catalogList != nil {
                catalogCell.name = catalogList![indexPath.item].catalog_name!
            }
            
            catalogCell.addBottomWholeBorderLine()
            cell = catalogCell
        } else if tableView == serviceTable {
            cell = tableView.dequeueReusableCellWithIdentifier("ServiceCell") as UITableViewCell
            cell!.textLabel?.text = "service"
        } else if tableView == providerTable {
            
            var header = NSBundle.mainBundle().loadNibNamed("AIProviderAvatarView", owner: self, options: nil).last as AIProviderAvatarView
            header.avatar.maskWithEllipse()
            header.avatar.image = UIImage(named: "Sample1")
            header.transform = CGAffineTransformMakeRotation(CGFloat(PI/2))
            
            let newView = UITableViewCell(frame:  CGRectMake(0, 0, 140, 140))
            header.setWidth(CGFloat(50))
            header.setHeight(CGFloat(40))
            header.center = newView.center
            newView.contentView.addSubview(header)
   
            header.center.y -= 20
            cell = newView
        }
        
        return cell!
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        if tableView == catalogTable {
            let catalog = self.catalogList?[indexPath.item]
            
            Async.background() {
                
                self.searchEngine?.queryServices(catalog!.catalog_id!, pageNum: 1, completion: self.loadServicesData)
                return
            }
        } else if tableView == serviceTable {
            
        } else if tableView == providerTable {
            
        }
    }
    
}

 