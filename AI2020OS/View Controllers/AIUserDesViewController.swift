//
//  AIUserDesViewController.swift
//  AI2020OS
//
//  Created by admin on 8/20/15.
//  Copyright (c) 2015 ___ASIAINFO___. All rights reserved.
//

import Foundation
import UIKit
import Spring

class AIUserDesViewController: UIViewController {
    
    @IBOutlet weak var titleImage: AsyncImageView!
   
    @IBOutlet weak var titleLabel: UILabel!
    
    @IBOutlet weak var tableview: UITableView!
    
     var avatorURL:String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        titleImage.setURL(self.avatorURL?.toURL(), placeholderImage: UIImage(named: "Placeholder"))
        
        let handImageView = self.tableview.tableHeaderView?.viewWithTag(2) as AsyncImageView
        handImageView.setURL(self.avatorURL?.toURL(), placeholderImage: UIImage(named: "Placeholder"))
        
        self.tableview.reloadData()
    }
    
    @IBAction func menuAction(sender: AnyObject) {
        showMenuViewController()
    }
    
}

extension AIUserDesViewController: UITableViewDataSource,UITableViewDelegate {
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        return UITableViewCell()
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
}