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
   
    @IBOutlet weak var titleEffectView: UIVisualEffectView!
    
    @IBOutlet weak var titleLabel: UILabel!
    
    @IBOutlet weak var tableview: UITableView!
    
    @IBOutlet weak var buttonAvator: AsyncImageView!
    var avatorURL:String?
    var username:String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        titleImage.setURL(self.avatorURL?.toURL(), placeholderImage: UIImage(named: "Placeholder"))
        titleLabel.text = username ?? ""
        let handImageView = self.tableview.tableHeaderView?.viewWithTag(2) as AsyncImageView
        handImageView.setURL(self.avatorURL?.toURL(), placeholderImage: UIImage(named: "Placeholder"))
       
        buttonAvator.setURL(self.avatorURL?.toURL(), placeholderImage: UIImage(named: "Placeholder"))
        buttonAvator.maskWithEllipse()
        
        self.tableview.reloadData()
        
        self.tableview.contentInset = UIEdgeInsetsMake(-20, 0, 0, 0)
    }
    
    @IBAction func menuAction(sender: AnyObject) {
        showMenuViewController()
    }
    
}

extension AIUserDesViewController: UIScrollViewDelegate {

    func scrollViewDidScroll(scrollView: UIScrollView) {
        let scrollOffset = self.tableview.contentOffset.y
        
        /*
        if scrollOffset < 0 {
            let imageScalingFactor: CGFloat = 64.0
            let comte = 0-(scrollOffset/imageScalingFactor)
            println("comte: \(comte)")
            self.titleImage.alpha = CGFloat(comte)
            self.titleEffectView.alpha = CGFloat(comte)
        }
        
       
        if scrollOffset >= 88 {
            let imageScalingFactor: CGFloat = 88.0
            let comte =  (scrollOffset/imageScalingFactor)
            println("comte: \(comte)")
        }*/
        
        if scrollOffset < 0 || scrollOffset >= 88{
            self.titleEffectView.alpha = 1
            self.titleImage.alpha = 1
        }else{
            self.titleEffectView.alpha = 0
            self.titleImage.alpha = 0
        }
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