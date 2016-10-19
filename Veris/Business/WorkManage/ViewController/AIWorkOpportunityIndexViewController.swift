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
	
	var once = false
	
	override func viewDidLoad() {
		super.viewDidLoad()
		headerView.delegate = self
        setupAIWorkOpportunityPopularChartView()
        
	}
    
    func setupAIWorkOpportunityPopularChartView() {
        let v =  AIWorkOpportunityPopularChartView()
        view.addSubview(v)
        v.snp_makeConstraints { (make) in
            make.top.equalTo(headerView.snp_bottom).offset(73.displaySizeFrom1242DesignSize())
            make.leading.trailing.equalTo(view)
        }
    }
	
	override func viewDidLayoutSubviews() {
		super.viewDidLayoutSubviews()
		if once == false {
			headerView.setIndex(0)
			once = true
		}
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
        let workInfoVC = UIStoryboard(name:  AIApplication.MainStoryboard.MainStoryboardIdentifiers.AIWorkManageStoryboard, bundle: nil).instantiateViewControllerWithIdentifier(AIApplication.MainStoryboard.ViewControllerIdentifiers.AIWorkInfoViewController) as! AIWorkInfoViewController
        workInfoVC.in_workId = "100000000300"
        workInfoVC.in_workName = "陪护"
        let navigationController = UINavigationController(rootViewController: workInfoVC)
        navigationController.modalTransitionStyle = UIModalTransitionStyle.CrossDissolve
        navigationController.modalPresentationStyle = UIModalPresentationStyle.OverFullScreen
        self.presentViewController(navigationController, animated: true, completion: nil)
    }

}
