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
    
    var mostRequestedServices = [AISearchServiceModel]()
    var mostPopularServices = [AISearchServiceModel]()
    var whatsNewServices = [AISearchServiceModel]()
    
    var scrollView: UIScrollView!
    var containerView: UIView!
    
	var once = false
	
	override func viewDidLoad() {
		super.viewDidLoad()
        setupContainerView()
        
        fetchData()
	}
    
    func fetchData() {
        let service = AIWorkOpportunityService()
        service.queryMostRequestedWork({ [weak self] (result) in
            self?.mostRequestedServices = result
            self?.setupAIWorkManageHeaderView()
            service.queryMostPopularWork({ [weak self] (result) in
                self?.mostPopularServices = result
                self?.setupAIWorkOpportunityPopularChartView()
                
                service.queryNewestWorkOpportunity({ [weak self] (result) in
                    self?.whatsNewServices = result
                    self?.setupAIWorkOpportunityWhatsNewView()
                }) { (errType, errDes) in
                }
            }) { (errType, errDes) in
            }
        }) { (errType, errDes) in
        }
        
        
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
        headerView.services = mostRequestedServices
        containerView.addSubview(headerView)
		headerView.delegate = self
        headerView.snp_makeConstraints { (make) in
            make.top.leading.trailing.equalTo(containerView)
            make.height.equalTo(242)
        }
    }
    
    func setupAIWorkOpportunityPopularChartView() {
        chartView =  AIWorkOpportunityPopularChartView(services: mostPopularServices)
        containerView.addSubview(chartView)
        chartView.snp_makeConstraints { (make) in
            make.top.equalTo(headerView.snp_bottom).offset(73.displaySizeFrom1242DesignSize())
            make.leading.trailing.equalTo(containerView)
        }
    }
    
    func setupAIWorkOpportunityWhatsNewView() {
        let v = AIWorkOpportunityWhatsNewView(services: whatsNewServices)
        containerView.addSubview(v)
        
        v.snp_makeConstraints { (make) in
            make.top.equalTo(chartView.snp_bottom).offset(108.displaySizeFrom1242DesignSize())
            make.bottom.leading.trailing.equalTo(containerView)
        }
    }

	
	override func viewDidLayoutSubviews() {
		super.viewDidLayoutSubviews()
        if let headerView = headerView {
            if once == false {
                headerView.setIndex(0)
                once = true
            }
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
