//
//  AIWorkOpportunityIndexViewController.swift
//  AIVeris
//
//  Created by zx on 8/10/16.
//  Copyright © 2016 ___ASIAINFO___. All rights reserved.
//

import UIKit

class AIWorkOpportunityIndexViewController: UIViewController {
    
    @IBOutlet weak var headerView: AIWorkManageHeaderView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        headerView.delegate = self
    }
	
	@IBAction func backButtonPressed(sender: AnyObject) {
        dismissViewControllerAnimated(true, completion: nil)
	}
	@IBAction func cameraButtonPressed(sender: AnyObject) {
	}
	@IBAction func rightButtonPressed(sender: AnyObject) {
	}
}

extension AIWorkOpportunityIndexViewController: AIWorkManageHeaderViewDelegate {
    func headerView(headerView: AIWorkManageHeaderView, didClickAtIndex index: Int) {
        // did at index
    }
}
