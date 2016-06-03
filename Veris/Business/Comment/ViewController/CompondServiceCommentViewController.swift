//
//  CompondServiceCommentViewController.swift
//  AIVeris
//
//  Created by Rocky on 16/6/3.
//  Copyright © 2016年 ___ASIAINFO___. All rights reserved.
//

import UIKit

class CompondServiceCommentViewController: UIViewController {
    
    @IBOutlet weak var serviceTableView: UITableView!

    override func viewDidLoad() {
        super.viewDidLoad()

        serviceTableView.estimatedRowHeight = 200.0
        
        serviceTableView.registerNib(UINib(nibName: "ServiceCommentTableViewCell", bundle: nil), forCellReuseIdentifier: "ServiceCommentTableViewCell")
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()

    }

}

extension CompondServiceCommentViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3;
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCellWithIdentifier("ServiceCommentTableViewCell") as!ServiceCommentTableViewCell
        
        return cell
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 200
    }
}
