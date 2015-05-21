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
        
        var oneButton = UIButton.buttonWithType(.Custom)
        oneButton.setImage(UIImage(named: "ico_user"), forState: UIControlState.Normal)
        let userItem =  UIBarButtonItem(customView: oneButton as UIView)
        
        
        var twoButton = UIButton.buttonWithType(.Custom)
        twoButton.setImage(UIImage(named: "ico_more"), forState: UIControlState.Normal)
        let twoItem =  UIBarButtonItem(customView: twoButton as UIView)
        
        
        
        navigationItem.rightBarButtonItems = [userItem,twoItem]
        
    }
    
    @IBAction func backViewAction(sender: AnyObject) {
        dismissViewControllerAnimated(true, completion: nil)
    }
}