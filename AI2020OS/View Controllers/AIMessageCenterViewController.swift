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

    // MARK: swift controls
    @IBOutlet weak var toolBarView: UIView!
    
    // MARK: life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
    
        self.toolBarView.addBottomWholeBorderLine()
    }
    
    override func viewWillAppear(animated: Bool) {
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(named: "navigationbar-white"), forBarMetrics: UIBarMetrics.Default)
        navigationController?.setNavigationBarHidden(false, animated: true)
        navigationController?.interactivePopGestureRecognizer.delegate = nil
        super.viewWillAppear(animated)
    }

    // MARK: event response
    @IBAction func moreAction(sender: AnyObject) {
        showMenuViewController()        
    }
    
    @IBAction func userAction(sender: AnyObject) {
//    UIfetchViewContrller
    }
    
    @IBAction func backViewAction(sender: AnyObject) {
        dismissViewControllerAnimated(true, completion: nil)
    }
}