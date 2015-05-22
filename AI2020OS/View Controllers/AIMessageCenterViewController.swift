//
//  AIMessageCenterViewController.swift
//  AI2020OS
//
//  Created by tinkl on 21/5/15.
//  Copyright (c) 2015 ___ASIAINFO___. All rights reserved.
//

import Foundation
import UIKit

class AIMessageCenterViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(named: "navigationbar-white"), forBarMetrics: UIBarMetrics.Default)
    }
    
    @IBAction func moreAction(sender: AnyObject) {
        
    }
    
    @IBAction func userAction(sender: AnyObject) {
        
    }
    
    @IBAction func backViewAction(sender: AnyObject) {
        dismissViewControllerAnimated(true, completion: nil)
    }
}