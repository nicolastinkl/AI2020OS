//
//  AICServiceViewController.swift
//  AI2020OS
//
//  Created by tinkl on 3/6/15.
//  Copyright (c) 2015 ___ASIAINFO___. All rights reserved.
//

import Foundation
import UIKit

class AICServiceViewController: UITableViewController,AIConnectViewDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        AIConnectView.sharedManager.delegate = self
    }
    
    func exchangeViewModel(viewModel: ConnectViewModel) {
        
    }
    
}

/*!
*  @author tinkl, 15-06-03 11:06:40
*
*  list View model
*/
class AICServiceViewControllerCell: UITableViewCell {
    
}


/*!
*  @author tinkl, 15-06-03 11:06:13
*
*  Image push model
*/
class AICServiceViewControllerImageCell: UITableViewCell{
    
}