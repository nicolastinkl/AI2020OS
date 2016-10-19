//
//  AIWorkOpportunityIndexViewController.swift
//  AIVeris
//
//  Created by zx on 8/10/16.
//  Copyright © 2016 ___ASIAINFO___. All rights reserved.
//

import UIKit

class AIWorkOpportunityIndexViewController: UIViewController {
	
	var headerView: AIWorkManageHeaderView!
    var chartView: AIWorkOpportunityPopularChartView!
    @IBOutlet weak var navigationBar: UIView!
    
    var scrollView: UIScrollView!
    var containerView: UIView!
    
	var once = false
	
	override func viewDidLoad() {
		super.viewDidLoad()
        setupContainerView()
        setupAIWorkManageHeaderView()
        setupAIWorkOpportunityPopularChartView()
        setupAIWorkOpportunityWhatsNewView()
	}
    
    func setupContainerView() {
        scrollView = UIScrollView()
        view.insertSubview(scrollView, belowSubview: navigationBar)
        
        containerView = UIView()
        scrollView.addSubview(containerView)
        
        // setup constraints
        scrollView.snp_makeConstraints { (make) in
            make.edges.equalTo(view)
        }
        
        containerView.snp_makeConstraints { (make) in
            make.width.equalTo(view)
            make.top.leading.bottom.equalTo(scrollView)
        }
    }
    
    func setupAIWorkManageHeaderView() {
        headerView = AIWorkManageHeaderView(frame: .zero)
        containerView.addSubview(headerView)
		headerView.delegate = self
        
        headerView.snp_makeConstraints { (make) in
            make.top.leading.trailing.equalTo(containerView)
            make.height.equalTo(242)
        }
    }
    
    func setupAIWorkOpportunityWhatsNewView() {
        var services = [AISearchServiceModel]()
        for i in 0...10 {
            let service = AISearchServiceModel()
            service.sid = i
            service.name = "service name"
            service.icon = "http://oc3j76nok.bkt.clouddn.com/%E9%99%AA%E6%8A%A4.png"
            services.append(service)
        }
        let v = AIWorkOpportunityWhatsNewView(services: services)
        containerView.addSubview(v)
        
        v.snp_makeConstraints { (make) in
            make.top.equalTo(chartView.snp_bottom).offset(108.displaySizeFrom1242DesignSize())
            make.bottom.leading.trailing.equalTo(containerView)
        }
    }
    
    func setupAIWorkOpportunityPopularChartView() {
        chartView =  AIWorkOpportunityPopularChartView()
        containerView.addSubview(chartView)
        chartView.snp_makeConstraints { (make) in
            make.top.equalTo(headerView.snp_bottom).offset(73.displaySizeFrom1242DesignSize())
            make.leading.trailing.equalTo(containerView)
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
        let navigationController = UINavigationController(rootViewController: workInfoVC)
        navigationController.modalTransitionStyle = UIModalTransitionStyle.CrossDissolve
        navigationController.modalPresentationStyle = UIModalPresentationStyle.OverFullScreen
        self.presentViewController(navigationController, animated: true, completion: nil)
    }

}
