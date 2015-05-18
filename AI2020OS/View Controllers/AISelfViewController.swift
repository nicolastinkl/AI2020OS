//
//  AISelfViewController.swift
//  AI2020OS
//
//  Created by tinkl on 31/3/15.
//  Copyright (c) 2015 ___ASIAINFO___. All rights reserved.
//

import Foundation
import UIKit

class AISelfViewController: UITableViewController {
    
    @IBOutlet var expandBgImageView: UIImageView!
    @IBOutlet var tableview: UITableView!

    private let kImageOriginHight:CGFloat = 240.0
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.title = "我的"
        
        // Do any additional setup after loading the view, typically from a nib.
        
//        let headerview = self.tableview.tableHeaderView as UIView?
//        let headerImg =  headerview?.getViewByTag(1) as UIImageView?
        // referesh UI
        
        //Just put this blur view on the imageView
//        var visualEffectView = UIVisualEffectView(effect: UIBlurEffect(style: .Dark)) as UIVisualEffectView
//        visualEffectView.frame = self.expandBgImageView.bounds
//        self.expandBgImageView.addSubview(visualEffectView)
        
        self.tableView.contentInset = UIEdgeInsetsMake(kImageOriginHight, 0, 0, 0);
        self.tableView.addSubview(self.expandBgImageView);
        self.expandBgImageView.frame = CGRectMake(0, -kImageOriginHight, self.tableView.frame.size.width, kImageOriginHight);
    }
    
    override func scrollViewDidScroll(scrollView: UIScrollView) {
        let yOffset:CGFloat   = scrollView.contentOffset.y;
        if (yOffset < -kImageOriginHight) {
            var f:CGRect = self.expandBgImageView.frame;
            f.origin.y = yOffset;
            f.size.height =  -yOffset;
            self.expandBgImageView.frame = f;
        }
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(true, animated: false)
        
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
}

