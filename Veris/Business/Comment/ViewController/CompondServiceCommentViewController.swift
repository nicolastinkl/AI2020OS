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
    
    class func loadFromXib() -> CompondServiceCommentViewController {
        let vc = CompondServiceCommentViewController(nibName: "CompondServiceCommentViewController", bundle: nil)
        return vc
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        serviceTableView.registerNib(UINib(nibName: "ServiceCommentTableViewCell", bundle: nil), forCellReuseIdentifier: "ServiceCommentTableViewCell")
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()

    }

}

extension CompondServiceCommentViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 30;
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCellWithIdentifier("ServiceCommentTableViewCell") as!ServiceCommentTableViewCell
        
        
        if indexPath.row == 0 {
            cell.setToHeadComment()
        } else {
            cell.setToSubComment()
        }
        
        return cell
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        if indexPath.row == 0 {
            return 250
        } else {
            return 200
        }
    }
}
