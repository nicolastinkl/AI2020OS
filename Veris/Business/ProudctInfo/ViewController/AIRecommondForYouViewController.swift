// AIVeris
//
//  Created by zx on 7/18/16.
//  Copyright © 2016 ___ASIAINFO___. All rights reserved.
//

import UIKit

class AIRecommondForYouViewController: UIViewController {
	var tableView: UITableView!
	var service_id: Int!
	private var dataSource: [AISearchServiceModel] = []
	
	override func viewDidLoad() {
		super.viewDidLoad()
		fetchData()
		setupTableView()
		setupNavigationItems()
	}
	
	func setupNavigationItems() {
		setupNavigationBarLikeQA(title: "AIRecommondForYouViewController.recommend".localized)
	}
	
	func fetchData() {
		let service = AIRecommondForYouService()
		service.allRecomends(service_id, success: { [weak self] models in
			self?.dataSource = models
			self?.tableView.reloadData()
		}) { (errType, errDes) in
			// error
		}
	}
	
	func setupTableView() {
		tableView = UITableView(frame: .zero, style: .Plain)
		tableView.tableFooterView = UIView()
		tableView.backgroundColor = UIColor.clearColor()
		tableView.delegate = self
		tableView.dataSource = self
		tableView.rowHeight = UITableViewAutomaticDimension
		tableView.estimatedRowHeight = 100
        tableView.separatorStyle = .None
		view.addSubview(tableView)
		tableView.snp_makeConstraints { (make) in
			make.edges.equalTo(view).offset(UIEdgeInsets(top: -64, left: 0, bottom: 0, right: 0))
		}
		tableView.contentInset = UIEdgeInsets(top: 64, left: 0, bottom: 0, right: 0)
	}
}

// MARK: - UITableViewDataSource
extension AIRecommondForYouViewController: UITableViewDataSource {
	func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return dataSource.count
	}
	
	func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
		let model: AISearchServiceModel = dataSource[indexPath.row]
		let cell = AICustomSearchHomeCell.initFromNib() as? AICustomSearchHomeCell
		cell?.initData(model)
		cell?.backgroundColor = UIColor.clearColor()
		return cell!
	}
}

// MARK: - UITableViewDelegate
extension AIRecommondForYouViewController: UITableViewDelegate {
	
	func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
		tableView.deselectRowAtIndexPath(indexPath, animated: true)
		let model: AISearchServiceModel = dataSource[indexPath.row]
		let vc = AISuperiorityViewController.initFromNib()
		vc.serviceModel = model
		showTransitionStyleCrossDissolveView(vc)
	}
}
